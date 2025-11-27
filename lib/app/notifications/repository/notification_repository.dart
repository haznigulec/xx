import 'package:piapiri_v2/core/api/model/api_response.dart';

abstract class NotificationsRepository {
  Future<ApiResponse> getNotificationDetial({
    List<dynamic> notificationId = const [],
  });

  Future<ApiResponse> getNotificationUnReadCount();

  Future<ApiResponse> getNotificationPreferencesByCustomerID();
  Future<ApiResponse> getNotificationPreferencesByDeviceID();

  Future<ApiResponse> updateNotificationPreferencesByCustomerId(
    List<Map<String, dynamic>> list,
  );

  Future<ApiResponse> updateNotificationPreferencesByDeviceId(
    List<Map<String, dynamic>> list,
  );
  Future<ApiResponse> updateRegistrationToken({
    String? token,
    required String deviceId,
  });

  Future<ApiResponse> getNotificationCategories();

  Future<ApiResponse> getNotifications(
    int categoryId,
    int pageKey,
  );

  Future<ApiResponse> deleteNotification({
    int? categoryId,
    required List<int> notificationId,
  });

  Future<ApiResponse> readNotification({
    int? categoryId,
    required List<dynamic> notificationId,
    required bool isRead,
  });
}
