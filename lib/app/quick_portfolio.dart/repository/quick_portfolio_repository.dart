import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';

abstract class QuickPortfolioRepository {
  Future<ApiResponse> getModelPortfolio({
    required String languageCode,
  });

  Future<ApiResponse> getRoboticBaskets(
    int portfolioId,
  );
  Future<ApiResponse> getPreparedPortfolios({
    required String porfolioKey,
    required String languageCode,
  });

  Future<ApiResponse> getSpecificList({
    required String mainGroup,
  });

  Future<ApiResponse> getById({
    required int id,
    required String languageCode,
  });

  Future<ApiResponse> getFundInfoFromSpecialListById({
    required String specialListId,
  });

  Future<List<Map<String, dynamic>>> getDetailsOfSymbols({
    required List<dynamic> symbols,
  });

  Future<String> getFundFounderCode({
    required String code,
  });

  Future<List<MarketListModel>> fetchSymbolDetails(
    List<String> codes,
  );
  Future<List<String>> fetchFundFounderCodes(
    List<String> codes,
  );
}
