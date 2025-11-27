import 'package:piapiri_v2/core/api/model/api_response.dart';

abstract class ProfileReferanceRepository {
  Future<ApiResponse> getReferenceCode();
  Future<ApiResponse> getApplicationSettingsByKeyAndCustomerExtId({
    bool checkBudyReferanceCode = false,
    String? budyReferanceCode,
  });
}
