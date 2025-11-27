import 'package:piapiri_v2/core/api/client/api_client.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/config/app_info.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/user_model.dart';

class NotificationService {
  final ApiClient api;

  NotificationService(this.api);
  static const String _updateNotificationPreferencesByDeviceIdUrl = '/cmsnotificationpreferences/updatebydeviceid';
  static const String _getNotificationCountByCustomerId = '/CmsNotification/getnotificationcountbycustomerextid';
  static const String _getNotificationDetailById = '/CmsNotification/getnotificationdetailbyidv2';
  static const String _getNotificationPreferencesByCustomerIdUrl = '/cmsnotificationpreferences/getbycustomerextid';
  static const String _getNotificationPreferencesByDeviceIdUrl = '/cmsnotificationpreferences/getbydeviceid';
  static const String _updateNotificationPreferencesByCustomerIdUrl =
      '/cmsnotificationpreferences/updatebycustomerextid';
  static const String _updateCustomerRegistrationToken = '/CmsNotification/updatecustomerregistrationtoken';
  static const String _getNotificationCategoriesByCustomerExtId =
      '/cmsnotification/getnotificationcategoriesbycustomerextid';
  static const String _getNotificationsByCustomerExtId = '/cmsnotification/getnotificationsbycustomerextid';
  static const String _deleteNotificationsByCustomerExtId = '/CmsNotification/deletenotificationsbycustomerextid';
  static const String _readNotificationsByCustomerExtId = '/CmsNotification/readnotificationsbycustomerextid';

  Future<ApiResponse> getNotificationDetial({
    List<dynamic> notificationId = const [],
  }) async {
    return api.post(
      _getNotificationDetailById,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'notificationId': notificationId,
      },
    );
  }

  Future<ApiResponse> getNotificationUnReadCount() async {
    return api.post(
      _getNotificationCountByCustomerId,
      tokenized: true,
      body: {
        'customerextid': UserModel.instance.customerId,
      },
    );
  }

  Future<ApiResponse> getNotificationPreferencesByCustomerID() async {
    return api.post(
      _getNotificationPreferencesByCustomerIdUrl,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
      },
    );
  }

  Future<ApiResponse> getNotificationPreferencesByDeviceID() async {
    return api.post(
      _getNotificationPreferencesByDeviceIdUrl,
      body: {
        'deviceId': getIt<AppInfo>().deviceId,
      },
    );
  }

  Future<ApiResponse> updateNotificationPreferencesByCustomerId(
    List<Map<String, dynamic>> list,
  ) async {
    return api.post(
      _updateNotificationPreferencesByCustomerIdUrl,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'preferences': list,
      },
    );
  }

  Future<ApiResponse> updateNotificationPreferencesByDeviceId(
    List<Map<String, dynamic>> list,
  ) async {
    return api.post(
      _updateNotificationPreferencesByDeviceIdUrl,
      body: {
        'deviceId': getIt<AppInfo>().deviceId,
        'preferences': list,
      },
    );
  }

  Future<ApiResponse> updateRegistrationToken({
    String? token,
    required String deviceId,
  }) async {
    return api.post(
      _updateCustomerRegistrationToken,
      body: {
        'deviceId': deviceId,
        'fcmRegistrationToken': token,
      },
    );
  }

  Future<ApiResponse> getNotificationCategories() async {
    final data = {
      'customerExtId': UserModel.instance.customerId,
    };

    return api.post(
      _getNotificationCategoriesByCustomerExtId,
      tokenized: true,
      body: data,
    );
  }

  Future<ApiResponse> getNotifications(
    int categoryId,
    int pageKey,
  ) async {
    final params = {
      'customerExtId': UserModel.instance.customerId,
      'categoryId': categoryId,
      'page': pageKey,
    };

    return api.post(
      _getNotificationsByCustomerExtId,
      tokenized: true,
      body: params,
    );
  }

  Future<ApiResponse> deleteNotification({
    int? categoryId,
    required List<int> notificationId,
  }) async {
    final params = {
      'customerExtId': UserModel.instance.customerId,
      'categoryId': categoryId,
      'notificationId': notificationId,
    };

    return api.post(
      _deleteNotificationsByCustomerExtId,
      tokenized: true,
      body: params,
    );
  }

  Future<ApiResponse> readNotification({
    int? categoryId,
    required List<dynamic> notificationId,
    required bool isRead,
  }) async {
    final params = {
      'customerExtId': UserModel.instance.customerId,
      'categoryId': categoryId,
      'notificationId': notificationId,
      'isRead': isRead,
    };

    return api.post(
      _readNotificationsByCustomerExtId,
      tokenized: true,
      body: params,
    );
  }
}
