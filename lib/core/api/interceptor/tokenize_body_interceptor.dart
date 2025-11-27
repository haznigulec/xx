import 'package:dio/dio.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/services/token_service.dart';

class TokenizeBodyInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.data is Map) {
      Map data = options.data;
      data['token'] = getIt<TokenService>().getToken();
      options.data = data;
    }
    if (options.data is FormData) {
      FormData data = options.data;
      data.fields.add(MapEntry('token', getIt<TokenService>().getToken()));
      options.data = data;
    }
    super.onRequest(options, handler);
  }
}
