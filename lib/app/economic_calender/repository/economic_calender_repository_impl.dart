import 'package:piapiri_v2/app/economic_calender/repository/economic_calender_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';

class EconomicCalenderRepositoryImpl extends EconomicCalenderRepository {
  @override
  Future<ApiResponse> getEconomicCalendar({
    required String startDate,
    required String endDate,
    required String url,
  }) async {
    return getIt<PPApi>().matriksApiClient.get(
          '$url?start=$startDate&end=$endDate',
        );
  }

  @override
  Future<ApiResponse> getEconomicCalendarCountries(
    String url,
  ) async {
    return getIt<PPApi>().matriksApiClient.get(
          url,
        );
  }
}
