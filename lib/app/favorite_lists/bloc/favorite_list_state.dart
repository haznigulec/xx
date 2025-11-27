import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/model/favorite_list.dart';

class FavoriteListState extends PState {
  final List<FavoriteList> watchList;
  final FavoriteList? selectedList;
  final List<FavoriteListItem> quickList;

  const FavoriteListState({
    super.type = PageState.initial,
    super.error,
    this.watchList = const [],
    this.selectedList,
    this.quickList = const [],
  });

  @override
  FavoriteListState copyWith({
    PageState? type,
    PBlocError? error,
    List<FavoriteList>? watchList,
    FavoriteList? selectedList,
    List<FavoriteListItem>? quickList,
  }) {
    return FavoriteListState(
      type: type ?? this.type,
      error: error ?? this.error,
      watchList: watchList ?? this.watchList,
      selectedList: selectedList ?? this.selectedList,
      quickList: quickList ?? this.quickList,
    );
  }

  @override
  List<Object?> get props => [
        type,
        error,
        watchList,
        selectedList,
        quickList,
      ];
}
