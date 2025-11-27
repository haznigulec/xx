import 'package:flutter/material.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_event.dart';

abstract class AuthEvent extends PEvent {
  final Function(String)? onError;

  const AuthEvent({
    this.onError,
  });
}

class InitEvent extends AuthEvent {}

class LogInEvent extends AuthEvent {
  final String? username;
  final String? password;
  final bool willRemember;
  final Function(String, bool)? onSuccess;
  final Function(String, bool)? onChangedRequiredPassword;
  final Function(String, int, bool)? onCheckOtp;
  final String? biometricData;

  const LogInEvent({
    this.username,
    this.password,
    this.willRemember = false,
    this.onSuccess,
    super.onError,
    this.biometricData,
    this.onCheckOtp,
    this.onChangedRequiredPassword,
  });
}

class BiometricLoginEvent extends AuthEvent {
  final VoidCallback onSuccess;
  final Function(String) onFailed;
  final Function()? onNotSupported;

  const BiometricLoginEvent({
    required this.onSuccess,
    required this.onFailed,
    required this.onNotSupported,
  });
}

class CheckOTPEvent extends AuthEvent {
  final String customerExtId;
  final String otp;
  final Function(dynamic)? onSuccess;

  const CheckOTPEvent({
    required this.customerExtId,
    required this.otp,
    this.onSuccess,
    Function(dynamic)? onError, // sadece parametre olarak al
  }) : super(onError: onError);
}

class CheckOTPAgainEvent extends AuthEvent {
  final String customerExtId;
  final Function(dynamic)? onSuccess;

  const CheckOTPAgainEvent({
    required this.customerExtId,
    this.onSuccess,
    Function(dynamic)? onError, // sadece parametre olarak al
  }) : super(onError: onError);
}

class ForgotPasswordEvent extends AuthEvent {
  final String? tcNo;
  final String taxNo;
  final String cellPhone;
  final String? birthDate;
  final Function(dynamic) onSuccess;

  const ForgotPasswordEvent({
    this.tcNo,
    required this.taxNo,
    required this.cellPhone,
    this.birthDate,
    required this.onSuccess,
  });
}

class ResetPasswordEvent extends AuthEvent {
  final String customerId;
  final String otp;
  final Function() onSuccess;

  const ResetPasswordEvent({
    required this.customerId,
    required this.otp,
    required this.onSuccess,
  });
}

class ChangeExpiredPasswordEvent extends AuthEvent {
  final String customerId;
  final String oldPassword;
  final String newPassword;
  final String otpCode;
  final bool isTCKN;
  final Function() onSuccess;

  const ChangeExpiredPasswordEvent({
    required this.customerId,
    required this.oldPassword,
    required this.newPassword,
    required this.otpCode,
    required this.isTCKN,
    required this.onSuccess,
  });
}

class RequestOtpEvent extends AuthEvent {
  final String customerId;
  final Function(ApiResponse) onSuccess;

  const RequestOtpEvent({
    required this.customerId,
    required this.onSuccess,
  });
}

class LogoutEvent extends AuthEvent {
  final bool shouldRegisterForNotifications;
  final Function()? callback;

  const LogoutEvent({
    this.shouldRegisterForNotifications = false,
    this.callback,
  });
}
