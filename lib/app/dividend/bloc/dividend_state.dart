import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/model/symbol_dividend_model.dart';

class DividendState extends PState {
  final SymbolDividendModel? symbolDividend;
  final List<SymbolDividendModel>? symbolDividendHistories;
  final List<String>? incomingDividends;
  final PageState? incomingDividendsState;

  const DividendState({
    super.type = PageState.initial,
    super.error,
    this.symbolDividend,
    this.symbolDividendHistories,
    this.incomingDividends,
    this.incomingDividendsState,
  });

  @override
  DividendState copyWith({
    PageState? type,
    PBlocError? error,
    SymbolDividendModel? symbolDividend,
    List<SymbolDividendModel>? symbolDividendHistories,
    List<String>? incomingDividends,
    PageState? incomingDividendsState,
  }) {
    return DividendState(
      type: type ?? this.type,
      error: error ?? this.error,
      symbolDividend: symbolDividend ?? this.symbolDividend,
      symbolDividendHistories: symbolDividendHistories ?? this.symbolDividendHistories,
      incomingDividends: incomingDividends ?? this.incomingDividends,
      incomingDividendsState: incomingDividendsState ?? this.incomingDividendsState,
    );
  }

  @override
  List<Object?> get props => [
        type,
        error,
        symbolDividend,
        symbolDividendHistories,
        incomingDividends,
        incomingDividendsState,
      ];
}
