import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piapiri_v2/app/parity/bloc/parity_event.dart';
import 'package:piapiri_v2/app/parity/bloc/parity_state.dart';
import 'package:piapiri_v2/app/parity/repository/parity_repository.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/parity_enum.dart';

class ParityBloc extends PBloc<ParityState> {
  final ParityRepository _parityRepository;

  ParityBloc({required ParityRepository parityRepository})
      : _parityRepository = parityRepository,
        super(initialState: const ParityState()) {
    on<ParitySetMarketEvent>(_onSetMarketEvent);
  }

  FutureOr<void> _onSetMarketEvent(
    ParitySetMarketEvent event,
    Emitter<ParityState> emit,
  ) async {
    emit(
      state.copyWith(
        selectedParity: event.parity,
        parityIndex: event.parityIndex,
      ),
    );
    if (event.parity == ParityEnum.freeMarketRates && state.currencySymbolList.isNotEmpty) return;
    if (event.parity == ParityEnum.parities && state.paritySymbolList.isNotEmpty) return;
    if (event.parity == ParityEnum.preciousMetals && state.metalsSymbolList.isNotEmpty) return;
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    try {
      List<MarketListModel> tcmbRatesSymbolList = [];
      if (state.tcmbRatesSymbolList.isNotEmpty) {
        tcmbRatesSymbolList = state.tcmbRatesSymbolList;
      } else {
        List<dynamic> rawTcmbRates = await _parityRepository.paritySubItemList(
          exchangeCode: ParityEnum.tcmbRates.exchangeCode,
          marketCodes: ParityEnum.tcmbRates.marketCode,
        );
        tcmbRatesSymbolList = _rawDataToMarketListModel(rawTcmbRates);
      }

      List<MarketListModel> symbolList = [];
      List<dynamic> parityItems = await _parityRepository.paritySubItemList(
        exchangeCode: event.parity.exchangeCode,
        marketCodes: event.parity.marketCode,
      );

      symbolList = _rawDataToMarketListModel(parityItems);
      // Kurlarin yaninda merkaz bankasi kurlar da gosteriliyor
      if (event.parity == ParityEnum.freeMarketRates) {
        symbolList.addAll(tcmbRatesSymbolList.where((e) => !e.symbolCode.contains('ALTIN')));
      }
      if (event.parity == ParityEnum.preciousMetals) {
        List<dynamic> rawFreeMarketGold = await _parityRepository.paritySubItemList(
          exchangeCode: ParityEnum.freeMarketGold.exchangeCode,
          marketCodes: ParityEnum.freeMarketGold.marketCode,
        );
        symbolList.addAll(_rawDataToMarketListModel(rawFreeMarketGold));
        symbolList.addAll(tcmbRatesSymbolList.where((e) => e.symbolCode.contains('ALTIN')));
      }

      emit(
        state.copyWith(
            type: PageState.success,
            selectedParity: event.parity,
            parityIndex: event.parityIndex,
            currencySymbolList: event.parity == ParityEnum.freeMarketRates ? symbolList : null,
            paritySymbolList: event.parity == ParityEnum.parities ? symbolList : null,
            metalsSymbolList: event.parity == ParityEnum.preciousMetals ? symbolList : null,
            tcmbRatesSymbolList: state.tcmbRatesSymbolList.isEmpty ? tcmbRatesSymbolList : null),
      );
      event.callback?.call(symbolList);
    } catch (e) {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            message: e.toString(),
            errorCode: '03PRT01',
          ),
        ),
      );
    }
  }

  List<MarketListModel> _rawDataToMarketListModel(List rawData) {
    return rawData.map((e) {
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
  }
}
