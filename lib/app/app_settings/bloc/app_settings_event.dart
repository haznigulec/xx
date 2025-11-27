import 'dart:ui';

import 'package:piapiri_v2/app/orders/model/american_order_type_enum.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_event.dart';
import 'package:piapiri_v2/core/model/depth_type_enum.dart';
import 'package:piapiri_v2/core/model/general_settings.dart';
import 'package:piapiri_v2/core/model/language_enum.dart';
import 'package:piapiri_v2/core/model/order_completion_enum.dart';
import 'package:piapiri_v2/core/model/order_type_enum.dart';
import 'package:piapiri_v2/core/model/order_validity_enum.dart';
import 'package:piapiri_v2/core/model/statement_preference_enum.dart';
import 'package:piapiri_v2/core/model/theme_enum.dart';
import 'package:piapiri_v2/core/model/timeout_enum.dart';

abstract class AppSettingsEvent extends PEvent {}

class GetOrderSettingsEvent extends AppSettingsEvent {
  final VoidCallback onCallback;

  GetOrderSettingsEvent({
    required this.onCallback,
  });
}

class GetLocalGeneralSettingsEvent extends AppSettingsEvent {
  final Function(GeneralSettings generalSettings)? onSuccess;
  final Function()? onCompleter;

  GetLocalGeneralSettingsEvent({
    this.onSuccess,
    this.onCompleter,
  });
}

class SetGeneralSettingsEvent extends AppSettingsEvent {
  final ThemeEnum? theme;
  final LanguageEnum? language;
  final TimeoutEnum? timeout;
  final bool? keepScreenOpen;
  final bool? touchFaceId;
  final List<String>? showCase;

  SetGeneralSettingsEvent({
    this.theme,
    this.language,
    this.timeout,
    this.keepScreenOpen,
    this.touchFaceId,
    this.showCase,
  });
}

class SetOrderSettingsEvent extends AppSettingsEvent {
  final String? equityDefaultAccount;
  final String? viopDefaultAccount;
  final String? fundDefaultAccount;
  final OrderTypeEnum? equityDefaultOrderType;
  final OptionOrderTypeEnum? viopDefaultOrderType;
  final AmericanOrderTypeEnum? usDefaultOrderType;
  final OrderValidityEnum? equityDefaultValidity;
  final OptionOrderValidityEnum? viopDefaultValidity;
  final int? depthCount;
  final DepthTypeEnum? depthType;
  final bool? earningInterest;
  final bool? transactionApprovalRequest;
  final OrderCompletionEnum? orderCompletion;
  final StatementPreferenceEnum? statementPreference;
  final Function(String message, bool isSuccsess)? onSuccess;

  SetOrderSettingsEvent({
    this.equityDefaultAccount,
    this.viopDefaultAccount,
    this.fundDefaultAccount,
    this.equityDefaultOrderType,
    this.viopDefaultOrderType,
    this.usDefaultOrderType,
    this.equityDefaultValidity,
    this.viopDefaultValidity,
    this.depthCount,
    this.depthType,
    this.earningInterest,
    this.transactionApprovalRequest,
    this.orderCompletion,
    this.statementPreference,
    this.onSuccess,
  });
}

class ChangePasswordEvent extends AppSettingsEvent {
  final String oldPassword;
  final String newPassword;
  final Function(dynamic message, bool isSuccsess)? onSuccess;

  ChangePasswordEvent({
    required this.oldPassword,
    required this.newPassword,
    this.onSuccess,
  });
}

class ResetApplicationSettingsEvent extends AppSettingsEvent {
  ResetApplicationSettingsEvent();
}

class GetCustomerParametersEvent extends AppSettingsEvent {
  GetCustomerParametersEvent();
}

class UpdateCustomerParametersEvent extends AppSettingsEvent {
  final bool interest;
  final String receiptType;
  final Function()? onSuccess;
  final Function(String)? onFailed;

  UpdateCustomerParametersEvent({
    required this.interest,
    required this.receiptType,
    this.onSuccess,
    this.onFailed,
  });
}
