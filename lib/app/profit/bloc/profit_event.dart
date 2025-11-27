import 'package:flutter/material.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_event.dart';
import 'package:piapiri_v2/core/model/assets_model.dart';

abstract class ProfitEvent extends PEvent {}

class GetProfitEvent extends ProfitEvent {
  final DateTime profitStartDate;
  final DateTime profitEndDate;

  GetProfitEvent({
    required this.profitStartDate,
    required this.profitEndDate,
  });
}

class GetCustomerTargetEvent extends ProfitEvent {
  GetCustomerTargetEvent();
}

class SetCustomerTargetEvent extends ProfitEvent {
  final double target;
  final DateTime targetDate;
  final VoidCallback? onSuccess;
  SetCustomerTargetEvent({
    required this.target,
    required this.targetDate,
    this.onSuccess,
  });
}

class GetOverallSummaryEvent extends ProfitEvent {
  final String accountId;
  final bool isConsolidated;
  final bool allAccounts;
  final bool getInstant;
  final String? overallDate;
  final bool includeCashFlow;
  final bool includeCreditDetail;
  final bool calculateTradeLimit;
  final Function(AssetModel assetsModel)? callback;
  final String? fundSymbol;

  GetOverallSummaryEvent({
    required this.accountId,
    this.isConsolidated = true,
    this.allAccounts = false,
    this.getInstant = true,
    this.overallDate,
    this.includeCashFlow = false,
    this.includeCreditDetail = false,
    this.calculateTradeLimit = false,
    this.callback,
    this.fundSymbol,
  });
}

class GetCapraPortfolioSummaryEvent extends ProfitEvent {
  final Function()? onFecthed;

  GetCapraPortfolioSummaryEvent({
    this.onFecthed,
  });
}

class ClearPotentialProfitLossModel extends ProfitEvent {
  ClearPotentialProfitLossModel();
}

class ClearTaxDetail extends ProfitEvent {
  ClearTaxDetail();
}
