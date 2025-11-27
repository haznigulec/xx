import 'package:piapiri_v2/core/api/client/api_client.dart';
import 'package:piapiri_v2/core/api/client/matriks_api_client.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';

class MarketService {
  final ApiClient api;
  final MatriksApiClient matriksApiClient;

  MarketService(this.api, this.matriksApiClient);

  Future<ApiResponse> getPivotAnalysis({
    required String symbolName,
    required String url,
  }) async {
    return matriksApiClient.get(
      '$url?symbol=$symbolName',
    );
  }

  Future<ApiResponse> getTwitterList({
    required String url,
    required String parameter,
    required String symbolName,
  }) async {
    return matriksApiClient.get(
      // url + '?'+parameter+'='+symbolName,
      '$url?symbol=$symbolName',
    );
  }

  // Bilanço ve Gelir ( Yıl/Çeyrek bilgisi )
  Future<ApiResponse> getBalanceIncomeYearInfo({
    required String url,
    required String symbolName,
  }) async {
    return matriksApiClient.get(
      '$url?symbol=$symbolName',
    );
  }
}
