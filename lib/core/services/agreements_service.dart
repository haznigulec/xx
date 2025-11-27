import 'package:piapiri_v2/core/api/client/api_client.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/model/user_model.dart';

class AgreementsService {
  final ApiClient api;

  AgreementsService(this.api);

  static const String getMissingAgreementsPeriods = '/adkreconciliation/GetMissingReconciliationPeriods';
  static const String setAgreements = '/adkreconciliation/SetReconciliation';

  Future<ApiResponse> getReconciliation({
    String date = '',
  }) async {
    return api.post(
      getMissingAgreementsPeriods,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'AccountExtId': '',
        'date': date,
      },
    );
  }

  Future<ApiResponse> setReconciliation({
    String customerId = '',
    String accountId = '',
    String agreementPeriodId = '',
    String agreementPortfolioDate = '',
    String clientIp = '',
  }) async {
    return api.post(
      setAgreements,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'AccountExtId': accountId,
        'AgreementPortfolioDate': agreementPortfolioDate,
        'ClientIp': clientIp,
        'Accepted': true,
        'RefuseDescription': '',
        'AgreementPeriodId': agreementPeriodId,
      },
    );
  }
}
