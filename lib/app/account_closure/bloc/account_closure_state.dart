import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';

class AccountClosureState extends PState {
  final bool accountClosureStatus;

  const AccountClosureState({
    super.type = PageState.initial,
    super.error,
    this.accountClosureStatus = false,
  });

  @override
  AccountClosureState copyWith({
    PageState? type,
    PBlocError? error,
    bool? accountClosureStatus,
  }) {
    return AccountClosureState(
      type: type ?? this.type,
      error: error ?? this.error,
      accountClosureStatus: accountClosureStatus ?? this.accountClosureStatus,
    );
  }

  @override
  List<Object?> get props => [
        type,
        error,
        accountClosureStatus,
      ];
}
