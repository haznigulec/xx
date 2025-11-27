import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:p_core/utils/log_utils.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/services/token_service.dart';

class TokenInterceptor extends QueuedInterceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    try {
      if (response.data.runtimeType != String && response.data is! bool && response.data is! List) {
        if (response.data.isNotEmpty &&
            response.data["token"] != null &&
            response.data["token"].toString().isNotEmpty) {
          getIt<TokenService>().setToken(response.data["token"]);
        }
      }
      if (response.statusCode == 401) {
        try {
          remoteConfig.fetchAndActivate();
        } catch (e, stackTrace) {
          FirebaseCrashlytics.instance.recordError(e, stackTrace, reason: 'Remote config fetch failed');
        }
      }
    } catch (e, stackTrace) {
      LogUtils.pLog(e.toString());
      LogUtils.pLog(stackTrace.toString());
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String processid = '';
    String date = '';
    String token = '';
    if (err.response?.data != null &&
        err.response?.data.isNotEmpty &&
        err.response!.data["token"].toString().isNotEmpty &&
        err.response!.data["token"] != null) {
      token = err.response!.data["token"];
      getIt<TokenService>().setToken(err.response!.data["token"]);
    }
    if (err.response?.headers.map['x-correlation-id'] != null &&
        err.response?.headers.map['x-correlation-id']?.isNotEmpty == true) {
      processid = err.response?.headers.map['x-correlation-id']?[0] ?? '';
    }
    if (err.response?.headers.map['date'] != null && err.response?.headers.map['date']?.isNotEmpty == true) {
      date = err.response?.headers.map['date']?[0] ?? '';
    }
    talker.critical(
      'x-correlation-id: $processid,\ndate: $date\ntoken: $token',
      StackTrace.fromString('MethodName: ${err.response?.realUri.path ?? ''}\nError: ${err.message}'),
    );
    super.onError(err, handler);
  }
}
