import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piapiri_v2/app/education/bloc/education_event.dart';
import 'package:piapiri_v2/app/education/bloc/education_state.dart';
import 'package:piapiri_v2/app/education/repository/education_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/model/education_list_model.dart';

class EducationBloc extends PBloc<EducationState> {
  final EducationRepository _educationRepository;

  EducationBloc({
    required EducationRepository educationRepository,
  })  : _educationRepository = educationRepository,
        super(initialState: const EducationState()) {
    on<GetEducationEvent>(_onGetEducations);
  }

  FutureOr<void> _onGetEducations(
    GetEducationEvent event,
    Emitter<EducationState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    ApiResponse response = await _educationRepository.getEducation();

    if (response.success) {
      emit(
        state.copyWith(
          type: PageState.success,
          educationList:
              response.data['educationList'].map<EducationListModel>((e) => EducationListModel.fromJson(e)).toList(),
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '01EDUC01',
          ),
        ),
      );
    }
  }
}
