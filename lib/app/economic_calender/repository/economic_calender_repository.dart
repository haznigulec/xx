import 'package:piapiri_v2/core/api/model/api_response.dart';

abstract class EconomicCalenderRepository {
  Future<ApiResponse> getEconomicCalendar({
    required String startDate,
    required String endDate,
    required String url,
  });

  Future<ApiResponse> getEconomicCalendarCountries(
    String url,
  );
}
