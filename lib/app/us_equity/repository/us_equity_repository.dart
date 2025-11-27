import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/model/sort_enum.dart';
import 'package:piapiri_v2/core/model/us_market_movers_enum.dart';

abstract class UsEquityRepository {
  Future<ApiResponse> getLosersGainersPolygon({
    required UsMarketMovers marketMover,
  });

  Future<ApiResponse> getLosersGainersCapra();

  Future<ApiResponse> getCustomBars({
    required String symbols,
    required String timeframe,
    required String from,
    required String to,
    SortEnum? sortEnum,
    int? limit,

  });

  Future<ApiResponse> getDividends({
    required List<String> symbols,
    required List<int> types,
    required String startDate,
    required String endDate,
    required int sortDirection,
  });

  Future<ApiResponse> getIncomingDividends({
    required List<int> types,
    required String startDate,
    required String endDate,
    required int sortDirection,
    required bool onlyFavorites,
  });

  Future<ApiResponse> getActiveSymbols();

  Future<ApiResponse> getActiveSymbolsHead();

  Future<Map<String, dynamic>?> readActiveSymbolsLocal();

  void writeActiveSymbolsLocal(Map<String, dynamic> symbols);

  Future<ApiResponse> getFavoriteSymbols();

  Future<ApiResponse> getFavoriteSymbolsHead();

  Future<Map<String, dynamic>?> readFavoriteSymbolsLocal();

  void writeFavoriteSymbolsLocal(Map<String, dynamic> symbols);

  Future<ApiResponse> getFractionableSymbols();

  Future<ApiResponse> getFractionableSymbolsHead();

  Future<Map<String, dynamic>?> readFractionableSymbolsLocal();

  void writeFractionableSymbolsLocal(Map<String, dynamic> symbols);


  Future<ApiResponse> getTickerSnapshot({
    required String symbol,
  });

  Future<ApiResponse> getTickerOverview({
    required String symbolName,
  });

  Future<ApiResponse> getFinancialData({
    required String symbolName,
  });

  Future<ApiResponse> getRelatedTickers({
    required String symbolName,
  });

  Future<ApiResponse> getDailyTransactionInfo();

  Future<ApiResponse> getUsSectors();

}
