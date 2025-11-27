import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piapiri_v2/app/robo_signal/bloc/robo_signal_event.dart';
import 'package:piapiri_v2/app/robo_signal/bloc/robo_signal_state.dart';
import 'package:piapiri_v2/app/robo_signal/repository/robo_signal_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/model/robo_signal_model.dart';

class RoboSignalBloc extends PBloc<RoboSignalState> {
  final RoboSignalRepository _roboSignalRepository;

  RoboSignalBloc({
    required RoboSignalRepository robosignalRepository,
  })  : _roboSignalRepository = robosignalRepository,
        super(initialState: const RoboSignalState()) {
    on<GetRoboSignalsEvent>(_onGetRoboSignals);
  }

  FutureOr<void> _onGetRoboSignals(
    GetRoboSignalsEvent event,
    Emitter<RoboSignalState> emit,
  ) async {
    emit(
      state.copyWith(
        roboSignalState: PageState.loading,
      ),
    );
    ApiResponse response = await _roboSignalRepository.getRoboSignals();

    if (response.success) {
      List<RoboSignalModel> roboSignals =
          response.data['roboSignals'].map<RoboSignalModel>((e) => RoboSignalModel.fromJson(e)).toList();
      emit(
        state.copyWith(
          roboSignalList: roboSignals,
          roboSignalState: PageState.success,
        ),
      );
    } else {
      emit(
        state.copyWith(
          roboSignalState: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '01ROB001',
          ),
        ),
      );
    }
  }
}
