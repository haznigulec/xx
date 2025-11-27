import 'package:piapiri_v2/core/api/client/api_client.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/model/user_model.dart';

class ProfitService {
  final ApiClient api;

  ProfitService(this.api);

  static const String _getTaxDetail = '/adkcustomer/getTaxDetail';
  static const String _getCustomerTarget = '/adkcustomer/getcustomertarget';
  static const String _setCustomerTargetUrl = '/adkcustomer/setcustomertarget';

  Future<ApiResponse> getTaxDetailWithModel({
    required String fromDate,
    required String toDate,
  }) async {
    return api.post(
      _getTaxDetail,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'startDate': fromDate,
        'endDate': toDate,
      },
    );
  }

  Future<ApiResponse> getCustomerTarget() {
    return api.post(
      _getCustomerTarget,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
      },
    );
  }

  Future<ApiResponse> setCustomerTarget({
    required double target,
    required DateTime targetDate,
  }) async {
    return api.post(
      _setCustomerTargetUrl,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'target': target,
        'targetDate': targetDate.toString().replaceAll(' ', 'T'),
      },
    );
  }
}
