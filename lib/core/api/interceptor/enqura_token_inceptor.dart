import 'dart:async';

import 'package:dio/dio.dart';
import 'package:piapiri_v2/app/enqura/bloc/enqura_bloc.dart';
import 'package:piapiri_v2/app/enqura/bloc/enqura_event.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/storage/local_storage.dart';

class EnquraTokenInceptor extends QueuedInterceptor {
  final Dio _dio = Dio();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await getIt<LocalStorage>().readSecure('enquraAccessToken');
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && !err.requestOptions.path.contains('/Auth/Refresh')) {
      try {
        final refreshToken = await getIt<LocalStorage>().readSecure('enquraRefreshToken');
        if (refreshToken == null) return handler.next(err);

        String? newAccessToken;

        final completer = Completer<void>();

        getIt<EnquraBloc>().add(
          AuthRefreshEvent(
            authRefresh: refreshToken,
            onAccessToken: (token) {
              newAccessToken = token;
              completer.complete();
            },
          ),
        );

        await completer.future;
        if (newAccessToken == null) return handler.next(err);

        final RequestOptions newRequest = err.requestOptions..headers['Authorization'] = 'Bearer $newAccessToken';

        final retryResponse = await _dio.fetch(newRequest);
        return handler.resolve(retryResponse);
      } catch (e) {
        return handler.next(err); // Refresh başarısız
      }
    }
    return handler.next(err);
  }
}
