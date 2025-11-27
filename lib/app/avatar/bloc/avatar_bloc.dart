import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piapiri_v2/app/avatar/bloc/avatar_event.dart';
import 'package:piapiri_v2/app/avatar/bloc/avatar_state.dart';
import 'package:piapiri_v2/app/avatar/model/generate_avatar_model.dart';
import 'package:piapiri_v2/app/avatar/model/validate_avatar_model.dart';
import 'package:piapiri_v2/app/avatar/repository/avatar_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class AvatarBloc extends PBloc<AvatarState> {
  final AvatarRepository _avatarRepository;
  AvatarBloc({required AvatarRepository avatarRepository})
      : _avatarRepository = avatarRepository,
        super(initialState: const AvatarState()) {
    on<GetAvatarAndLimitEvent>(_onGetAvatarAndLimit);
    on<UploadAvatarEvent>(_onUploadAvatar);
    on<GenerateAvatarEvent>(_onGenerateAvatar);
    on<SetAvatarEvent>(_onSetAvatar);
    on<LogoutAvatarEvent>(_onLogoutAvatar);
  }

/// Avatari ve yapay zekadan gorsel olusturma limitini getirir
  FutureOr<void> _onGetAvatarAndLimit(
    GetAvatarAndLimitEvent event,
    Emitter<AvatarState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _avatarRepository.getAvatarAndLimit(
      refCode: event.refCode,
    );

    if (response.success) {
      ValidateAvatarModel validateAvatarModel = ValidateAvatarModel.fromJson(response.data);
      emit(
        state.copyWith(
          type: PageState.success,
          validateAvatarModel: validateAvatarModel,
        ),
      );
      event.callback?.call(validateAvatarModel.limitData);
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '05PROF06',
          ),
        ),
      );
    }
  }

  /// Galeridan secilen gorselleri sunucuya yukler
  FutureOr<void> _onUploadAvatar(
    UploadAvatarEvent event,
    Emitter<AvatarState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _avatarRepository.uploadAvatar(
      image: event.image,
    );

    if (response.success) {
      add(
        GetAvatarAndLimitEvent(
        ),
      );
      event.callback?.call();
      emit(
        state.copyWith(
          type: PageState.success,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '05PROF07',
          ),
        ),
      );
    }
  }

  /// Yapay zeka ile avatar olusturur
  FutureOr<void> _onGenerateAvatar(
    GenerateAvatarEvent event,
    Emitter<AvatarState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          type: PageState.loading,
        ),
      );

      ApiResponse response = await _avatarRepository.generateAvatar(
        descriptionText: event.descriptionText,
      );

      if (response.success) {
        GenerateAvatarModel generateAvatarModel = GenerateAvatarModel.fromJson(response.data);
        event.callback(generateAvatarModel);
        emit(
          state.copyWith(
            type: PageState.success,
          ),
        );
      } else {
        emit(
          state.copyWith(
            type: PageState.failed,
            error: PBlocError(
              showErrorWidget: true,
              message: response.error?.message == null
                  ? L10n.tr(
                    'generate_avatar_general_error',
                    )
                  : L10n.tr('avatar.error.${response.error?.message}'),
              errorCode: '05PROF09',
            ),
          ),
        );
        event.errorCallback?.call();
      }
    } catch (e) {
      emit(
        state.copyWith(
          type: PageState.success,
        ),
      );
    }
  }
  // Yapay zeka ile olusturulan avatar secildigi durumda refCode verildiginde avatar set edilir
  FutureOr<void> _onSetAvatar(
    SetAvatarEvent event,
    Emitter<AvatarState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _avatarRepository.setAvatar(
      refCode: event.refCode,
    );

    if (response.success) {
      add(
        GetAvatarAndLimitEvent(
        ),
      );

      event.callback(true);
      emit(
        state.copyWith(
          type: PageState.success,
        ),
      );
    } else {
      event.callback(false);
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '05PROF08',
          ),
        ),
      );
    }
  }
  // Avatarin logout edildigi durumda state sifirlanir
  FutureOr<void> _onLogoutAvatar(
    LogoutAvatarEvent event,
    Emitter<AvatarState> emit,
  ) async {
    emit(
      const AvatarState(
        type: PageState.success,
        validateAvatarModel: null,
      ),
    );

  }
}
