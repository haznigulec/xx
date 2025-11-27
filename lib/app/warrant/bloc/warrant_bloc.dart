import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p_core/extensions/date_time_extensions.dart';
import 'package:piapiri_v2/app/warrant/bloc/warrant_event.dart';
import 'package:piapiri_v2/app/warrant/bloc/warrant_state.dart';
import 'package:piapiri_v2/app/warrant/repository/warrant_repository.dart';
import 'package:piapiri_v2/app/warrant/warrant_constants.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/bloc/language/bloc/language_bloc.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/warrant_dropdown_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class WarrantBloc extends PBloc<WarrantState> {
  final WarrantRepository _warrantRepository;

  WarrantBloc({required WarrantRepository warrantRepository})
      : _warrantRepository = warrantRepository,
        super(initialState: const WarrantState()) {
    on<InitEvent>(_onInit);
    on<OnApplyFilterEvent>(_onApply);
    on<OnRemoveSelectedEvent>(_onRemoveSelectedMaturity);
    on<GetWarrantUsUnderlyingEvent>(_onGetWarrantUsUnderlying);
    on<HasWarrantOfSymbolEvent>(_onHasUnderlying);
  }

  FutureOr<void> _onInit(
    InitEvent event,
    Emitter<WarrantState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    List<Map<String, dynamic>> marketMakerData = await _warrantRepository.getMarketMakersDropDownList();
    List<WarrantDropdownModel> marketMakerList = marketMakerData.map(
      (element) {
        return WarrantDropdownModel(
          key: element['MarketMaker'],
          name: element['InstitutionDisplayName'],
        );
      },
    ).toList();

    List<String> marketMakerOrder =
        (jsonDecode(remoteConfig.getValue('warrantMarketMakerSorting').asString())['symbols'] as List)
            .map((e) => e.toString())
            .toList();

    marketMakerList.sort((a, b) {
      int indexA = marketMakerOrder.indexOf(a.key);
      int indexB = marketMakerOrder.indexOf(b.key);

      // Eğer marketMakerOrder içinde yoksa, sona atsın
      if (indexA == -1) indexA = marketMakerOrder.length;
      if (indexB == -1) indexB = marketMakerOrder.length;

      return indexA.compareTo(indexB);
    });

    marketMakerList.insert(
      0,
      WarrantDropdownModel(
        key: '',
        name: L10n.tr('all'),
      ),
    );
    final String selectedMarketMaker =
        marketMakerList.firstWhere((element) => element.key == (event.selectedMarketMaker ?? 'UNS')).key;
    List<dynamic> underlyingAssetData = await _warrantRepository.getUnderlyindAssetDropDownList(
      selectedMarketMaker: selectedMarketMaker,
    );

    List<WarrantDropdownModel> underlyingAssetList = [];
    String selectedUnderlyingAsset = '';

    if (underlyingAssetData.isNotEmpty) {
      underlyingAssetList = underlyingAssetData.map(
        (element) {
          String underlyingName = state.warrantUsUnderlying[element['Name']] ?? element['Name'];
          return WarrantDropdownModel(
            name: underlyingName,
            key: underlyingName,
          );
        },
      ).toList();

      WarrantDropdownModel bistUnderlying =
          underlyingAssetList.firstWhere((e) => e.name == (selectedMarketMaker == 'GRM' ? 'EURUSD' : 'XU030'));
      underlyingAssetList.remove(bistUnderlying);
      underlyingAssetList.insert(0, bistUnderlying);

      selectedUnderlyingAsset =
          state.warrantUsUnderlying.entries.firstWhereOrNull((e) => e.value == event.underlyingAsset)?.key ??
              event.underlyingAsset ??
              underlyingAssetList.first.name;

      add(
        OnApplyFilterEvent(
          marketMaker: selectedMarketMaker,
          underlyingAsset: selectedUnderlyingAsset,
        ),
      );
      emit(
        state.copyWith(
          marketMakerList: marketMakerList,
          underlyingAssetList: underlyingAssetList,
          uncertainUnderlyingAssetList: underlyingAssetList,
          selectedMarketMaker: selectedMarketMaker,
          selectedUnderlyingAsset: selectedUnderlyingAsset,
        ),
      );
    }
  }

  FutureOr<void> _onApply(
    OnApplyFilterEvent event,
    Emitter<WarrantState> emit,
  ) async {
    emit(
      state.copyWith(
        selectedMarketMaker: event.marketMaker,
        selectedUnderlyingAsset: event.underlyingAsset,
        selectedMaturity: event.maturity,
        selectedType: event.type,
        selectedRisk: event.risk,
      ),
    );
    List<dynamic> underlyingAssetData =
        await _warrantRepository.getUnderlyindAssetDropDownList(selectedMarketMaker: event.marketMaker);

    List<WarrantDropdownModel> underlyingAssetList = [];
    String selectedUnderlyingAsset = '';

    if (underlyingAssetData.isNotEmpty) {
      underlyingAssetList = underlyingAssetData.map(
        (element) {
          String underlyingName = state.warrantUsUnderlying[element['Name']] ?? element['Name'];
          return WarrantDropdownModel(
            name: underlyingName,
            key: underlyingName,
          );
        },
      ).toList();

      WarrantDropdownModel? bistUnderlying = underlyingAssetList.firstWhereOrNull((e) => e.name == 'XU030');
      if (bistUnderlying != null) {
        underlyingAssetList.remove(bistUnderlying);
        underlyingAssetList.insert(0, bistUnderlying);
      }

      selectedUnderlyingAsset = underlyingAssetList.firstWhereOrNull((e) => e.key == event.underlyingAsset)?.key ??
          underlyingAssetList.first.name;
    }

    final ApiResponse response = await _warrantRepository.filterWarrants(
      issuer: WarrantConstants().marketMakertoIssuer[state.selectedMarketMaker] ?? '',
      underlying: selectedUnderlyingAsset,
      risk: state.selectedRisk?.value,
      type: state.selectedType,
    );

    if (response.success) {
      List<dynamic> data = jsonDecode(response.data) as List;
      if (data.isNotEmpty) {
        List<dynamic> symbols = data[0]['symbols'];
        List<Map<String, dynamic>> symbolData = await _warrantRepository.getDetailsOfSymbols(
          symbols: symbols,
        );

        List<String> symbolNames = [];
        List<MarketListModel> symbolList = symbolData.map((symbol) {
          return MarketListModel(
            symbolCode: symbol['Name'],
            updateDate: '',
            type: symbol['TypeCode'],
            underlying: symbol['UnderlyingName'],
            optionClass: symbol['OptionClass'] ?? '',
            optionType: symbol['OptionType'] ?? '',
            multiplier: symbol['Multiplier'] ?? 1,
            description: symbol['Description'] ?? '',
            maturity: symbol['MaturityDate'] ?? '',
            marketCode: symbol['MarketCode'] ?? '',
            swapType: symbol['SwapType'] ?? '',
            actionType: symbol['ActionType'] ?? '',
            issuer: symbol['Issuer'] ?? '',
          );
        }).toList();
        Set<String> maturityDateSet = symbolList
            .map(
              (e) => DateTimeUtils.monthAndYear(
                e.maturity,
                getIt<LanguageBloc>().state.languageCode,
              ),
            )
            .toSet();

        if (state.selectedMaturity != null) {
          symbolList = symbolList.where((symbol) {
            DateTime maturityDate =
                DateTimeUtils.fromMonthAndYearToDate(state.selectedMaturity!, getIt<LanguageBloc>().state.languageCode);

            DateTime startOfTheMonth = DateTime(maturityDate.year, maturityDate.month, 1);
            DateTime endOfTheMonth = DateTime(maturityDate.year, maturityDate.month + 1, 1).subtract(
              const Duration(days: 1),
            );

            if (DateTimeUtils.fromServerDate(symbol.maturity).isBetween(startOfTheMonth, endOfTheMonth) == true) {
              symbolNames.add(symbol.symbolCode);
              return true;
            }
            return false;
          }).toList();
        }

        event.unsubscribeCallback?.call(state.symbolList);
        event.callback?.call(symbolList);
        emit(
          state.copyWith(
            type: PageState.success,
            selectedUnderlyingAsset: selectedUnderlyingAsset,
            underlyingAssetList: underlyingAssetList,
            symbolList: symbolList,
            maturityDateSet: maturityDateSet.isNotEmpty ? maturityDateSet : null,
            hasWarrant: state.hasWarrant,
          ),
        );
      } else {
        emit(
          state.copyWith(
            type: PageState.success,
            underlyingAssetList: state.uncertainUnderlyingAssetList,
            symbolList: [],
          ),
        );
      }
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
        ),
      );
    }
  }

  FutureOr<void> _onRemoveSelectedMaturity(OnRemoveSelectedEvent event, Emitter<WarrantState> emit) async {
    emit(
      WarrantState(
        selectedRisk: event.removeRisk ? null : state.selectedRisk,
        selectedMaturity: event.removeMaturity ? null : state.selectedMaturity,
        selectedType: event.removeType ? null : state.selectedType,
        selectedUnderlyingAsset: state.selectedUnderlyingAsset,
        selectedMarketMaker: state.selectedMarketMaker,
        symbolList: state.symbolList,
        maturityDateSet: state.maturityDateSet,
        underlyingAssetList: state.underlyingAssetList,
        uncertainUnderlyingAssetList: state.uncertainUnderlyingAssetList,
        type: PageState.success,
        filterType: PageState.success,
        marketMakerList: state.marketMakerList,
        warrantUsUnderlying: state.warrantUsUnderlying,
        hasWarrant: state.hasWarrant,
      ),
    );
    add(
      OnApplyFilterEvent(
        marketMaker: state.selectedMarketMaker,
        underlyingAsset: state.selectedUnderlyingAsset,
        maturity: event.removeMaturity ? null : state.selectedMaturity,
        type: event.removeType ? null : state.selectedType,
        risk: event.removeRisk ? null : state.selectedRisk,
      ),
    );
  }

  FutureOr<void> _onGetWarrantUsUnderlying(
    GetWarrantUsUnderlyingEvent event,
    Emitter<WarrantState> emit,
  ) async {
    Map<String, dynamic> warrantUsUnderlyings = jsonDecode(remoteConfig.getString('warrantUsUnderlying'));
    emit(
      state.copyWith(
        warrantUsUnderlying: warrantUsUnderlyings,
      ),
    );
  }

  FutureOr<void> _onHasUnderlying(
    HasWarrantOfSymbolEvent event,
    Emitter<WarrantState> emit,
  ) async {
    bool hasUnderlying = await _warrantRepository.hasUnderlying(
      symbol: event.symbol,
    );

    emit(
      state.copyWith(
        hasWarrant: hasUnderlying,
      ),
    );
  }
}
