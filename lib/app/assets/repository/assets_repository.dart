import 'package:piapiri_v2/core/api/model/api_response.dart';

abstract class AssetsRepository {
  Future<ApiResponse> getAccountOverallWithsummary({
    bool isConsolidated = true,
    String selectedAccount = '',
    String date = '',
    required String accountId,
    bool allAccount = false,
    bool getInstant = true,
    String? overallDate,
    bool includeCashFlow = false,
    bool includeCreditDetail = false,
    bool calculateTradeLimit = false,
    bool? includeSummary,
  });

  Future<ApiResponse> getCashFlow({
    String accountId = '',
    bool allAccounts = false,
  });

  Future<ApiResponse> getCollateralInfo({
    String accountId = '',
  });

  Future<ApiResponse> getTradeLimit({
    String accountId = '',
    String? typeName,
  });

  Future<String> getFundFounderCode({
    required String code,
  });

  Future<Map<String, dynamic>?> getSymbolDetail({
    required String symbolCode,
  });

  Future<ApiResponse> getCapraPortfolioSummary();

  Future<ApiResponse> getCapraCollateralInfo();
}
