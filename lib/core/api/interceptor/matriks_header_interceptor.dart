import 'package:dio/dio.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';

class MatriksHeaderInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final shouldSkipToken = options.extra['skipToken'] == true;
    if (!shouldSkipToken) {      
    String token = await getIt<PPApi>().matriksService.getMatriksTokenByQueue();
    options.headers.addAll({'Authorization': 'jwt $token'});
    }
    options.contentType = 'application/json';
    super.onRequest(options, handler);
  }
}
