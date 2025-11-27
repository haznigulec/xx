import 'package:flutter_insider/flutter_insider.dart';
// ignore: implementation_imports
import 'package:flutter_insider/src/identifiers.dart';
import 'package:local_auth/local_auth.dart';
import 'package:piapiri_v2/app/auth/repository/auth_repository.dart';
import 'package:piapiri_v2/common/utils/local_keys.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/config/analytics/analytics.dart';
import 'package:piapiri_v2/core/config/app_info.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/user_model.dart';
import 'package:piapiri_v2/core/storage/local_storage.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class AuthRepositoryImpl extends AuthRepository {
  final LocalAuthentication auth = LocalAuthentication();

  @override
  Future<bool> authenticate({
    required String localizedReason,
    AuthenticationOptions options = const AuthenticationOptions(),
  }) {
    return auth.authenticate(
      localizedReason: L10n.tr('biometric_login'),
      options: const AuthenticationOptions(
        stickyAuth: true,
        biometricOnly: false,
        useErrorDialogs: true,
      ),
    );
  }

  @override
  Future<bool> get canCheckBiometrics => auth.canCheckBiometrics;

  @override
  Future<ApiResponse> checkOtp({
    required String customerId,
    required String otp,
  }) {
    return getIt<PPApi>().authService.checkOtp(customerId, otp);
  }

  @override
  void clearFavoriteList() {
    // getIt<MarketListingBloc>().add(MarketListingClearFavoriteListEvent());
  }

  @override
  Future<ApiResponse> forgotPassword({
    String? tcNo,
    String? taxNo,
    required String cellPhone,
    String? birthDate,
    String accountExtId = '100',
  }) {
    return getIt<PPApi>().authService.forgotPassword(
          tcNo: tcNo,
          taxNo: taxNo,
          cellPhone: cellPhone,
          birthDate: birthDate,
          accountExtId: accountExtId,
        );
  }

  @override
  Future<List<BiometricType>> getAvailableBiometrics() {
    return auth.getAvailableBiometrics();
  }

  @override
  void hideCreateAccount() {
    getIt<LocalStorage>().write(LocalKeys.showCreateAccount, false);
  }

  @override
  Future<bool> isDeviceSupported() {
    return auth.isDeviceSupported();
  }

  @override
  Future<ApiResponse> login({
    required String customerId,
    required String password,
    required String language,
    String? biometricData,
  }) {
    return getIt<PPApi>().authService.login(
          customerId,
          password,
          getIt<AppInfo>().deviceId,
          language,
          biometricData,
        );
  }

  @override
  Future<ApiResponse> resetPassword({
    required String customerId,
    required String otp,
  }) {
    return getIt<PPApi>().authService.resetPassword(
          customerId: customerId,
          otp: otp,
        );
  }

  @override
  Future<ApiResponse> sendOtpSmsAgain({
    required String customerId,
  }) {
    return getIt<PPApi>().authService.againOtp(
          customerId,
        );
  }

  @override
  void setAccountList({
    required List<dynamic> accountList,
    required String defaultAccount,
    required String customerId,
  }) {
    getIt<LocalStorage>().write(LocalKeys.accountList, accountList);
    getIt<LocalStorage>().write(LocalKeys.defaultAccount, defaultAccount);
    getIt<LocalStorage>().write(LocalKeys.customerId, customerId);
    getIt<AppInfo>().updateAccountList();
  }

  @override
  void setFirebaseProperties() {
    getIt<Analytics>().setFirebaseUserProperties(
      customerId: UserModel.instance.customerId ?? '',
      deviceId: getIt<AppInfo>().deviceId,
    );
  }

  @override
  void setInsiderData() {
    UserModel user = UserModel.instance;
    FlutterInsiderIdentifiers identifiers = FlutterInsiderIdentifiers();
    identifiers
      ..addEmail(user.email)
      ..addPhoneNumber(user.phone)
      ..addUserID(user.customerId ?? '');

    FlutterInsider.Instance.getCurrentUser()
      ?..setEmail(user.email)
      ..setPhoneNumber(user.phone)
      ..setCustomAttributeWithString('customer_no', user.customerId ?? '')
      ..setName(user.name)
      ..login(identifiers);
  }

  @override
  String get localCustomerId => getIt<LocalStorage>().read(LocalKeys.customerId);

  @override
  bool get showBiometricLogin => getIt<LocalStorage>().read(LocalKeys.showBiometricLogin);

  @override
  Future<ApiResponse> changeExpiredPassword({
    String customerExtId = '',
    String oldPassword = '',
    String newPassword = '',
    String otpCode = '',
    bool isTCKN = false,
  }) async {
    return getIt<PPApi>().authService.changeExpiredPassword(
          customerExtId: customerExtId,
          oldPassword: oldPassword,
          newPassword: newPassword,
          otpCode: otpCode,
          isTCKN: isTCKN,
        );
  }

  @override
  Future<ApiResponse> requestOtp(
    String customerExtId,
  ) async {
    return getIt<PPApi>().authService.requestOtp(
          customerExtId,
        );
  }

  @override
  Future<String> readPassword() async {
    return getIt<LocalStorage>().readSecure(LocalKeys.loginTcCustomerNo).toString();
  }

  @override
  Future<String> readUsername() async {
    return getIt<LocalStorage>().readSecure(LocalKeys.loginPassword).toString();
  }

  @override
  Map<String, int>? readLoginCount() {
    final dynamic rawData = getIt<LocalStorage>().read(LocalKeys.loginCount);
    if (rawData != null) {
      if (rawData is Map) {
        return rawData.map((key, value) => MapEntry(key.toString(), value as int));
      }
      return getIt<LocalStorage>().read(LocalKeys.loginCount) as Map<String, int>;
    }
    return getIt<LocalStorage>().read(LocalKeys.loginCount) == null
        ? null
        : getIt<LocalStorage>().read(LocalKeys.loginCount) as Map<String, int>;
  }

  @override
  void writeLoginCount({
    required Map<String, int> count,
  }) {
    getIt<LocalStorage>().write(
      LocalKeys.loginCount,
      count,
    );
  }
}
