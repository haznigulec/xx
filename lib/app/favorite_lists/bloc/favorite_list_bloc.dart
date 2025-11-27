import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piapiri_v2/app/favorite_lists/bloc/favorite_list_event.dart';
import 'package:piapiri_v2/app/favorite_lists/bloc/favorite_list_state.dart';
import 'package:piapiri_v2/app/favorite_lists/repository/favorite_list_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/favorite_list.dart';
import 'package:piapiri_v2/core/model/favorite_sorting_enum.dart';
import 'package:piapiri_v2/core/model/symbol_model.dart';
import 'package:piapiri_v2/core/model/symbol_soruce_enum.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';

class FavoriteListBloc extends PBloc<FavoriteListState> {
  final FavoriteListRepository _favoriteListRepository;

  FavoriteListBloc({
    required FavoriteListRepository favoriteListRepository,
  })  : _favoriteListRepository = favoriteListRepository,
        super(initialState: const FavoriteListState()) {
    on<GetListEvent>(_onGetList);
    on<CreateListEvent>(_onCreateList);
    on<UpdateListEvent>(_onUpdateList);
    on<UpdateBulkListEvent>(_onUpdateBulkList);
    on<RemoveListEvent>(_onRemoveList);
    on<SelectListEvent>(_onSelectList);
    on<GetQuickListEvent>(_onGetQuickList);
    on<ClearWatchListEvent>(_onClearWatchList);
  }

  /// Favori listeleri getirir
  FutureOr<void> _onGetList(
    GetListEvent event,
    Emitter<FavoriteListState> emit,
  ) async {
    ApiResponse response = await _favoriteListRepository.getFavoriteList();

    if (response.success) {
      List<FavoriteList> watchList =
          List<FavoriteList>.from(response.data['favoriteLists'].map((e) => FavoriteList.fromJson(e)).toList());
      if (watchList.isEmpty) {
        emit(
          FavoriteListState(
            type: PageState.success,
            watchList: const [],
            selectedList: null,
            quickList: state.quickList,
          ),
        );
        _favoriteListRepository.deleteSelectedFavoriteListIdLocal();
        return;
      }

      Map<String, dynamic> symbolDetails = await _favoriteListRepository.getSymbolsDetail(
        symbolCode: List<String>.from(watchList
            .map((e) => e.favoriteListItems
                .where((e) => e.symbolSource == SymbolSourceEnum.matriks)
                .map((e) => e.symbol)
                .toList())
            .expand((element) => element)),
      );
      for (FavoriteList favoriteList in watchList) {
        for (FavoriteListItem item in favoriteList.favoriteListItems) {
          if (item.symbolSource == SymbolSourceEnum.matriks) {
            item.description = symbolDetails[item.symbol]?['Description'] ?? '';
            item.underlyingName = symbolDetails[item.symbol]?['UnderlyingName'] ?? '';
          }
        }
      }
      int? localSelectedListId = await _favoriteListRepository.getSelectedFavoriteListIdLocal();
      int listId = event.listId ?? localSelectedListId ?? state.selectedList?.id ?? watchList.last.id;
      FavoriteList selectedList = watchList.firstWhereOrNull((element) => element.id == listId) ?? watchList.last;
      event.callback?.call(watchList);
      _favoriteListRepository.createSelectedFavoriteListIdLocal(listId: listId);
      emit(
        state.copyWith(
          selectedList: selectedList,
          watchList: watchList,
          type: PageState.success,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '02MLST001',
          ),
        ),
      );
    }
  }

  /// Favori listesi oluşturur
  FutureOr<void> _onCreateList(
    CreateListEvent event,
    Emitter<FavoriteListState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    ApiResponse response = await _favoriteListRepository.createFavoriteList(
      name: event.name,
      items: event.items.map((e) => e.toJson()).toList(),
    );

    if (response.success) {
      emit(
        state.copyWith(
          type: PageState.success,
        ),
      );
      event.onSuccess(int.parse(response.data['id']));
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '02MLST004',
          ),
        ),
      );
    }
  }

  /// Favori listesini günceller
  FutureOr<void> _onUpdateList(
    UpdateListEvent event,
    Emitter<FavoriteListState> emit,
  ) async {
    List<FavoriteListItem> items = [];

    if (event.favoriteListItems != null) {
      items.addAll(event.favoriteListItems!);
    } else if (event.items != null) {
      for (SymbolModel symbolModel in event.items!) {
        SymbolTypes symbolType = SymbolTypes.values
            .firstWhere((element) => element.dbKey.toLowerCase() == symbolModel.typeCode.toLowerCase());
        SymbolSourceEnum sourceEnum =
            SymbolSourceEnum.values.firstWhere((element) => element.symbolTypes.contains(symbolType));
        items.add(
          FavoriteListItem(
            symbol: symbolModel.name,
            symbolType: symbolType,
            symbolSource: sourceEnum,
          ),
        );
      }
    }

    if (event.sortingEnum == FavoriteSortingEnum.alphabetic) {
      items.sort((a, b) => a.symbol.compareTo(b.symbol));
    }
    if (event.sortingEnum == FavoriteSortingEnum.reverseAlphabetic) {
      items.sort((a, b) => b.symbol.compareTo(a.symbol));
    }

    ApiResponse response = await _favoriteListRepository.updateFavoriteList(
      id: event.id,
      name: event.name,
      sortingEnum: event.sortingEnum,
      items: items.map((e) => e.toJson()).toList(),
    );

    if (response.success) {
      event.onSuccess?.call();
      add(GetListEvent());
      emit(
        state.copyWith(
          type: PageState.success,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '02MLST002',
          ),
        ),
      );
    }
  }

  /// Favori listelerini toplu günceller
  FutureOr<void> _onUpdateBulkList(
    UpdateBulkListEvent event,
    Emitter<FavoriteListState> emit,
  ) async {
    List<FavoriteList> addFavoriteList = [
      ...state.watchList.where((element) => event.addedListIds.contains(element.id))
    ];
    List<FavoriteList> removeFavoriteList = [
      ...state.watchList.where((element) => event.removedListIds.contains(element.id))
    ];
    List<dynamic> requestList = [];

    for (FavoriteList element in addFavoriteList) {
      List<FavoriteListItem> list = [...element.favoriteListItems, event.item];
      if (element.sortingEnum == FavoriteSortingEnum.alphabetic) {
        list.sort((a, b) => a.symbol.compareTo(b.symbol));
      } else if (element.sortingEnum == FavoriteSortingEnum.reverseAlphabetic) {
        list.sort((a, b) => b.symbol.compareTo(a.symbol));
      }
      requestList.add(_favoriteListRepository.updateFavoriteList(
        id: element.id,
        name: element.name,
        sortingEnum: element.sortingEnum,
        items: list.map((e) => e.toJson()).toList(),
      ));
    }

    for (FavoriteList element in removeFavoriteList) {
      List<FavoriteListItem> list = [
        ...element.favoriteListItems.where(
          (e) => !(e.symbol == event.item.symbol && e.symbolType == event.item.symbolType),
        ),
      ];

      requestList.add(_favoriteListRepository.updateFavoriteList(
        id: element.id,
        name: element.name,
        sortingEnum: element.sortingEnum,
        items: list.map((e) => e.toJson()).toList(),
      ));
    }

    List<dynamic> _ = await Future.wait([...requestList]);

    add(GetListEvent());
    emit(
      state.copyWith(
        type: PageState.success,
      ),
    );
  }

  /// Favori listesini siler
  FutureOr<void> _onRemoveList(
    RemoveListEvent event,
    Emitter<FavoriteListState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    ApiResponse response = await _favoriteListRepository.favoriteListDelete(
      id: event.id,
    );
    event.callback?.call();
    if (response.success) {
      add(GetListEvent());
      List<FavoriteList> watchList = state.watchList.where((element) => element.id != event.id).toList();
      emit(
        state.copyWith(
          type: PageState.success,
          watchList: watchList,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: false,
            message: response.error?.message ?? '',
            errorCode: '02MLST007',
          ),
        ),
      );
    }
  }

  /// Statedeki SelectedList i gunceller
  FutureOr<void> _onSelectList(
    SelectListEvent event,
    Emitter<FavoriteListState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    emit(
      state.copyWith(
        type: PageState.success,
        selectedList: event.selectedList,
      ),
    );
    _favoriteListRepository.createSelectedFavoriteListIdLocal(listId: event.selectedList.id);
  }

  /// Hızlı favori listesini remoteConfigden getirir
  FutureOr<void> _onGetQuickList(
    GetQuickListEvent event,
    Emitter<FavoriteListState> emit,
  ) async {
    List<String> quickFavoriteList =
        List<String>.from(await jsonDecode(remoteConfig.getString('quickFavoriteList'))['qucikFavoriteList']);

    Map<String, dynamic> symbolDetails = await _favoriteListRepository.getSymbolsDetail(
      symbolCode: quickFavoriteList,
    );

    List<FavoriteListItem> items = quickFavoriteList
        .map((e) => FavoriteListItem(
              symbol: e,
              description: symbolDetails[e]['Description'] ?? '',
              underlyingName: symbolDetails[e]['UnderlyingName'] ?? '',
              symbolType: SymbolTypes.values.firstWhere((element) => element.dbKey == symbolDetails[e]['TypeCode']),
              symbolSource: SymbolSourceEnum.matriks,
            ))
        .toList();

    emit(
      state.copyWith(
        quickList: items,
      ),
    );
  }

  FutureOr<void> _onClearWatchList(
    ClearWatchListEvent event,
    Emitter<FavoriteListState> emit,
  ) async {
    emit(
      state.copyWith(
        watchList: [],
      ),
    );
  }
}
