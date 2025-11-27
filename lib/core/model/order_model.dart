import 'package:equatable/equatable.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/order_action_type_enum.dart';
import 'package:piapiri_v2/core/model/order_completion_enum.dart';
import 'package:piapiri_v2/core/model/order_type_enum.dart';
import 'package:piapiri_v2/core/model/order_validity_enum.dart';
import 'package:piapiri_v2/core/model/stock_item_model.dart';
import 'package:piapiri_v2/core/model/symbol_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/model/transaction_model.dart';

class OrderModel extends Equatable {
  final bool isTransfer;
  final int quantity;
  final double price;
  final String selectedAccount;
  final SymbolModel? selectedSymbol;
  final String selectedOrderCompletion;
  final OrderTypeEnum selectedOrderType;
  final StockItemModel? selectedStockItem;
  final String selectedOrderCompletionName;
  final OrderValidityEnum selectedValidity;
  final OrderActionTypeEnum selectedOrderActionType;
  final int shownQuantity;
  final SymbolTypes? symbolType;
  final MarketListModel? conditionSymbol;
  final String? conditionType;
  final double? conditionPrice;
  final double? stopLossPrice;
  final double? takeProfitPrice;
  final DateTime? periodEndDate;
  final bool isStopLossExpanded;
  final bool isConditionExpanded;

  const OrderModel({
    this.isTransfer = false,
    this.quantity = 1,
    this.price = 0,
    this.selectedSymbol,
    this.selectedAccount = '',
    this.selectedOrderCompletion = '1',
    this.selectedOrderCompletionName = 'Sms',
    this.selectedOrderType = OrderTypeEnum.limit,
    this.selectedStockItem,
    this.selectedValidity = OrderValidityEnum.daily,
    this.selectedOrderActionType = OrderActionTypeEnum.buy,
    this.shownQuantity = 0,
    this.conditionSymbol,
    this.conditionType,
    this.conditionPrice,
    this.symbolType,
    this.stopLossPrice,
    this.takeProfitPrice,
    this.periodEndDate,
    this.isStopLossExpanded = false,
    this.isConditionExpanded = false,
  });

  OrderModel copyWith({
    bool? isTransfer,
    int? quantity,
    double? price,
    SymbolModel? selectedSymbol,
    String? selectedAccount,
    String? selectedOrderCompletion,
    OrderTypeEnum? selectedOrderType,
    StockItemModel? selectedStockItem,
    String? selectedOrderCompletionName,
    OrderValidityEnum? selectedValidity,
    OrderActionTypeEnum? selectedOrderActionType,
    int? shownQuantity,
    SymbolTypes? symbolType,
    MarketListModel? conditionSymbol,
    String? conditionType,
    double? conditionPrice,
    double? stopLossPrice,
    double? takeProfitPrice,
    DateTime? periodEndDate,
    bool? isStopLossExpanded,
    bool? isConditionExpanded,
  }) {
    return OrderModel(
      isTransfer: isTransfer ?? this.isTransfer,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      selectedAccount: selectedAccount ?? this.selectedAccount,
      selectedSymbol: selectedSymbol ?? this.selectedSymbol,
      selectedOrderCompletion: selectedOrderCompletion ?? this.selectedOrderCompletion,
      selectedOrderType: selectedOrderType ?? this.selectedOrderType,
      selectedStockItem: selectedStockItem ?? this.selectedStockItem,
      selectedOrderCompletionName: selectedOrderCompletionName ?? this.selectedOrderCompletionName,
      selectedValidity: selectedValidity ?? this.selectedValidity,
      selectedOrderActionType: selectedOrderActionType ?? this.selectedOrderActionType,
      shownQuantity: shownQuantity ?? this.shownQuantity,
      symbolType: symbolType ?? this.symbolType,
      conditionSymbol: conditionSymbol ?? this.conditionSymbol,
      conditionType: conditionType ?? this.conditionType,
      conditionPrice: conditionPrice ?? this.conditionPrice,
      stopLossPrice: stopLossPrice ?? this.stopLossPrice,
      takeProfitPrice: takeProfitPrice ?? this.takeProfitPrice,
      periodEndDate: periodEndDate ?? this.periodEndDate,
      isStopLossExpanded: isStopLossExpanded ?? this.isStopLossExpanded,
      isConditionExpanded: isConditionExpanded ?? this.isConditionExpanded,
    );
  }

  OrderModel resetCondition() {
    return OrderModel(
      isTransfer: isTransfer,
      quantity: quantity,
      price: price,
      selectedAccount: selectedAccount,
      selectedSymbol: selectedSymbol,
      selectedOrderCompletion: selectedOrderCompletion,
      selectedOrderType: selectedOrderType,
      selectedStockItem: selectedStockItem,
      selectedOrderCompletionName: selectedOrderCompletionName,
      selectedValidity: selectedValidity,
      selectedOrderActionType: selectedOrderActionType,
      shownQuantity: shownQuantity,
      symbolType: symbolType,
      conditionSymbol: null,
      conditionType: null,
      conditionPrice: null,
      stopLossPrice: null,
      takeProfitPrice: null,
      periodEndDate: null,
    );
  }

  @override
  List<Object?> get props => [
        isTransfer,
        quantity,
        price,
        selectedSymbol,
        selectedAccount,
        selectedOrderCompletion,
        selectedOrderType,
        selectedStockItem,
        selectedOrderCompletionName,
        selectedValidity,
        selectedOrderActionType,
        shownQuantity,
        conditionSymbol,
        conditionType,
        conditionPrice,
        symbolType,
        stopLossPrice,
        takeProfitPrice,
        periodEndDate,
        isStopLossExpanded,
        isConditionExpanded,
      ];
}

class OrderItemModel {
  final String symbol;
  String finInstFullName;
  final String equityGroupCode;
  final String marketName;
  final List<TransactionModel> dataList;

  OrderItemModel({
    required this.symbol,
    required this.finInstFullName,
    required this.equityGroupCode,
    required this.marketName,
    required this.dataList,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      symbol: json['symbol'],
      finInstFullName: json['finInstFullName'],
      equityGroupCode: json['equityGroupCode'] ?? '',
      marketName: json['marketName'] ?? '',
      dataList: json['dataList'].map<TransactionModel>((e) => TransactionModel.fromJson(e)).toList(),
    );
  }
}

class ChainOrderModel {
  final int chainNo;
  final String parentTransactionId;
  final MarketListModel marketListModel;
  final OrderActionTypeEnum orderAction;
  final double price;
  final int units;
  final OrderValidityEnum orderValidity;
  final OrderTypeEnum orderType;
  final String customerExtId;
  final String accountExtId;

  ChainOrderModel({
    required this.chainNo,
    required this.parentTransactionId,
    required this.marketListModel,
    required this.orderAction,
    required this.price,
    required this.units,
    required this.orderValidity,
    required this.orderType,
    this.customerExtId = '',
    this.accountExtId = '',
  });

  factory ChainOrderModel.dummy() {
    return ChainOrderModel(
      chainNo: 0,
      parentTransactionId: '',
      marketListModel: MarketListModel(
        symbolCode: '',
        updateDate: '',
        type: SymbolTypes.equity.name,
      ),
      orderAction: OrderActionTypeEnum.buy,
      price: 0,
      units: 1,
      orderValidity: OrderValidityEnum.daily,
      orderType: OrderTypeEnum.limit,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chainNo': chainNo,
      'parentTransactionId': parentTransactionId,
      'symbol': marketListModel.symbolCode,
      'side': orderAction.value,
      'price': price,
      'units': units,
      'timeInForce': orderValidity.value,
      'customerExtId': customerExtId,
      'accountExtId': accountExtId,
    };
  }

  copyWith({
    int? chainNo,
    String? parentTransactionId,
    MarketListModel? marketListModel,
    OrderActionTypeEnum? orderAction,
    double? price,
    int? units,
    OrderValidityEnum? orderValidity,
    OrderTypeEnum? orderType,
    String? customerExtId,
    String? accountExtId,
  }) {
    return ChainOrderModel(
      chainNo: chainNo ?? this.chainNo,
      parentTransactionId: parentTransactionId ?? this.parentTransactionId,
      marketListModel: marketListModel ?? this.marketListModel,
      orderAction: orderAction ?? this.orderAction,
      price: price ?? this.price,
      units: units ?? this.units,
      orderValidity: orderValidity ?? this.orderValidity,
      orderType: orderType ?? this.orderType,
      customerExtId: customerExtId ?? this.customerExtId,
      accountExtId: accountExtId ?? this.accountExtId,
    );
  }
}

class OptionContractOrderModel extends Equatable {
  final SymbolTypes symbolType;
  final String assetName;
  final ProcessType processType;
  final String maturityDate;
  final String contract;
  final OrderActionTypeEnum orderAction;
  final OptionOrderTypeEnum orderType;
  final OptionOrderValidityEnum orderValidity;
  final double price;
  final int units;
  final OrderCompletionEnum fillType;
  final List<String> maturityDateList;
  final List<String> contractList;
  final DateTime? endingSessionDate;
  final double multiplier;
  final StockItemModel? selectedStockItem;

  const OptionContractOrderModel({
    this.symbolType = SymbolTypes.future,
    this.assetName = '',
    this.processType = ProcessType.call,
    this.maturityDate = '',
    this.contract = '',
    this.orderAction = OrderActionTypeEnum.buy,
    this.orderType = OptionOrderTypeEnum.limit,
    this.orderValidity = OptionOrderValidityEnum.daily,
    this.price = 0,
    this.units = 0,
    this.fillType = OrderCompletionEnum.sms,
    this.maturityDateList = const [],
    this.contractList = const [],
    this.endingSessionDate,
    this.multiplier = 1,
    this.selectedStockItem,
  });

  OptionContractOrderModel copyWith({
    SymbolTypes? symbolType,
    String? assetName,
    ProcessType? processType,
    String? maturityDate,
    String? contract,
    OrderActionTypeEnum? orderAction,
    OptionOrderTypeEnum? orderType,
    OptionOrderValidityEnum? orderValidity,
    double? price,
    int? units,
    OrderCompletionEnum? fillType,
    List<String>? maturityDateList,
    List<String>? contractList,
    DateTime? endingSessionDate,
    double? multiplier,
    StockItemModel? selectedStockItem,
  }) {
    return OptionContractOrderModel(
      symbolType: symbolType ?? this.symbolType,
      assetName: assetName ?? this.assetName,
      processType: processType ?? this.processType,
      maturityDate: maturityDate ?? this.maturityDate,
      contract: contract ?? this.contract,
      orderAction: orderAction ?? this.orderAction,
      orderType: orderType ?? this.orderType,
      orderValidity: orderValidity ?? this.orderValidity,
      price: price ?? this.price,
      units: units ?? this.units,
      fillType: fillType ?? this.fillType,
      maturityDateList: maturityDateList ?? this.maturityDateList,
      contractList: contractList ?? this.contractList,
      endingSessionDate: endingSessionDate ?? this.endingSessionDate,
      multiplier: multiplier ?? this.multiplier,
      selectedStockItem: selectedStockItem ?? this.selectedStockItem,
    );
  }

  @override
  List<Object?> get props => [
        symbolType,
        assetName,
        processType,
        maturityDate,
        contract,
        orderAction,
        orderType,
        orderValidity,
        price,
        units,
        fillType,
        maturityDateList,
        contractList,
        endingSessionDate,
        multiplier,
        selectedStockItem,
      ];
}

enum ProcessType {
  call,
  put,
}
