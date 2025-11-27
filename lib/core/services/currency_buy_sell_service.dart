import 'package:piapiri_v2/core/api/client/api_client.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/model/user_model.dart';

class CurrencyBuySellService {
  final ApiClient api;

  CurrencyBuySellService(this.api);

  static const String _getCurrencyRatios = '/AdkCash/GetCurrencyRatios';
  static const String _getSystemParameters = '/adkcustomer/getsystemparameters';
  static const String _fcBuySell = '/AdkCash/fcbuysell';

  Future<ApiResponse> getCurrencyRatios({
    String currency = '',
  }) async {
    return api.post(
      _getCurrencyRatios,
      tokenized: true,
      body: {
        'CustomerExtId': UserModel.instance.customerId,
        'CurrencyName': currency,
      },
    );
  }

  Future<ApiResponse> getSystemParameters() async {
    return api.post(
      _getSystemParameters,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
      },
    );
  }

  Future<ApiResponse> fcBuySell({
    String debitCredit = '',
    String tlAccountId = '',
    String accountId = '',
    String finInstName = '',
    double amount = 0,
    double exchangeRate = 0,
  }) async {
    return api.post(
      _fcBuySell,
      tokenized: true,
      body: {
        'CustomerExtId': UserModel.instance.customerId,
        'TLAccountExtId': tlAccountId,
        'AccountExtId': accountId,
        'FinInstName': finInstName,
        'DebitCredit': debitCredit,
        'Amount': amount,
        'ValueDate': DateTime.now().toIso8601String(),
        'exchangeRate': exchangeRate,
      },
    );
  }
}
