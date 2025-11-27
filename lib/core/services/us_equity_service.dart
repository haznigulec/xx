import 'package:piapiri_v2/core/api/client/api_client.dart';
import 'package:piapiri_v2/core/api/client/generic_api_client.dart';
import 'package:piapiri_v2/core/api/client/polygon_api_client.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/bloc/language/bloc/language_bloc.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/us_market_movers_enum.dart';
import 'package:piapiri_v2/core/model/user_model.dart';

class UsEquityService {
  final ApiClient apiClient;
  final GenericApiClient genericApiClient;
  final ApiClient alpacaApiClient;
  final PolygonApiClient polygonApiClient;

  UsEquityService(
    this.apiClient,
    this.genericApiClient,
    this.alpacaApiClient,
    this.polygonApiClient,
  );

  static const String _getLosersGainersPolygon = '/v2/snapshot/locale/us/markets/stocks';
  static const String _getLosersGainersCapra = '/capradata/api/Subscription/getpolygonmarketmoverscache';
  static const String _getVolumes = '/capradata/api/Subscription/getactivestocksbyvolume?numberOfTopMostActiveStocks=';
  static const String _getPopulers = '/capradata/api/Subscription/getactivestocksbytrade?numberOfTopMostActiveStocks=';
  static const String _getDividends = '/capradata/api/Subscription/getallcorporateactions';
  static const String _getDailyTransactionInfo = '/Capra/getalpacadailytransactioninfo';
  static const String _getAllAbdSectors = '/Capra/getallabdsectors';

  static const String _getActiveSymbols = 'https://piapiri-std.b-cdn.net/CapraSymbols/symbols.txt';
  static const String _getFavoriteSymbols = 'https://piapiri-std.b-cdn.net/CapraSymbols/favorites.txt';
  static const String _getFractionableSymbols = 'https://piapiri-std.b-cdn.net/CapraSymbols/fractionables.txt';

  Future<ApiResponse> getLosersGainersPolygon(UsMarketMovers marketMover) async {
    return polygonApiClient.get(
      '$_getLosersGainersPolygon/${marketMover.value}',
    );
  }

  Future<ApiResponse> getLosersGainersCapra() async {
    return alpacaApiClient.get(
      _getLosersGainersCapra,
    );
  }

  Future<ApiResponse> getVolumes(int? count) async {
    return alpacaApiClient.get(
      '$_getVolumes${count ?? 50}',
    );
  }

  Future<ApiResponse> getPopulers(int? count) async {
    return alpacaApiClient.get(
      '$_getPopulers${count ?? 50}',
    );
  }

  Future<ApiResponse> getDividends({
    required List<String> symbols,
    required List<int> types,
    required String startDate,
    required String endDate,
    required int sortDirection,
  }) async {
    final Map<String, dynamic> body = {
      'symbols': symbols,
      'types': types,
      'startDate': startDate,
      'endDate': endDate,
      'sortDirection': sortDirection,
    };

    return alpacaApiClient.post(
      _getDividends,
      body: body,
    );
  }

  Future<ApiResponse> getIncomingDividends({
    required List<int> types,
    required String startDate,
    required String endDate,
    required int sortDirection,
    required bool onlyFavorites,
  }) async {
    final Map<String, dynamic> body = {
      'types': types,
      'startDate': startDate,
      'endDate': endDate,
      'sortDirection': sortDirection,
      'onlyFavorites': onlyFavorites,
    };
    return alpacaApiClient.post(
      _getDividends,
      body: body,
    );
  }

  Future<ApiResponse> getActiveSymbols() async {
    return genericApiClient.get(
      _getActiveSymbols,
    );
  }

  Future<ApiResponse> getActiveSymbolsHead() async {
    return genericApiClient.head(
      _getActiveSymbols,
    );
  }

  Future<ApiResponse> getFavoriteSymbols() async {
    return genericApiClient.get(
      _getFavoriteSymbols,
    );
  }

  Future<ApiResponse> getFavoriteSymbolsHead() async {
    return genericApiClient.head(
      _getFavoriteSymbols,
    );
  }

  Future<ApiResponse> getFractionableSymbols() async {
    return genericApiClient.get(
      _getFractionableSymbols,
    );
  }

  Future<ApiResponse> getFractionableSymbolsHead() async {
    return genericApiClient.head(
      _getFractionableSymbols,
    );
  }
  
  Future<ApiResponse> getDailyTransactionInfo() async {
    return apiClient.post(
      _getDailyTransactionInfo,
      body: {
        "customerExtId": UserModel.instance.customerId,
      },
    );
  }
  
  Future<ApiResponse> getUsSectors() async {
    return apiClient.post(
      _getAllAbdSectors,
      body: {
        "language": getIt<LanguageBloc>().state.languageCode,
      },
    );
  }

}
