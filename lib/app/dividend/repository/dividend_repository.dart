import 'package:piapiri_v2/core/api/model/api_response.dart';

abstract class DividendRepository {
  Future<ApiResponse> getBySymbolName({
    required String symbolName,
  });
  Future<ApiResponse> getDividendHistoryBySymbolName({
    required String symbolName,
  });
  Future<ApiResponse> getAllDividends();
  Future<ApiResponse> getAllUsDividends();
}
