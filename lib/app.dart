// ignore_for_file: avoid_print
import 'package:adjust_sdk/adjust.dart';
import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_insider/flutter_insider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:p_core/keys/navigator_keys.dart';
import 'package:piapiri_v2/app/app_settings/bloc/app_settings_bloc.dart';
import 'package:piapiri_v2/app/app_settings/bloc/app_settings_state.dart';
import 'package:piapiri_v2/common/utils/local_keys.dart';
import 'package:piapiri_v2/common/widgets/scroll/p_scroll_behavior.dart';
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
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/language/bloc/language_bloc.dart';
import 'package:piapiri_v2/core/bloc/language/bloc/language_state.dart';
import 'package:piapiri_v2/core/config/app_config.dart';
import 'package:piapiri_v2/core/config/router/app_router.dart';
import 'package:piapiri_v2/core/config/router/app_router_observer.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/config/session_timer.dart';
import 'package:piapiri_v2/core/model/insider_callback_action.dart';
import 'package:piapiri_v2/core/model/theme_enum.dart';
import 'package:piapiri_v2/core/storage/local_storage.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:tw_queue/tw_queue.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  late AppRouter _appRouter;

  void _handleFreshInstall() {
    String? installDate = getIt<LocalStorage>().read(LocalKeys.installDate);
    if (installDate == null) {
      getIt<LocalStorage>().write(LocalKeys.installDate, DateTime.now().toString());
    }
  }

  @override
  void initState() {
    _appRouter = AppRouter(navigatorKey: NavigatorKeys.navigatorKey);
    WidgetsBinding.instance.addObserver(this);
    initInsider();
    initShowCase();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.resumed:
        Adjust.onResume();
        getIt<TWQueue>().resume();
        getIt<TWQueue>(instanceName: 'MQTT').resume();

        /// Verdiğimiz karar sonucunda; Kullanıcı uygulamayı arka plana atıp tekrar geldiğinde değerleri 0 görme problemi yaşarsa
        /// tekrar subscribe etmek için kullanılıyor. Farklı bir yöntem akla gelirse değerlendirilebilir.
        getIt<MqttDepthController>().reSubscribeSymbols();
        getIt<MqttDLStatsController>().reSubscribeSymbols();
        getIt<MqttDLSymbolController>().reSubscribeSymbols();
        getIt<MqttDLViopStatsController>().reSubscribeSymbols();
        getIt<MqttRTStatsController>().reSubscribeSymbols();
        getIt<MqttRTSymbolController>().reSubscribeSymbols();
        getIt<MqttRTViopStatsController>().reSubscribeSymbols();
        getIt<MqttTradeController>().reSubscribeSymbols();
        getIt<MqttWarrantDLStatsController>().reSubscribeSymbols();
        getIt<MqttWarrantRTStatsController>().reSubscribeSymbols();
        break;
      case AppLifecycleState.paused:
        Adjust.onPause();
        getIt<TWQueue>().pause();
        getIt<TWQueue>(instanceName: 'MQTT').pause();
        break;
      case AppLifecycleState.hidden:
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    _handleFreshInstall();

    return Listener(
      onPointerDown: (_) => SessionTimer.instance?.userActivityDetected(),
      child: PBlocBuilder<LanguageBloc, LanguageState>(
        bloc: getIt<LanguageBloc>(),
        builder: (context, languageState) {
          return PBlocBuilder<AppSettingsBloc, AppSettingsState>(
            bloc: getIt<AppSettingsBloc>(),
            builder: (context, appSettingsState) {
              late bool isLightTheme;
              if (appSettingsState.generalSettings.theme == ThemeEnum.deviceSettings) {
                isLightTheme = MediaQuery.of(context).platformBrightness == Brightness.light;
              } else if (appSettingsState.generalSettings.theme == ThemeEnum.dark) {
                isLightTheme = false;
              } else {
                isLightTheme = true;
              }

              SystemChrome.setSystemUIOverlayStyle(
                SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: isLightTheme ? Brightness.dark : Brightness.light,
                  statusBarBrightness: isLightTheme ? Brightness.light : Brightness.dark,
                ),
              );
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.noScaling,
                  boldText: false,
                ),
                child: OverlaySupport.global(
                  child: MaterialApp.router(
                    key: ValueKey(languageState.languageCode),
                    scrollBehavior: PScrollBehavior(),
                    locale: Locale(languageState.languageCode),
                    supportedLocales: const <Locale>[
                      Locale('tr'),
                      Locale('en'),
                    ],
                    localizationsDelegates: const [
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    debugShowCheckedModeBanner: AppConfig.instance.flavor == Flavor.dev,
                    theme: PAppThemes.lightTheme,
                    darkTheme: PAppThemes.darkTheme,
                    themeMode: isLightTheme ? ThemeMode.light : ThemeMode.dark,
                    themeAnimationDuration: Duration.zero,
                    routerDelegate: AutoRouterDelegate(
                      _appRouter,
                      navigatorObservers: () => [
                        AppRouterObserver(talker),
                      ],
                    ),
                    routeInformationParser: _appRouter.defaultRouteParser(),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future initInsider() async {
    if (!mounted) return;
    String insiderClient = 'piapiri';

    // Call in async method.
    await FlutterInsider.Instance.init(insiderClient, "group.com.unluco.piapiri", callback);

    // This is an utility method, if you want to handle the push permission in iOS own your own you can omit the following method.
    FlutterInsider.Instance.setActiveForegroundPushView();
    FlutterInsider.Instance.registerWithQuietPermission(false);
  }

  initShowCase() {
    ShowcaseView.register(
      blurValue: .6,
      onStart: (index, key) => debugPrint('ShowcaseView start: $index $key'),
      onComplete: (index, key) => debugPrint('ShowcaseView done:  $index $key'),
      enableAutoScroll: true,
    );
  }

  callback(int type, dynamic data) {
    switch (type) {
      case InsiderCallbackAction.notificationOpen:
        print("[INSIDER][NOTIFICATION_OPEN]: $data");
        // setState(() {
        //   _callbackData = data.toString();
        // });
        break;
      case InsiderCallbackAction.tempStoreCustomAction:
        print("[INSIDER][TEMP_STORE_CUSTOM_ACTION]: $data");
        // setState(() {
        //   _callbackData = data.toString();
        // });
        break;
      default:
        print("[INSIDER][InsiderCallbackAction]: Unregistered Action!");
        break;
    }
  }
}
