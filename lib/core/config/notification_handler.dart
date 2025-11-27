import 'package:piapiri_v2/core/model/notification_model.dart';

abstract class NotificationHandler {
  Future<void> executePendingNavigationIfExists();

  void performNotificationAction({
    String? action,
    String? params,
    String? tags,
    String? externalLink,
    String? fileUrl,
    NotificationModel? notificationModel,
    NotificationDetail? notificationDetail,
  });

  Future<void> registerForNotifications();
}
