import 'package:piapiri_v2/core/api/model/api_response.dart';

abstract class TransactionHistoryRepository {
  Future<ApiResponse> getTransactionHistory({
    required String listType,
    required String side,
    required String startDate,
    required String endDate,
    required String finInstName,
    required String accountId,
  });

  Future<ApiResponse> getCapraTransactionHistory({
    String side = '',
    String symbol = '',
    String until = '',
    String after = '',
  });
}
