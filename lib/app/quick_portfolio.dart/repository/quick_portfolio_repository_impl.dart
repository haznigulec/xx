import 'package:piapiri_v2/app/quick_portfolio.dart/repository/quick_portfolio_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/database/db_helper.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';

class QuickPortfolioRepositoryImpl extends QuickPortfolioRepository {
  DatabaseHelper dbHelper = DatabaseHelper();
  @override
  Future<ApiResponse> getRoboticBaskets(
    int portfolioId,
  ) async {
    return getIt<PPApi>().quickPortfolioService.getRoboticBaskets(
          portfolioId,
        );
  }

  @override
  Future<ApiResponse> getModelPortfolio({required String languageCode}) async {
    return getIt<PPApi>().quickPortfolioService.getModelPortfolio(
          languageCode: languageCode,
        );
  }

  @override
  Future<ApiResponse> getById({
    required int id,
    required String languageCode,
  }) async {
    return getIt<PPApi>().quickPortfolioService.getById(
          id: id,
          languageCode: languageCode,
        );
  }

  @override
  Future<ApiResponse> getPreparedPortfolios({
    required String porfolioKey,
    required String languageCode,
  }) async {
    return getIt<PPApi>().quickPortfolioService.getPreparedPortfolios(
          porfolioKey: porfolioKey,
          languageCode: languageCode,
        );
  }

  @override
  Future<ApiResponse> getSpecificList({
    required String mainGroup,
  }) async {
    return getIt<PPApi>().quickPortfolioService.getSpecificList(
          mainGroup: mainGroup,
        );
  }

  @override
  Future<ApiResponse> getFundInfoFromSpecialListById({
    required String specialListId,
  }) async {
    return getIt<PPApi>().quickPortfolioService.getFundInfoFromSpecialListById(
          specialListId: specialListId,
        );
  }

  @override
  Future<List<Map<String, dynamic>>> getDetailsOfSymbols({
    required List<dynamic> symbols,
  }) async {
    return await dbHelper.getDetailsOfSymbols(symbols);
  }

  @override
  Future<String> getFundFounderCode({
    required String code,
  }) async {
    return await dbHelper.getFundFounderCode(code);
  }

  @override
  Future<List<MarketListModel>> fetchSymbolDetails(List<String> codes) async {
    final symbolData = await getDetailsOfSymbols(symbols: codes.toSet().toList());
    return symbolData.map((symbol) {
      return MarketListModel(
        symbolCode: symbol['Name'],
        updateDate: '',
        type: symbol['TypeCode'],
        underlying: symbol['UnderlyingName'] ?? '',
        optionClass: symbol['OptionClass'] ?? '',
        optionType: symbol['OptionType'] ?? '',
        multiplier: symbol['Multiplier'] ?? 1,
        description: symbol['Description'] ?? '',
        maturity: symbol['MaturityDate'] ?? '',
        marketCode: symbol['MarketCode'] ?? '',
        swapType: symbol['SwapType'] ?? '',
        actionType: symbol['ActionType'] ?? '',
        issuer: symbol['Issuer'] ?? '',
      );
    }).toList();
  }

  @override
  Future<List<String>> fetchFundFounderCodes(List<String> codes) async {
    final List<String> results = [];
    for (final code in codes) {
      final founderCode = await getFundFounderCode(code: code);
      results.add(founderCode);
    }
    return results;
  }
}
