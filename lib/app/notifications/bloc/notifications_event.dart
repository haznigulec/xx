import 'package:flutter/material.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_event.dart';
import 'package:piapiri_v2/core/model/notification_model.dart';

abstract class NotificationsEvent extends PEvent {}

class GetNotificationUnReadCountEvent extends NotificationsEvent {
  GetNotificationUnReadCountEvent();
}

class NotificationDetailEvent extends NotificationsEvent {
  final List<dynamic> notificationId;
  final Function(NotificationDetail? notificationDetail) callback;

  NotificationDetailEvent({
    required this.notificationId,
    required this.callback,
  });
}

class NotificationGetCategories extends NotificationsEvent {
  final Function(NotificationCategoryModel)? callback;

  NotificationGetCategories({
    this.callback,
  });
}

class NotificationGetNotifications extends NotificationsEvent {
  final int categoryId;
  final int pageKey;

  NotificationGetNotifications({
    required this.categoryId,
    required this.pageKey,
  });
}

class NotificationDeleteEvent extends NotificationsEvent {
  final int? categoryId;
  final List<int> notificationId;
  final VoidCallback? callback;

  NotificationDeleteEvent({
    required this.notificationId,
    this.categoryId,
    this.callback,
  });
}

class NotificationReadEvent extends NotificationsEvent {
  final int? categoryId;
  final List<int> notificationId;
  final bool isRead;
  final VoidCallback? callback;

  NotificationReadEvent({
    required this.notificationId,
    required this.isRead,
    this.categoryId,
    this.callback,
  });
}

class NotificationSetCountByCategory extends NotificationsEvent {
  final int? categoryId;

  NotificationSetCountByCategory({
    required this.categoryId,
  });
}

class GetNotificationPreferencesByCustomerIdEvent extends NotificationsEvent {
  GetNotificationPreferencesByCustomerIdEvent();
}

class GetNotificationPreferencesByDeviceIdEvent extends NotificationsEvent {
  GetNotificationPreferencesByDeviceIdEvent();
}

class UpdateNotificationPreferencesByCustomerIdEvent extends NotificationsEvent {
  final List<Map<String, dynamic>> list;

  UpdateNotificationPreferencesByCustomerIdEvent({
    required this.list,
  });
}

class UpdateNotificationPreferencesByDeviceIdEvent extends NotificationsEvent {
  final List<Map<String, dynamic>> list;

  UpdateNotificationPreferencesByDeviceIdEvent({
    required this.list,
  });
}
