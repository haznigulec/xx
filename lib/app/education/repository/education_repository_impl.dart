import 'package:piapiri_v2/app/education/repository/education_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';

class EducationRepositoryImpl extends EducationRepository {
  @override
  Future<ApiResponse> getEducation() async {
    return getIt<PPApi>().educationService.getAllEducations();
  }
}
