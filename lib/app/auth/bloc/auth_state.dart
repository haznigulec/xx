import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';

class AuthState extends PState {
  final String message;
  final String? customerId;
  final bool showBiometricLogin;
  final bool isLoggedIn;
  final bool shouldRegisterForNotifications;

  const AuthState({
    super.type = PageState.initial,
    super.error,
    this.message = '',
    this.customerId,
    this.showBiometricLogin = false,
    this.isLoggedIn = false,
    this.shouldRegisterForNotifications = false,
  });

  @override
  AuthState copyWith({
    PageState? type,
    PBlocError? error,
    String? message,
    String? customerId,
    bool? showBiometricLogin,
    bool? isLoggedIn,
    bool? shouldRegisterForNotifications,
  }) {
    return AuthState(
      type: type ?? this.type,
      error: error ?? this.error,
      message: message ?? this.message,
      customerId: customerId ?? this.customerId,
      showBiometricLogin: showBiometricLogin ?? this.showBiometricLogin,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      shouldRegisterForNotifications: shouldRegisterForNotifications ?? this.shouldRegisterForNotifications,
    );
  }

  @override
  List<Object?> get props => [
        type,
        error,
        message,
        customerId,
        showBiometricLogin,
        isLoggedIn,
        shouldRegisterForNotifications,
      ];
}
