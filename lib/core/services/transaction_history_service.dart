import 'package:piapiri_v2/core/api/client/api_client.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/model/user_model.dart';

class TransactionHistoryService {
  final ApiClient api;
  TransactionHistoryService(this.api);

  static const String _getDailyTransactionsUrl = '/adkcustomer/getaccountdailytransactions';
  static const String _getCapraTransactionHistory = '/Capra/gettransactionhistory';

  Future<ApiResponse> getTransactionHistory({
    required String listType,
    required String side,
    required String startDate,
    required String endDate,
    required String finInstName,
    required String accountId,
  }) async {
    return api.post(
      _getDailyTransactionsUrl,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'AccountExtId': accountId,
        'OrderStatus': 'ALL',
        'ListType': listType,
        'Side': side,
        'FirstDate': startDate,
        'LastDate': endDate,
        'FinInstName': finInstName,
        'MinimumPrice': null,
        'MaximumPrice': null,
      },
    );
  }

  Future<ApiResponse> getCapraTransactionHistory({
    String side = '',
    String symbol = '',
    String until = '',
    String after = '',
  }) async {
    return api.post(
      _getCapraTransactionHistory,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'side': side,
        'symbol': symbol,
        'until': '${until}Z',
        'after': '${after}Z',
      },
    );
  }
}
