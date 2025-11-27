import 'package:piapiri_v2/app/pivot_analysis/repository/pivot_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';

class PivotRepositoryImpl extends PivotRepository {
  @override
  Future<ApiResponse> getPivotAnalysis({
    required String symbolName,
    required String url,
  }) {
    return getIt<PPApi>().pivotAnalysisService.getPivotAnalysis(
          symbolName: symbolName,
          url: url,
        );
  }
}
