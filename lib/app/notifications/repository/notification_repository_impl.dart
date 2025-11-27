import 'package:piapiri_v2/app/notifications/repository/notification_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';

class NotificationRepositoryImpl extends NotificationsRepository {
  @override
  Future<ApiResponse> getNotificationDetial({
    List<dynamic> notificationId = const [],
  }) async {
    return getIt<PPApi>().notificationService.getNotificationDetial(
          notificationId: notificationId,
        );
  }

  @override
  Future<ApiResponse> getNotificationUnReadCount() async {
    return getIt<PPApi>().notificationService.getNotificationUnReadCount();
  }

  @override
  Future<ApiResponse> getNotificationPreferencesByCustomerID() async {
    return getIt<PPApi>().notificationService.getNotificationPreferencesByCustomerID();
  }

  @override
  Future<ApiResponse> getNotificationPreferencesByDeviceID() async {
    return getIt<PPApi>().notificationService.getNotificationPreferencesByDeviceID();
  }

  @override
  Future<ApiResponse> updateNotificationPreferencesByCustomerId(
    List<Map<String, dynamic>> list,
  ) async {
    return getIt<PPApi>().notificationService.updateNotificationPreferencesByCustomerId(
          list,
        );
  }

  @override
  Future<ApiResponse> updateNotificationPreferencesByDeviceId(
    List<Map<String, dynamic>> list,
  ) async {
    return getIt<PPApi>().notificationService.updateNotificationPreferencesByDeviceId(
          list,
        );
  }

  @override
  Future<ApiResponse> updateRegistrationToken({
    String? token,
    required String deviceId,
  }) async {
    return getIt<PPApi>().notificationService.updateRegistrationToken(
          token: token,
          deviceId: deviceId,
        );
  }

  @override
  Future<ApiResponse> getNotificationCategories() async {
    return getIt<PPApi>().notificationService.getNotificationCategories();
  }

  @override
  Future<ApiResponse> getNotifications(
    int categoryId,
    int pageKey,
  ) async {
    return getIt<PPApi>().notificationService.getNotifications(
          categoryId,
          pageKey,
        );
  }

  @override
  Future<ApiResponse> deleteNotification({
    int? categoryId,
    required List<int> notificationId,
  }) async {
    return getIt<PPApi>().notificationService.deleteNotification(
          categoryId: categoryId,
          notificationId: notificationId,
        );
  }

  @override
  Future<ApiResponse> readNotification({
    int? categoryId,
    required List<dynamic> notificationId,
    required bool isRead,
  }) async {
    return getIt<PPApi>().notificationService.readNotification(
          categoryId: categoryId,
          notificationId: notificationId,
          isRead: isRead,
        );
  }
}
