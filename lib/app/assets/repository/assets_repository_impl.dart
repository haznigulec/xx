import 'package:piapiri_v2/app/assets/repository/assets_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/database/db_helper.dart';

class AssetsRepositoryImpl implements AssetsRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

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
  Future<ApiResponse> getCashFlow({
    String accountId = '',
    bool allAccounts = false,
  }) {
    return getIt<PPApi>().assetsService.getCashFlow(
          accountId: accountId,
          allAccounts: allAccounts,
        );
  }

  @override
  Future<ApiResponse> getCollateralInfo({
    String accountId = '',
  }) {
    return getIt<PPApi>().assetsService.getCollateralInfo(
          accountId: accountId,
        );
  }

  @override
  Future<ApiResponse> getTradeLimit({
    String accountId = '',
    String? typeName,
  }) {
    return getIt<PPApi>().assetsService.getTradeLimit(
          accountId: accountId,
          typeName: typeName,
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
  Future<Map<String, dynamic>?> getSymbolDetail({
    required String symbolCode,
  }) async {
    List<Map<String, dynamic>>? selectedListItem = await _dbHelper.symbolDetails(
      symbolCode,
    );
    return selectedListItem.isNotEmpty ? selectedListItem.first : null;
  }

  @override
  Future<ApiResponse> getCapraPortfolioSummary() {
    return getIt<PPApi>().assetsService.getCapraPortfolioSummary();
  }

  @override
  Future<ApiResponse> getCapraCollateralInfo() {
    return getIt<PPApi>().assetsService.getCapraCollateralInfo();
  }
}
