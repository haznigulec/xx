import 'package:equatable/equatable.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class PBlocError extends Equatable implements Exception {
  final String message;
  final bool showErrorWidget;
  final bool shouldLogout;
  final String errorCode;

  const PBlocError({
    required this.message,
    this.showErrorWidget = false,
    this.shouldLogout = false,
    required this.errorCode,
  });

  PBlocError copy({
    String? message,
    bool? showErrorWidget,
    String? errorCode,
  }) {
    bool isInvalid = message == L10n.tr('invalid_token') ||
        message == 'invalid_token' ||
        message == 'Invalid Token' ||
        message == 'Unauthorized';
    bool isMultiConnect = message == '900000001';
    String? errorMessage = isInvalid
        ? L10n.tr('invalid_token')
        : isMultiConnect
            ? L10n.tr('900000001')
            : message ?? this.message;
    return PBlocError(
      message: message ?? this.message,
      showErrorWidget: errorMessage != 'Timeout',
      shouldLogout: isInvalid,
      errorCode: errorCode ?? this.errorCode,
    );
  }

  @override
  List<Object> get props => [message, showErrorWidget, errorCode];
}
