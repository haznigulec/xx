import 'package:piapiri_v2/app/income/repository/income_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';

class IncomeRepositoryImpl extends IncomeRepository {
  @override
  Future<ApiResponse> getBalanceYearInfo({
    required String symbolName,
  }) {
    return getIt<PPApi>().balanceService.getBalanceYearInfo(
          symbolName: symbolName,
        );
  }

  @override
  Future getBalance({
    required String symbolName,
    required String period,
  }) {
    return getIt<PPApi>().incomeService.getIncome(
          symbolName: symbolName,
          period: period,
        );
  }
}
