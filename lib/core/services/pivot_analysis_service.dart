import 'package:piapiri_v2/core/api/client/matriks_api_client.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';

class PivotAnalysisService {
  final MatriksApiClient matriksApiClient;

  PivotAnalysisService(this.matriksApiClient);

  Future<ApiResponse> getPivotAnalysis({
    required String symbolName,
    required String url,
  }) async {
    return matriksApiClient.get(
      '$url?symbol=$symbolName',
    );
  }
}
