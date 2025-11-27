import 'package:piapiri_v2/core/api/client/api_client.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/model/user_model.dart';

class UsBalanceService {
  final ApiClient api;

  UsBalanceService(this.api);

  static const String _getInstantCashAmount = '/AdkCash/getinstantcashamount';
  static const String _balanceTransfer = '/Capra/balancetransfer';

  Future<ApiResponse> getInstantCashAmount({
    required String accountId,
    required String finInstName,
  }) async {
    return api.post(
      _getInstantCashAmount,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'accountExtId': accountId,
        'finInstName': finInstName,
      },
    );
  }

  Future<ApiResponse> balanceTransfer({
    required String accountId,
    required String amount,
    required int collateralType,
  }) async {
    return api.post(
      _balanceTransfer,
      tokenized: true,
      body: {
        'customerextid': UserModel.instance.customerId,
        'accountextid': accountId,
        'amount': amount.replaceAll(',', '.'),
        'currency': 'USD',
        'type': collateralType,
        'description': collateralType == 0
            ? '${UserModel.instance.customerId}-$accountId / Bakiye Yatırma'
            : '${UserModel.instance.customerId}-$accountId / Bakiye Çekme',
      },
    );
  }
}
