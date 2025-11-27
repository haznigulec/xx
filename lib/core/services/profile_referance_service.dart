import 'package:piapiri_v2/core/api/client/api_client.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/model/user_model.dart';

class ProfileReferanceService {
  final ApiClient api;

  ProfileReferanceService(this.api);

  static const String _getReferenceCode = '/adkcustomer/getreferencecode';
  static const String _updateApplicationSettingsByCustomerIdUrl =
      '/usersettings/updateapplicationsettingsbycustomerextid';
  static const String _getApplicationSettingsByKeyAndCustomerExtid =
      '/usersettings/getapplicationsettingsbykeyandcustomerextid';

  Future<ApiResponse> getReferenceCode() {
    return api.post(
      _getReferenceCode,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
      },
    );
  }

  Future<ApiResponse> getApplicationSettingsByKeyAndCustomerExtId({
    bool checkBudyReferanceCode = false,
    String? budyReferanceCode,
  }) {
    final Map<String, dynamic> body = {
      'customerExtId': UserModel.instance.customerId,
    };
    if (budyReferanceCode == null) {
      body['key'] = checkBudyReferanceCode ? "buddy_reference_code" : "my_reference_code";
    } else {
      body['settings'] = [
        {
          "key": "buddy_reference_code",
          "value": budyReferanceCode,
          "order": 0,
        }
      ];
    }
    return api.post(
      budyReferanceCode != null
          ? _updateApplicationSettingsByCustomerIdUrl
          : _getApplicationSettingsByKeyAndCustomerExtid,
      tokenized: true,
      body: body,
    );
  }
}
