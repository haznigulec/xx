import 'package:piapiri_v2/app/us_balance/repository/us_balance_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';

class UsBalanceRepositoryImpl implements UsBalanceRepository {
  @override
  Future<ApiResponse> getInstantCashAmount({
    required String accountId,
  }) {
    return getIt<PPApi>().usBalanceService.getInstantCashAmount(
          accountId: accountId,
          finInstName: 'USD',
        );
  }

  @override
  Future<ApiResponse> balanceTransfer({
    required String accountId,
    required String amount,
    required int collateralType,
  }) {
    return getIt<PPApi>().usBalanceService.balanceTransfer(
          accountId: accountId,
          amount: amount,
          collateralType: collateralType,
        );
  }
}
