import 'package:piapiri_v2/core/api/model/api_response.dart';

abstract class CurrencyBuySellRepository {
  Future<ApiResponse> getCurrencyRatios({
    required String currency,
  });

  Future<ApiResponse> getTradeLimit({
    String accountId = '',
    String typeName = '',
  });

  Future<ApiResponse> getSystemParameters();

  Future<ApiResponse> getInstantCashAmount({
    required String accountId,
    required String finInstName,
  });

  Future<ApiResponse> fcBuySell({
    String debitCredit = '',
    String tlAccountId = '',
    String accountId = '',
    String finInstName = '',
    double amount = 0,
    double exchangeRate = 0,
  });
}
