import 'package:piapiri_v2/app/profile/repository/profile_referance_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';

class ProfileReferanceRepositoryImpl extends ProfileReferanceRepository {
  @override
  Future<ApiResponse> getReferenceCode() {
    return getIt<PPApi>().profileReferanceService.getReferenceCode();
  }

  @override
  Future<ApiResponse> getApplicationSettingsByKeyAndCustomerExtId({
    bool checkBudyReferanceCode = false,
    String? budyReferanceCode,
  }) {
    return getIt<PPApi>().profileReferanceService.getApplicationSettingsByKeyAndCustomerExtId(
          checkBudyReferanceCode: checkBudyReferanceCode,
          budyReferanceCode: budyReferanceCode,
        );
  }
}
