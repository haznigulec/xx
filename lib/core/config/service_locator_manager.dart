import 'dart:convert';
import 'dart:io';

import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_config.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'package:flutter_notification_channel/notification_visibility.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:piapiri_v2/bootstrap/feature_status.dart';
import 'package:piapiri_v2/core/api/mqtt_client/mqtt_depth_controller.dart';
import 'package:piapiri_v2/core/api/mqtt_client/mqtt_dl_stats_controller.dart';
import 'package:piapiri_v2/core/api/mqtt_client/mqtt_dl_symbol_controller.dart';
import 'package:piapiri_v2/core/api/mqtt_client/mqtt_dl_viop_stats_controller.dart';
import 'package:piapiri_v2/core/api/mqtt_client/mqtt_rt_stats_controller.dart';
import 'package:piapiri_v2/core/api/mqtt_client/mqtt_rt_symbol_controller.dart';
import 'package:piapiri_v2/core/api/mqtt_client/mqtt_rt_viop_stats_controller.dart';
import 'package:piapiri_v2/core/api/mqtt_client/mqtt_trade_controller.dart';
import 'package:piapiri_v2/core/api/mqtt_client/mqtt_warrant_dl_stats_controller.dart';
import 'package:piapiri_v2/core/api/mqtt_client/mqtt_warrant_rt_stats_controller.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/api/pp_api_impl.dart';
import 'package:piapiri_v2/core/api/websocket_client/polygon_wss_controller.dart';
import 'package:piapiri_v2/core/config/analytics/analytics.dart';
import 'package:piapiri_v2/core/config/analytics/analytics_service.dart';
import 'package:piapiri_v2/core/config/app_info.dart';
import 'package:piapiri_v2/core/config/bloc_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/user_model.dart';
import 'package:piapiri_v2/core/services/token_service.dart';
import 'package:piapiri_v2/core/storage/local_storage.dart';
import 'package:piapiri_v2/core/storage/local_storage_impl.dart';
import 'package:tw_queue/tw_queue.dart';

class ServiceLocatorManager {
  static Future<void> registerObjects() async {
    AdjustConfig adjustConfig = AdjustConfig(
      't7gt2c6lgsn4',
      AdjustEnvironment.production,
    );

    adjustConfig.logLevel = AdjustLogLevel.debug;
    adjustConfig.sendInBackground = true;
    UserModel(
      phone: '',
      address: '',
      email: '',
      name: '',
      password: '',
      accountId: '',
      langCode: '',
      accounts: [],
      alpacaAccountStatus: false,
      changePasswordRequired: false,
      customerChannel: '',
    );

    Adjust.start(adjustConfig);

    final dir = await path.getApplicationDocumentsDirectory();
    Hive.init(dir.path);

    final box = await Hive.openBox('piapiri');

    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 15),
        minimumFetchInterval: const Duration(minutes: 1),
      ),
    );

    await Future.delayed(const Duration(seconds: 1));

    try {
      await remoteConfig.fetchAndActivate();
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(e, stackTrace, reason: 'Remote config fetch failed');
    }

    Map<String, dynamic> enabledFeatures = jsonDecode(remoteConfig.getValue('enabledFeatures').asString());

    getIt.registerLazySingleton<TokenService>(
      () => TokenService(),
    );

    getIt.registerLazySingleton<FeatureStatus>(
      () => FeatureStatus(enabledFeatures['features'] as List<String>),
    );

    getIt.registerLazySingleton<PPApi>(
      () => PPApiImpl(),
    );
    getIt.registerLazySingleton<LocalStorage>(
      () => LocalStorageImpl(box),
    );

    getIt.registerLazySingleton<AppInfo>(
      () => AppInfo(),
    );

    getIt.registerLazySingleton<MqttRTSymbolController>(
      () => MqttRTSymbolController(),
    );
    getIt.registerLazySingleton<MqttDLSymbolController>(
      () => MqttDLSymbolController(),
    );
    getIt.registerLazySingleton<MqttRTStatsController>(
      () => MqttRTStatsController(),
    );
    getIt.registerLazySingleton<MqttDLStatsController>(
      () => MqttDLStatsController(),
    );
    getIt.registerLazySingleton<MqttWarrantRTStatsController>(
      () => MqttWarrantRTStatsController(),
    );
    getIt.registerLazySingleton<MqttWarrantDLStatsController>(
      () => MqttWarrantDLStatsController(),
    );
    getIt.registerLazySingleton<MqttDepthController>(
      () => MqttDepthController(),
    );
    getIt.registerLazySingleton<MqttTradeController>(
      () => MqttTradeController(),
    );
    getIt.registerLazySingleton<MqttRTViopStatsController>(
      () => MqttRTViopStatsController(),
    );
    getIt.registerLazySingleton<MqttDLViopStatsController>(
      () => MqttDLViopStatsController(),
    );
    getIt.registerLazySingleton<Analytics>(
      () => AnalyticsService(),
    );
    getIt.registerLazySingleton<PolygonWSSController>(
      () => PolygonWSSController(),
    );

    getIt.registerLazySingleton<TWQueue>(
      () => TWQueue(parallel: 3),
    );
    getIt.registerLazySingleton<TWQueue>(
      () => TWQueue(),
      instanceName: 'MQTT',
    );

    getIt<PPApi>().init();
    BlocLocator.init();
    await getIt<AppInfo>().init();
    getIt<Analytics>().initialize();
    if (Platform.isAndroid) {
      await FlutterNotificationChannel().registerNotificationChannel(
        description: 'High level of importance',
        id: 'piapiri_high_level',
        importance: NotificationImportance.IMPORTANCE_HIGH,
        name: 'High level',
        visibility: NotificationVisibility.VISIBILITY_PUBLIC,
        allowBubbles: true,
        enableVibration: true,
        enableSound: true,
        showBadge: true,
        customSound: 'notification',
      );
    }
    await getIt.allReady();
  }

  static Future<void> resetMqtt() async {
    getIt<MqttRTSymbolController>().disconnect();
    getIt<MqttDLSymbolController>().disconnect();
    getIt<MqttRTStatsController>().disconnect();
    getIt<MqttDLStatsController>().disconnect();
    getIt<MqttWarrantRTStatsController>().disconnect();
    getIt<MqttWarrantDLStatsController>().disconnect();
    getIt<MqttDepthController>().disconnect();
    getIt<MqttTradeController>().disconnect();
    getIt.resetLazySingleton<MqttRTSymbolController>();
    getIt.resetLazySingleton<MqttDLSymbolController>();
    getIt.resetLazySingleton<MqttRTStatsController>();
    getIt.resetLazySingleton<MqttDLStatsController>();
    getIt.resetLazySingleton<MqttDepthController>();
    getIt.resetLazySingleton<MqttTradeController>();
  }

  static Future<bool> environmentReset() async {
    await getIt.unregister<TokenService>();
    await getIt.unregister<PPApi>();
    getIt.registerLazySingleton<TokenService>(
      () => TokenService(),
    );

    getIt.registerLazySingleton<PPApi>(
      () => PPApiImpl(),
    );
    getIt<PPApi>().init();
    getIt<LocalStorage>().delete('MatriksToken');
    getIt<LocalStorage>().delete('MatriksTokenTime');
    return true;
  }

  static void cancelQueue() {
    getIt<TWQueue>().cancel();
    getIt<TWQueue>(instanceName: 'MQTT').cancel();
    getIt.resetLazySingleton<TWQueue>();
  }
}
