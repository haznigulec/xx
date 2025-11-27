import 'package:piapiri_v2/core/api/client/api_client.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';

class DividendService {
  final ApiClient api;

  DividendService(this.api);

  static const String _getDividendBySymbol = '/Dividend/getbysymbolname';
  static const String _getDividendHistoryBySymbol = '/Dividend/getdividendhistory';
  static const String _getAllDividens = '/Dividend/getalldividends';

  Future<ApiResponse> getBySymbolName({
    required String symbolName,
  }) {
    return api.post(
      _getDividendBySymbol,
      body: {
        'symbolName': symbolName,
      },
    );
  }

  Future<ApiResponse> getDividendHistoryBySymbolName({
    required String symbolName,
  }) {
    return api.post(
      _getDividendHistoryBySymbol,
      body: {
        'symbolName': symbolName,
      },
    );
  }

  Future<ApiResponse> getAllDividends() {
    return api.post(
      _getAllDividens,
      body: {},
    );
  }
}
