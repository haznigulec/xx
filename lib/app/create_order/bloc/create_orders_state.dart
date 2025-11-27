import 'package:piapiri_v2/app/assets/model/collateral_info_model.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/model/assets_model.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/order_model.dart';
import 'package:piapiri_v2/core/model/stock_item_model.dart';

class CreateOrdersState extends PState {
  final PageState consolidateAssetState;
  final AssetModel? consolidatedAssets;
  final double cashLimit;
  final double tradeLimit;
  final List<StockItemModel> positionList;
  final List<MarketListModel> positionDetailedList;
  final CollateralInfo? collateralInfo;
  final List<ChainOrderModel> chainOrderList;

  const CreateOrdersState({
    super.type = PageState.initial,
    this.consolidateAssetState = PageState.initial,
    this.consolidatedAssets,
    super.error,
    this.cashLimit = 0,
    this.tradeLimit = 0,
    this.positionList = const [],
    this.positionDetailedList = const [],
    this.collateralInfo,
    this.chainOrderList = const [],
  });

  @override
  CreateOrdersState copyWith({
    PageState? type,
    PBlocError? error,
    AssetModel? consolidatedAssets,
    PageState? consolidateAssetState,
    double? cashLimit,
    double? tradeLimit,
    List<StockItemModel>? positionList,
    List<MarketListModel>? positionDetailedList,
    CollateralInfo? collateralInfo,
    List<ChainOrderModel>? chainOrderList,
  }) {
    return CreateOrdersState(
      type: type ?? this.type,
      error: error ?? this.error,
      consolidatedAssets: consolidatedAssets ?? this.consolidatedAssets,
      consolidateAssetState: consolidateAssetState ?? this.consolidateAssetState,
      cashLimit: cashLimit ?? this.cashLimit,
      tradeLimit: tradeLimit ?? this.tradeLimit,
      positionList: positionList ?? this.positionList,
      positionDetailedList: positionDetailedList ?? this.positionDetailedList,
      collateralInfo: collateralInfo ?? this.collateralInfo,
      chainOrderList: chainOrderList ?? this.chainOrderList,
    );
  }

  @override
  List<Object?> get props => [
        type,
        error,
        consolidatedAssets,
        consolidateAssetState,
        cashLimit,
        tradeLimit,
        positionList,
        positionDetailedList,
        collateralInfo,
        chainOrderList,
      ];
}
