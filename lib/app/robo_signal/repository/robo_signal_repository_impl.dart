import 'package:piapiri_v2/app/robo_signal/repository/robo_signal_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';

class RoboSignalRepositoryImpl extends RoboSignalRepository {
  @override
  Future<ApiResponse> getRoboSignals() {
    return getIt<PPApi>().roboSignalService.getRoboSignals();
  }
}
