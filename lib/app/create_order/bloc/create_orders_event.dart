import 'package:piapiri_v2/app/assets/model/collateral_info_model.dart';
import 'package:piapiri_v2/app/create_order/model/condition.dart';
import 'package:piapiri_v2/app/create_order/model/stoploss_takeprofit.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_event.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/order_action_type_enum.dart';
import 'package:piapiri_v2/core/model/order_completion_enum.dart';
import 'package:piapiri_v2/core/model/order_type_enum.dart';
import 'package:piapiri_v2/core/model/order_validity_enum.dart';
import 'package:piapiri_v2/core/model/stock_item_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/model/viop_session_enum.dart';

abstract class CreateOrdersEvent extends PEvent {}

class GetTradeLimitEvent extends CreateOrdersEvent {
  final String symbolName;
  final String accountId;
  final Function(double)? callback;

  GetTradeLimitEvent({
    required this.symbolName,
    required this.accountId,
    this.callback,
  });
}

class GetPositionListEvent extends CreateOrdersEvent {
  final String accountId;
  final Function(List<StockItemModel>)? callback;

  GetPositionListEvent({
    required this.accountId,
    this.callback,
  });
}

class GetCashLimitEvent extends CreateOrdersEvent {
  final String accountId;
  final String symbolName;
  final OrderActionTypeEnum orderActionType;

  GetCashLimitEvent({
    required this.accountId,
    required this.symbolName,
    this.orderActionType = OrderActionTypeEnum.buy,
  });
}

class GetDetailsOfSymbolsEvent extends CreateOrdersEvent {
  final List<String> symbolNameList;
  final Function(List<MarketListModel> detailedSymbols)? callback;

  GetDetailsOfSymbolsEvent({
    required this.symbolNameList,
    this.callback,
  });
}

class CreateOrderEvent extends CreateOrdersEvent {
  final String symbolName;
  final SymbolTypes symbolType;
  final String account;
  final int unit;
  final OrderActionTypeEnum orderActionType;
  final OrderTypeEnum orderType;
  final OrderValidityEnum orderValidity;
  final double price;
  final Condition? condition;
  final StopLossTakeProfit? stopLossTakeProfit;
  final int? shownUnit;
  final OrderCompletionEnum orderCompletionType;
  final Function(String text, bool isError) callback;
  final String? suffix;

  CreateOrderEvent({
    required this.symbolName,
    required this.symbolType,
    required this.account,
    required this.unit,
    required this.orderActionType,
    required this.orderType,
    required this.orderValidity,
    required this.price,
    required this.orderCompletionType,
    this.shownUnit,
    this.condition,
    this.stopLossTakeProfit,
    required this.callback,
    this.suffix = '',
  });
}

class ClearChainOrderListEvent extends CreateOrdersEvent {
  ClearChainOrderListEvent();
}

class AddChainListEvent extends CreateOrdersEvent {
  final MarketListModel marketListModel;
  final OrderActionTypeEnum orderAction;
  final int unit;
  final double price;

  AddChainListEvent({
    required this.marketListModel,
    required this.orderAction,
    required this.unit,
    required this.price,
  });
}

class AddChainListByIndexEvent extends CreateOrdersEvent {
  final MarketListModel marketListModel;
  final OrderActionTypeEnum orderAction;
  final int unit;
  final double price;
  final int index;

  AddChainListByIndexEvent({
    required this.marketListModel,
    required this.orderAction,
    required this.unit,
    required this.price,
    required this.index,
  });
}

class UpdateChainListByIndexEvent extends CreateOrdersEvent {
  final MarketListModel marketListModel;
  final OrderActionTypeEnum orderAction;
  final int unit;
  final double price;
  final int index;

  UpdateChainListByIndexEvent({
    required this.marketListModel,
    required this.orderAction,
    required this.unit,
    required this.price,
    required this.index,
  });
}

class RemoveChainListEvent extends CreateOrdersEvent {
  final int index;
  final bool removeAll;

  RemoveChainListEvent({
    required this.index,
    this.removeAll = false,
  });
}

class CreateOptionOrderEvent extends CreateOrdersEvent {
  final String accountId;
  final OrderActionTypeEnum orderAction;
  final MarketListModel symbol;
  final int units;
  final OptionOrderTypeEnum optionOrderType;
  final OptionOrderValidityEnum orderValidity;
  final double price;
  final DateTime? validityDate;
  final ViopSessionEnum? viopSession;
  final Function(bool isSuccess, String message) callback;

  CreateOptionOrderEvent({
    required this.accountId,
    required this.orderAction,
    required this.symbol,
    required this.units,
    required this.optionOrderType,
    required this.orderValidity,
    required this.price,
    this.validityDate,
    this.viopSession,
    required this.callback,
  });
}

class GetCollateralInfoEvent extends CreateOrdersEvent {
  final String accountId;
  final Function(CollateralInfo?)? callback;
  GetCollateralInfoEvent({required this.accountId, this.callback});
}

class GetViopDataEvent extends CreateOrdersEvent {
  final String asset;
  final Function(num multiplier, bool isMultiSession) callback;

  GetViopDataEvent({
    required this.asset,
    required this.callback,
  });
}

class GetSuffixEvent extends CreateOrdersEvent {
  final String symbolName;
  final Function(String text) callback;

  GetSuffixEvent({
    required this.symbolName,
    required this.callback,
  });
}

class GetUnderlyingListEvent extends CreateOrdersEvent {}

class AddSubMarketContractEvent extends CreateOrdersEvent {
  final String equityName;
  final String accountId;
  final Function(bool) callback;

  AddSubMarketContractEvent({
    required this.equityName,
    required this.accountId,
    required this.callback,
  });
}

class GetViopInitialRequirementEvent extends CreateOrdersEvent {
  final String symbolName;
  final OrderActionTypeEnum orderAction;
  final int unit;
  final String accountId;
  final Function(double? initialRequirements) callback;

  GetViopInitialRequirementEvent({
    required this.symbolName,
    required this.orderAction,
    required this.unit,
    required this.accountId,
    required this.callback,
  });
}
