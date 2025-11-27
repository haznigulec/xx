import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/model/advice_history_model.dart';
import 'package:piapiri_v2/core/model/advice_model.dart';
import 'package:piapiri_v2/core/model/report_model.dart';
import 'package:piapiri_v2/core/model/robo_signal_model.dart';

class AdvicesState extends PState {
  final PageState advicesState;
  final List<AdviceModel> adviceBySymbolNameList;
  final List<AdviceModel> adviceList;
  final DateTime? adviceListFetchDate;
  final String? adviceListFetchCustomerId;
  final AdviceHistoryModel adviceHistoryModel;
  final PageState reportsState;
  final List<ReportModel> reports;
  final List<RoboSignalModel> roboSignalList;

  const AdvicesState({
    super.type = PageState.initial,
    super.error,
    this.advicesState = PageState.initial,
    this.adviceBySymbolNameList = const [],
    this.adviceList = const [],
    this.adviceListFetchDate,
    this.adviceListFetchCustomerId,
    this.adviceHistoryModel = const AdviceHistoryModel(),
    this.reportsState = PageState.initial,
    this.reports = const [],
    this.roboSignalList = const [],
  });

  @override
  AdvicesState copyWith({
    PageState? type,
    PBlocError? error,
    PageState? advicesState,
    DateTime? adviceListFetchDate,
    String? adviceListFetchCustomerId,
    List<AdviceModel>? adviceBySymbolNameList,
    List<AdviceModel>? adviceList,
    AdviceHistoryModel? adviceHistoryModel,
    PageState? reportsState,
    List<ReportModel>? reports,
    List<RoboSignalModel>? roboSignalList,
  }) {
    return AdvicesState(
      type: type ?? this.type,
      error: error ?? this.error,
      advicesState: advicesState ?? this.advicesState,
      adviceBySymbolNameList: adviceBySymbolNameList ?? this.adviceBySymbolNameList,
      adviceList: adviceList ?? this.adviceList,
      adviceListFetchDate: adviceListFetchDate ?? this.adviceListFetchDate,
      adviceListFetchCustomerId: adviceListFetchCustomerId ?? this.adviceListFetchCustomerId,
      adviceHistoryModel: adviceHistoryModel ?? this.adviceHistoryModel,
      reportsState: reportsState ?? this.reportsState,
      reports: reports ?? this.reports,
      roboSignalList: roboSignalList ?? this.roboSignalList,
    );
  }

  @override
  List<Object?> get props => [
        type,
        error,
        advicesState,
        adviceBySymbolNameList,
        adviceList,
        adviceListFetchDate,
        adviceListFetchCustomerId,
        adviceHistoryModel,
        reportsState,
        reports,
        roboSignalList,
      ];
}
