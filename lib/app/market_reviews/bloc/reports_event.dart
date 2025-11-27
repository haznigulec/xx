import 'package:piapiri_v2/core/bloc/bloc/bloc_event.dart';
import 'package:piapiri_v2/core/model/report_model.dart';

abstract class ReportsEvent extends PEvent {}

class GetReportsEvent extends ReportsEvent {
  final String? deviceId;
  final String mainGroup;

  GetReportsEvent({
    this.deviceId,
    required this.mainGroup,
  });
}

class SetReportFilterEvent extends ReportsEvent {
  final ReportFilterModel reportFilter;
  final String? deviceId;
  final String? customerId;
  final String mainGroup;

  SetReportFilterEvent({
    required this.reportFilter,
    this.deviceId,
    this.customerId,
    required this.mainGroup,
  });
}

class GetVideoReportsEvent extends ReportsEvent {
  GetVideoReportsEvent();
}
