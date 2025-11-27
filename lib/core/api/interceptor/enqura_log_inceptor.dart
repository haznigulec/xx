import 'package:dio/dio.dart';
import 'package:p_core/utils/log_utils.dart';
import 'package:piapiri_v2/core/database/db_helper.dart';
import 'package:talker_dio_logger/dio_logs.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';
import 'package:talker_flutter/talker_flutter.dart';

class EnquraLogInterceptor extends TalkerDioLogger {
  EnquraLogInterceptor({
    super.talker,
    TalkerDioLoggerSettings? settings,
    super.addonId,
  }) : super(
          settings: settings ?? const TalkerDioLoggerSettings(),
        );

  @override
  void configure({
    bool? printResponseData,
    bool? printResponseHeaders,
    bool? printResponseMessage,
    bool? printRequestData,
    bool? printRequestHeaders,
    AnsiPen? requestPen,
    AnsiPen? responsePen,
    AnsiPen? errorPen,
  }) {
    settings = settings.copyWith(
      printRequestData: printRequestData,
      printRequestHeaders: printRequestHeaders,
      printResponseData: printResponseData,
      printResponseHeaders: printResponseHeaders,
      printResponseMessage: printResponseMessage,
      requestPen: requestPen,
      responsePen: responsePen,
      errorPen: errorPen,
    );
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    super.onRequest(options, handler);
    final accepted = settings.requestFilter?.call(options) ?? true;
    if (!accepted) return;

    try {
      final dbHelper = DatabaseHelper();
      final uri = options.uri.toString();
      Map<String, dynamic> data = Map.from(options.data ?? {});

      // Hassas veri maskelenmesi
      if (options.path.contains('/Auth/Login')) {
        if (data.containsKey('password')) data['password'] = '********';
        if (data.containsKey('refreshToken')) data['refreshToken'] = '********';
      }

      final httpLog = DioRequestLog(
        uri,
        requestOptions: RequestOptions(
          baseUrl: options.baseUrl,
          path: options.path,
          method: options.method,
          data: data,
          contentType: options.contentType,
          responseType: options.responseType,
          connectTimeout: options.connectTimeout,
          receiveTimeout: options.receiveTimeout,
          headers: options.headers,
          extra: options.extra,
          queryParameters: options.queryParameters,
          sendTimeout: options.sendTimeout,
        ),
        settings: settings,
      );

      await dbHelper.dbLog(LogLevel.info, httpLog);
    } catch (e, stackTrace) {
      LogUtils.pLog(e.toString());
      LogUtils.pLog(stackTrace.toString());
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    super.onResponse(response, handler);
    final accepted = settings.responseFilter?.call(response) ?? true;
    if (!accepted) return;

    try {
      final uri = response.requestOptions.uri.toString();
      final maskedResponse = _maskSensitiveResponse(response);

      final httpLog = DioResponseLog(
        uri,
        settings: settings,
        response: maskedResponse,
      );
      final dbHelper = DatabaseHelper();
      await dbHelper.dbLog(LogLevel.info, httpLog);
    } catch (_) {
      // ignore silently
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    super.onError(err, handler);
    try {
      final uri = err.requestOptions.uri.toString();
      final httpErrorLog = DioErrorLog(
        uri,
        dioException: err,
        settings: settings,
      );
      final dbHelper = DatabaseHelper();
      await dbHelper.dbLog(LogLevel.critical, httpErrorLog);
    } catch (_) {
      // ignore silently
    }
  }

  // Token veya hassas veriler varsa response'u maskeler
  Response _maskSensitiveResponse(Response original) {
    if (original.data is Map<String, dynamic>) {
      final Map<String, dynamic> newData = Map<String, dynamic>.from(original.data);
      if (newData.containsKey('accessToken')) newData['accessToken'] = '********';
      if (newData.containsKey('refreshToken')) newData['refreshToken'] = '********';

      return Response(
        requestOptions: original.requestOptions,
        data: newData,
        headers: original.headers,
        isRedirect: original.isRedirect,
        redirects: original.redirects,
        statusCode: original.statusCode,
        statusMessage: original.statusMessage,
        extra: original.extra,
      );
    }
    return original;
  }
}
