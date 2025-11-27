import 'package:piapiri_v2/app/agreements/repository/agreements_repository.dart';
import 'package:piapiri_v2/common/utils/local_keys.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/storage/local_storage.dart';

class AgreementsRepositoryImpl extends AgreementsRepository {
  @override
  Future<ApiResponse> getAgreements({
    required String date,
  }) {
    return getIt<PPApi>().agreementsService.getReconciliation(
          date: date,
        );
  }

  @override
  Future<ApiResponse> setAgreements({
    required String accountId,
    required String agreementPeriodId,
    required String agreementPortfolioDate,
    required String clientIp,
  }) {
    return getIt<PPApi>().agreementsService.setReconciliation(
          accountId: accountId,
          agreementPeriodId: agreementPeriodId,
          agreementPortfolioDate: agreementPortfolioDate,
          clientIp: clientIp,
        );
  }

  @override
  Map<String, int> readLoginCount() {
    final dynamic rawData = getIt<LocalStorage>().read(LocalKeys.loginCount);
    if (rawData is Map) {
      return rawData.map((key, value) => MapEntry(key.toString(), value as int));
    }
    return getIt<LocalStorage>().read(LocalKeys.loginCount) != null
        ? getIt<LocalStorage>().read(LocalKeys.loginCount) as Map<String, int>
        : <String, int>{};
  }

  @override
  void writeLoginCount({
    required Map<String, dynamic> count,
  }) {
    getIt<LocalStorage>().write(
      LocalKeys.loginCount,
      count,
    );
  }

  @override
  String getLastReconciliationDate() {
    return getIt<LocalStorage>().read(LocalKeys.lastGetReconciliationDate) ?? '';
  }

  @override
  void writeLastReconciliationDate({
    required String? date,
  }) {
    getIt<LocalStorage>().write('lastGetReconciliationDate', date);
  }
}
