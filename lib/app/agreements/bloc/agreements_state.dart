import 'package:piapiri_v2/core/model/agreements_model.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';

class AgreementsState extends PState {
  final List<AgreementsModel> agreementsList;

  const AgreementsState({
    super.type = PageState.initial,
    super.error,
    this.agreementsList = const [],
  });

  @override
  AgreementsState copyWith({
    PageState? type,
    PBlocError? error,
    List<AgreementsModel>? agreementsList,
  }) {
    return AgreementsState(
      type: type ?? this.type,
      error: error ?? this.error,
      agreementsList: agreementsList ?? this.agreementsList,
    );
  }

  @override
  List<Object?> get props => [
        type,
        error,
        agreementsList,
      ];
}
