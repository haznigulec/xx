import 'package:piapiri_v2/core/bloc/bloc/bloc_event.dart';

abstract class LicenseEvent extends PEvent {}

class GetLicensesEvent extends LicenseEvent {}

class RequestLicenseEvent extends LicenseEvent {
  final int licenceId;
  final String? startDate;
  final String customerId;
  final int requestType;
  final Function(bool)? onSuccess;

  RequestLicenseEvent({
    required this.licenceId,
    this.startDate,
    required this.customerId,
    required this.requestType,
    this.onSuccess,
  });
}

class CancelLicenseEvent extends LicenseEvent {
  final int licenceId;
  final int requestType;
  final Function(bool)? onSuccess;

  CancelLicenseEvent({
    required this.licenceId,
    required this.requestType,
    this.onSuccess,
  });
}
