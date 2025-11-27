import 'package:piapiri_v2/app/fund/repository/fund_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/database/db_helper.dart';
import 'package:piapiri_v2/core/model/fund_order_action.dart';

class FundRepositoryImpl extends FundRepository {
  DatabaseHelper dbHelper = DatabaseHelper();

  @override
  Future<ApiResponse> getFundPriceGraph({
    required String fundCode,
    required String startDate,
    required String endDate,
    required String period,
  }) async {
    return getIt<PPApi>().fundService.getFundPriceGraph(
          fundCode: fundCode,
          startDate: startDate,
          endDate: endDate,
          period: period,
        );
  }

  @override
  Future<ApiResponse> getFundVolumeHistory({
    String? fundCode = '',
  }) async {
    return getIt<PPApi>().fundService.getFundVolumeHistory(
          fundCode: fundCode,
        );
  }

  @override
  Future<ApiResponse> getFinancialInstutionList({
    String? founderCode,
    String? subTypeCode,
    int? fundTitleTypeCode,
    int? tefasStatus,
    String? mainTypeCode,
    int? applicationCategoryId,
    int? themeId,
  }) async {
    return getIt<PPApi>().fundService.getFinancialInstutionList(
          founderCode: founderCode,
          subTypeCode: subTypeCode,
          fundTitleTypeCode: fundTitleTypeCode,
          tefasStatus: tefasStatus,
          mainTypeCode: mainTypeCode,
          applicationCategoryId: applicationCategoryId,
          themeId: themeId,
        );
  }

  @override
  Future<ApiResponse> getFundDetails({
    required String fundCode,
  }) async {
    return getIt<PPApi>().fundService.getFundDetails(
          fundCode: fundCode,
        );
  }

  @override
  Future<ApiResponse> getFundInfo({
    required String accountId,
    required String fundCode,
    required String buySell,
  }) async {
    return getIt<PPApi>().fundService.getFundInfo(
          accountId: accountId,
          fundCode: fundCode,
          buySell: buySell,
        );
  }

  @override
  Future<ApiResponse> newOrder({
    required String accountId,
    required String fundCode,
    required double price,
    required int unit,
    required double amount,
    required FundOrderActionEnum orderActionType,
    required String valorDate,
    required String baseType,
  }) async {
    return getIt<PPApi>().fundService.newOrder(
          accountId: accountId,
          fundCode: fundCode,
          price: price,
          unit: unit,
          amount: amount,
          orderActionType: orderActionType,
          valorDate: valorDate,
          baseType: baseType,
        );
  }

  @override
  Future<ApiResponse> getFundsByProfit({
    String startDate = '',
    String endDate = '',
  }) async {
    return getIt<PPApi>().fundService.getFundsByProfit(
          startDate: startDate,
          endDate: endDate,
        );
  }

  @override
  Future<ApiResponse> getFundsByManagementFee() async {
    return getIt<PPApi>().fundService.getFundsByManagementFee();
  }

  @override
  Future<ApiResponse> getFundsByPortfolioSize() async {
    return getIt<PPApi>().fundService.getFundsByPortfolioSize();
  }

  @override
  Future<ApiResponse> getFinancialFounderList(String? institutionCode) async {
    return getIt<PPApi>().fundService.getFinancialFounderList(
          institutionCode: institutionCode ?? '',
        );
  }

  @override
  Future<ApiResponse> getFundPerformanceRanking() async {
    return getIt<PPApi>().fundService.getFundPerformanceRanking();
  }

  @override
  Future<ApiResponse> getFilterAndSortFunds({
    String? institutionCode,
    int startIndex = 1,
    int count = 50,
  }) async {
    return getIt<PPApi>().fundService.getFilterAndSortFunds(
          institutionCode: institutionCode ?? '',
          startIndex: startIndex,
          count: count,
        );
  }

  @override
  Future<ApiResponse> newBulkOrder({
    required List<Map<String, dynamic>> funds,
    required String account,
  }) async {
    return getIt<PPApi>().fundService.newBulkOrder(
          funds: funds,
          account: account,
        );
  }

  @override
  Future<List<Map<String, dynamic>>> getSubTypes({
    required String founder,
    required String mainType,
    required String tefasStatus,
  }) async {
    List<Map<String, dynamic>> subTypes = await dbHelper.getSubTypes(
      founder,
      mainType,
      tefasStatus,
    );
    return subTypes;
  }

  @override
  Future<List<Map<String, dynamic>>> getInstitutions() async {
    var institutions = await dbHelper.getInstitutions();
    return institutions;
  }

  @override
  Future<List<Map<String, dynamic>>> getFundTitleTypes({
    required String founder,
    required String mainType,
    required String tefasStatus,
    required String subType,
  }) async {
    List<Map<String, dynamic>> fundTitles = await dbHelper.getFundTitleTypes(
      founder,
      mainType,
      tefasStatus,
      subType,
    );
    return fundTitles;
  }

  @override
  Future<ApiResponse> getFundApplicationCategories() {
    return getIt<PPApi>().fundService.getFundApplicationCategories();
  }

  @override
  Future<ApiResponse> getCurrencyRatios({
    required String currency,
  }) {
    return getIt<PPApi>().currencyBuySellService.getCurrencyRatios(
          currency: currency,
        );
  }

  @override
  Future<ApiResponse> getFundPrice({
    required String fundCode,
  }) {
    return getIt<PPApi>().fundService.getFundPrice(
          fundCode: fundCode,
        );
  }

  @override
  Future<ApiResponse> getAllFundThemes() {
    return getIt<PPApi>().fundService.getAllFundThemes();
  }
}
