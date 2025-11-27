import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';

class IncomeState extends PState {
  final Map? yearMonthList;
  final Map? balanceList;
  const IncomeState({
    super.type = PageState.initial,
    super.error,
    this.yearMonthList,
    this.balanceList,
  });

  @override
  IncomeState copyWith({
    PageState? type,
    PBlocError? error,
    Map? yearMonthList,
    Map? balanceList,
  }) {
    return IncomeState(
      type: type ?? this.type,
      error: error ?? this.error,
      yearMonthList: yearMonthList ?? this.yearMonthList,
      balanceList: balanceList ?? this.balanceList,
    );
  }

  @override
  List<Object?> get props => [
        type,
        error,
        yearMonthList,
        balanceList,
      ];
}
