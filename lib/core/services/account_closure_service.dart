import 'package:piapiri_v2/core/api/client/api_client.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/model/user_model.dart';

class AccountClosureService {
  final ApiClient api;

  AccountClosureService(this.api);

  static const String _accountClosureUrl = '/adkcustomer/accountclosure';
  static const String _accountClosureStatusUrl = '/adkcustomer/getaccountclosurestatus';

  Future<ApiResponse> accountClosure({
    String customerId = '',
  }) async {
    return api.post(
      _accountClosureUrl,
      tokenized: true,
      body: {
        'customerExtId': customerId,
      },
    );
  }

  Future<ApiResponse> getAccountClosureStatus() async {
    return api.post(
      _accountClosureStatusUrl,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
      },
    );
  }
}
