import 'package:piapiri_v2/core/api/model/api_response.dart';

abstract class RoboSignalRepository {
  Future<ApiResponse> getRoboSignals();
}
