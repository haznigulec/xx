import 'package:piapiri_v2/core/api/model/proto_model/base_symbol/base_symbol.dart';
import 'package:piapiri_v2/core/api/model/proto_model/computed_values/computed_values.dart';
import 'package:piapiri_v2/core/api/model/proto_model/ranker/ranker_model.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_event.dart';
import 'package:piapiri_v2/core/gen/RankedSymbols/RankedSymbols.pb.dart';
import 'package:piapiri_v2/core/model/market_carousel_model.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/ranker_enum.dart';
import 'package:piapiri_v2/core/model/symbol_info_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';

abstract class SymbolEvent extends PEvent {}

class SymbolUpdateListData extends SymbolEvent {
  final BaseSymbol symbol;

  SymbolUpdateListData({
    required this.symbol,
  });
}

class SymbolOnDisposeDetail extends SymbolEvent {}

class SymbolGetInfo extends SymbolEvent {
  final String symbolName;
  final Function(SymbolInfoModel) callback;

  SymbolGetInfo(
    this.symbolName,
    this.callback,
  );
}

class SymbolSubscribeStatsEvent extends SymbolEvent {
  final String statsKey;
  final String unsubscribeKey;
  final RankerEnum rankerEnum;

  SymbolSubscribeStatsEvent({
    this.statsKey = 'high',
    this.unsubscribeKey = '',
    required this.rankerEnum,
  });
}

class SymbolUpdateEquityRankerListEvent extends SymbolEvent {
  final List<Ranker> rankerList;
  final String topic;

  SymbolUpdateEquityRankerListEvent({
    required this.rankerList,
    required this.topic,
  });
}

class SymbolUpdateWarrantRankerListEvent extends SymbolEvent {
  final List<Ranker> rankerList;
  final String topic;

  SymbolUpdateWarrantRankerListEvent({
    required this.rankerList,
    required this.topic,
  });
}

class SymbolUpdateViopRankerListEvent extends SymbolEvent {
  final RankedSymbolsMessage rankedSymbols;

  SymbolUpdateViopRankerListEvent({
    required this.rankedSymbols,
  });
}

class SymbolUnsubcribeRankerListEvent extends SymbolEvent {
  final String statsKey;
  final RankerEnum rankerEnum;

  SymbolUnsubcribeRankerListEvent({
    required this.statsKey,
    required this.rankerEnum,
  });
}

class SymbolSubTopicsEvent extends SymbolEvent {
  final List<MarketListModel> symbols;
  final Function(List<MarketListModel>)? callback;
  final Function(MarketListModel)? subscribeCallback;
  final bool skipDetails;
  final bool isGrid;

  SymbolSubTopicsEvent({
    required this.symbols,
    this.callback,
    this.skipDetails = false,
    this.isGrid = false,
    this.subscribeCallback,
  });
}

class SymbolSubOneTopicEvent extends SymbolEvent {
  final String symbol;
  final Function(MarketListModel)? callback;
  final bool skipDetails;
  final SymbolTypes? symbolType;

  SymbolSubOneTopicEvent({
    required this.symbol,
    this.callback,
    this.skipDetails = false,
    this.symbolType,
  });
}

class SymbolUnsubsubscribeEvent extends SymbolEvent {
  final List<MarketListModel> symbolList;

  SymbolUnsubsubscribeEvent({
    this.symbolList = const [],
  });
}

class SymbolRestartSubscription extends SymbolEvent {}

class GetSymbolTypesEvent extends SymbolEvent {
  final List<String> symbolList;
  final Function(
    Map<String, MarketListModel?> symbolTypeList,
  )? callback;
  GetSymbolTypesEvent({
    required this.symbolList,
    this.callback,
  });
}

class GetSpesificListSymbolTypesEvent extends SymbolEvent {
  final List<String> symbolList;
  final String? symbolListType;
  final Function(
    Map<String, MarketListModel?> symbolTypeList,
  )? callback;
  GetSpesificListSymbolTypesEvent({
    required this.symbolList,
    this.symbolListType,
    this.callback,
  });
}

class SymbolRestartTempSelectedItem extends SymbolEvent {}

class SymbolSubscribeComputedValuesEvent extends SymbolEvent {
  final String symbolCode;
  final String symbolType;

  SymbolSubscribeComputedValuesEvent({
    required this.symbolCode,
    required this.symbolType,
  });
}

class SymbolSetComputedValuesEvent extends SymbolEvent {
  final ComputedValues? computedValues;

  SymbolSetComputedValuesEvent({
    this.computedValues,
  });
}

class SymbolUnsubcribeComputedValuesEvent extends SymbolEvent {
  final String symbolCode;
  final String symbolType;

  SymbolUnsubcribeComputedValuesEvent({
    required this.symbolCode,
    required this.symbolType,
  });
}

class GetSymbolDetailEvent extends SymbolEvent {
  final String symbolName;
  final Function(MarketListModel symbolModel) callback;

  GetSymbolDetailEvent({
    required this.symbolName,
    required this.callback,
  });
}

class GetBuySellButtonsEnabledEvent extends SymbolEvent {
  final String symbolName;
  final String symbolType;

  final Function(bool) callback;

  GetBuySellButtonsEnabledEvent({
    required this.symbolName,
    required this.symbolType,
    required this.callback,
  });
}

class GetMarketCarouselEvent extends SymbolEvent {
  final Function(List<MarketCarouselModel> symbolModel)? callback;

  GetMarketCarouselEvent({
    this.callback,
  });
}

class SymbolIsExistInDBEvent extends SymbolEvent {
  final String symbol;
  final Function(bool, String) hasInDB;
  final SymbolTypes symbolTypes;

  SymbolIsExistInDBEvent({
    required this.symbol,
    required this.hasInDB,
    required this.symbolTypes,
  });
}

class SubscribeDLDummyEvent extends SymbolEvent {
  final Function? callback;
  SubscribeDLDummyEvent({
    this.callback,
  });
}
