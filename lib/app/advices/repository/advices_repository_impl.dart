import 'package:piapiri_v2/app/advices/repository/advices_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';

class AdvicesRepositoryImpl extends AdvicesRepository {
  @override
  Future<ApiResponse> getAdvices({
    String mainGroup = '',
    required String languageCode,
  }) {
    return getIt<PPApi>().advicesService.getAdvices(
          mainGroup: mainGroup,
          languageCode: languageCode,
        );
  }

  @override
  Future<ApiResponse> getAdvicesHistory({
    required String mainGroup,
    required int year,
  }) {
    return getIt<PPApi>().advicesService.getAdviceHistory(
          mainGroup: mainGroup,
          year: year,
        );
  }

  @override
  Future<ApiResponse> getRoboSignals() {
    return getIt<PPApi>().roboSignalService.getRoboSignals();
  }
}
