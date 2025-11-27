import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piapiri_v2/app/pivot_analysis/bloc/pivot_event.dart';
import 'package:piapiri_v2/app/pivot_analysis/bloc/pivot_state.dart';
import 'package:piapiri_v2/app/pivot_analysis/repository/pivot_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/bloc/matriks/matriks_bloc.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/pivot_analysis_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class PivotBloc extends PBloc<PivotState> {
  final PivotRepository _pivotRepository;

  PivotBloc({
    required PivotRepository pivotRepository,
  })  : _pivotRepository = pivotRepository,
        super(
          initialState: const PivotState(),
        ) {
    on<GetPivotAnalysisEvent>(_onGetPivotAnalysis);
  }

  FutureOr<void> _onGetPivotAnalysis(
    GetPivotAnalysisEvent event,
    Emitter<PivotState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          type: PageState.loading,
        ),
      );
      ApiResponse response = await _pivotRepository.getPivotAnalysis(
        symbolName: event.symbol,
        url: getIt<MatriksBloc>().state.endpoints!.rest!.techAnalysis!.pivots!.url ?? '',
      );

      if (response.success) {
        PivotAnalysisModel pivotAnalysisModel = PivotAnalysisModel.fromJson(response.data[0]);
        pivotAnalysisModel.copyWith(symbol: event.symbol);
        emit(
          state.copyWith(
            type: PageState.success,
            pivotAnalysis: pivotAnalysisModel,
          ),
        );
      } else {
        if (response.error?.code == '404') {
          emit(
            state.copyWith(
              type: PageState.success,
              pivotAnalysis: PivotAnalysisModel.notFound(),
            ),
          );
        } else {
          emit(
            state.copyWith(
              type: PageState.failed,
              error: PBlocError(
                showErrorWidget: true,
                message: response.error?.message ?? '',
                errorCode: '02MLST003',
              ),
            ),
          );
        }
      }
    } catch (e) {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: L10n.tr('error'),
            errorCode: '02MLST003',
          ),
        ),
      );
    }
    return null;
  }
}
