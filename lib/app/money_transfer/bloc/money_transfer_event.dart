import 'package:flutter/material.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_event.dart';
import 'package:piapiri_v2/core/model/assets_model.dart';

abstract class MoneyTransferEvent extends PEvent {}

class GetCustomerBankAccountsEvent extends MoneyTransferEvent {
  final String accountId;

  GetCustomerBankAccountsEvent({
    required this.accountId,
  });
}

class GetEftInfoEvent extends MoneyTransferEvent {
  final String accountExtId;
  final Function(EftInfoModel) callback;

  GetEftInfoEvent({
    required this.accountExtId,
    required this.callback,
  });
}

class GetVirementInstitutionsEvent extends MoneyTransferEvent {
  GetVirementInstitutionsEvent();
}

class DeleteCustomerBankAccountEvent extends MoneyTransferEvent {
  final String accountId;
  final String bankAccountId;
  final Function(String) onSuccess;

  DeleteCustomerBankAccountEvent({
    required this.accountId,
    required this.bankAccountId,
    required this.onSuccess,
  });
}

class GetTradeLimitEvent extends MoneyTransferEvent {
  final String accountId;
  final String typeName;

  GetTradeLimitEvent({
    required this.accountId,
    required this.typeName,
  });
}

class GetTradeLimitForAllAccountsEvent extends MoneyTransferEvent {
  final List<String> accountList;
  final String typeName;

  GetTradeLimitForAllAccountsEvent({
    required this.accountList,
    required this.typeName,
  });
}

class RequestOTPEvent extends MoneyTransferEvent {
  final Function(dynamic)? onSuccess;
  RequestOTPEvent({
    required this.onSuccess,
  });
}

class MoneyTransferOrderEvent extends MoneyTransferEvent {
  final String accountId;
  final String bankAccId;
  final double amount;
  final String description;
  final String finInstName;
  final Function()? onSuccess;
  final Function(String)? onFailed;

  MoneyTransferOrderEvent({
    required this.accountId,
    required this.bankAccId,
    required this.amount,
    required this.description,
    required this.finInstName,
    required this.onSuccess,
    required this.onFailed,
  });
}

class AddVirmanOrderEvent extends MoneyTransferEvent {
  final String accountId;
  final String toAccountId;
  final double amount;
  final String? description;
  final Function() onSuccess;

  AddVirmanOrderEvent({
    required this.accountId,
    required this.toAccountId,
    required this.amount,
    this.description,
    required this.onSuccess,
  });
}

class AddCustomerBankAccountEvent extends MoneyTransferEvent {
  final String customerAccountId;
  final String ibanNo;
  final String otpCode;
  final String name;
  final Function(String) onSuccess;

  AddCustomerBankAccountEvent({
    required this.customerAccountId,
    required this.ibanNo,
    required this.otpCode,
    required this.name,
    required this.onSuccess,
  });
}

class GetCashBalance extends MoneyTransferEvent {
  final String accountId;
  final String typeName;

  GetCashBalance({
    required this.accountId,
    this.typeName = 'CASH-T2',
  });
}

class GetCollateralInfoEvent extends MoneyTransferEvent {
  final String accountId;

  GetCollateralInfoEvent({
    required this.accountId,
  });
}

class CollateralAdministrationDataEvent extends MoneyTransferEvent {
  final String customerExtId;
  final String accountExtId;
  final double amount;
  final String source;
  final String target;
  final VoidCallback onSuccess;
  final Function(String) onFailed;

  CollateralAdministrationDataEvent({
    required this.customerExtId,
    required this.accountExtId,
    required this.amount,
    required this.source,
    required this.target,
    required this.onSuccess,
    required this.onFailed,
  });
}

class GetTradeLimitBySenderRecipientEvent extends MoneyTransferEvent {
  final String accountId;
  final String typeName;
  final bool isSender;

  GetTradeLimitBySenderRecipientEvent({
    required this.accountId,
    required this.typeName,
    required this.isSender,
  });
}

class GetConvertT0Event extends MoneyTransferEvent {
  final Function(double, double)? callBack;
  GetConvertT0Event({
    this.callBack,
  });
}

class GetT0CreditTransactionExpenseInfoEvent extends MoneyTransferEvent {
  final String accountExtId;
  final double t1CreditAmount;
  final double t2CreditAmount;
  final VoidCallback onErrorCallback;
  GetT0CreditTransactionExpenseInfoEvent({
    required this.accountExtId,
    required this.t1CreditAmount,
    required this.t2CreditAmount,
    required this.onErrorCallback,
  });
}

class AddT0CreditTransactionEvent extends MoneyTransferEvent {
  final String accountExtId;
  final double t1CreditAmount;
  final double t2CreditAmount;
  final VoidCallback onErrorCallback;
  final VoidCallback onSuccesCallback;
  AddT0CreditTransactionEvent({
    required this.accountExtId,
    required this.t1CreditAmount,
    required this.t2CreditAmount,
    required this.onErrorCallback,
    required this.onSuccesCallback,
  });
}

class GetInstantCashAmountEvent extends MoneyTransferEvent {
  final String accountId;
  final String finInstName;
  final bool isSender;

  GetInstantCashAmountEvent({
    required this.accountId,
    required this.finInstName,
    required this.isSender,
  });
}
