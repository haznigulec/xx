import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/model/chart_model.dart';
import 'package:piapiri_v2/core/model/chart_performance_model.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';

class SymbolChartState extends PState {
  final List<SymbolChartModel> data;
  final List<ChartData> chartData;
  final DateTime minimumDate;
  final ChartFilter selectedFilter;
  final ChartFilter selectedPerformanceFilter;
  final ChartType chartType;
  final CurrencyEnum chartCurrency;
  final List<ChartPerformanceModel> performanceData;
  final List<ChartPerformanceModel> fundCompareSymbols;
  final Map<ChartFilter, List<ChartPerformanceModel>> fundCompareData;
  

  const SymbolChartState({
    super.type = PageState.initial,
    super.error,
    this.data = const [],
    this.chartData = const [],
    required this.minimumDate,
    this.selectedFilter = ChartFilter.oneDay,
    this.selectedPerformanceFilter = ChartFilter.oneWeek,
    this.chartType = ChartType.area,
    this.chartCurrency = CurrencyEnum.turkishLira,
    this.performanceData = const [],
    this.fundCompareSymbols = const [],
    this.fundCompareData = const {},
  });

  @override
  SymbolChartState copyWith({
    List<SymbolChartModel>? data,
    List<ChartData>? chartData,
    DateTime? minimumDate,
    ChartFilter? selectedFilter,
    ChartFilter? selectedPerformanceFilter,
    ChartType? chartType,
    PageState? type,
    PBlocError? error,
    CurrencyEnum? chartCurrency,
    List<ChartPerformanceModel>? performanceData,
    List<ChartPerformanceModel>? fundCompareSymbols,
    Map<ChartFilter, List<ChartPerformanceModel>>? fundCompareData,

  }) {
    return SymbolChartState(
      data: data ?? this.data,
      chartData: chartData ?? this.chartData,
      minimumDate: minimumDate ?? this.minimumDate,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      selectedPerformanceFilter: selectedPerformanceFilter ?? this.selectedPerformanceFilter,
      chartType: chartType ?? this.chartType,
      chartCurrency: chartCurrency ?? this.chartCurrency,
      performanceData: performanceData ?? this.performanceData,
      fundCompareSymbols: fundCompareSymbols ?? this.fundCompareSymbols,
      fundCompareData: fundCompareData ?? this.fundCompareData,
      type: type ?? this.type,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        data,
        chartData,
        minimumDate,
        selectedFilter,
        selectedPerformanceFilter,
        chartType,
        type,
        error,
        chartCurrency,
        performanceData,
        fundCompareSymbols,
        fundCompareData,
      ];
}

class SymbolChartModel {
  final DateTime date;
  final double open;
  final double high;
  final double low;
  final double close;

  const SymbolChartModel({
    required this.date,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
  });

  SymbolChartModel copyWith({
    DateTime? date,
    double? open,
    double? high,
    double? low,
    double? close,
  }) {
    return SymbolChartModel(
      date: date ?? this.date,
      open: open ?? this.open,
      high: high ?? this.high,
      low: low ?? this.low,
      close: close ?? this.close,
    );
  }

  factory SymbolChartModel.fromJson(Map<String, dynamic> json) {
    return SymbolChartModel(
      date: DateTime.fromMillisecondsSinceEpoch(json['time']),
      open: double.parse(json['open'].toStringAsFixed(2)),
      high: double.parse(json['high'].toStringAsFixed(2)),
      low: double.parse(json['low'].toStringAsFixed(2)),
      close: double.parse(json['close'].toStringAsFixed(2)),
    );
  }

  List<Object?> get props => [
        date,
        open,
        high,
        low,
        close,
      ];
}
