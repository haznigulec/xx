import 'package:dio/dio.dart';
import 'package:p_core/utils/log_utils.dart';
import 'package:piapiri_v2/core/database/db_helper.dart';
import 'package:talker_dio_logger/dio_logs.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';
import 'package:talker_flutter/talker_flutter.dart';

class CustomLogInterceptor extends TalkerDioLogger {
  CustomLogInterceptor({
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
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    super.onRequest(options, handler);
    final accepted = settings.requestFilter?.call(options) ?? true;
    if (!accepted) {
      return;
    }
    try {
      DatabaseHelper dbHelper = DatabaseHelper();
      final message = '${options.uri}';
      Map<String, dynamic> data = Map.from(options.data ?? {});
      if (options.path.endsWith('/adkcustomer/login') && data.isNotEmpty && data['password'] != null) {
        data['password'] = '********';
      }
      final httpLog = DioRequestLog(
        message,
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
      await dbHelper.dbLog(
        LogLevel.info,
        httpLog,
      );
    } catch (e, stackTrace) {
      LogUtils.pLog(e.toString());
      LogUtils.pLog(stackTrace.toString());
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    super.onResponse(response, handler);
    final accepted = settings.responseFilter?.call(response) ?? true;
    if (!accepted) {
      return;
    }
    try {
      final message = '${response.requestOptions.uri}';
      final httpLog = DioResponseLog(
        message,
        settings: settings,
        response: response,
      );
      DatabaseHelper dbHelper = DatabaseHelper();
      await dbHelper.dbLog(
        LogLevel.info,
        httpLog,
      );
    } catch (_) {
      //pass
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    super.onError(err, handler);
    try {
      final message = '${err.requestOptions.uri}';
      final httpErrorLog = DioErrorLog(
        message,
        dioException: err,
        settings: settings,
      );
      DatabaseHelper dbHelper = DatabaseHelper();
      await dbHelper.dbLog(
        LogLevel.critical,
        httpErrorLog,
      );
    } catch (_) {
      //pass
    }
  }
}
