import 'package:piapiri_v2/core/api/model/api_response.dart';

abstract class ReportsRepository {
  Future<ApiResponse> getReports({
    required bool showAnalysis,
    required bool showReport,
    required bool showPodcast,
    required bool showVideoComment,
    required bool youtubeVideo,
    required String language,
    required String mainGroup,
    DateTime? startDate,
    DateTime? endDate,
    String? deviceId,
  });
}
