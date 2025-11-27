import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:piapiri_v2/app/profile/bloc/profile_referance_event.dart';
import 'package:piapiri_v2/app/profile/bloc/profile_referance_state.dart';
import 'package:piapiri_v2/app/profile/repository/profile_referance_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';

class ProfileReferanceBloc extends PBloc<ProfileReferanceState> {
  final ProfileReferanceRepository _profileReferanceRepository;
  ProfileReferanceBloc({required ProfileReferanceRepository profileReferanceRepository})
      : _profileReferanceRepository = profileReferanceRepository,
        super(initialState: const ProfileReferanceState()) {
    on<GetReferanceCodeEvent>(_onGetReferanceCode);
    on<GetApplicationSettingsByKeyAndCustomerExtIdEvent>(_onGetApplicationSettingsByKeyAndCustomerExtId);
    on<ClearReferanceCodesEvent>(_onClearReferanceCodes);
  }

  FutureOr<void> _onGetReferanceCode(
    GetReferanceCodeEvent event,
    Emitter<ProfileReferanceState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    ApiResponse response = await _profileReferanceRepository.getReferenceCode();
    if (response.success) {
      emit(
        state.copyWith(
          type: PageState.success,
          referanceCode: response.data['referenceCode'],
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '01PREF01',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetApplicationSettingsByKeyAndCustomerExtId(
    GetApplicationSettingsByKeyAndCustomerExtIdEvent event,
    Emitter<ProfileReferanceState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    ApiResponse response = await _profileReferanceRepository.getApplicationSettingsByKeyAndCustomerExtId(
      checkBudyReferanceCode: event.checkBudyReferanceCode,
      budyReferanceCode: event.budyReferanceCode,
    );
    if (response.success) {
      event.onSuccessCallback?.call();
      emit(
        state.copyWith(
          type: PageState.success,
          budyReferanceCode: event.budyReferanceCode != null
              ? event.budyReferanceCode!
              : event.checkBudyReferanceCode
                  ? response.data
                  : state.budyReferanceCode,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '01ASKC01',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onClearReferanceCodes(
    ClearReferanceCodesEvent event,
    Emitter<ProfileReferanceState> emit,
  ) {
    state.copyWith(
      referanceCode: '',
      budyReferanceCode: '',
    );
  }
}
