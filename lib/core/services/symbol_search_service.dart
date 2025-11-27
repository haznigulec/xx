import 'package:piapiri_v2/core/api/client/polygon_api_client.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';

class SymbolSearchService {
  final PolygonApiClient polygonApiClient;
  SymbolSearchService(this.polygonApiClient);
  static const String _getAllTickersSearch = '/v3/reference/tickers';


  Future<ApiResponse> searchUsSymbol(String searchString, int limit) async {
    return polygonApiClient.get(
      _getAllTickersSearch,
      params: {
        'market': 'stocks',
        'search': searchString.toUpperCase(),
        'active': true,
        'order': 'asc',
        'limit': limit,
        'sort': 'ticker',
      },
    );
  }

  Future<ApiResponse> getUSSymbol(String searchString) async {
    return polygonApiClient.get(
      '$_getAllTickersSearch/${searchString.toUpperCase()}',
    );
  }
}
