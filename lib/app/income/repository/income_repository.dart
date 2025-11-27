import 'package:piapiri_v2/core/api/model/api_response.dart';

abstract class IncomeRepository {
  Future<ApiResponse> getBalanceYearInfo({
    required String symbolName,
  });

  Future getBalance({
    required String symbolName,
    required String period,
  });
}
