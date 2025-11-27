import 'package:piapiri_v2/core/api/model/api_response.dart';

abstract class AgreementsRepository {
  Future<ApiResponse> getAgreements({
    required String date,
  });

  Future<ApiResponse> setAgreements({
    required String accountId,
    required String agreementPeriodId,
    required String agreementPortfolioDate,
    required String clientIp,
  });

  Map<String, int> readLoginCount();

  void writeLoginCount({
    required Map<String, dynamic> count,
  });

  String getLastReconciliationDate();

  void writeLastReconciliationDate({
    required String? date,
  });
}
