import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piapiri_v2/app/crypto/bloc/crypto_event.dart';
import 'package:piapiri_v2/app/crypto/bloc/crypto_state.dart';
import 'package:piapiri_v2/app/crypto/repository/crypto_repository.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/model/crypto_enum.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';

class CryptoBloc extends PBloc<CryptoState> {
  final CryptoRepository _cryptoRepository;

  CryptoBloc({required CryptoRepository cryptoRepository})
      : _cryptoRepository = cryptoRepository,
        super(initialState: const CryptoState()) {
    on<CryptoSetMarketEvent>(_onSetMarketEvent);
  }

  FutureOr<void> _onSetMarketEvent(
    CryptoSetMarketEvent event,
    Emitter<CryptoState> emit,
  ) async {
    emit(
      state.copyWith(
        selectedMarket: event.selectedMarket,
      ),
    );
    // if (event.selectedMarket == CryptoEnum.btcTurk && state.btcturkSymbolList.isNotEmpty) return;
    if (event.selectedMarket == CryptoEnum.binance && state.binanceSymbolList.isNotEmpty) return;
    // if (event.selectedMarket == CryptoEnum.bitmex && state.bitmexSymbolList.isNotEmpty) return;
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    List<dynamic> cryptoCurrencies =
        await _cryptoRepository.getCryptoCurrenciesSubItemList(market: event.selectedMarket);
    List<MarketListModel> symbolList = cryptoCurrencies.map((e) {
      return MarketListModel(
        symbolCode: e['Name'],
        type: e['TypeCode'],
        underlying: e['UnderlyingName'] ?? '',
        exchangeCode: e['ExchangeCode'] ?? '',
        marketCode: e['MarketCode'] ?? '',
        description: e['Description'] ?? '',
        swapType: e['SwapType'] ?? '',
        actionType: e['ActionType'] ?? '',
        issuer: e['Issuer'] ?? '',
        updateDate: '',
      );
    }).toList();

    event.callback?.call(symbolList);

    emit(
      state.copyWith(
        type: PageState.success,
        selectedMarket: event.selectedMarket,
        // btcturkSymbolList: event.selectedMarket == CryptoEnum.btcTurk ? symbolList : null,
        binanceSymbolList: event.selectedMarket == CryptoEnum.binance ? symbolList : null,
        // bitmexSymbolList: event.selectedMarket == CryptoEnum.bitmex ? symbolList : null,
      ),
    );
  }
}
