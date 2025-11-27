import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_insider/flutter_insider.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:p_core/utils/log_utils.dart';
import 'package:p_core/utils/platform_utils.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/app/markets/model/market_menu.dart';
import 'package:piapiri_v2/common/utils/constant.dart';
import 'package:piapiri_v2/common/utils/local_keys.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/bloc/tab/tab_bloc.dart';
import 'package:piapiri_v2/core/bloc/tab/tab_event.dart';
import 'package:piapiri_v2/core/config/app_info.dart';
import 'package:piapiri_v2/core/config/local_notification.dart';
import 'package:piapiri_v2/core/config/notification_handler.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/notification_model.dart';
import 'package:piapiri_v2/core/model/order_action_type_enum.dart';
import 'package:piapiri_v2/core/storage/local_storage.dart';
import 'package:talker_flutter/talker_flutter.dart';

enum NotificationState { onMessage, onLaunch, onResume }

class NotificationHandlerImpl extends NotificationHandler {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static const _tapChannel = MethodChannel('NOTIFICATION_TAP_CHANNEL');

  late NotificationState state;

  List<NotificationDetail> notificationsList = <NotificationDetail>[];
  bool hasActiveNotification = false;

  NotificationHandlerImpl() {
    if (PlatformUtils.isIos) {
      _tapChannel.setMethodCallHandler(_handleIosNotificationTap);
    }
  }

  Future<void> _executePendingNavigationIfExistsIOS() async {
    try {
      final raw = await _tapChannel.invokeMethod<Map<dynamic, dynamic>?>('getInitialNotification');
      if (raw != null) {
        final source = raw['source']?.toString();
        if (source == 'Insider') return;
        final remoteMessage = _remoteMessageFromIosMap(raw);
        isLaunchedNotification = true;
        state = NotificationState.onLaunch;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final result = _remoteMessageConverter(remoteMessage);
          router.push(
            NotificationRoute(
              remoteNotificationModel: result.$1,
              remoteNotificationDetail: result.$2,
            ),
          );
        });
      }
    } catch (e, s) {
      LogUtils.pLog('_executePendingNavigationIfExistsIOS getInitialNotification error: $e\n$s');
    }
  }

  Future<void> _executePendingNavigationIfExistsAndroid() async {
    final RemoteMessage? initialNotification = await _firebaseMessaging.getInitialMessage();
    if (initialNotification != null) {
      isLaunchedNotification = true;
      state = NotificationState.onLaunch;
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          final result = _remoteMessageConverter(initialNotification);
          router.push(
            NotificationRoute(
              remoteNotificationModel: result.$1,
              remoteNotificationDetail: result.$2,
            ),
          );
        },
      );
    }
  }

  @override
  Future<void> executePendingNavigationIfExists() async {
    if (PlatformUtils.isIos) {
      // Insider kaldırıldığında kaldırılacak.
      await _executePendingNavigationIfExistsIOS();
      return;
    }
    await _executePendingNavigationIfExistsAndroid();
  }

  @override
  void performNotificationAction({
    String? action,
    String? params,
    String? tags,
    String? externalLink,
    String? fileUrl,
    NotificationModel? notificationModel,
    NotificationDetail? notificationDetail,
  }) {
    switch (action) {
      case 'SimpleNotification':
        if (notificationModel != null) {
          router.push(
            NotificationDetailRoute(
              selectedNotificationModel: notificationModel,
              selectedNotificationDetail: notificationDetail,
            ),
          );
        } else if (notificationDetail == null) {
          router.push(NotificationRoute());
        }

        break;
      case 'ExternalLink':
        if (externalLink?.isNotEmpty == true) {
          router.push(
            NotificationDetailWebViewRoute(
              url: externalLink!,
            ),
          );
        } else if (notificationDetail == null) {
          router.push(NotificationRoute());
        }
        break;
      case 'InternalNavigation': // Öneriler
        if (fileUrl?.isNotEmpty == true) {
          router.push(
            NotificationDetailPdfRoute(
              pdfUrl: fileUrl!,
            ),
          );
          break;
        }

        if (params == 'buysell') {
          getIt<AuthBloc>().state.isLoggedIn
              ? router.push(
                  CreateOrderRoute(
                    symbol: MarketListModel(
                      symbolCode: tags.toString().split(',')[0],
                      updateDate: '',
                    ),
                    action: OrderActionTypeEnum.buy,
                  ),
                )
              : router.push(
                  AuthRoute(
                    afterLoginAction: () {
                      router.push(
                        CreateOrderRoute(
                          symbol: MarketListModel(
                            symbolCode: tags.toString().split(',')[0],
                            updateDate: '',
                          ),
                          action: OrderActionTypeEnum.buy,
                        ),
                      );
                    },
                  ),
                );
          break;
        }

        router.popUntilRoot();
        getIt.get<TabBloc>().add(
              const TabChangedEvent(
                tabIndex: 2,
                marketMenu: MarketMenu.istanbulStockExchange,
                marketMenuTabIndex: 3,
              ),
            );
        break;
      case 'ShowFile':
        break;
      default:
        LogUtils.pLog('any notification');
        break;
    }
  }

  @override
  Future<void> registerForNotifications() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (PlatformUtils.isIos) {
        String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
        if (apnsToken != null) {
          await _register();
        } else {
          await Future<void>.delayed(
            const Duration(seconds: 3),
          );
          apnsToken = await _firebaseMessaging.getAPNSToken();
          if (apnsToken != null) {
            await _register();
          }
        }
      } else {
        await _register();
      }
    } else {
      log('User declined or has not accepted permission');
    }
  }

  Future<void> _register() async {
    _firebaseMessaging.getToken().then((String? token) async {
      if (token == null) {
        return;
      }
      getIt<LocalStorage>().write(LocalKeys.fcmToken, token);
      await getIt<PPApi>().notificationService.updateRegistrationToken(
            token: token,
            deviceId: getIt<AppInfo>().deviceId,
          );
      talker.critical('token: $token');
    });
    _listenNotifications();
  }

  void _listenNotifications() {
    // Insider kaldırıldığında kaldırılacak.
    if (PlatformUtils.isIos) {
      FlutterInsider.Instance.setForegroundPushCallback(
        (Map<String, dynamic> message) async {
          LogUtils.pLog('[INSIDER] foreground callback: $message');
          final source = message['source']?.toString();
          if (source == 'Insider') return;

          /// NON-INSIDER → FCM onMessage gibi davran
          try {
            state = NotificationState.onMessage;
            final remoteMessage = _remoteMessageFromIosMap(message);
            if (remoteMessage.notification != null) {
              final result = _remoteMessageConverter(remoteMessage);
              showOverlayNotification(
                duration: const Duration(seconds: 4),
                (context) => LocalNotification(
                  remoteMessage: remoteMessage,
                  remoteNotificationModel: result.$1,
                  remoteNotificationDetail: result.$2,
                  onClose: () => OverlaySupportEntry.of(context)?.dismiss(),
                ),
              );
            }
          } catch (e, s) {
            LogUtils.pLog('[INSIDER→FCM] parse error: $e\n$s');
          }
        },
      );
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) {
      // Insider kaldırıldığında kaldırılacak.
      if (PlatformUtils.isIos) return;
      state = NotificationState.onMessage;
      if (remoteMessage.notification != null) {
        final result = _remoteMessageConverter(remoteMessage);
        showOverlayNotification(
          duration: const Duration(seconds: 4),
          (context) => LocalNotification(
            remoteMessage: remoteMessage,
            remoteNotificationModel: result.$1,
            remoteNotificationDetail: result.$2,
            onClose: () => OverlaySupportEntry.of(context)?.dismiss(),
          ),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage remoteMessage) async {
        // Insider kaldırıldığında kaldırılacak.
        if (PlatformUtils.isIos) return;
        state = NotificationState.onResume;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final result = _remoteMessageConverter(remoteMessage);
          router.push(
            NotificationRoute(
              remoteNotificationModel: result.$1,
              remoteNotificationDetail: result.$2,
            ),
          );
        });
      },
    );

    FirebaseMessaging.onBackgroundMessage((remoteMessage) async {
      talker.log(
        remoteMessage.notification.toString(),
        logLevel: LogLevel.warning,
      );
    });
  }

  /// Insider kaldırıldığında kaldırılacak.
  /// iOS'ta native AppDelegate → MethodChannel üzerinden gelen tap event'lerini
  /// (app arkadayken / açıkken) FCM onMessageOpenedApp akışı gibi ele alıyoruz.
  Future<void> _handleIosNotificationTap(MethodCall call) async {
    if (call.method != 'onNotificationTap') return;

    final raw = call.arguments;
    if (raw is! Map) return;

    final Map<dynamic, dynamic> map = raw;

    try {
      final source = map['source']?.toString();
      if (source == 'Insider') return;

      final remoteMessage = _remoteMessageFromIosMap(map);
      state = NotificationState.onResume;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        final result = _remoteMessageConverter(remoteMessage);
        router.push(
          NotificationRoute(
            remoteNotificationModel: result.$1,
            remoteNotificationDetail: result.$2,
          ),
        );
      });
    } catch (e, s) {
      LogUtils.pLog('[TAP] iOS notification tap parse error: $e\n$s');
    }
  }

  /// iOS userInfo → RemoteMessage çeviricisi
  RemoteMessage _remoteMessageFromIosMap(Map<dynamic, dynamic> map) {
    final aps = map['aps'] as Map<dynamic, dynamic>?;
    final alert = aps?['alert'] as Map<dynamic, dynamic>?;

    final String title = alert?['title']?.toString() ?? '';
    final String body = alert?['body']?.toString() ?? '';

    final Map<String, dynamic> data = {};
    map.forEach((key, value) {
      if (key is String && key != 'aps' && key != 'source') {
        data[key] = value;
      }
    });

    final remoteNotification = RemoteNotification(
      title: title,
      body: body,
    );

    return RemoteMessage(
      data: data,
      notification: remoteNotification,
      messageId: map['gcm.message_id']?.toString(),
      sentTime: DateTime.now(),
    );
  }

  (NotificationModel, NotificationDetail) _remoteMessageConverter(
    RemoteMessage remoteMessage,
  ) {
    final data = remoteMessage.data;
    String? str(String key) {
      final v = data[key];
      if (v == null) return null;
      return v.toString();
    }

    final List<int> notificationIds = <int>[];
    final rawTags = str('Tags');
    final List<String> tags = rawTags == null || rawTags.isEmpty
        ? []
        : rawTags.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    final sentTime = remoteMessage.sentTime?.toLocal() ?? DateTime.now();
    final createdIso = sentTime.toIso8601String();
    final notificationActionType = str('NotificationActionTypeKey');
    final notificationActionParams = str('NotificationActionParamsKey');
    final fileUrl = str('FileUrl') ?? '';
    final externalLink = str('ExternalLink') ?? '';
    final content = remoteMessage.notification?.body ?? '';
    const contentId = '';
    final notificationModel = NotificationModel(
      notificationId: notificationIds,
      createdDay: createdIso,
      createdTime: createdIso,
      title: remoteMessage.notification?.title ?? '',
      subTitle: remoteMessage.notification?.body ?? '',
      notificationActionType: notificationActionType,
      notificationActionParams: notificationActionParams,
      fileUrl: fileUrl,
      externalLink: externalLink,
      tags: tags,
      isRead: false,
    );
    final notificationDetail = NotificationDetail(
      content: content,
      contentId: contentId,
      symbolTags: tags,
      externalLink: externalLink,
      fileUrl: fileUrl,
    );
    return (notificationModel, notificationDetail);
  }
}
