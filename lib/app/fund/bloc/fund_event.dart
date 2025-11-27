import 'package:flutter/material.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_event.dart';
import 'package:piapiri_v2/core/model/chart_model.dart';
import 'package:piapiri_v2/core/model/fund_model.dart';
import 'package:piapiri_v2/core/model/fund_order_action.dart';

abstract class FundEvent extends PEvent {}

class GetFundsEvent extends FundEvent {
  final Function()? completedCallback;
  GetFundsEvent({
    this.completedCallback,
  });
}

class GetInstitutionsEvent extends FundEvent {
  final Function(List<String>) callback;
  GetInstitutionsEvent({
    required this.callback,
  });
}

class ChangeSubTypeEvent extends FundEvent {
  final String institution;
  final String subType;

  ChangeSubTypeEvent({
    required this.institution,
    required this.subType,
  });
}

class SetFilterEvent extends FundEvent {
  final FundFilterModel fundFilter;
  final Function(List<String>) callback;
  final Function()? getFundsCompletedCallback;

  SetFilterEvent({
    required this.fundFilter,
    required this.callback,
    this.getFundsCompletedCallback,
  });
}

class GetDetailEvent extends FundEvent {
  final String fundCode;
  final Function(FundDetailModel)? callBack;

  GetDetailEvent({
    required this.fundCode,
    this.callBack,
  });
}

class GetDetailsEvent extends FundEvent {
  final List<String> fundCodeList;
  final Function(List<FundDetailModel>) callBack;

  GetDetailsEvent({
    required this.fundCodeList,
    required this.callBack,
  });
}

class GetFundInfoEvent extends FundEvent {
  final String fundCode;
  final String accountId;
  final String type;
  final Function(String)? callback;

  GetFundInfoEvent({
    required this.accountId,
    required this.type,
    required this.fundCode,
    this.callback,
  });
}

class NewOrderEvent extends FundEvent {
  final String fundCode;
  final String accountId;
  final FundOrderActionEnum orderActionType;
  final double price;
  final int unit;
  final String valorDate;
  final VoidCallback successCallback;
  final VoidCallback errorCallback;
  final String baseType;
  final double amount;

  NewOrderEvent({
    required this.accountId,
    required this.fundCode,
    required this.orderActionType,
    required this.price,
    required this.unit,
    required this.valorDate,
    required this.successCallback,
    required this.errorCallback,
    required this.baseType,
    required this.amount,
  });
}

class GetByProfitEvent extends FundEvent {
  final String startDate;
  final String endDate;
  final String? institutionCode;

  GetByProfitEvent({
    required this.startDate,
    required this.endDate,
    this.institutionCode,
  });
}

class GetByManagementFeeEvent extends FundEvent {
  GetByManagementFeeEvent();
}

class GetByPortfolioSizeEvent extends FundEvent {
  GetByPortfolioSizeEvent();
}

class GetFinancialFounderListEvent extends FundEvent {
  final String? institutionCode;

  GetFinancialFounderListEvent(
    this.institutionCode,
  );
}

class GetFundPerformanceRankingEvent extends FundEvent {}

class GetFilterAndSortEvent extends FundEvent {
  final String? institutionCode;
  final int? startIndex;
  final int? count;
  final Function()? completedCallBack;

  GetFilterAndSortEvent(
    this.institutionCode,
    this.startIndex,
    this.count,
    this.completedCallBack,
  );
}

class NewBulkOrderEvent extends FundEvent {
  final String account;
  final List<Map<String, dynamic>> list;
  final Function(int, int) callback;

  NewBulkOrderEvent({
    required this.account,
    required this.list,
    required this.callback,
  });
}

class GetFundPriceGraphEvent extends FundEvent {
  final ChartFilter? chartFilter;
  final String fundCode;

  GetFundPriceGraphEvent({
    this.chartFilter,
    required this.fundCode,
  });
}

class GetFundVolumeHistoryEvent extends FundEvent {
  final String fundCode;

  GetFundVolumeHistoryEvent({
    required this.fundCode,
  });
}

class GetFundApplicationCategoriesListEvent extends FundEvent {}

class FundDetailClearEvent extends FundEvent {}

class SetFunCurrencyType extends FundEvent {
  SetFunCurrencyType();
}

class GetFundPriceEvent extends FundEvent {
  final String fundCode;
  final Function(double?)? callback;
  GetFundPriceEvent({
    required this.fundCode,
    this.callback,
  });
}

class GetAllFundThemesEvent extends FundEvent {
  GetAllFundThemesEvent();
}
