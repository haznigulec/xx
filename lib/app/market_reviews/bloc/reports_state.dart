import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/model/report_model.dart';

class ReportsState extends PState {
  final PageState reportsState;
  final List<ReportModel> reportList;
  final ReportFilterModel reportFilter;
  final List<ReportModel> bistVideoReportList;
  final List<ReportModel> fundVideoReportList;
  final List<ReportModel> usVideoReportList;

  const ReportsState({
    super.type = PageState.initial,
    super.error,
    this.reportsState = PageState.initial,
    this.reportList = const [],
    this.reportFilter = const ReportFilterModel(),
    this.bistVideoReportList = const [],
    this.fundVideoReportList = const [],
    this.usVideoReportList = const [],
  });

  @override
  ReportsState copyWith({
    PageState? type,
    PBlocError? error,
    PageState? reportsState,
    List<ReportModel>? reportList,
    ReportFilterModel? reportFilter,
    List<ReportModel>? bistVideoReportList,
    List<ReportModel>? fundVideoReportList,
    List<ReportModel>? usVideoReportList,
  }) {
    return ReportsState(
      type: type ?? this.type,
      error: error ?? this.error,
      reportsState: reportsState ?? this.reportsState,
      reportList: reportList ?? this.reportList,
      reportFilter: reportFilter ?? this.reportFilter,
      bistVideoReportList: bistVideoReportList ?? this.bistVideoReportList,
      fundVideoReportList: fundVideoReportList ?? this.fundVideoReportList,
      usVideoReportList: usVideoReportList ?? this.usVideoReportList,
    );
  }

  @override
  List<Object?> get props => [
        type,
        error,
        reportsState,
        reportList,
        reportFilter,
        bistVideoReportList,
        fundVideoReportList,
        usVideoReportList,
      ];
}
