import 'package:dio/dio.dart';
import 'package:piapiri_v2/core/api/interceptor/custom_log_interceptor.dart';
import 'package:piapiri_v2/core/api/interceptor/matriks_header_interceptor.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';

class MatriksApiClient {
  late Dio _client;

  MatriksApiClient() {
    _client = _initDio();
    _client.interceptors.addAll(
      [
        MatriksHeaderInterceptor(),
        CustomLogInterceptor(
          talker: talker,
          addonId: 'MatriksClient',
          settings: const TalkerDioLoggerSettings(
            printRequestHeaders: true,
            printResponseHeaders: true,
            printResponseMessage: true,
            printRequestData: true,
            printResponseData: false,
          ),
        ),
      ],
    );
  }

  Dio _initDio() {
    final Dio dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 25),
        contentType: Headers.jsonContentType,
      ),
    );
    return dio;
  }

  Future<ApiResponse> put(
    String path, {
    Map<String, dynamic>? body,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
    Options? options,
  }) {
    return _client
        .put(
          path,
          data: body,
          options: getOptions(options),
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
        )
        .then((Response<dynamic> response) => ApiResponse(response))
        .catchError((Object error) {
      return _handleError(error);
    });
  }

  Future<ApiResponse> multipartPut(
    String path, {
    required Map<String, dynamic> body,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
    Options? options,
  }) {
    final FormData formData = FormData.fromMap(body);
    return _client
        .put(
          path,
          data: formData,
          options: getOptions(options),
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
        )
        .then((Response<dynamic> response) => ApiResponse(response))
        .catchError((Object error) {
      return _handleError(error);
    });
  }

  Future<ApiResponse> patch(
    String path, {
    Map<String, dynamic>? body,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
    Options? options,
  }) {
    return _client
        .patch(
          path,
          data: body,
          options: getOptions(options),
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
        )
        .then((Response<dynamic> response) => ApiResponse(response))
        .catchError((Object error) {
      return _handleError(error);
    });
  }

  Future<ApiResponse> post(
    String path, {
    Map<String, dynamic>? body,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) {
    return _client
        .post(
          path,
          data: body,
          options: getOptions(options),
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
          cancelToken: cancelToken,
        )
        .then((Response<dynamic> response) => ApiResponse(response))
        .catchError((Object error) {
      return _handleError(error);
    });
  }

  Future<ApiResponse> multipartPost(
    String path, {
    required Map<String, dynamic> body,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
    Options? options,
  }) {
    final FormData formData = FormData.fromMap(body);
    return _client
        .post(
          path,
          data: formData,
          options: getOptions(options),
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
        )
        .then((Response<dynamic> response) => ApiResponse(response))
        .catchError((Object error) {
      return _handleError(error);
    });
  }

  Future<ApiResponse> get(
    String path, {
    Object? data,
    Map<String, dynamic>? params,
    Map<String, dynamic>? filters,
    CancelToken? cancelToken,
    Options? options,
    ProgressCallback? onReceiveProgress,
  }) {
    return _client
        .get(
          path,
          data: data,
          queryParameters: queryParams(params, filters),
          options: getOptions(options),
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress,
        )
        .then((Response<dynamic> response) => ApiResponse(response))
        .catchError((Object error) {
      return _handleError(error);
    });
  }

  Future<Response<dynamic>> download(
    String urlPath,
    String savePath, {
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
    Options? options,
  }) async {
    return _client
        .download(
      urlPath,
      savePath,
      options: getOptions(options),
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    )
        .catchError((Object error) {
      return _handleError(error).dioResponse!;
    });
  }

  ApiResponse _handleError(Object error) {
    if (error is DioException) {
      return ApiResponse.fail(error);
    } else {
      return ApiResponse.genericFail(error.toString());
    }
  }

  Future<ApiResponse> delete(
    String path, {
    bool tokenized = false,
    Map<String, dynamic>? body,
  }) {
    return _client
        .delete(
          path,
          data: body,
        )
        .then((Response<dynamic> response) => ApiResponse(response))
        .catchError((Object error) {
      return _handleError(error);
    });
  }

  Map<String, dynamic> queryParams(
    Map<String, dynamic>? params,
    Map<String, dynamic>? filters,
  ) {
    final Map<String, dynamic> queryParameters = <String, dynamic>{};

    params?.forEach((String k, dynamic v) {
      queryParameters[k] = v?.toString();
    });

    filters?.forEach((String k, dynamic v) {
      queryParameters['filters[$k]'] = v;
    });

    queryParameters.removeWhere((String k, dynamic v) => v == null);
    return queryParameters;
  }

  Options getOptions([Options? options]) {
    final Options opts = options ?? Options();
    opts.listFormat = ListFormat.multiCompatible;
    return opts;
  }
}
