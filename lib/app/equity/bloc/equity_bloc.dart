import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piapiri_v2/app/equity/bloc/equity_event.dart';
import 'package:piapiri_v2/app/equity/bloc/equity_state.dart';
import 'package:piapiri_v2/app/equity/repository/equity_repository.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';

class EquityBloc extends PBloc<EquityState> {
  final EquityRepository _equityRepository;

  EquityBloc({
    required EquityRepository equityRepository,
  })  : _equityRepository = equityRepository,
        super(initialState: const EquityState()) {
    on<InitEvent>(_onInit);
    on<SelectListEvent>(_onSelectList);
  }

  FutureOr<void> _onInit(
    InitEvent event,
    Emitter<EquityState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.fetching,
      ),
    );
    List<MarketListModel> symbolList = await _equityRepository.getSymbolInfo(
      selectedList: state.selectedList,
    );
    event.callback(symbolList);
    emit(
      state.copyWith(
        type: PageState.success,
        symbolList: symbolList,
      ),
    );
  }


  FutureOr<void> _onSelectList(
    SelectListEvent event,
    Emitter<EquityState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.fetching,
      ),
    );

    List<MarketListModel> symbolList = [];
    if (event.selectedList.type != '20') {
      symbolList = await _equityRepository.getSymbolInfo(
        selectedList: event.selectedList,
      );
    }

    event.unsubscribeCallback?.call(symbolList);
    event.callback?.call(symbolList);
    emit(
      state.copyWith(
        type: PageState.success,
        selectedList: event.selectedList,
        symbolList: symbolList,
      ),
    );
  }

}
