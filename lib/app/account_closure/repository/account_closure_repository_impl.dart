import 'package:piapiri_v2/app/account_closure/repository/account_closure_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';

class AccountClosureRepositoryImpl extends AccountClosureRepository {
  @override
  Future<ApiResponse> accountClosure({
    String customerId = '',
  }) {
    return getIt<PPApi>().accountClosureService.accountClosure(
          customerId: customerId,
        );
  }

  @override
  Future<ApiResponse> getAccountClosureStatus() {
    return getIt<PPApi>().accountClosureService.getAccountClosureStatus();
  }
}
