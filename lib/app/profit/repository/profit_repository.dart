import 'package:piapiri_v2/core/api/model/api_response.dart';

abstract class ProfitRepository {
  Future<ApiResponse> getTaxDetailWithModel({
    required String fromDate,
    required String toDate,
  });

  Future<ApiResponse> getCustomerTarget();

  Future<ApiResponse> setCustomerTarget({
    required double target,
    required DateTime targetDate,
  });

  Future<String> getFundFounderCode({
    required String code,
  });

  Future<Map<String, dynamic>> getSymbolDetail({
    required String symbolCode,
  });

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

  Future<ApiResponse> getCapraPortfolioSummary();
}
