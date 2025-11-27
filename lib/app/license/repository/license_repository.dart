import 'package:piapiri_v2/core/api/model/api_response.dart';

abstract class LicensesRepository {
  Future<ApiResponse> getLicenses();
  Future<ApiResponse> requestLicense({
    required int licenceId,
    required int requestType,
    String? startDateStr,
  });
}
