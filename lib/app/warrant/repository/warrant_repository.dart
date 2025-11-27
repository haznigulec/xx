import 'package:piapiri_v2/core/api/model/api_response.dart';

abstract class WarrantRepository {
  Future<List<Map<String, dynamic>>> getMarketMakersDropDownList();

  Future<List<dynamic>> getUnderlyindAssetDropDownList({
    required String selectedMarketMaker,
  });

  Future<ApiResponse> filterWarrants({
    required String issuer,
    required String underlying,
    String? risk,
    String? type,
  });

  Future<List<Map<String, dynamic>>> getDetailsOfSymbols({
    required List<dynamic> symbols,
  });

  Future<bool> hasUnderlying({
    required String symbol,
  });
}
