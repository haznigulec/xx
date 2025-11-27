import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piapiri_v2/app/stage_analysis/bloc/stage_analysis_event.dart';
import 'package:piapiri_v2/app/stage_analysis/bloc/stage_analysis_state.dart';
import 'package:piapiri_v2/app/stage_analysis/repository/stage_analysis_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/model/stage_analysis_model.dart';

class StageAnalysisBloc extends PBloc<StageAnalysisState> {
  final StageAnalysisRepository _stageAnalysisRepository;

  StageAnalysisBloc({
    required StageAnalysisRepository stageAnalysisRepository,
  })  : _stageAnalysisRepository = stageAnalysisRepository,
        super(
          initialState: const StageAnalysisState(),
        ) {
    on<StageAnalysisListEvent>(_onGetStageAnalysisData);
  }

  FutureOr<void> _onGetStageAnalysisData(
    StageAnalysisListEvent event,
    Emitter<StageAnalysisState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _stageAnalysisRepository.stageAnalysisData(
      symbol: event.symbol,
    );

    if (response.success) {
      List<StageAnalysisModel> stageAnalysisList = [];

      stageAnalysisList = response.data.map<StageAnalysisModel>((e) => StageAnalysisModel.fromJson(e)).toList();

      emit(
        state.copyWith(
          type: PageState.success,
          stageAnalysisList: stageAnalysisList,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '01STAG001',
          ),
        ),
      );
    }
  }
}
