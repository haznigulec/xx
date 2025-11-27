import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/model/twitter_model.dart';

class TwitterState extends PState {
  final List<TwitterModel>? twitterList;
  const TwitterState({
    super.type = PageState.initial,
    super.error,
    this.twitterList,
  });

  @override
  TwitterState copyWith({
    PageState? type,
    PBlocError? error,
    List<TwitterModel>? twitterList,
  }) {
    return TwitterState(
      type: type ?? this.type,
      error: error ?? this.error,
      twitterList: twitterList ?? this.twitterList,
    );
  }

  @override
  List<Object?> get props => [
        type,
        error,
        twitterList,
      ];
}
