import 'package:piapiri_v2/core/bloc/bloc/bloc_event.dart';
import 'package:piapiri_v2/core/model/chart_model.dart';
import 'package:piapiri_v2/core/model/performance_gauge_mdoel.dart';
import 'package:piapiri_v2/core/model/ticker_overview.dart';
import 'package:piapiri_v2/core/model/us_financial_model.dart';
import 'package:piapiri_v2/core/model/us_sector_model.dart';
import 'package:piapiri_v2/core/model/us_symbol_snapshot.dart';

abstract class UsEquityEvent extends PEvent {}

class GetLosersGainersEvent extends UsEquityEvent {}

class GetCustomBarsEvent extends UsEquityEvent {
  final ChartFilter? chartFilter;
  final String symbols;

  GetCustomBarsEvent({
    this.chartFilter,
    required this.symbols,
  });
}

class SubscribeSymbolEvent extends UsEquityEvent {
  final List<String> symbolName;
  final Function(List<UsSymbolSnapshot> symbols, List<String> alreadySubscribedList)? callback;

  SubscribeSymbolEvent({
    required this.symbolName,
    this.callback,
  });
}

class UnsubscribeSymbolEvent extends UsEquityEvent {
  final List<String> symbolName;

  UnsubscribeSymbolEvent({
    required this.symbolName,
  });
}

class UpdateUsSymbolEvent extends UsEquityEvent {
  final String symbolName;
  final double price;
  final int timestamp;

  UpdateUsSymbolEvent({
    required this.symbolName,
    required this.price,
    required this.timestamp,
  });
}

class GetDividendWeeklyEvent extends UsEquityEvent {
  final List<String> symbols;

  GetDividendWeeklyEvent({
    required this.symbols,
  });
}

class GetDividendYearlyEvent extends UsEquityEvent {
  final List<String> symbols;

  GetDividendYearlyEvent({
    required this.symbols,
  });
}

class GetDividendTwoYearEvent extends UsEquityEvent {
  final List<String> symbols;

  GetDividendTwoYearEvent({
    required this.symbols,
  });
}

class GetUsIncomingDividends extends UsEquityEvent {
  final bool isFavorite;
  final Function()? successCallback;

  GetUsIncomingDividends({
    required this.isFavorite,
    this.successCallback,
  });
}

class SetUsChartCurrentType extends UsEquityEvent {
  SetUsChartCurrentType();
}

class SetUsChartType extends UsEquityEvent {
  final ChartType usChartType;
  SetUsChartType({
    required this.usChartType,
  });
}

class GetActiveSymbols extends UsEquityEvent {}

class GetFavoriteSymbols extends UsEquityEvent {}

class GetFractionableSymbols extends UsEquityEvent {}

class GetPolygonApiKeyEvent extends UsEquityEvent {}

class ChangeSubscriptionStatusEvent extends UsEquityEvent {
  final List<String> symbolList;
  final bool isSubscribed;
  ChangeSubscriptionStatusEvent({
    required this.symbolList,
    required this.isSubscribed,
  });
}

class GetSymbolsDetailEvent extends UsEquityEvent {
  final List<String> symbols;
  final Function(List<UsSymbolSnapshot> symbols)? callback;
  GetSymbolsDetailEvent({
    required this.symbols,
    this.callback,
  });
}

class GetTickerOverviewEvent extends UsEquityEvent {
  final String symbolName;
  final Function(TickerOverview? tickerOverview)? callback;
  GetTickerOverviewEvent({
    required this.symbolName,
    this.callback,
  });
}

class GetFinancialDataEvent extends UsEquityEvent {
  final String symbolName;
  final Function(UsFinancialModel? usFinancialModel)? callback;
  GetFinancialDataEvent({
    required this.symbolName,
    this.callback,
  });
}

class GetPerformanceGaugeEvent extends UsEquityEvent {
  final String symbolName;
  final Function(
    PerformanceGaugeModel? weeklyBar,
    PerformanceGaugeModel? monthlyBar,
    PerformanceGaugeModel? yearlyBar,
  )? callback;
  GetPerformanceGaugeEvent({
    required this.symbolName,
    this.callback,
  });
}

class GetRelatedTickersEvent extends UsEquityEvent {
  final String symbolName;
  final Function(List<String>? relatedTickers)? callback;
  GetRelatedTickersEvent({
    required this.symbolName,
    this.callback,
  });
}

class GetDailyTransactionEvent extends UsEquityEvent {
  final Function(int last5WorkingDayDailyBuySellCount)? callback;
  GetDailyTransactionEvent({
    this.callback,
  });
}

class GetUsSectorsEvent extends UsEquityEvent {
  final Function(List<UsSectorModel> sectorList)? callback;
  GetUsSectorsEvent({
    this.callback,
  });
}

