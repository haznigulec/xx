import 'package:piapiri_v2/app/account_statement/repository/account_statement_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';

class AccountStatementRepositoryImpl extends AccountStatementRepository {
  @override
  Future<ApiResponse> getAccountTransactions({
    required String selectedAccount,
    required int transactionType,
    required String startDate,
    required String endDate,
  }) {
    return getIt<PPApi>().accountStatementService.getAccountTransactions(
          selectedAccount: selectedAccount,
          transactionType: transactionType,
          startDate: startDate,
          endDate: endDate,
        );
  }

  @override
  Future<ApiResponse> sendCustomerStatement({
    String accountId = '',
    int? transactionType,
    String startDate = '',
    String endDate = '',
  }) {
    return getIt<PPApi>().accountStatementService.sendCustomerStatement(
          accountId: accountId,
          transactionType: transactionType,
          startDate: startDate,
          endDate: endDate,
        );
  }
}
