import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/model/robo_signal_model.dart';

class RoboSignalState extends PState {
  final PageState roboSignalState;
  final List<RoboSignalModel> roboSignalList;

  const RoboSignalState({
    super.type = PageState.initial,
    super.error,
    this.roboSignalState = PageState.initial,
    this.roboSignalList = const [],
  });

  @override
  RoboSignalState copyWith({
    PageState? type,
    PBlocError? error,
    PageState? roboSignalState,
    List<RoboSignalModel>? roboSignalList,
  }) {
    return RoboSignalState(
      type: type ?? this.type,
      error: error ?? this.error,
      roboSignalState: roboSignalState ?? this.roboSignalState,
      roboSignalList: roboSignalList ?? this.roboSignalList,
    );
  }

  @override
  List<Object?> get props => [
        type,
        error,
        roboSignalState,
        roboSignalList,
      ];
}
