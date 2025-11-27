import 'package:piapiri_v2/app/assets/model/collateral_info_model.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/model/assets_model.dart';
import 'package:piapiri_v2/core/model/order_list_model.dart';
import 'package:piapiri_v2/core/model/order_model.dart';
import 'package:piapiri_v2/core/model/order_status_enum.dart';
import 'package:piapiri_v2/core/model/stock_item_model.dart';
import 'package:piapiri_v2/core/model/symbol_type_enum.dart';

class OrdersState extends PState {
  final PageState positionListState;
  final PageState orderListState;
  final String selectedAccount;
  final SymbolTypeEnum selectedSymbolType;
  final OrderStatusEnum selectedOrderStatus;
  final Map<OrderStatusEnum, OrderListModel>? orderListMap;
  final OrderListModel allOrderList;
  final double cashLimit;
  final double tradeLimit;
  final List<StockItemModel> positionList;
  final List<OverallSubItemModel> viopPositionList;
  final OverallSubItemModel? selectedViopItem;
  final OrderModel newOrder;
  final List<OrderItemModel> equityOrderList;
  final List<OrderItemModel> warrantOrderList;
  final List<ChainOrderModel> chainOrderList;
  final List<AssetModel> portfolioAssetList;
  final List<String> futureUnderlyingList;
  final List<String> optionUnderlyingList;
  final List<Map<String, dynamic>> contracts;
  final OptionContractOrderModel newOptionOrder;
  final CollateralInfo? collateralInfo;
  final bool? isAsc;

  const OrdersState({
    super.type = PageState.initial,
    this.positionListState = PageState.initial,
    this.orderListState = PageState.initial,
    super.error,
    this.selectedAccount = '',
    this.selectedOrderStatus = OrderStatusEnum.pending,
    this.selectedSymbolType = SymbolTypeEnum.all,
    this.cashLimit = 0,
    this.tradeLimit = 0,
    this.positionList = const [],
    this.viopPositionList = const [],
    this.newOrder = const OrderModel(),
    this.equityOrderList = const [],
    this.warrantOrderList = const [],
    this.orderListMap,
    this.allOrderList = const OrderListModel(),
    this.chainOrderList = const [],
    this.portfolioAssetList = const [],
    this.futureUnderlyingList = const [],
    this.optionUnderlyingList = const [],
    this.contracts = const [],
    this.newOptionOrder = const OptionContractOrderModel(),
    this.collateralInfo,
    this.selectedViopItem,
    this.isAsc = true,
  });

  @override
  OrdersState copyWith({
    PageState? type,
    PageState? positionListState,
    PageState? orderListState,
    PBlocError? error,
    String? selectedAccount,
    SymbolTypeEnum? selectedSymbolType,
    OrderStatusEnum? selectedOrderStatus,
    double? cashLimit,
    double? tradeLimit,
    List<StockItemModel>? positionList,
    List<OverallSubItemModel>? viopPositionList,
    OverallSubItemModel? selectedViopItem,
    OrderModel? newOrder,
    List<OrderItemModel>? equityOrderList,
    List<OrderItemModel>? warrantOrderList,
    Map<OrderStatusEnum, OrderListModel>? orderListMap,
    OrderListModel? allOrderList,
    List<ChainOrderModel>? chainOrderList,
    List<AssetModel>? portfolioAssetList,
    List<String>? futureUnderlyingList,
    List<String>? optionUnderlyingList,
    List<Map<String, dynamic>>? contracts,
    OptionContractOrderModel? newOptionOrder,
    CollateralInfo? collateralInfo,
    bool? isAsc,
  }) {
    return OrdersState(
      type: type ?? this.type,
      positionListState: positionListState ?? this.positionListState,
      orderListState: orderListState ?? this.orderListState,
      error: error ?? this.error,
      selectedAccount: selectedAccount ?? this.selectedAccount,
      selectedSymbolType: selectedSymbolType ?? this.selectedSymbolType,
      selectedOrderStatus: selectedOrderStatus ?? this.selectedOrderStatus,
      orderListMap: orderListMap ?? this.orderListMap,
      allOrderList: allOrderList ?? this.allOrderList,
      cashLimit: cashLimit ?? this.cashLimit,
      tradeLimit: tradeLimit ?? this.tradeLimit,
      positionList: positionList ?? this.positionList,
      viopPositionList: viopPositionList ?? this.viopPositionList,
      selectedViopItem: selectedViopItem ?? this.selectedViopItem,
      newOrder: newOrder ?? this.newOrder,
      equityOrderList: equityOrderList ?? this.equityOrderList,
      warrantOrderList: warrantOrderList ?? this.warrantOrderList,
      chainOrderList: chainOrderList ?? this.chainOrderList,
      portfolioAssetList: portfolioAssetList ?? this.portfolioAssetList,
      futureUnderlyingList: futureUnderlyingList ?? this.futureUnderlyingList,
      optionUnderlyingList: optionUnderlyingList ?? this.optionUnderlyingList,
      contracts: contracts ?? this.contracts,
      newOptionOrder: newOptionOrder ?? this.newOptionOrder,
      collateralInfo: collateralInfo ?? this.collateralInfo,
      isAsc: isAsc ?? this.isAsc,
    );
  }

  @override
  List<Object?> get props => [
        type,
        positionListState,
        orderListState,
        error,
        selectedAccount,
        selectedSymbolType,
        selectedOrderStatus,
        orderListMap,
        allOrderList,
        cashLimit,
        tradeLimit,
        positionList,
        newOrder,
        equityOrderList,
        warrantOrderList,
        chainOrderList,
        portfolioAssetList,
        futureUnderlyingList,
        optionUnderlyingList,
        contracts,
        newOptionOrder,
        collateralInfo,
        viopPositionList,
        selectedViopItem,
        isAsc,
      ];
}
