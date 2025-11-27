import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/parity_enum.dart';

class ParityState extends PState {
  final ParityEnum selectedParity;
  final int parityIndex;
  final List<MarketListModel> currencySymbolList;
  final List<MarketListModel> paritySymbolList;
  final List<MarketListModel> metalsSymbolList;
  final List<MarketListModel> tcmbRatesSymbolList;

  const ParityState({
    super.type = PageState.initial,
    super.error,
    this.selectedParity = ParityEnum.freeMarketRates,
    this.parityIndex = 0,
    this.currencySymbolList = const [],
    this.paritySymbolList = const [],
    this.metalsSymbolList = const [],
    this.tcmbRatesSymbolList = const [],
  });

  @override
  ParityState copyWith({
    PageState? type,
    PBlocError? error,
    ParityEnum? selectedParity,
    int? parityIndex,
    List<String>? symbolNames,
    List<MarketListModel>? currencySymbolList,
    List<MarketListModel>? paritySymbolList,
    List<MarketListModel>? metalsSymbolList,
    List<MarketListModel>? tcmbRatesSymbolList,
  }) {
    return ParityState(
      type: type ?? this.type,
      error: error ?? this.error,
      selectedParity: selectedParity ?? this.selectedParity,
      parityIndex: parityIndex ?? this.parityIndex,
      currencySymbolList: currencySymbolList ?? this.currencySymbolList,
      paritySymbolList: paritySymbolList ?? this.paritySymbolList,
      metalsSymbolList: metalsSymbolList ?? this.metalsSymbolList,
      tcmbRatesSymbolList: tcmbRatesSymbolList ?? this.tcmbRatesSymbolList,
    );
  }

  @override
  List<Object?> get props => [
        type,
        error,
        selectedParity,
        parityIndex,
        currencySymbolList,
        paritySymbolList,
        metalsSymbolList,
        tcmbRatesSymbolList,
      ];
}
