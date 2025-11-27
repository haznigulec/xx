import 'package:piapiri_v2/core/api/model/api_response.dart';

abstract class UsBalanceRepository {
  Future<ApiResponse> getInstantCashAmount({
    required String accountId,
  });

  Future<ApiResponse> balanceTransfer({
    required String accountId,
    required String amount,
    required int collateralType,
  });
}
