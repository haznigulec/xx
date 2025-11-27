import 'package:piapiri_v2/core/model/symbol_types.dart';

class ChartPerformanceModel {
  final String symbolName;
  final String underlyingName;
  final String? subType;
  final String description;
  final SymbolTypes symbolType;
  final List<ChartPerformanceData>? data;
  final double? performance;

  ChartPerformanceModel({
    required this.symbolName,
    required this.underlyingName,
    this.subType,
    required this.description,
    required this.symbolType,
    this.data,
    this.performance,
  });
}

class ChartPerformanceData {
  final DateTime? date;
  final double? performance;

  ChartPerformanceData(
    this.date,
    this.performance,
  );
}
