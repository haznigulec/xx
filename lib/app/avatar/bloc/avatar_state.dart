import 'package:piapiri_v2/app/avatar/model/validate_avatar_model.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';

class AvatarState extends PState {
  final ValidateAvatarModel? validateAvatarModel;

  const AvatarState({
    super.type = PageState.initial,
    super.error,
    this.validateAvatarModel,
  });

  @override
  AvatarState copyWith({
    PageState? type,
    PBlocError? error,
    ValidateAvatarModel? validateAvatarModel,
  }) {
    return AvatarState(
      type: type ?? this.type,
      error: error ?? this.error,
      validateAvatarModel: validateAvatarModel ?? this.validateAvatarModel,
    );
  }

  @override
  List<Object?> get props => [
        type,
        error,
        validateAvatarModel,
      ];
}
