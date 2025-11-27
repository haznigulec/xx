import 'dart:convert';

import 'package:piapiri_v2/app/app_settings/repository/settings_repository.dart';
import 'package:piapiri_v2/common/utils/local_keys.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/general_settings.dart';
import 'package:piapiri_v2/core/model/order_settings.dart';
import 'package:piapiri_v2/core/model/user_model.dart';
import 'package:piapiri_v2/core/storage/local_storage.dart';

class SettingsRepositoryImpl extends SettingsRepository {
  @override
  GeneralSettings? getApplicationSettings() {
    String? settings = getIt<LocalStorage>().read(LocalKeys.generalSettings);
    if (settings == null) {
      return null;
    }
    return GeneralSettings.fromJson(json.decode(settings));
  }

  @override
  bool? getV1BiometricData() {
    return getIt<LocalStorage>().read(LocalKeys.showBiometricLogin);
  }

  @override
  void setApplicationSettings({
    required GeneralSettings generalSettings,
  }) {
    getIt<LocalStorage>().write(LocalKeys.generalSettings, json.encode(generalSettings.toJson()));
  }

  @override
  Future<ApiResponse> getOrderSettings() {
    return getIt<PPApi>().settingsService.getOrderSettings();
  }

  @override
  Future<ApiResponse> setOrderSettings({
    required OrderSettings orderSettings,
  }) {
    return getIt<PPApi>().settingsService.setOrderSettings(orderSettings);
  }

  @override
  Future<ApiResponse> changePassword({
    required String oldPassword,
    required String newPassword,
  }) {
    return getIt<PPApi>().profileService.changePassword(
          customerId: UserModel.instance.customerId ?? '',
          oldPassword: oldPassword,
          newPassword: newPassword,
        );
  }

  @override
  Future<ApiResponse> resetApplicationSettings() {
    return getIt<PPApi>().profileService.resetAppSettings();
  }

  @override
  Future<ApiResponse> getCustomerParameters() {
    return getIt<PPApi>().profileService.getCustomerParemeters();
  }

  @override
  Future<ApiResponse> updateCustomerParemeters({
    String? receiptType,
    required bool interest,
  }) {
    return getIt<PPApi>().profileService.updateCustomerParemeters(
          receiptType: receiptType ?? '',
          interest: interest,
        );
  }

  @override
  String getDefaultAccount() {
    return getIt<LocalStorage>().read(LocalKeys.defaultAccount).toString();
  }
}
