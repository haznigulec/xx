import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piapiri_v2/app/viop/bloc/viop_event.dart';
import 'package:piapiri_v2/app/viop/bloc/viop_state.dart';
import 'package:piapiri_v2/app/viop/repository/viop_repository.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/symbol_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class ViopBloc extends PBloc<ViopState> {
  final ViopRepository _viopRepository;

  ViopBloc({required ViopRepository viopRepository})
      : _viopRepository = viopRepository,
        super(initialState: const ViopState()) {
    on<ViopInitEvent>(_onInit);
    on<ApplyFiltersEvent>(_onApplyFilters);
    on<GetUnderlyingListEvent>(_onGetUnderlyingList);
    on<GetMaturityListEvent>(_onGetMaturityList);
    on<OnRemoveSelectedEvent>(_onRemoveSelected);
    on<GetViopListsEvent>(_onGetViopLists);
    on<OnDisposeEvent>(_onDispose);
  }

  FutureOr<void> _onInit(
    ViopInitEvent event,
    Emitter<ViopState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    add(
      ApplyFiltersEvent(
        underlyingName: event.underlyingName ?? 'XU030',
        callback: event.callback,
        subMaketCode: event.subMarketCode,
      ),
    );

    emit(
      state.copyWith(
        type: PageState.success,
      ),
    );
  }

  FutureOr<void> _onApplyFilters(
    ApplyFiltersEvent event,
    Emitter<ViopState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
        selectedContractType: event.contractType,
        selectedUnderlying: event.underlyingName,
        selectedMaturity: event.maturityDate,
        selectedTransactionType: event.transactionType,
        symbolList: [],
      ),
    );

    List<SymbolModel> symbolModelList = await _viopRepository.getViopByFilters(
      filter: state.selectedContractType?.filter?.dbKeys?.first,
      underlyingName: state.selectedUnderlying,
      maturityDate: state.selectedMaturity == L10n.tr('all_maturities') ? null : state.selectedMaturity,
      transactionType: state.selectedTransactionType?.value,
      subMarketCode: event.subMaketCode,
    );
    List<MarketListModel> marketModelList = symbolModelList.map((e) {
      return MarketListModel(
        symbolCode: e.name,
        updateDate: '',
        type: e.typeCode,
        underlying: e.underlyingName,
        description: e.description,
        maturity: e.maturityDate,
        marketCode: e.marketCode,
        swapType: e.swapType,
        actionType: e.actionType,
        subMarketCode: '',
        issuer: e.issuer,
      );
    }).toList();
    add(GetMaturityListEvent(subMarketCode: event.subMaketCode));
    event.callback?.call(marketModelList);
    emit(
      state.copyWith(
        type: PageState.success,
        symbolList: marketModelList,
      ),
    );
  }

  FutureOr<void> _onGetUnderlyingList(
    GetUnderlyingListEvent event,
    Emitter<ViopState> emit,
  ) async {
    if (state.underlyingList.isNotEmpty) {
      event.callback?.call(state.underlyingList);
      return;
    }

    List<String> rawUnderlyingList = await _viopRepository.getUnderlyingList();

    int bistIndex = rawUnderlyingList.indexOf('XU030');
    if (bistIndex != -1) {
      rawUnderlyingList.removeAt(bistIndex);
      rawUnderlyingList.insert(0, 'XU030');
    }
    event.callback?.call(rawUnderlyingList);

    emit(
      state.copyWith(
        type: PageState.success,
        underlyingList: rawUnderlyingList,
      ),
    );
  }

  FutureOr<void> _onGetMaturityList(
    GetMaturityListEvent event,
    Emitter<ViopState> emit,
  ) async {
    List<String> rawMaturityList = event.subMarketCode == null
        ? await _viopRepository.getMaturityListByUnderlying(state.selectedUnderlying)
        : await _viopRepository.getMaturityListBySubMarketCode(event.subMarketCode!);
    emit(
      state.copyWith(
        type: PageState.success,
        maturityList: rawMaturityList,
        selectedMaturity: state.selectedMaturity,
      ),
    );
  }

  FutureOr<void> _onRemoveSelected(
    OnRemoveSelectedEvent event,
    Emitter<ViopState> emit,
  ) async {
    emit(
      ViopState(
        type: state.type,
        error: state.error,
        selectedUnderlying: state.selectedUnderlying,
        selectedMaturity: event.removeMaturity ? null : state.selectedMaturity,
        selectedContractType: event.removeContractType ? null : state.selectedContractType,
        selectedTransactionType: event.removeTransactionType ? null : state.selectedTransactionType,
        symbolList: state.symbolList,
        underlyingList: state.underlyingList,
        maturityList: state.maturityList,
        subMarketList: state.subMarketList,
      ),
    );

    add(
      ApplyFiltersEvent(
        contractType: event.removeContractType ? null : state.selectedContractType,
        underlyingName: state.selectedUnderlying,
        maturityDate: event.removeMaturity ? null : state.selectedMaturity,
        transactionType: event.removeTransactionType ? null : state.selectedTransactionType,
        subMaketCode: event.subMarketCode,
        callback: (List<MarketListModel> marketModelList) {
          event.callback?.call(marketModelList);
        },
      ),
    );
  }

  FutureOr<void> _onGetViopLists(
    GetViopListsEvent event,
    Emitter<ViopState> emit,
  ) async {
    List<String> subMarketList = [];
    if (state.subMarketList.isEmpty) {
      subMarketList = List<String>.from(await json.decode(remoteConfig.getString('viopLists'))['viopSubmarketCodes']);
    }
    emit(
      state.copyWith(
        type: PageState.success,
        subMarketList: subMarketList.isNotEmpty ? subMarketList : state.subMarketList,
      ),
    );
  }

  FutureOr<void> _onDispose(
    OnDisposeEvent event,
    Emitter<ViopState> emit,
  ) async {
    emit(
      ViopState(
        type: state.type,
        error: state.error,
        selectedUnderlying: state.selectedUnderlying,
        selectedMaturity: null,
        selectedContractType: null,
        selectedTransactionType: null,
        symbolList: const [],
        underlyingList: state.underlyingList,
        maturityList: state.maturityList,
        subMarketList: state.subMarketList,
      ),
    );
  }
}
