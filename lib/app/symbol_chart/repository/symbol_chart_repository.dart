import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/model/chart_model.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';

abstract class SymbolChartRepository {
  writeChartType({
    required String chartTypeName,
  });

  Future<ApiResponse> symbolDetailBar(
    String symbolName,
    ChartFilter filter, {
    MapEntry<String, String>? dates,
    required String derivedUrl,
    required String barUrl,
    required CurrencyEnum currencyEnum,
    bool isPerformance = false,
    String? period,
  });

  Future<ApiResponse> symbolDetailBarByDateRange(
    String symbolName, {
    required String barUrl,
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<ChartType> getChartType();

  Future<ApiResponse> getUsChartData({
    required String symbols,
    required String timeframe,
    required String currency,
    required String from,
    required String to,
    num? multiplier,
  });

  Future<ApiResponse> getFundChartData({
    required String symbol,
    required String start,
    required String end,
    required String period,
  });
}
