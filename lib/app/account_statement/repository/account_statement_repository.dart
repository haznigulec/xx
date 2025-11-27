import 'package:piapiri_v2/core/api/model/api_response.dart';

abstract class AccountStatementRepository {
  Future<ApiResponse> getAccountTransactions({
    required String selectedAccount,
    required int transactionType,
    required String startDate,
    required String endDate,
  });

  Future<ApiResponse> sendCustomerStatement({
    String accountId = '',
    int? transactionType,
    String startDate = '',
    String endDate = '',
  });
}
