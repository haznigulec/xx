import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:piapiri_v2/core/api/interceptor/custom_log_interceptor.dart';
import 'package:piapiri_v2/core/api/interceptor/header_interceptor.dart';
import 'package:piapiri_v2/core/api/interceptor/token_interceptor.dart';
import 'package:piapiri_v2/core/api/interceptor/tokenize_body_interceptor.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';

class ApiClient {
  late Dio _anonymousClient;
  late Dio _authorizedClient;
  final String _baseUrl;
  ApiClient(this._baseUrl) {
    _anonymousClient = _initDio();
    _anonymousClient.interceptors.addAll([
      HeaderInterceptor(),
      TokenInterceptor(),
      CustomLogInterceptor(
        talker: talker,
        addonId: 'AnonymousClient',
        settings: const TalkerDioLoggerSettings(
          printRequestHeaders: true,
          printResponseHeaders: true,
          printResponseMessage: false,
          printRequestData: true,
          printResponseData: false,
        ),
      ),
    ]);

    _authorizedClient = _initDio();
    _authorizedClient.interceptors.addAll([
      HeaderInterceptor(),
      TokenInterceptor(),
      TokenizeBodyInterceptor(),
      CustomLogInterceptor(
        talker: talker,
        addonId: 'AuthorizedClient',
        settings: const TalkerDioLoggerSettings(
          printRequestHeaders: true,
          printResponseHeaders: true,
          printResponseMessage: false,
          printRequestData: true,
          printResponseData: false,
        ),
      ),
    ]);
  }

  Dio _initDio() {
    Map certificates = jsonDecode(remoteConfig.getValue('unluPublicCertificate').asString())['certificates'];
    final Dio dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(milliseconds: 305000),
        contentType: Headers.jsonContentType,
      ),
    );
    if (certificates.isNotEmpty) {
      (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
        final Uint8List certBytes = base64Decode(certificates['prod']);
        final SecurityContext context = SecurityContext();
        context.setTrustedCertificatesBytes(certBytes);
        final HttpClient client = HttpClient(context: context);
        client.badCertificateCallback = (X509Certificate cert, String host, int port) => false;
        return client;
      };
    }
    return dio;
  }

  Future<ApiResponse> put(
    String path, {
    Map<String, dynamic>? body,
    bool tokenized = false,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) {
    final Dio client = tokenized ? _authorizedClient : _anonymousClient;
    return client
        .put(
          path,
          data: body,
          options: getOptions(),
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
    bool tokenized = false,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) {
    final Dio client = tokenized ? _authorizedClient : _anonymousClient;
    final FormData formData = FormData.fromMap(body);
    return client
        .put(
          path,
          data: formData,
          options: getOptions(),
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
    bool tokenized = false,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) {
    final Dio client = tokenized ? _authorizedClient : _anonymousClient;
    return client
        .patch(
          path,
          data: body,
          options: getOptions(),
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
    bool tokenized = false,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) {
    // log('bodyy: -path : $path - ' + body.toString());
    final Dio client = tokenized ? _authorizedClient : _anonymousClient;
    return client
        .post(
      path,
      data: body,
      options: getOptions(options),
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      cancelToken: cancelToken,
    )
        .then((Response<dynamic> response) {
      return ApiResponse(response);
    }).catchError((Object error) {
      return _handleError(error);
    });
  }

  Future<ApiResponse> multipartPost(
    String path, {
    required Map<String, dynamic> body,
    bool tokenized = false,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) {
    final Dio client = tokenized ? _authorizedClient : _anonymousClient;
    final FormData formData = FormData.fromMap(body);
    return client
        .post(
          path,
          data: formData,
          options: getOptions(),
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
    bool tokenized = false,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) {
    final Dio client = tokenized ? _authorizedClient : _anonymousClient;
    return client
        .get(
          path,
          data: data,
          queryParameters: queryParams(params, filters),
          options: getOptions(),
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
    bool tokenized = false,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    final Dio client = tokenized ? _authorizedClient : _anonymousClient;
    return client
        .download(
      urlPath,
      savePath,
      options: getOptions(),
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    )
        .catchError((Object error) {
      return _handleError(error).dioResponse!;
    });
  }

  Future<ApiResponse> head(
    String path, {
    Map<String, dynamic>? headers,
    bool tokenized = false,
  }) {
    final Dio client = tokenized ? _authorizedClient : _anonymousClient;
    return client
        .head(
          path,
          options: Options(headers: headers),
        )
        .then((Response<dynamic> response) => ApiResponse(response))
        .catchError((Object error) {
      return _handleError(error);
    });
  }

  ApiResponse _handleError(Object error) {
    if (error is DioException) {
      return ApiResponse.fail(error);
    } else {
      return ApiResponse.genericFail(error.toString());
    }
  }

  Future<ApiResponse> delete(String path, {bool tokenized = false}) {
    final Dio client = tokenized ? _authorizedClient : _anonymousClient;
    return client.delete(path).then((Response<dynamic> response) => ApiResponse(response)).catchError((Object error) {
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
