import 'package:piapiri_v2/app/symbol_chart/bloc/symbol_chart_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_event.dart';
import 'package:piapiri_v2/core/model/chart_model.dart';
import 'package:piapiri_v2/core/model/chart_performance_model.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';

abstract class SymbolChartEvent extends PEvent {}

class GetDataEvent extends SymbolChartEvent {
  final String symbolName;
  final ChartFilter? filter;
  final Function(List<SymbolChartModel>)? callback;
  final CurrencyEnum? chartCurrency;
  GetDataEvent({
    required this.symbolName,
    this.filter,
    this.callback,
    required this.chartCurrency,
  });
}

class GetPerformanceEvent extends SymbolChartEvent {
  final List<ChartPerformanceModel> chartPerformanceModels;
  final ChartFilter performanceFilter;
  final bool isInitial;
  final bool isFundPerformance;
  final Function(bool isSuccess, List<ChartPerformanceModel>? data)? callback;

  GetPerformanceEvent({
    required this.chartPerformanceModels,
    this.performanceFilter = ChartFilter.oneWeek,
    this.isInitial = false,
    this.isFundPerformance = false,
    this.callback,
  });
}

class AddPerformanceEvent extends SymbolChartEvent {
  final ChartPerformanceModel chartPerformance;
  final int? index;
  final Function(bool isSuccess, List<ChartPerformanceModel>? data)? callback;

  AddPerformanceEvent({
    required this.chartPerformance,
    this.index,
    this.callback,
  });
}

class RemovePerformanceEvent extends SymbolChartEvent {
  final String symbolName;

  RemovePerformanceEvent({
    required this.symbolName,
  });
}

class SetChartTypeEvent extends SymbolChartEvent {
  final ChartType chartType;

  SetChartTypeEvent({
    required this.chartType,
  });
}

class GetDataByDateRangeEvent extends SymbolChartEvent {
  final String symbolName;
  final DateTime startDate;
  final DateTime endDate;
  final Function(List<SymbolChartModel>?)? callback;

  GetDataByDateRangeEvent({
    required this.symbolName,
    required this.startDate,
    required this.endDate,
    this.callback,
  });
}

class SymbolChangeChartCurrencyEvent extends SymbolChartEvent {}

class GetFundCompareSymbolsEvent extends SymbolChartEvent {}
