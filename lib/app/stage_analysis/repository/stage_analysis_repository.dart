import 'package:piapiri_v2/core/api/model/api_response.dart';

abstract class StageAnalysisRepository {
  Future<ApiResponse> stageAnalysisData({
    required String symbol,
  });
}
