import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/model/fund_order_action.dart';

abstract class FundRepository {
  Future<ApiResponse> getFinancialInstutionList({
    String? founderCode,
    String? subTypeCode,
    int? fundTitleTypeCode,
    int? tefasStatus,
    String? mainTypeCode,
    int? applicationCategoryId,
    int? themeId,
  });

  Future<ApiResponse> getFundPriceGraph({
    required String fundCode,
    required String startDate,
    required String endDate,
    required String period,
  });

  Future<ApiResponse> getFundDetails({
    required String fundCode,
  });

  Future<ApiResponse> getFundInfo({
    required String accountId,
    required String fundCode,
    required String buySell,
  });

  Future<ApiResponse> getFundVolumeHistory({
    required String fundCode,
  });

  Future<ApiResponse> newOrder({
    required String accountId,
    required String fundCode,
    required double price,
    required int unit,
    required double amount,
    required FundOrderActionEnum orderActionType,
    required String valorDate,
    required String baseType,
  });

  Future<ApiResponse> getFundsByProfit({
    String startDate = '',
    String endDate = '',
  });

  Future<ApiResponse> getFundsByManagementFee();

  Future<ApiResponse> getFundsByPortfolioSize();

  Future<ApiResponse> getFundPerformanceRanking();

  Future<ApiResponse> getFinancialFounderList(
    String? institutionCode,
  );

  Future<ApiResponse> getFilterAndSortFunds({
    String? institutionCode,
    int startIndex = 1,
    int count = 50,
  });

  Future<ApiResponse> newBulkOrder({
    required List<Map<String, dynamic>> funds,
    required String account,
  });

  Future<List<Map<String, dynamic>>> getSubTypes({
    required String founder,
    required String mainType,
    required String tefasStatus,
  });

  Future<List<Map<String, dynamic>>> getInstitutions();

  Future<ApiResponse> getFundApplicationCategories();

  Future<List<Map<String, dynamic>>> getFundTitleTypes({
    required String founder,
    required String mainType,
    required String tefasStatus,
    required String subType,
  });

  Future<ApiResponse> getCurrencyRatios({
    required String currency,
  });

  Future<ApiResponse> getFundPrice({
    required String fundCode,
  });

  Future<ApiResponse> getAllFundThemes();
}
