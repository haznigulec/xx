import 'package:piapiri_v2/app/currency_buy_sell/model/currency_ratios_model.dart';
import 'package:piapiri_v2/app/currency_buy_sell/model/system_paremeters_model.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';

class CurrencyBuySellState extends PState {
  final List<CurrenyRatios>? currencyRatioList;
  final double? tlTradeLimit;
  final double? tradeLimitByCurrency;
  final SystemParametersModel? systemParametersModel;

  const CurrencyBuySellState({
    super.type = PageState.initial,
    super.error,
    this.currencyRatioList,
    this.tlTradeLimit,
    this.tradeLimitByCurrency,
    this.systemParametersModel,
  });

  @override
  PState copyWith({
    PageState? type,
    PBlocError? error,
    List<CurrenyRatios>? currencyRatioList,
    double? tlTradeLimit,
    double? tradeLimitByCurrency,
    SystemParametersModel? systemParametersModel,
  }) {
    return CurrencyBuySellState(
      type: type ?? this.type,
      error: error ?? this.error,
      currencyRatioList: currencyRatioList ?? this.currencyRatioList,
      tlTradeLimit: tlTradeLimit ?? this.tlTradeLimit,
      tradeLimitByCurrency: tradeLimitByCurrency ?? this.tradeLimitByCurrency,
      systemParametersModel: systemParametersModel ?? this.systemParametersModel,
    );
  }

  @override
  List<Object?> get props => [
        type,
        error,
        currencyRatioList,
        tlTradeLimit,
        tradeLimitByCurrency,
        systemParametersModel,
      ];
}
