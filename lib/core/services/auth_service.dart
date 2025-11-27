import 'package:piapiri_v2/core/api/client/api_client.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/config/app_info.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';

class AuthService {
  final ApiClient api;

  AuthService(this.api);

  static const String _checkotpUrl = '/adkcustomer/checkotp';
  static const String _requestOtpUrl = '/adkcustomer/requestotp';
  static const String _forgotPasswordUrl = '/adkcustomer/forgottenpassword';
  static const String _resetPasswordUrl = '/adkcustomer/resetpassword';
  static const String _loginApiEndpoint = '/adkcustomer/login';
  static const String _changeExpiredPassword = '/adkcustomer/changeexpiredpassword';

  Future<ApiResponse> checkOtp(
    String customerNo,
    String otp,
  ) async {
    return api.post(
      _checkotpUrl,
      tokenized: true,
      body: {
        'CustomerExtId': customerNo,
        'Otp': otp,
        'deviceId': getIt<AppInfo>().deviceId,
      },
    );
  }

  Future<ApiResponse> againOtp(
    String customerNo,
  ) async {
    return api.post(
      _requestOtpUrl,
      body: {
        'CustomerExtId': customerNo,
      },
    );
  }

  Future<ApiResponse> login(
    String customerExtId,
    String password,
    String deviceId,
    String deviceLanguage,
    String? biometricData,
  ) async {
    return api.post(
      _loginApiEndpoint,
      body: {
        'customerExtId': customerExtId,
        'password': password,
        'language': deviceLanguage,
        'deviceId': deviceId,
        'deviceModel': getIt<AppInfo>().deviceModel,
        'appVersion': getIt<AppInfo>().appVersion,
        if (biometricData != null) 'BiometricData': biometricData,
      },
    );
  }

  Future<ApiResponse> forgotPassword({
    String? tcNo = '',
    String? taxNo = '',
    String cellPhone = '',
    String? birthDate,
    String? accountExtId = '',
  }) async {
    return api.post(
      _forgotPasswordUrl,
      body: {
        'customerExtId': '',
        'tckn': tcNo,
        'taxNo': taxNo,
        'cellPhone': '0$cellPhone',
        if (birthDate != null) 'birthDate': birthDate,
        'accountExtId': accountExtId,
      },
    );
  }

  Future<ApiResponse> resetPassword({
    String customerId = '',
    String otp = '',
  }) async {
    return api.post(
      _resetPasswordUrl,
      body: {
        'customerExtId': customerId,
        'OTP': otp,
      },
    );
  }

  Future<ApiResponse> requestOtp(
    String customerExtId,
  ) async {
    return api.post(
      _requestOtpUrl,
      body: {
        'customerExtId': customerExtId,
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
}
