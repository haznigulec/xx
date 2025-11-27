import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/global_account_onboarding/bloc/global_account_onboarding_bloc.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/account_model.dart';

class UserModel {
  static late UserModel instance;
  final UserType _userType;
  final String _phone;
  final String _address;
  final String _email;
  final String _name;
  final String? _customerId;
  final String _password;
  final String _accountId;
  final String _langCode;
  final String? _customerType;
  final String? _innerType;
  List<AccountModel> _accounts;
  final bool _alpacaAccountStatus;
  final bool _changePasswordRequired;
  final String _customerChannel;
  final ValueNotifier<bool> _showTotalAsset = ValueNotifier<bool>(true);

  factory UserModel({
    UserType userType = UserType.unauth,
    required String phone,
    required String address,
    required String email,
    required String name,
    String? customerId,
    required String password,
    required String accountId,
    required String langCode,
    String? customerType,
    String? innerType,
    required List<AccountModel> accounts,
    required bool alpacaAccountStatus,
    required bool changePasswordRequired,
    required String customerChannel,
  }) {
    instance = UserModel._internal(
      userType,
      phone,
      address,
      email,
      name,
      customerId,
      password,
      accountId,
      langCode,
      customerType,
      innerType,
      accounts,
      alpacaAccountStatus,
      changePasswordRequired,
      customerChannel,
    );
    return instance;
  }

  UserModel._internal(
    this._userType,
    this._phone,
    this._address,
    this._email,
    this._name,
    this._customerId,
    this._password,
    this._accountId,
    this._langCode,
    this._customerType,
    this._innerType,
    this._accounts,
    this._alpacaAccountStatus,
    this._changePasswordRequired,
    this._customerChannel,
  );

  UserType get userType => _userType;

  String get phone => _phone;

  String get address => _address;

  String get email => _email;

  String get name => _name;

  String? get customerId => _customerId;

  String get password => _password;

  String get accountId => _accountId;

  String get langCode => _langCode;

  String? get customerType => _customerType;

  String? get innerType => _innerType;

  List<AccountModel> get accounts => _accounts;

  bool get alpacaAccountStatus =>
      _alpacaAccountStatus ||
      (_customerId != null &&
          _customerId == getIt<GlobalAccountOnboardingBloc>().state.cutomerId &&
          getIt<GlobalAccountOnboardingBloc>().state.accountSettingStatus?.accountStatus == 'ACTIVE');

  bool get changePasswordRequired => _changePasswordRequired;

  String? get customerChannel => _customerChannel;

  ValueNotifier<bool> get showTotalAsset => _showTotalAsset;

  set setAccounts(List<AccountModel> newAccounts) {
    _accounts = newAccounts;
  }

  set setShowTotalAsset(bool showTotalAsset) {
    _showTotalAsset.value = showTotalAsset;
  }
}

enum UserType { account, member, unauth }
