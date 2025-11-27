import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/model/stage_analysis_model.dart';

class StageAnalysisState extends PState {
  final List<StageAnalysisModel>? stageAnalysisList;

  const StageAnalysisState({
    super.type = PageState.initial,
    super.error,
    this.stageAnalysisList,
  });

  @override
  StageAnalysisState copyWith({
    PageState? type,
    PBlocError? error,
    List<StageAnalysisModel>? stageAnalysisList,
  }) {
    return StageAnalysisState(
      type: type ?? this.type,
      error: error ?? this.error,
      stageAnalysisList: stageAnalysisList ?? this.stageAnalysisList,
    );
  }

  @override
  List<Object?> get props => [
        type,
        error,
        stageAnalysisList,
      ];
}
