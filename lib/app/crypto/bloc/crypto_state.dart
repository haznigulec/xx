import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/model/crypto_enum.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';

class CryptoState extends PState {
  final CryptoEnum selectedMarket;
  final List<MarketListModel> btcturkSymbolList;
  final List<MarketListModel> binanceSymbolList;
  final List<MarketListModel> bitmexSymbolList;

  const CryptoState({
    super.type = PageState.initial,
    super.error,
    this.selectedMarket = CryptoEnum.btcTurk,
    this.btcturkSymbolList = const [],
    this.binanceSymbolList = const [],
    this.bitmexSymbolList = const [],
  });

  @override
  CryptoState copyWith({
    PageState? type,
    PBlocError? error,
    CryptoEnum? selectedMarket,
    List<MarketListModel>? btcturkSymbolList,
    List<MarketListModel>? binanceSymbolList,
    List<MarketListModel>? bitmexSymbolList,
  }) {
    return CryptoState(
      type: type ?? this.type,
      error: error ?? this.error,
      selectedMarket: selectedMarket ?? this.selectedMarket,
      btcturkSymbolList: btcturkSymbolList ?? this.btcturkSymbolList,
      binanceSymbolList: binanceSymbolList ?? this.binanceSymbolList,
      bitmexSymbolList: bitmexSymbolList ?? this.bitmexSymbolList,
    );
  }

  @override
  List<Object?> get props => [
        type,
        error,
        selectedMarket,
        btcturkSymbolList,
        binanceSymbolList,
        bitmexSymbolList,
      ];
}
