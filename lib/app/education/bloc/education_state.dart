import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/model/education_list_model.dart';

class EducationState extends PState {
  final List<EducationListModel> educationList;

  const EducationState({
    super.type = PageState.initial,
    super.error,
    this.educationList = const [],
  });

  @override
  EducationState copyWith({
    PageState? type,
    PBlocError? error,
    List<EducationListModel>? educationList,
  }) {
    return EducationState(
      type: type ?? this.type,
      error: error ?? this.error,
      educationList: educationList ?? this.educationList,
    );
  }

  @override
  List<Object?> get props => [
        type,
        error,
        educationList,
      ];
}
