import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';

class ProfileReferanceState extends PState {
  final String referanceCode;
  final String budyReferanceCode;

  const ProfileReferanceState({
    super.type = PageState.initial,
    super.error,
    this.referanceCode = '',
    this.budyReferanceCode = '',
  });

  @override
  ProfileReferanceState copyWith({
    PageState? type,
    PBlocError? error,
    String? referanceCode,
    String? budyReferanceCode,
  }) {
    return ProfileReferanceState(
      type: type ?? this.type,
      error: error ?? this.error,
      referanceCode: referanceCode ?? this.referanceCode,
      budyReferanceCode: budyReferanceCode ?? this.budyReferanceCode,
    );
  }

  @override
  List<Object?> get props => [
        type,
        error,
        referanceCode,
        budyReferanceCode,
      ];
}
