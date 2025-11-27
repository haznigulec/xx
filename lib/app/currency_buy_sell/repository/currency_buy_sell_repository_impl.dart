import 'package:piapiri_v2/app/currency_buy_sell/repository/currency_buy_sell_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';

class CurrencyBuySellRepositoryImpl implements CurrencyBuySellRepository {
  @override
  Future<ApiResponse> getCurrencyRatios({
    required String currency,
  }) {
    return getIt<PPApi>().currencyBuySellService.getCurrencyRatios(
          currency: currency,
        );
  }

  @override
  Future<ApiResponse> getTradeLimit({
    String accountId = '',
    String typeName = '',
  }) {
    return getIt<PPApi>().moneyTransferService.getTradeLimit(
          accountId: accountId,
          typeName: typeName,
        );
  }

  @override
  Future<ApiResponse> getSystemParameters() {
    return getIt<PPApi>().currencyBuySellService.getSystemParameters();
  }

  @override
  Future<ApiResponse> getInstantCashAmount({
    required String accountId,
    required String finInstName,
  }) {
    return getIt<PPApi>().usBalanceService.getInstantCashAmount(
          accountId: accountId,
          finInstName: finInstName,
        );
  }

  @override
  Future<ApiResponse> fcBuySell({
    String debitCredit = '',
    String tlAccountId = '',
    String accountId = '',
    String finInstName = '',
    double amount = 0,
    double exchangeRate = 0,
  }) {
    return getIt<PPApi>().currencyBuySellService.fcBuySell(
          debitCredit: debitCredit,
          tlAccountId: tlAccountId,
          accountId: accountId,
          finInstName: finInstName,
          amount: amount,
          exchangeRate: exchangeRate,
        );
  }
}
