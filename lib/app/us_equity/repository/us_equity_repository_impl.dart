import 'package:piapiri_v2/app/us_equity/repository/us_equity_repository.dart';
import 'package:piapiri_v2/common/utils/local_keys.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/sort_enum.dart';
import 'package:piapiri_v2/core/model/us_market_movers_enum.dart';
import 'package:piapiri_v2/core/storage/local_storage.dart';

class UsEquityRepositoryImpl extends UsEquityRepository {
  @override
  Future<ApiResponse> getLosersGainersPolygon({
    required UsMarketMovers marketMover,
  }) {
    return getIt<PPApi>().usEquityService.getLosersGainersPolygon(
          marketMover,
        );
  }
  @override
  Future<ApiResponse> getLosersGainersCapra() {
    return getIt<PPApi>().usEquityService.getLosersGainersCapra();
  }

  @override
  Future<ApiResponse> getCustomBars({
    required String symbols,
    required String timeframe,
    required String from,
    required String to,
    SortEnum? sortEnum,
    int? limit,

  }) {
    return getIt<PPApi>().polygonService.getCustomBars(
          symbol: symbols,
          timeframe: timeframe,
          from: from,
          to: to,
          sortEnum: sortEnum,
          limit: limit,
        );
  }


  @override
  Future<ApiResponse> getDividends({
    required List<String> symbols,
    required List<int> types,
    required String startDate,
    required String endDate,
    required int sortDirection,
  }) {
    return getIt<PPApi>().usEquityService.getDividends(
          symbols: symbols,
          types: types,
          startDate: startDate,
          endDate: endDate,
          sortDirection: sortDirection,
        );
  }

  @override
  Future<ApiResponse> getIncomingDividends({
    required List<int> types,
    required String startDate,
    required String endDate,
    required int sortDirection,
    required bool onlyFavorites,
  }) {
    return getIt<PPApi>().usEquityService.getIncomingDividends(
          types: types,
          startDate: startDate,
          endDate: endDate,
          sortDirection: sortDirection,
          onlyFavorites: onlyFavorites,
        );
  }

  @override
  Future<ApiResponse> getActiveSymbols() {
    return getIt<PPApi>().usEquityService.getActiveSymbols();
  }

  @override
  Future<ApiResponse> getActiveSymbolsHead() {
    return getIt<PPApi>().usEquityService.getActiveSymbolsHead();
  }

  @override
  Future<Map<String, dynamic>?> readActiveSymbolsLocal() async {
    final data = await getIt<LocalStorage>().read(LocalKeys.activeUsSymbols);
    return data != null ? Map<String, dynamic>.from(data) : null;
  }

  @override
  void writeActiveSymbolsLocal(Map<String, dynamic> symbols) {
    return getIt<LocalStorage>().write(LocalKeys.activeUsSymbols, symbols);
  }

  @override
  Future<ApiResponse> getFavoriteSymbols() {
    return getIt<PPApi>().usEquityService.getFavoriteSymbols();
  }

  @override
  Future<ApiResponse> getFavoriteSymbolsHead() {
    return getIt<PPApi>().usEquityService.getFavoriteSymbolsHead();
  }

  @override
  Future<Map<String, dynamic>?> readFavoriteSymbolsLocal() async {
    final data = await getIt<LocalStorage>().read(LocalKeys.favoriteUsSymbols);
    return data != null ? Map<String, dynamic>.from(data) : null;
  }

  @override
  void writeFavoriteSymbolsLocal(Map<String, dynamic> symbols) {
    return getIt<LocalStorage>().write(LocalKeys.favoriteUsSymbols, symbols);
  }

  @override
  Future<ApiResponse> getFractionableSymbols() {
    return getIt<PPApi>().usEquityService.getFractionableSymbols();
  }

  @override
  Future<ApiResponse> getFractionableSymbolsHead() {
    return getIt<PPApi>().usEquityService.getFractionableSymbolsHead();
  }

  @override
  Future<Map<String, dynamic>?> readFractionableSymbolsLocal() async {
    final data = await getIt<LocalStorage>().read(LocalKeys.fractionableUsSymbols);
    return data != null ? Map<String, dynamic>.from(data) : null;
  }

  @override
  void writeFractionableSymbolsLocal(Map<String, dynamic> symbols) {
    return getIt<LocalStorage>().write(LocalKeys.fractionableUsSymbols, symbols);
  }

  @override
  Future<ApiResponse> getTickerSnapshot({
    required String symbol,
  }) {
    return getIt<PPApi>().polygonService.getTickerSnapshot(symbol: symbol);
  }

  @override
  Future<ApiResponse> getTickerOverview({
    required String symbolName,
  }) {
    return getIt<PPApi>().polygonService.getTickerOverview(symbolName: symbolName);
  }

  @override
  Future<ApiResponse> getFinancialData({
    required String symbolName,
  }) {
    return getIt<PPApi>().polygonService.getFinancialData(symbol: symbolName);
  }

  @override
  Future<ApiResponse> getRelatedTickers({
    required String symbolName,
  }) {
    return getIt<PPApi>().polygonService.getRelatedTickers(symbol: symbolName);
  }

  @override
  Future<ApiResponse> getDailyTransactionInfo() {
    return getIt<PPApi>().usEquityService.getDailyTransactionInfo();
  }

  @override
  Future<ApiResponse> getUsSectors() {
    return getIt<PPApi>().usEquityService.getUsSectors();
  }

}
