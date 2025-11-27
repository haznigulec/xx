import 'package:piapiri_v2/app/stage_analysis/repository/stage_analysis_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';

class StageAnalysisRepositoryImpl extends StageAnalysisRepository {
  @override
  Future<ApiResponse> stageAnalysisData({
    required String symbol,
  }) {
    return getIt<PPApi>().stageAnalysisService.stageAnalysisData(
          symbol: symbol,
        );
  }
}
