import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/config/matriks_info.dart';
import 'package:piapiri_v2/core/model/warrant_calculation_model.dart';

class MatriksState extends PState {
  final MatriksInfo? endpoints;
  final Map<String, dynamic> topics;
  final int tokenTime;
  final String token;
  final WarrantCalculateModel? warrantCalculate;
  final WarrantCalculateDetailsModel? warrantCalculateDetails;

  const MatriksState({
    super.type = PageState.initial,
    super.error,
    this.endpoints,
    this.topics = const {},
    this.tokenTime = 0,
    this.token = '',
    this.warrantCalculate,
    this.warrantCalculateDetails,
  });

  @override
  MatriksState copyWith({
    PageState? type,
    PBlocError? error,
    MatriksInfo? endpoints,
    Map<String, dynamic>? topics,
    int? tokenTime,
    String? token,
    WarrantCalculateModel? warrantCalculate,
    WarrantCalculateDetailsModel? warrantCalculateDetails,
  }) {
    return MatriksState(
      type: type ?? this.type,
      error: error ?? this.error,
      endpoints: endpoints ?? this.endpoints,
      topics: topics ?? this.topics,
      token: token ?? this.token,
      tokenTime: tokenTime ?? this.tokenTime,
      warrantCalculate: warrantCalculate ?? this.warrantCalculate,
      warrantCalculateDetails: warrantCalculateDetails ?? this.warrantCalculateDetails,
    );
  }

  @override
  List<Object?> get props => [
        type,
        error,
        endpoints,
        topics,
        token,
        tokenTime,
        warrantCalculate,
        warrantCalculateDetails,
      ];
}
