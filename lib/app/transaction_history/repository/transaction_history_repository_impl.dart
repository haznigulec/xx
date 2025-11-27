import 'package:piapiri_v2/app/transaction_history/repository/transaction_history_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';

class TransactionHistoryRepositoryImpl extends TransactionHistoryRepository {
  @override
  Future<ApiResponse> getTransactionHistory({
    required String listType,
    required String side,
    required String startDate,
    required String endDate,
    required String finInstName,
    required String accountId,
  }) {
    return getIt<PPApi>().transactionHistoryService.getTransactionHistory(
          listType: listType,
          side: side,
          startDate: startDate,
          endDate: endDate,
          finInstName: finInstName,
          accountId: accountId,
        );
  }

  @override
  Future<ApiResponse> getCapraTransactionHistory({
    String side = '',
    String symbol = '',
    String until = '',
    String after = '',
  }) {
    return getIt<PPApi>().transactionHistoryService.getCapraTransactionHistory(
          side: side,
          symbol: symbol,
          until: until,
          after: after,
        );
  }
}
