import 'package:piapiri_v2/core/api/model/api_response.dart';

abstract class EducationRepository {
  Future<ApiResponse> getEducation();
}
