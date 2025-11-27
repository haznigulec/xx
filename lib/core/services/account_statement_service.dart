import 'package:piapiri_v2/core/api/client/api_client.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/model/user_model.dart';

class AccountStatementService {
  final ApiClient api;

  AccountStatementService(this.api);

  static const String _getaccounttransactionsUrl = '/adkcustomer/getaccounttransactions';
  static const String _sendCustomerStatement = '/adkcustomer/sendcustomerstatement';

  Future<ApiResponse> getAccountTransactions({
    String selectedAccount = '',
    int transactionType = 0,
    String startDate = '',
    String endDate = '',
  }) async {
    return api.post(
      _getaccounttransactionsUrl,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'accountExtId': selectedAccount == 'tum_hesaplar' ? '' : selectedAccount.split('-')[1],
        'TransactionType': transactionType,
        'StartDate': startDate,
        'EndDate': endDate,
      },
    );
  }

  Future<ApiResponse> sendCustomerStatement({
    String accountId = '',
    int? transactionType,
    String startDate = '',
    String endDate = '',
  }) async {
    return api.post(
      _sendCustomerStatement,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'AccountExtId': accountId,
        'TransactionType': transactionType,
        'StartDate': startDate,
        'EndDate': endDate,
      },
    );
  }
}
