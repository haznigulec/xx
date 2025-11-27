import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/model/general_settings.dart';
import 'package:piapiri_v2/core/model/order_settings.dart';

abstract class SettingsRepository {
  GeneralSettings? getApplicationSettings();

  bool? getV1BiometricData();

  void setApplicationSettings({
    required GeneralSettings generalSettings,
  });

  Future<ApiResponse> getOrderSettings();

  Future<ApiResponse> setOrderSettings({
    required OrderSettings orderSettings,
  });

  Future<ApiResponse> changePassword({
    required String oldPassword,
    required String newPassword,
  });

  Future<ApiResponse> resetApplicationSettings();

  Future<ApiResponse> getCustomerParameters();

  Future<ApiResponse> updateCustomerParemeters({
    String receiptType,
    required bool interest,
  });

  String getDefaultAccount();
}
