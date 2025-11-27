import 'package:local_auth/local_auth.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';

abstract class AuthRepository {
  Future<bool> authenticate({
    required String localizedReason,
    AuthenticationOptions options = const AuthenticationOptions(
      stickyAuth: true,
      biometricOnly: false,
      useErrorDialogs: true,
    ),
  });

  Future<bool> get canCheckBiometrics;

  Future<ApiResponse> checkOtp({
    required String customerId,
    required String otp,
  });

  void clearFavoriteList();

  Future<ApiResponse> forgotPassword({
    String? tcNo,
    String? taxNo,
    required String cellPhone,
    String? birthDate,
    String accountExtId = '100',
  });

  Future<bool> isDeviceSupported();

  Future<List<BiometricType>> getAvailableBiometrics();

  void hideCreateAccount();

  String get localCustomerId;

  Future<ApiResponse> login({
    required String customerId,
    required String password,
    required String language,
    String? biometricData,
  });

  Future<ApiResponse> resetPassword({
    required String customerId,
    required String otp,
  });

  Future<ApiResponse> sendOtpSmsAgain({
    required String customerId,
  });

  void setAccountList({
    required List<dynamic> accountList,
    required String defaultAccount,
    required String customerId,
  });

  void setFirebaseProperties();

  void setInsiderData();

  bool get showBiometricLogin;

  Future<ApiResponse> changeExpiredPassword({
    String customerExtId = '',
    String oldPassword = '',
    String newPassword = '',
    String otpCode = '',
    bool isTCKN = false,
  });

  Future<ApiResponse> requestOtp(
    String customerExtId,
  );

  Future<String> readUsername();

  Future<String> readPassword();

  Map<String, int>? readLoginCount();

  void writeLoginCount({
    required Map<String, int> count,
  });
}
