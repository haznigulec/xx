import 'package:dio/dio.dart';

class ApiError {
  final String? code;
  final String? message;
  final String? field;

  ApiError({
    this.code,
    this.message,
    this.field,
  });

  factory ApiError.mock() => ApiError(
        code: '500',
        message: 'error',
      );

  factory ApiError.generic(String? message) => ApiError(
        code: '500',
        message: message,
      );

  static String? checkConnectionErrors(DioException dioException) {
    if (dioException.type == DioExceptionType.connectionTimeout ||
        dioException.type == DioExceptionType.receiveTimeout) {
      return 'Timeout';
    } else if (dioException.type == DioExceptionType.unknown) {
      return 'Invalid Token';
    } else if (dioException.response?.statusCode == 503) {
      return 'Service unavailable';
    }

    return null;
  }
}
