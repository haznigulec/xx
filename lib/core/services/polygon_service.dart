import 'package:piapiri_v2/core/api/client/polygon_api_client.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/model/sort_enum.dart';

class PolygonService {
  final PolygonApiClient polygonApiClient;

  PolygonService(
    this.polygonApiClient,
  );

  static const String _getSymbolDetails = '/v3/snapshot';
  static const String _getTickerOverview = '/v3/reference/tickers';
  static const String _getCustomBars = '/v2/aggs/ticker';
  static const String _getFinancialData = '/vX/reference/financials';
  static const String _getRelatedTickers = '/v1/related-companies';

  Future<ApiResponse> getTickerSnapshot({
    required String symbol,
  }) {

    return polygonApiClient.get(
      _getSymbolDetails, params: {
      'ticker': symbol,
    }
    );
  }

  Future<ApiResponse> getTickerOverview({
    required String symbolName,
  }) {
    return polygonApiClient.get(
      '$_getTickerOverview/$symbolName',
    );
  }

  Future<ApiResponse> getCustomBars({
    required String symbol,
    required String timeframe,
    required String from,
    required String to,
    num? multiplier,
    SortEnum? sortEnum,
    int? limit,
  }) async {
    final String queryParameters = '/$symbol'
        '/range'
        '/${multiplier ?? 1}'
        '/$timeframe'
        '/$from'
        '/$to';


    return polygonApiClient.get(
      '$_getCustomBars$queryParameters',
      params: {
      'adjusted': true,
      'sort': sortEnum?.value ?? SortEnum.ascending.value,
      if (limit != null) 'limit': limit,
    }
    );
  }

  Future<ApiResponse> getFinancialData({
    required String symbol,
  }) async {
    return polygonApiClient.get(
      _getFinancialData,
      params: {
        'ticker': symbol,
        'timeframe': 'ttm',
        'limit': 1,
      },
    );
  }

  Future<ApiResponse> getRelatedTickers({
    required String symbol,
  }) async {
    return polygonApiClient.get(
      '$_getRelatedTickers/$symbol',
    );
  }

}
