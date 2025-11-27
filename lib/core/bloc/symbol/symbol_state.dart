import 'package:piapiri_v2/core/api/model/proto_model/computed_values/computed_values.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/model/favorite_list.dart';
import 'package:piapiri_v2/core/model/market_carousel_model.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/ranker_enum.dart';

class SymbolState extends PState {
  final List<FavoriteList> watchList;
  final FavoriteList? selectedList;
  final MarketListModel selectedItem;
  final MarketListModel? tempSelectedItem;
  final MarketListModel? conditionSymbol;
  final MarketListModel? detailSymbol;
  final String homeSymbol;
  final List<MarketListModel> oldWatchingSymbolNames;
  final List<String> watchingSymbolNames;
  final List<MarketListModel> watchingItems;
  final String rankerKey;
  final MarketListModel updatedSymbol;
  final List<ComputedValues> computedValues;
  final RankerEnum rankerEnum;
  final List<MarketListModel> equityRankerList;
  final List<MarketListModel> warrantRankerList;
  final List<MarketListModel> viopRankerList;
  final List<MarketCarouselModel> marketCarousel;

  const SymbolState({
    super.type = PageState.initial,
    super.error,
    this.watchList = const [],
    this.selectedList,
    this.watchingItems = const [],
    this.selectedItem = const MarketListModel(
      symbolCode: 'XU100',
      updateDate: '',
    ),
    this.tempSelectedItem,
    this.conditionSymbol,
    this.detailSymbol,
    this.watchingSymbolNames = const [],
    this.oldWatchingSymbolNames = const [],
    this.homeSymbol = 'XU100',
    this.rankerKey = '',
    this.updatedSymbol = const MarketListModel(
      symbolCode: '',
      updateDate: '',
    ),
    this.computedValues = const [],
    this.rankerEnum = RankerEnum.equity,
    this.equityRankerList = const [],
    this.warrantRankerList = const [],
    this.viopRankerList = const [],
    this.marketCarousel = const [],
  });

  @override
  SymbolState copyWith({
    PageState? type,
    PBlocError? error,
    List<FavoriteList>? watchList,
    FavoriteList? selectedList,
    List<MarketListModel>? watchingItems,
    MarketListModel? selectedItem,
    List<String>? watchingSymbolNames,
    List<MarketListModel>? oldWatchingSymbolNames,
    String? homeSymbol,
    MarketListModel? tempSelectedItem,
    MarketListModel? conditionSymbol,
    MarketListModel? detailSymbol,
    String? rankerKey,
    MarketListModel? updatedSymbol,
    List<ComputedValues>? computedValues,
    RankerEnum? rankerEnum,
    List<MarketListModel>? equityRankerList,
    List<MarketListModel>? warrantRankerList,
    List<MarketListModel>? viopRankerList,
    List<MarketCarouselModel>? marketCarousel,
  }) {
    return SymbolState(
      type: type ?? this.type,
      error: error ?? this.error,
      watchList: watchList ?? this.watchList,
      selectedList: selectedList ?? this.selectedList,
      watchingItems: watchingItems ?? this.watchingItems,
      selectedItem: selectedItem ?? this.selectedItem,
      watchingSymbolNames: watchingSymbolNames ?? this.watchingSymbolNames,
      oldWatchingSymbolNames: oldWatchingSymbolNames ?? this.oldWatchingSymbolNames,
      homeSymbol: homeSymbol ?? this.homeSymbol,
      tempSelectedItem: tempSelectedItem ?? this.tempSelectedItem,
      conditionSymbol: conditionSymbol ?? this.conditionSymbol,
      rankerKey: rankerKey ?? this.rankerKey,
      updatedSymbol: updatedSymbol ?? this.updatedSymbol,
      detailSymbol: detailSymbol ?? this.detailSymbol,
      computedValues: computedValues ?? this.computedValues,
      rankerEnum: rankerEnum ?? this.rankerEnum,
      equityRankerList: equityRankerList ?? this.equityRankerList,
      warrantRankerList: warrantRankerList ?? this.warrantRankerList,
      viopRankerList: viopRankerList ?? this.viopRankerList,
      marketCarousel: marketCarousel ?? this.marketCarousel,
    );
  }

  SymbolState restartTempSelectedItem() {
    return SymbolState(
      type: type,
      error: error,
      watchList: watchList,
      selectedList: selectedList,
      watchingItems: watchingItems,
      selectedItem: selectedItem,
      watchingSymbolNames: watchingSymbolNames,
      oldWatchingSymbolNames: oldWatchingSymbolNames,
      homeSymbol: homeSymbol,
      tempSelectedItem: null,
      conditionSymbol: conditionSymbol,
      rankerKey: rankerKey,
      updatedSymbol: updatedSymbol,
      detailSymbol: detailSymbol,
      computedValues: computedValues,
      rankerEnum: rankerEnum,
      equityRankerList: equityRankerList,
      warrantRankerList: warrantRankerList,
      viopRankerList: viopRankerList,
      marketCarousel: marketCarousel,
    );
  }

  SymbolState restartComputedValues() {
    return SymbolState(
      type: type,
      error: error,
      watchList: watchList,
      selectedList: selectedList,
      watchingItems: watchingItems,
      selectedItem: selectedItem,
      watchingSymbolNames: watchingSymbolNames,
      oldWatchingSymbolNames: oldWatchingSymbolNames,
      homeSymbol: homeSymbol,
      tempSelectedItem: tempSelectedItem,
      conditionSymbol: conditionSymbol,
      rankerKey: rankerKey,
      updatedSymbol: updatedSymbol,
      detailSymbol: detailSymbol,
      computedValues: const [],
      rankerEnum: rankerEnum,
      equityRankerList: equityRankerList,
      warrantRankerList: warrantRankerList,
      viopRankerList: viopRankerList,
      marketCarousel: marketCarousel,
    );
  }

  @override
  List<Object?> get props => [
        type,
        error,
        watchList,
        selectedList,
        watchingItems,
        selectedItem,
        watchingSymbolNames,
        oldWatchingSymbolNames,
        homeSymbol,
        tempSelectedItem,
        conditionSymbol,
        rankerKey,
        updatedSymbol,
        detailSymbol,
        computedValues,
        rankerEnum,
        equityRankerList,
        warrantRankerList,
        viopRankerList,
        marketCarousel,
      ];
}
