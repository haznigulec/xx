import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/assets/model/collateral_info_model.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_event.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/order_action_type_enum.dart';
import 'package:piapiri_v2/core/model/order_completion_enum.dart';
import 'package:piapiri_v2/core/model/order_list_model.dart';
import 'package:piapiri_v2/core/model/order_model.dart';
import 'package:piapiri_v2/core/model/order_status_enum.dart';
import 'package:piapiri_v2/core/model/order_type_enum.dart';
import 'package:piapiri_v2/core/model/order_validity_enum.dart';
import 'package:piapiri_v2/core/model/stock_item_model.dart';
import 'package:piapiri_v2/core/model/symbol_model.dart';
import 'package:piapiri_v2/core/model/symbol_type_enum.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';

abstract class OrdersEvent extends PEvent {}

class GetOrdersEvent extends OrdersEvent {
  final String account;
  final SymbolTypeEnum symbolType;
  final OrderStatusEnum orderStatus;
  final bool refreshData;
  final bool isLoading;
  final Function(OrderListModel orderListModel)? callBack;
  final Function()? invalidTokenCallBack;
  GetOrdersEvent({
    required this.account,
    required this.orderStatus,
    required this.symbolType,
    this.refreshData = false,
    this.isLoading = false,
    this.callBack,
    this.invalidTokenCallBack,
  });
}

class RefreshOrdersEvent extends OrdersEvent {
  final String account;
  final SymbolTypeEnum symbolType;
  final OrderStatusEnum orderStatus;
  final bool refreshData;
  final bool isLoading;
  final Function()? onFetched;

  RefreshOrdersEvent({
    required this.account,
    required this.orderStatus,
    required this.symbolType,
    this.refreshData = false,
    this.isLoading = false,
    this.onFetched,
  });
}

class GetTradeLimitEvent extends OrdersEvent {
  final String symbolName;
  final String? accountId;
  final String? symbolType;
  final Function(double)? callback;

  GetTradeLimitEvent({
    required this.symbolName,
    this.accountId,
    this.callback,
    this.symbolType,
  });
}

class UpdateOrderEvent extends OrdersEvent {
  final bool? isTransfer;
  final int? quantity;
  final double? price;
  final String? selectedAccount;
  final SymbolModel? selectedSymbol;
  final SymbolTypes? symbolType;
  final String? selectedOrderCompletion;
  final OrderTypeEnum? selectedOrderType;
  final StockItemModel? selectedStockItem;
  final String? selectedOrderCompletionName;
  final OrderValidityEnum? selectedValidity;
  final OrderActionTypeEnum? selectedOrderActionType;
  final int? shownQuantity;
  final MarketListModel? conditionSymbol;
  final String? conditionType;
  final double? conditionPrice;
  final double? stopLossPrice;
  final double? takeProfitPrice;
  final DateTime? periodEndDate;
  final bool? isStopLossExpanded;
  final bool? isConditionExpanded;

  UpdateOrderEvent({
    this.isTransfer,
    this.quantity,
    this.price,
    this.selectedAccount,
    this.selectedSymbol,
    this.selectedOrderCompletion,
    this.selectedOrderType,
    this.selectedStockItem,
    this.selectedOrderCompletionName,
    this.selectedValidity,
    this.selectedOrderActionType,
    this.shownQuantity,
    this.conditionSymbol,
    this.conditionType,
    this.conditionPrice,
    this.symbolType,
    this.stopLossPrice,
    this.takeProfitPrice,
    this.periodEndDate,
    this.isStopLossExpanded,
    this.isConditionExpanded,
  });
}

class RemoveConditionEvent extends OrdersEvent {}

class CreateOrderEvent extends OrdersEvent {
  final Function(String text, bool isError) callback;
  final String? suffix;

  CreateOrderEvent({
    required this.callback,
    this.suffix = '',
  });
}

class CreateConditionOrderEvent extends OrdersEvent {
  final Function(String successMessage, bool isError) callback;
  final String? suffix;
  final String? transactionId;
  final String symbolName;
  final int units;
  final OrderActionTypeEnum orderActionType;
  final OrderTypeEnum orderType;
  final OrderValidityEnum orderValidity;
  final String account;
  final double price;
  final String conditionSymbolCode;
  final String conditionType;
  final double conditionPrice;

  CreateConditionOrderEvent({
    required this.callback,
    this.suffix = '',
    this.transactionId = '',
    this.symbolName = '',
    this.units = 0,
    this.orderActionType = OrderActionTypeEnum.buy,
    this.orderType = OrderTypeEnum.limit,
    this.orderValidity = OrderValidityEnum.daily,
    this.account = '',
    this.price = 0,
    this.conditionSymbolCode = '',
    this.conditionType = '',
    this.conditionPrice = 0,
  });
}

class CreateChainOrderEvent extends OrdersEvent {
  final int chainNo;
  final String parentTransactionId;
  final String accountExtId;
  final Function(List<String>) callback;

  CreateChainOrderEvent({
    required this.chainNo,
    required this.parentTransactionId,
    required this.accountExtId,
    required this.callback,
  });
}

class AddChainListEvent extends OrdersEvent {
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

class RemoveChainListEvent extends OrdersEvent {
  final int index;
  final bool removeAll;

  RemoveChainListEvent({
    required this.index,
    this.removeAll = false,
  });
}

class UpdateChainListEvent extends OrdersEvent {
  final int index;
  final OrderActionTypeEnum? orderAction;
  final double? price;
  final int? units;
  final OrderValidityEnum? orderValidity;
  final OrderTypeEnum? orderType;
  final MarketListModel? marketListModel;

  UpdateChainListEvent({
    required this.index,
    this.orderAction,
    this.price,
    this.units,
    this.orderValidity,
    this.orderType,
    this.marketListModel,
  });
}

class CancelOrderEvent extends OrdersEvent {
  final String transactionId;
  final String accountId;
  final String periodicTransactionId;
  final Function() succesCallBack;
  final Function(bool, String)? completedCallBack;

  CancelOrderEvent({
    required this.transactionId,
    required this.accountId,
    required this.periodicTransactionId,
    required this.succesCallBack,
    this.completedCallBack,
  });
}

class CancelBulkOrderEvent extends OrdersEvent {
  final List<String> transactionIdsList;
  final String selectedAccount;
  final VoidCallback? callback;

  CancelBulkOrderEvent({
    required this.transactionIdsList,
    required this.selectedAccount,
    this.callback,
  });
}

class CancelViopOrderEvent extends OrdersEvent {
  final String transactionId;
  final String accountId;
  final Function(bool, String)? completedCallBack;

  CancelViopOrderEvent({
    required this.transactionId,
    required this.accountId,
    this.completedCallBack,
  });
}

class CancelFundOrderEvent extends OrdersEvent {
  final String transactionId;
  final String accountId;
  final Function(bool, String)? completedCallBack;

  CancelFundOrderEvent({
    required this.transactionId,
    required this.accountId,
    this.completedCallBack,
  });
}

class UpdateViopOrderEvent extends OrdersEvent {
  final String transactionId;
  final String accountId;
  final Function(String) callback;
  final VoidCallback onFailed;
  final double price;
  final String endingDate;
  final double units;
  final String orderType;
  final String timeInForce;

  UpdateViopOrderEvent({
    required this.transactionId,
    required this.accountId,
    required this.callback,
    required this.onFailed,
    required this.price,
    required this.endingDate,
    required this.units,
    required this.orderType,
    required this.timeInForce,
  });
}

class CancelChainOrderEvent extends OrdersEvent {
  final int chainNo;
  final String transactionId;
  final String accountExtId;
  final String accountId;
  final Function(bool, String)? completedCallBack;

  CancelChainOrderEvent({
    required this.chainNo,
    required this.transactionId,
    required this.accountExtId,
    required this.accountId,
    this.completedCallBack,
  });
}

class CancelConditionalOrderEvent extends OrdersEvent {
  final String transactionId;
  final String accountExtId;
  final Function(bool, String)? completedCallBack;

  CancelConditionalOrderEvent({
    required this.transactionId,
    required this.accountExtId,
    this.completedCallBack,
  });
}

class BulkUpdateEvent extends OrdersEvent {
  final List<Map<String, dynamic>> list;
  final double price;
  final Function(String, bool) callback;

  BulkUpdateEvent({
    required this.list,
    required this.price,
    required this.callback,
  });
}

class CreateBulkOrderEvent extends OrdersEvent {
  final String account;
  final List<Map<String, dynamic>> list;
  final Function(int, int) callback;
  final Function()? trackEvent;

  CreateBulkOrderEvent({
    required this.account,
    required this.list,
    required this.callback,
    this.trackEvent,
  });
}

class GetUnderlyingListEvent extends OrdersEvent {}

class ChangeOptionOrderTypeEvent extends OrdersEvent {
  final SymbolTypes symbolType;
  final String assetName;
  final String contract;
  final double price;
  final OrderActionTypeEnum orderActionType;
  final int quantity;
  final OptionOrderTypeEnum orderType;
  final OptionOrderValidityEnum orderValidity;
  final VoidCallback? callback;

  ChangeOptionOrderTypeEvent({
    this.symbolType = SymbolTypes.future,
    this.assetName = '',
    this.contract = '',
    this.price = 0,
    this.orderActionType = OrderActionTypeEnum.buy,
    this.quantity = 1,
    this.orderType = OptionOrderTypeEnum.marketToLimit,
    this.orderValidity = OptionOrderValidityEnum.daily,
    this.callback,
  });
}

class GetContractsByAssetEvent extends OrdersEvent {
  final String asset;
  final SymbolTypes symbolType;

  GetContractsByAssetEvent({
    required this.asset,
    required this.symbolType,
  });
}

class UpdateOptionOrderEvent extends OrdersEvent {
  final SymbolTypes? symbolType;
  final String? assetName;
  final ProcessType? processType;
  final String? maturityDate;
  final String? contract;
  final OrderActionTypeEnum? orderAction;
  final OptionOrderTypeEnum? orderType;
  final OptionOrderValidityEnum? orderValidity;
  final double? price;
  final int? units;
  final OrderCompletionEnum? fillType;
  final StockItemModel? stockItem;
  final Function(String)? callback;

  UpdateOptionOrderEvent({
    this.symbolType,
    this.assetName,
    this.processType,
    this.maturityDate,
    this.contract,
    this.orderAction,
    this.orderType,
    this.orderValidity,
    this.price,
    this.units,
    this.fillType,
    this.stockItem,
    this.callback,
  });
}

class CreateOptionOrderEvent extends OrdersEvent {
  final Function(String) callback;
  final VoidCallback emptyAssetCallback;

  CreateOptionOrderEvent({
    required this.callback,
    required this.emptyAssetCallback,
  });
}

class GetCollateralInfoEvent extends OrdersEvent {
  final Function(CollateralInfo?)? callback;
  GetCollateralInfoEvent({this.callback});
}

class ReplaceOrderEvent extends OrdersEvent {
  final String transactionId;
  final double oldPrice;
  final int oldUnit;
  final double newPrice;
  final int newUnit;
  final double? stopLossPrice;
  final double? takeProfitPrice;
  final String? periodicTransactionId;
  final DateTime? periodEndingDate;
  final Function(String) errorCallback;
  final Function(String) successCallback;
  final String timeInForce;

  ReplaceOrderEvent({
    required this.transactionId,
    required this.oldPrice,
    required this.oldUnit,
    required this.newPrice,
    required this.newUnit,
    this.stopLossPrice,
    this.takeProfitPrice,
    this.periodicTransactionId,
    this.periodEndingDate,
    required this.errorCallback,
    required this.successCallback,
    required this.timeInForce,
  });
}

class ReplaceUsOrderEvent extends OrdersEvent {
  final String id;
  final String? qty;
  final String? price;
  final String? stopPrice;
  final String? trail;
  final String? tpPrice;
  final String? slPrice;
  final Function(bool isSuccess, String? message)? callback;

  ReplaceUsOrderEvent({
    required this.id,
    this.qty,
    this.price,
    this.stopPrice,
    this.trail,
    this.tpPrice,
    this.slPrice,
    this.callback,
  });
}

class DeleteUsOrderEvent extends OrdersEvent {
  final String id;
  final Function(bool isSuccess, String? message)? callback;

  DeleteUsOrderEvent({
    required this.id,
    this.callback,
  });
}

class UpdateChainOrderEvent extends OrdersEvent {
  final String accountExtId;
  final int chainNo;
  final String transactionExtId;
  final String equityName;
  final String debitCredit;
  final int session;
  final double price;
  final int units;
  final int transactionTypeName;
  final String orderValidity;
  final Function(String) onSuccess;
  final VoidCallback onFailed;

  UpdateChainOrderEvent({
    required this.accountExtId,
    required this.chainNo,
    required this.transactionExtId,
    required this.equityName,
    required this.debitCredit,
    required this.session,
    required this.price,
    required this.units,
    required this.transactionTypeName,
    required this.orderValidity,
    required this.onSuccess,
    required this.onFailed,
  });
}

class GetPeriodicOrdersEvent extends OrdersEvent {
  final String accountId;
  final String transactionExidId;
  final Function(DateTime?)? successCallback;
  final Function()? onErrorCallBack;
  GetPeriodicOrdersEvent({
    required this.accountId,
    required this.transactionExidId,
    this.successCallback,
    this.onErrorCallBack,
  });
}
