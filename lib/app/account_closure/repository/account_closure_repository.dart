import 'package:piapiri_v2/core/api/model/api_response.dart';

abstract class AccountClosureRepository {
  Future<ApiResponse> accountClosure({
    String customerId = '',
  });

  Future<ApiResponse> getAccountClosureStatus();
}
