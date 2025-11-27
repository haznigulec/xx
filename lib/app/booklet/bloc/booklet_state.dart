import 'package:piapiri_v2/core/api/model/proto_model/booklet/booklet_model.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';

class BookletState extends PState {
  final TopOfTheBookMessageModel? booklet;

  const BookletState({
    super.type = PageState.initial,
    super.error,
    this.booklet,
  });

  @override
  BookletState copyWith({
    PageState? type,
    PBlocError? error,
    TopOfTheBookMessageModel? booklet,
  }) {
    return BookletState(
      type: type ?? this.type,
      error: error ?? this.error,
      booklet: booklet ?? this.booklet,
    );
  }

  @override
  List<Object?> get props => [
        type,
        error,
        booklet,
      ];
}
