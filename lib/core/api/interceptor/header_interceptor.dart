import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:p_core/utils/string_utils.dart';
import 'package:piapiri_v2/core/config/app_config.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:encrypt/encrypt.dart';

class HeaderInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    Key key = Key.fromUtf8('cMV0b2RCkEMPyeMU');
    final iv = IV.fromUtf8('A9zrbTmzH2XfTE8P');
    String serverCred = AppConfig.instance.flavor != Flavor.dev
        ? remoteConfig.getString('serverCred')
        : remoteConfig.getString('qaServerCred');
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final encrypted = Encrypted.fromBase64(serverCred);
    String decrytedInfo = encrypter.decrypt(encrypted, iv: iv);
    String token = 'Basic ${base64.encode(utf8.encode(decrytedInfo))}';
    options.headers.addAll({
      'Authorization': token,
      'X-Correlation-ID': StringUtils.generateUuid(),
    });
    options.contentType = 'application/json';
    super.onRequest(options, handler);
  }
}
