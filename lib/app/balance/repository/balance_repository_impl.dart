import 'package:piapiri_v2/app/balance/repository/balance_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';

class BalanceRepositoryImpl extends BalanceRepository {
  @override
  Future<ApiResponse> getBalanceYearInfo({
    required String symbolName,
  }) {
    return getIt<PPApi>().balanceService.getBalanceYearInfo(
          symbolName: symbolName,
        );
  }

  @override
  Future<ApiResponse> getBalance({
    required String symbolName,
    required String period,
  }) {
    return getIt<PPApi>().balanceService.getBalance(
          symbolName: symbolName,
          period: period,
        );
  }
}
