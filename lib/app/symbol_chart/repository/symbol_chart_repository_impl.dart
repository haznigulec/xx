import 'package:piapiri_v2/app/symbol_chart/repository/symbol_chart_repository.dart';
import 'package:piapiri_v2/common/utils/local_keys.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/chart_model.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/storage/local_storage.dart';

class SymbolChartRepositoryImpl extends SymbolChartRepository {
  @override
  Future<ApiResponse> symbolDetailBar(
    String symbolName,
    ChartFilter filter, {
    MapEntry<String, String>? dates,
    required String derivedUrl,
    required String barUrl,
    required CurrencyEnum currencyEnum,
    bool isPerformance = false,
    String? period,
  }) {
    return getIt<PPApi>().matriksService.symbolDetailBar(
          symbolName,
          filter,
          dates: dates,
          derivedUrl: derivedUrl,
          barUrl: barUrl,
          currencyEnum: currencyEnum,
          isPerformance: isPerformance,
          period: period,
        );
  }

  @override
  Future<ApiResponse> symbolDetailBarByDateRange(
    String symbolName, {
    required String barUrl,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return getIt<PPApi>().matriksService.symbolDetailBarByDateRange(
          symbolName,
          barUrl: barUrl,
          startDate: startDate,
          endDate: endDate,
        );
  }

  @override
  writeChartType({
    required String chartTypeName,
  }) {
    return getIt<LocalStorage>().write(
      LocalKeys.chartType,
      chartTypeName,
    );
  }

  @override
  Future<ChartType> getChartType() async {
    String chartType = (await getIt<LocalStorage>().read(LocalKeys.chartType) ?? 'AREA').toString().toUpperCase();
    return ChartType.values.firstWhere(
      (element) => element.value == chartType,
    );
  }

  @override
  Future<ApiResponse> getUsChartData({
    required String symbols,
    required String timeframe,
    required String currency,
    required String from,
    required String to,
    num? multiplier,
  }) {
    return getIt<PPApi>().polygonService.getCustomBars(
          symbol: symbols,
          timeframe: timeframe,
          from: from,
          to: to,
          multiplier: multiplier,
        );
  }

  @override
  Future<ApiResponse> getFundChartData({
    required String symbol,
    required String start,
    required String end,
    required String period,
  }) {
    return getIt<PPApi>().fundService.getFundPriceGraph(
          fundCode: symbol,
          startDate: start,
          endDate: end,
          period: period,
        );
  }
}
