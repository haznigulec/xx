import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/model/pivot_analysis_model.dart';

class PivotState extends PState {
  final PivotAnalysisModel? pivotAnalysis;

  const PivotState({
    super.type = PageState.initial,
    super.error,
    this.pivotAnalysis,
  });

  @override
  PivotState copyWith({
    PageState? type,
    PBlocError? error,
    PivotAnalysisModel? pivotAnalysis,
  }) {
    return PivotState(
      type: type ?? this.type,
      error: error ?? this.error,
      pivotAnalysis: pivotAnalysis ?? this.pivotAnalysis,
    );
  }

  @override
  List<Object?> get props => [
        type,
        error,
        pivotAnalysis,
      ];
}
