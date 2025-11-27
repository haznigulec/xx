import 'package:piapiri_v2/core/api/model/api_response.dart';

abstract class PivotRepository {
  Future<ApiResponse> getPivotAnalysis({
    required String symbolName,
    required String url,
  });
}
