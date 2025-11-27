import 'package:piapiri_v2/app/market_reviews/repository/reports_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';

class ReportsRepositoryImpl extends ReportsRepository {
  @override
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
    String? customerId,
  }) {
    return getIt<PPApi>().reportsService.getAllReports(
          mainGroup: mainGroup,
          showAnalysis: showAnalysis,
          showReport: showReport,
          showPodcast: showPodcast,
          showVideoComment: showVideoComment,
          youtubeVideo: youtubeVideo,
          language: language,
          startDate: startDate,
          endDate: endDate,
          deviceId: deviceId,
        );
  }
}
