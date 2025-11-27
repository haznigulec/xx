import 'package:piapiri_v2/core/api/client/matriks_api_client.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';

class BrokerageService {
  final MatriksApiClient api;

  BrokerageService(this.api);

  Future<ApiResponse> getBrokerageDistribution({
    required String symbol,
    required int top,
    String dateFilter = '',
    required String url,
  }) async {
    return api.get(
      '$url?symbol=$symbol&top=$top$dateFilter',
    );
  }
}
