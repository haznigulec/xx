import 'package:flutter/material.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_event.dart';

abstract class CurrencyBuySellEvent extends PEvent {}

class GetCurrencyRatiosEvent extends CurrencyBuySellEvent {
  final String currency;

  GetCurrencyRatiosEvent({
    required this.currency,
  });
}

class GetTradeLimitTLEvent extends CurrencyBuySellEvent {
  final String accountId;
  final String typeName;

  GetTradeLimitTLEvent({
    required this.accountId,
    required this.typeName,
  });
}

class GetSystemParametersEvent extends CurrencyBuySellEvent {
  GetSystemParametersEvent();
}

class GetInstantCashAmountEvent extends GetSystemParametersEvent {
  final String accountId;
  final String finInstName;

  GetInstantCashAmountEvent({
    required this.accountId,
    required this.finInstName,
  });
}

class FcBuySellEvent extends CurrencyBuySellEvent {
  final String debitCredit;
  final String tlAccountId;
  final String accountId;
  final String finInstName;
  final double amount;
  final double exchangeRate;
  final VoidCallback? onSuccess;

  FcBuySellEvent({
    required this.debitCredit,
    required this.tlAccountId,
    required this.accountId,
    required this.finInstName,
    required this.amount,
    required this.exchangeRate,
    this.onSuccess,
  });
}
