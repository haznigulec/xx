import 'package:piapiri_v2/core/api/model/api_response.dart';

abstract class AdvicesRepository {
  Future<ApiResponse> getAdvices({
    required String mainGroup,
    required String languageCode,
  });
  Future<ApiResponse> getAdvicesHistory({
    required String mainGroup,
    required int year,
  });
  Future<ApiResponse> getRoboSignals();
}
