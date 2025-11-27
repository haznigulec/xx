import 'package:piapiri_v2/core/api/client/matriks_api_client.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';

class TwitterService {
  final MatriksApiClient matriksApiClient;

  TwitterService(this.matriksApiClient);

  Future<ApiResponse> getTwitterList({
    required String url,
    required String parameter,
    required String symbolName,
  }) async {
    return matriksApiClient.get(
      '$url?symbol=$symbolName',
    );
  }
}
