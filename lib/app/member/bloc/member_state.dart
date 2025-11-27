import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';

class MemberState extends PState {
  final String message;
  final Map<String, dynamic> memberInfo;

  const MemberState({
    super.type = PageState.initial,
    super.error,
    this.message = '',
    this.memberInfo = const {},
  });

  @override
  MemberState copyWith({
    PageState? type,
    PBlocError? error,
    String? message,
    Map<String, dynamic>? memberInfo,
  }) {
    return MemberState(
      type: type ?? this.type,
      error: error ?? this.error,
      message: message ?? this.message,
      memberInfo: memberInfo ?? this.memberInfo,
    );
  }

  @override
  List<Object?> get props => [
        type,
        error,
        message,
        memberInfo,
      ];
}
