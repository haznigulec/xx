import 'package:piapiri_v2/app/eurobond/repository/eurobond_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';

class EurobondRepositoryImpl extends EurobondRepository {
  @override
  Future<ApiResponse> addOrder({
    String accountId = '',
    String finInstName = '',
    String side = '',
    double amount = 0,
    double rate = 0,
    double nominal = 0,
    double unitPrice = 0,
  }) {
    return getIt<PPApi>().euroBondService.addOrder(
          accountId: accountId,
          finInstName: finInstName,
          side: side,
          amount: amount,
          rate: rate,
          nominal: nominal,
          unitPrice: unitPrice,
        );
  }

  @override
  Future<ApiResponse> deleteOrder({
    String accountId = '',
    String transactionId = '',
  }) {
    return getIt<PPApi>().euroBondService.deleteOrder(
          accountId: accountId,
          transactionId: transactionId,
        );
  }

  @override
  Future<ApiResponse> getBondDescription() {
    return getIt<PPApi>().euroBondService.getBondDescription(
        );
  }

  @override
  Future<ApiResponse> getBondLimit({
    String accountId = '',
    String finInstName = '',
    String side = '',
  }) {
    return getIt<PPApi>().euroBondService.getBondLimit(
          accountId: accountId,
          finInstName: finInstName,
          side: side,
        );
  }

  @override
  Future<ApiResponse> getBondList({
    String finInstId = '',
  }) {
    return getIt<PPApi>().euroBondService.getBondList(
          finInstId: finInstId,
        );
  }

  @override
  Future<ApiResponse> getBondAssets({
    required String accountId,
  }) {
    return getIt<PPApi>().assetsService.getAccountOverallWithsummary(
          accountId: accountId,
        );
  }

  @override
  Future<ApiResponse> validateOrder({
    String accountId = '',
    String finInstId = '',
    String side = '',
    double amount = 0,
  }) {
    return getIt<PPApi>().euroBondService.validateOrder(
          accountId: accountId,
          finInstId: finInstId,
          side: side,
          amount: amount,
        );
  }

  @override
  Future<ApiResponse> getTradeLimit() {
    return getIt<PPApi>().assetsService.getCashFlow(
          allAccounts: true,
        );
  }
}
