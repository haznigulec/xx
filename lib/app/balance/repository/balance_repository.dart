import 'package:piapiri_v2/core/api/model/api_response.dart';

abstract class BalanceRepository {
  Future<ApiResponse> getBalanceYearInfo({
    required String symbolName,
  });

  Future<ApiResponse> getBalance({
    required String symbolName,
    required String period,
  });
}
