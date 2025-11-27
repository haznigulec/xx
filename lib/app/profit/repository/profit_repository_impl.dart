import 'package:piapiri_v2/app/profit/repository/profit_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/database/db_helper.dart';

class ProfitRepositoryImpl extends ProfitRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  Future<ApiResponse> getTaxDetailWithModel({
    required String fromDate,
    required String toDate,
  }) async {
    return getIt<PPApi>().profitService.getTaxDetailWithModel(
          fromDate: fromDate,
          toDate: toDate,
        );
  }

  @override
  Future<ApiResponse> getCustomerTarget() {
    return getIt<PPApi>().profitService.getCustomerTarget();
  }

  @override
  Future<ApiResponse> setCustomerTarget({
    required double target,
    required DateTime targetDate,
  }) async {
    return getIt<PPApi>().profitService.setCustomerTarget(
          target: target,
          targetDate: targetDate,
        );
  }

  @override
  Future<String> getFundFounderCode({
    required String code,
  }) {
    return _dbHelper.getFundFounderCode(
      code,
    );
  }

  @override
  Future<Map<String, dynamic>> getSymbolDetail({
    required String symbolCode,
  }) async {
    List<Map<String, dynamic>> selectedListItem = await _dbHelper.symbolDetails(
      symbolCode,
    );
    return selectedListItem.first;
  }

  @override
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
  }) {
    return getIt<PPApi>().assetsService.getAccountOverallWithsummary(
          isConsolidated: isConsolidated,
          selectedAccount: selectedAccount,
          date: date,
          accountId: accountId,
          allAccount: allAccount,
          getInstant: getInstant,
          overallDate: overallDate,
          includeCashFlow: includeCashFlow,
          includeCreditDetail: includeCreditDetail,
          calculateTradeLimit: calculateTradeLimit,
          includeSummary: includeSummary,
        );
  }

  @override
  Future<ApiResponse> getCapraPortfolioSummary() {
    return getIt<PPApi>().assetsService.getCapraPortfolioSummary();
  }
}
