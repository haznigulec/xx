import 'package:piapiri_v2/core/config/service_locator.dart';

class TokenService {
  static String _token = '';

  String getToken() {
    return _token;
  }

  void setToken(String token) {
    _token = token;
    talker.info('TokenService.setToken: $token');
  }

  void clearToken() {
    _token = '';
    talker.info('TokenService.clearToken');
  }
}
