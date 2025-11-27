import 'package:dio/dio.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_bloc.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';

class PolygonHeaderInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters.addAll({
      'apiKey': getIt<UsEquityBloc>().state.polygonApiKey,
    });

    handler.next(options);
  }
}
