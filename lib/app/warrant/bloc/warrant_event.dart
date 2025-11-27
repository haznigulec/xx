import 'package:piapiri_v2/core/bloc/bloc/bloc_event.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/risk_level_enum.dart';

abstract class WarrantEvent extends PEvent {}

class InitEvent extends WarrantEvent {
  final String? underlyingAsset;
  final String? selectedMarketMaker;

  InitEvent({
    this.underlyingAsset,
    this.selectedMarketMaker,
  });
}

class OnApplyFilterEvent extends WarrantEvent {
  final String marketMaker;
  final String underlyingAsset;
  final RiskLevelEnum? risk;
  final String? type;
  final String? maturity;
  final Function(List<MarketListModel>)? callback;
  final Function(List<MarketListModel>)? unsubscribeCallback;

  OnApplyFilterEvent({
    required this.marketMaker,
    required this.underlyingAsset,
    this.risk,
    this.type,
    this.maturity,
    this.callback,
    this.unsubscribeCallback,
  });
}

class OnRemoveSelectedEvent extends WarrantEvent {
  final bool removeMaturity;
  final bool removeRisk;
  final bool removeType;
  OnRemoveSelectedEvent({
    this.removeMaturity = false,
    this.removeRisk = false,
    this.removeType = false,
  });
}

class GetWarrantUsUnderlyingEvent extends WarrantEvent {}

class HasWarrantOfSymbolEvent extends WarrantEvent {
  final String symbol;

  HasWarrantOfSymbolEvent({
    required this.symbol,
  });
}
