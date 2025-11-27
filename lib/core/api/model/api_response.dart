import 'dart:convert';

import 'package:dio/dio.dart';

import 'package:piapiri_v2/core/api/model/api_error.dart';

class ApiResponse {
  Response<dynamic>? dioResponse;

  dynamic data;
  bool success = false;
  ApiError? error;

  ApiResponse.mock({
    this.data,
    this.success = false,
    this.error,
  });

  ApiResponse(this.dioResponse) {
    data = dioResponse?.data;
    final code = dioResponse?.statusCode ?? 0;
    success = 200 <= code && code < 300 || code == 0;
  }

  ApiResponse.fail(DioException dioException) {
    success = false;
    dioResponse = dioException.response;
    if (dioResponse?.data != null && dioResponse?.data.runtimeType == String) {
      try {
        Map<String, dynamic> errorMap = json.decode(dioResponse?.data);
        dioResponse?.data = {'errorMessage': errorMap['error']['code'] ?? ''};
      } catch (e) {
        dioResponse?.data = {'errorMessage': dioResponse?.data};
      }
    }
    if (dioResponse?.data != null && dioResponse?.data['errorMessage'] != null) {
      error = ApiError(
        code: '${dioException.response?.statusCode}',
        message: dioResponse?.data['errorMessage'],
      );
    } else {
      try {
        final connectionError = ApiError.checkConnectionErrors(dioException);
        if (connectionError != null) {
          error = ApiError(
            code: '${dioException.response?.statusCode}',
            message: connectionError,
          );
        } else if (dioException.response?.statusCode == 403) {
          error = ApiError(
            code: '${dioException.response?.statusCode}',
            message: 'Forbidden',
          );
        } else if (dioException.response?.statusCode == 401) {
          error = ApiError(
            code: '${dioException.response?.statusCode}',
            message: 'Unauthorized',
          );
        } else if (dioException.response?.statusCode == 400) {
          error = ApiError(
            code: '${dioException.response?.statusCode}',
            message: 'Bad request',
          );
        } else {
          error = ApiError(
            code: '${dioException.response?.statusCode}',
            message: 'Error',
          );
        }
      } catch (e) {
        error = ApiError(
          code: '${dioException.response?.statusCode}',
          message: 'Error',
        );
      }
    }
  }

  ApiResponse.genericFail(String? message) {
    success = false;
    error = ApiError(message: message ?? 'Unknown error');
  }

  String strError([String? fallback]) {
    if (error!.message != null) {
      return error!.message!;
    }
    return fallback ?? 'an_error_occured';
  }
}
