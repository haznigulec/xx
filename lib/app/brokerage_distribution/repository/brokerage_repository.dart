import 'package:piapiri_v2/core/api/model/api_response.dart';

abstract class BrokerageRepository {
  Future<ApiResponse> getBrokerageDistribution({
    required String symbol,
    required int top,
    String dateFilter = '',
    required String url,
  });
}
