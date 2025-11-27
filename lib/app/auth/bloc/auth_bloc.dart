import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_insider/flutter_insider.dart';
import 'package:local_auth/local_auth.dart';
import 'package:piapiri_v2/app/assets/bloc/assets_bloc.dart';
import 'package:piapiri_v2/app/assets/bloc/assets_event.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_event.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_state.dart';
import 'package:piapiri_v2/app/auth/repository/auth_repository.dart';
import 'package:piapiri_v2/app/contracts/bloc/contracts_bloc.dart';
import 'package:piapiri_v2/app/contracts/bloc/contracts_event.dart';
import 'package:piapiri_v2/app/favorite_lists/bloc/favorite_list_bloc.dart';
import 'package:piapiri_v2/app/favorite_lists/bloc/favorite_list_event.dart';
import 'package:piapiri_v2/common/utils/local_keys.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_bloc.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_event.dart' as app_info_event;
import 'package:piapiri_v2/core/app_info/repository/app_info_repository.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/bloc/matriks/matriks_bloc.dart';
import 'package:piapiri_v2/core/bloc/matriks/matriks_event.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_bloc.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_event.dart';
import 'package:piapiri_v2/core/config/app_info.dart';
import 'package:piapiri_v2/core/config/bloc_locator.dart';
import 'package:piapiri_v2/core/config/notification_handler.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/config/service_locator_manager.dart';
import 'package:piapiri_v2/core/config/session_timer.dart';
import 'package:piapiri_v2/core/model/account_model.dart';
import 'package:piapiri_v2/core/model/user_model.dart';
import 'package:piapiri_v2/core/services/token_service.dart';
import 'package:piapiri_v2/core/storage/local_storage.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class AuthBloc extends PBloc<AuthState> {
  final AuthRepository _authRepository;
  final AppInfoRepository _appInfoRepository;

  AuthBloc({
    required AuthRepository authRepository,
    required AppInfoRepository appInfoRepository,
  })  : _authRepository = authRepository,
        _appInfoRepository = appInfoRepository,
        super(initialState: const AuthState()) {
    on<InitEvent>(_onInit);
    on<LogInEvent>(_onLogin);
    on<BiometricLoginEvent>(_onBiometricLogin);
    on<CheckOTPEvent>(_onCheckOTP);
    on<CheckOTPAgainEvent>(_onCheckOTPAgain);
    on<ForgotPasswordEvent>(_onForgotPassword);
    on<ResetPasswordEvent>(_onResetPassword);
    on<ChangeExpiredPasswordEvent>(_onChangeExpiredPassword);
    on<RequestOtpEvent>(_onRequestOtp);
    on<LogoutEvent>(_onLogoutEvent);
  }

  FutureOr<void> _onInit(InitEvent event, Emitter<AuthState> emit) {
    String localCustomerId = _authRepository.localCustomerId;
    bool showBiometricLogin = _authRepository.showBiometricLogin;

    emit(
      state.copyWith(
        customerId: localCustomerId,
        showBiometricLogin: showBiometricLogin,
      ),
    );
  }

  FutureOr<void> _onLogin(
    LogInEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    String lang = Platform.localeName.split('_')[0];
    if (lang != 'en' || lang != 'tr') {
      lang = 'tr';
    }
    String username = event.username ?? await _authRepository.readUsername();
    String password = event.password ?? await _authRepository.readPassword();

    ApiResponse response = await _authRepository.login(
      customerId: username,
      password: password,
      language: lang,
      biometricData: event.biometricData,
    );

    if (response.success) {
      getIt<AppInfo>().selectedAccount = '';

      UserModel(
        phone: response.data['customer']['phone'],
        address: response.data['customer']['adress'],
        email: response.data['customer']['email'],
        name: response.data['customer']['fullName'],
        customerId: response.data['customer']['customerExtId'],
        password: password,
        accountId: response.data['customer']['accountExtId'],
        langCode: response.data['customer']['langCode'],
        customerType: response.data['customer']['customerType'],
        innerType: response.data['customer']['customerType1'],
        accounts: (response.data['accountList'] as List).map((e) => AccountModel.fromJson(e)).toList(),
        alpacaAccountStatus: response.data['alpacaAccountStatus'],
        changePasswordRequired: response.data['changePasswordRequired'],
        customerChannel: response.data['customerChannel'],
      );
      getIt<AppInfoBloc>().add(
        app_info_event.WriteHasMembershipEvent(
          status: true,
          gsm: response.data['customer']['phone'],
        ),
      );
      await getIt<LocalStorage>()
          .writeSecureAsync(LocalKeys.loginTcCustomerNo, response.data['customer']['customerExtId']);
      await getIt<LocalStorage>().writeSecureAsync(LocalKeys.loginPassword, password);
      if (_authRepository.readLoginCount() == null) {
        _authRepository.writeLoginCount(
          count: {
            response.data['customer']['customerExtId'].toString(): 0,
          },
        );
        getIt<AppInfoBloc>().add(
          app_info_event.ReadLoginCountEvent(),
        );
      }

      if ((_authRepository.readLoginCount() != null &&
              _authRepository.readLoginCount()![response.data['customer']['customerExtId']] == 0 &&
              !_appInfoRepository.readHasMembership()['status']) ||
          state.shouldRegisterForNotifications) {
        await getIt<NotificationHandler>().registerForNotifications();
      }

      if (event.willRemember) {
        getIt<LocalStorage>().write('tc_customer_no', event.username);
      } else {
        getIt<LocalStorage>().delete('tc_customer_no');
      }

      _authRepository.setInsiderData();
      _authRepository.setFirebaseProperties();
      _authRepository.clearFavoriteList();

      if (response.data['changePasswordRequired']) {
        event.onChangedRequiredPassword?.call(
          response.data['customer']['customerExtId'],
          response.data['changePasswordRequired'],
        );
        return;
      } else {
        final newCustomerWelcomeScreen = response.data['newCustomerWelcomeScreen'] ?? false;
        if (response.data['otpRequired']) {
          event.onCheckOtp?.call(
            response.data['customer']['customerExtId'],
            response.data['otpTimeOut'],
            newCustomerWelcomeScreen,
          );
        } else {
          if ((response.data['accountList'] as List<dynamic>).isNotEmpty) {
            String defaultAccount = '';
            List<dynamic> accountList = response.data['accountList'].map((e) {
              if (e['defaultAccount'] == true) {
                defaultAccount = e['accountExtId'];
              }
              return {
                'accountExtId': e['accountExtId'].toString(),
                'currencyType': e['currencyType'].toString(),
              };
            }).toList();
            accountList.sort((a, b) => a['accountExtId'].compareTo(b['accountExtId']));

            _authRepository.setAccountList(
              accountList: accountList,
              defaultAccount: defaultAccount,
              customerId: response.data['customer']['customerExtId'],
            );
          }
          event.onSuccess?.call(
            response.data['customer']['customerExtId'],
            newCustomerWelcomeScreen,
          );
        }
      }
      getIt<ContractsBloc>().add(
        GetCustomerAnswersEvent(
          onSuccess: (customerResponse) {
            if (customerResponse.riskLevel != '' && customerResponse.riskLevel != null) {
              getIt<ContractsBloc>().add(
                GetGtpContractEvent(),
              );
            }
          },
        ),
      );
      emit(
        state.copyWith(
          type: PageState.success,
          isLoggedIn: !response.data['otpRequired'] ? true : null,
        ),
      );
    } else {
      event.onError?.call('${response.error?.message}');
      emit(
        state.copyWith(
          type: PageState.failed,
        ),
      );
    }
  }

  FutureOr<void> _onBiometricLogin(
    BiometricLoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      bool deviceSupported = await _authRepository.isDeviceSupported();

      if (!deviceSupported) {
        event.onNotSupported?.call();
        return;
      }

      bool hasBiometrics = await _authRepository.canCheckBiometrics;
      if (!hasBiometrics) {
        List<BiometricType> availableBiometrics = await _authRepository.getAvailableBiometrics();
        if (availableBiometrics.isEmpty) {
          event.onFailed('');
          return;
        }
        if (availableBiometrics.contains(BiometricType.face)) {
          return event.onFailed('faceid_neccessary_alert');
        } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
          return event.onFailed('fingerprint_neccessary_alert');
        } else {
          return event.onFailed(L10n.tr('biometric_alert'));
        }
      }

      bool authenticated = await _authRepository.authenticate(
        localizedReason: L10n.tr('biometric_login'),
        options: const AuthenticationOptions(
          stickyAuth: true, // for work in background.
          biometricOnly: false,
          useErrorDialogs: true,
        ),
      );

      if (authenticated) {
        _authRepository.hideCreateAccount();
        event.onSuccess();

        emit(
          state.copyWith(
            type: PageState.success,
            isLoggedIn: true,
          ),
        );
      } else {
        event.onFailed('');
      }
    } on PlatformException catch (e) {
      event.onFailed('biometric_login.${e.code}');
    }
  }

  FutureOr<void> _onCheckOTP(
    CheckOTPEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    ApiResponse response = await _authRepository.checkOtp(
      customerId: event.customerExtId,
      otp: event.otp,
    );

    if (response.success) {
      String defaultAccount = '';
      List<dynamic> accountList = response.data['accountList'].map((e) {
        if (e['defaultAccount'] == true) {
          defaultAccount = e['accountExtId'];
        }
        return {
          'accountExtId': e['accountExtId'].toString(),
          'currencyType': e['currencyType'].toString(),
        };
      }).toList();

      UserModel.instance.setAccounts =
          List<AccountModel>.from(response.data['accountList'].map((e) => AccountModel.fromJson(e)).toList());

      _authRepository.setAccountList(
        accountList: accountList,
        defaultAccount: defaultAccount,
        customerId: event.customerExtId,
      );

      emit(
        state.copyWith(
          type: PageState.success,
          isLoggedIn: true,
        ),
      );

      event.onSuccess?.call(response.data);
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: L10n.tr('check.otp.${response.error?.message ?? ''}'),
            errorCode: '09LANG01',
          ),
        ),
      );
      event.onError?.call(response.error?.message ?? '');
    }
  }

  FutureOr<void> _onCheckOTPAgain(
    CheckOTPAgainEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _authRepository.sendOtpSmsAgain(
      customerId: event.customerExtId,
    );

    if (response.success) {
      emit(
        state.copyWith(
          type: PageState.success,
          isLoggedIn: true,
        ),
      );
      event.onSuccess?.call(response.data);
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: 'again.otp.${response.error?.message ?? ''}',
            errorCode: '09OTP0002',
          ),
        ),
      );
      event.onError?.call(response.error?.message ?? '');
    }
  }

  String formatPhoneNumber(String phone) {
    if (!phone.startsWith('0')) {
      phone = '0$phone';
    }
    return phone;
  }

  FutureOr<void> _onForgotPassword(
    ForgotPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    ApiResponse response = await _authRepository.forgotPassword(
      tcNo: event.tcNo,
      taxNo: event.taxNo,
      cellPhone: event.cellPhone,
      birthDate: event.birthDate,
      accountExtId: '100',
    );

    if (response.success) {
      if (!response.data['result']) {
        return emit(
          state.copyWith(
            type: PageState.failed,
            error: const PBlocError(
              showErrorWidget: true,
              message: 'error',
              errorCode: '09OTP0003',
            ),
          ),
        );
      }

      emit(
        state.copyWith(
          type: PageState.success,
        ),
      );

      event.onSuccess(response.data);
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '09OTP0004',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onResetPassword(
    ResetPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    ApiResponse response = await _authRepository.resetPassword(
      customerId: event.customerId,
      otp: event.otp,
    );

    if (response.success) {
      getIt<LocalStorage>().write(
        LocalKeys.showBiometricLogin,
        false,
      );
      if (!response.data['result']) {
        return emit(
          state.copyWith(
            type: PageState.failed,
            error: const PBlocError(
              showErrorWidget: true,
              message: 'error',
              errorCode: '09OTP0005',
            ),
          ),
        );
      }

      emit(
        state.copyWith(
          type: PageState.success,
        ),
      );

      event.onSuccess();
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '09OTP0006',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onChangeExpiredPassword(
    ChangeExpiredPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _authRepository.changeExpiredPassword(
      customerExtId: event.customerId,
      oldPassword: event.oldPassword,
      newPassword: event.newPassword,
      otpCode: event.otpCode,
      isTCKN: event.isTCKN,
    );

    if (response.success) {
      emit(
        state.copyWith(
          type: PageState.success,
        ),
      );
      event.onSuccess();
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '09CEPS01',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onRequestOtp(
    RequestOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _authRepository.requestOtp(
      event.customerId,
    );

    if (response.success) {
      emit(
        state.copyWith(
          type: PageState.success,
        ),
      );
      event.onSuccess(response);
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '09ROTP01',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onLogoutEvent(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoggedIn: false,
        shouldRegisterForNotifications: event.shouldRegisterForNotifications,
        customerId: '',
      ),
    );
    getIt<FavoriteListBloc>().add(ClearWatchListEvent());
    getIt<LocalStorage>().delete(LocalKeys.customerInfo);
    getIt<LocalStorage>().delete(LocalKeys.otpTimeOut);
    getIt<LocalStorage>().delete(LocalKeys.customerType);
    getIt<TokenService>().clearToken();
    getIt<AssetsBloc>().add(
      ResetAssetsStateEvent(),
    );
    getIt<PPApi>().matriksService.deleteMatriksTokens();
    getIt<MatriksBloc>().add(
      MatriksGetTopicsEvent(
        callback: () async {
          await ServiceLocatorManager.resetMqtt();
          await BlocLocator.reset();
          getIt<SymbolBloc>().add(SymbolRestartSubscription());
        },
      ),
    );

    event.callback?.call();
    ServiceLocatorManager.cancelQueue();
    SessionTimer.instance?.cancelTimer();
    FlutterInsider.Instance.getCurrentUser()?.logout();
  }
}
