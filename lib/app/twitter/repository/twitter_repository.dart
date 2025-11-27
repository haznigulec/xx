import 'package:piapiri_v2/core/api/model/api_response.dart';

abstract class TwitterRepository {
  Future<ApiResponse> getTwitterList({
    required String symbolName,
  });
}
