import 'package:p_core/extensions/date_time_extensions.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/core/api/client/api_client.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/user_model.dart';

class ReportsService {
  final ApiClient api;

  ReportsService(this.api);

  static const String _getAllContentByCustomerIdUrl = '/cmscontent/getallcontentbycustomerextidv2';
  static const String _getAllContentByDeviceIdUrl = '/cmscontent/getallcontentbydeviceidv2';

  Future<ApiResponse> getAllReports({
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
  }) async {
    Map<String, dynamic> data = {
      'mainGroup': mainGroup,
      'Analysis': showAnalysis,
      'Report': showReport,
      'Podcast': showPodcast,
      'Video': showVideoComment,
      'Education': false,
      'YoutubeVideo': youtubeVideo,
      'language': language,
      'StartDate': (startDate ??
              DateTime.now().subtract(
                const Duration(days: 30),
              ))
          .formatToJson(),
      'EndDate': (endDate ?? DateTime.now()).formatToJson(),
    };
    bool isTokenized = false;

    if (getIt<AuthBloc>().state.isLoggedIn) {
      data['CustomerExtId'] = UserModel.instance.customerId;
      isTokenized = true;
    } else {
      data['deviceId'] = deviceId;
    }
    try {
      return await api.post(
        isTokenized ? _getAllContentByCustomerIdUrl : _getAllContentByDeviceIdUrl,
        body: data,
        tokenized: isTokenized,
      );
    } catch (e) {
      rethrow;
    }
  }
}
