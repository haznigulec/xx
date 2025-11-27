import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/core/api/client/api_client.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/config/app_info.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/paired_devices_model.dart';
import 'package:piapiri_v2/core/model/user_model.dart';

class ProfileService {
  final ApiClient api;

  ProfileService(this.api);

  static const String _resetApplicationSettingsByDeviceId = '/usersettings/resetapplicationsettingsbydeviceid';
  static const String _resetApplicationSettingsByCustomerId = '/usersettings/resetapplicationsettingsbycustomerextid';

  static const String _validateAvatar = '/adkavatar/validateavatar';
  static const String _uploadAvatar = '/adkavatar/uploadavatar';
  static const String _generateAvatar = '/adkavatar/generateavatar';
  static const String _setAvatar = '/adkavatar/setavatar';
  static const String _getAvatarSettings = '/adkavatar/getavatarsettings';
  static const String _getCustomerParemeters = '/adkcustomer/getcustomerparameters';
  static const String _updateCustomerParemeters = '/adkcustomer/updatecustomerparameters';
  static const String _changePasswordUrl = '/adkcustomer/changepassword';
  static const String _changeExpiredPassword = '/adkcustomer/changeexpiredpassword';
  static const String _setLanguageUrlByCustomerId = '/usersettings/setlanguagebycustomerextid';
  static const String _getPairedDevices = '/adkcustomer/getcustomerdeviceinfo';
  static const String _deletePairedDevices = '/adkcustomer/deletecustomerdeviceinfo';

  Future<ApiResponse> resetAppSettings() async {
    bool isTokenized = getIt<AuthBloc>().state.isLoggedIn;
    String endPoint = _resetApplicationSettingsByDeviceId;
    final Map<String, dynamic> body = {};
    if (isTokenized) {
      endPoint = _resetApplicationSettingsByCustomerId;
      body['customerExtId'] = UserModel.instance.customerId;
    } else {
      body['deviceId'] = getIt<AppInfo>().deviceId;
    }

    return api.post(
      endPoint,
      tokenized: isTokenized,
      body: body,
    );
  }

  Future<ApiResponse> changeLanguage(
    String languageCode,
  ) async {
    return api.post(
      _setLanguageUrlByCustomerId,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'langCode': languageCode,
      },
    );
  }

  Future<ApiResponse> validateAvatar({
    String customerExtId = '',
    String deviceId = '',
    String? refCode,
  }) async {
    return api.post(
      _validateAvatar,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'deviceId': deviceId,
        'refCode': refCode,
      },
    );
  }

  Future<ApiResponse> uploadAvatar({
    String customerExtId = '',
    String deviceId = '',
    String image = '',
  }) async {
    return api.post(
      _uploadAvatar,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'deviceId': deviceId,
        'image': image,
      },
    );
  }

  Future<ApiResponse> generateAvatar({
    String customerExtId = '',
    String deviceId = '',
    String descriptionText = '',
  }) async {
    return api.post(
      _generateAvatar,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'deviceId': deviceId,
        'descriptionText': descriptionText,
      },
    );
  }

  Future<ApiResponse> setAvatar({
    String customerExtId = '',
    String deviceId = '',
    String refCode = '',
  }) async {
    return api.post(
      _setAvatar,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'deviceId': deviceId,
        'refCode': refCode,
      },
    );
  }

  Future<ApiResponse> getAvatarSettings() async {
    return api.post(
      _getAvatarSettings,
    );
  }

  Future<ApiResponse> changePassword({
    String customerId = '',
    String oldPassword = '',
    String newPassword = '',
  }) async {
    return api.post(
      _changePasswordUrl,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      },
    );
  }

  Future<ApiResponse> getCustomerParemeters() async {
    return api.post(
      _getCustomerParemeters,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
      },
    );
  }

  Future<ApiResponse> updateCustomerParemeters({
    String receiptType = '',
    required bool interest,
  }) async {
    return api.post(
      _updateCustomerParemeters,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'interest': interest,
        'receiptType': receiptType,
      },
    );
  }

  Future<ApiResponse> changeExpiredPassword({
    String customerExtId = '',
    String oldPassword = '',
    String newPassword = '',
    String otpCode = '',
    bool isTCKN = false,
  }) async {
    return api.post(
      _changeExpiredPassword,
      tokenized: true,
      body: {
        'customerExtId': customerExtId,
        'oldPassword': oldPassword,
        'newPassword': newPassword,
        'otpCode': otpCode,
        'isTCKN': isTCKN,
      },
    );
  }

  Future<ApiResponse> getPairedDevices() async {
    return api.post(
      _getPairedDevices,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
      },
    );
  }

  Future<ApiResponse> deletePairedDevices(PairedDevicesModel device) async {
    return api.post(
      _deletePairedDevices,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'deviceId': device.deviceId,
      },
    );
  }
}
