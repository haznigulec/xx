import 'package:piapiri_v2/app/license/repository/license_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';

class LicensesRepositoryImpl extends LicensesRepository {
  @override
  Future<ApiResponse> getLicenses() {
    return getIt<PPApi>().licensesService.getAllLicences();
  }

  @override
  Future<ApiResponse> requestLicense({
    required int licenceId,
    required int requestType,
    String? startDateStr,
  }) {
    return getIt<PPApi>().licensesService.requestLicence(
          licenceId: licenceId,
          requestType: requestType,
          startDateStr: startDateStr,
        );
  }
}
