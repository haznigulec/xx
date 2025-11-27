import 'package:piapiri_v2/core/api/client/api_client.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/model/user_model.dart';

class LicensesService {
  final ApiClient api;

  LicensesService(this.api);

  static const String _getAllLicencesUrl = '/licence/getall';
  static const String _requestLicenceUrl = '/licence/requestlicence';

  Future<ApiResponse> getAllLicences() {
    return api.post(
      _getAllLicencesUrl,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
      },
    );
  }

  Future<ApiResponse> requestLicence({
    required int licenceId,
    required int requestType,
    String? startDateStr,
  }) async {
    return api.post(
      _requestLicenceUrl,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'licenceId': licenceId,
        'dataLicenceRequestType': requestType,
        'StartDateStr': startDateStr,
      },
    );
  }
}
