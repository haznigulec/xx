import 'package:piapiri_v2/app/dividend/repository/dividend_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';

class DividendRepositoryImpl extends DividendRepository {
  @override
  Future<ApiResponse> getBySymbolName({
    required String symbolName,
  }) {
    return getIt<PPApi>().dividendService.getBySymbolName(
          symbolName: symbolName,
        );
  }

  @override
  Future<ApiResponse> getDividendHistoryBySymbolName({
    required String symbolName,
  }) {
    return getIt<PPApi>().dividendService.getDividendHistoryBySymbolName(
          symbolName: symbolName,
        );
  }

  @override
  Future<ApiResponse> getAllDividends() {
    return getIt<PPApi>().dividendService.getAllDividends();
  }

  @override
  Future<ApiResponse> getAllUsDividends() {
    return getIt<PPApi>().dividendService.getAllDividends();
  }
}
