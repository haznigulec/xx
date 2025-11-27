import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piapiri_v2/app/sectors/bloc/sectors_event.dart';
import 'package:piapiri_v2/app/sectors/bloc/sectors_state.dart';
import 'package:piapiri_v2/app/sectors/repository/sectors_repository.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/sector_model.dart';

class SectorsBloc extends PBloc<SectorsState> {
  final SectorsRepository _sectorsRepository;

  SectorsBloc({required SectorsRepository sectorsRepository})
      : _sectorsRepository = sectorsRepository,
        super(initialState: const SectorsState()) {
    on<GetBistSectorsEvent>(_onGetBistSectors);
    on<GetEquityListBySectorEvent>(_onGetEquityListBySector);
    on<UpdateSelectedSectorKeysEvent>(_onUpdateSelectedSectorKeys);
    on<OnDisposeEvent>(_onDispose);
  }

  /// Firebase Remote Config'den BIST sektörlerini çeker.
  FutureOr<void> _onGetBistSectors(
    GetBistSectorsEvent event,
    Emitter<SectorsState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    List<SectorModel> sectorList = await _sectorsRepository.getBistSectors();
    event.callback?.call(sectorList);
    emit(
      state.copyWith(
        type: PageState.success,
        bistSectors: sectorList,
      ),
    );
  }

  /// Databaseden seçilen sektörlerin hisselerini çeker.
  FutureOr<void> _onGetEquityListBySector(
    GetEquityListBySectorEvent event,
    Emitter<SectorsState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    List<String> sectorList = event.sectorList;
    if (sectorList.isEmpty) {
      sectorList = state.bistSectors.firstWhere((element) => element.groupName == event.sectorGroupName).sectors;
    }
    List<MarketListModel> symbolList = await _sectorsRepository.getEquityListBySectors(
      sectorList: sectorList,
    );
    event.callback?.call(symbolList);
    emit(
      state.copyWith(
        type: PageState.success,
        bistSymbolList: symbolList,
      ),
    );
  }

  /// Seçilen sektörleri günceller.
  FutureOr<void> _onUpdateSelectedSectorKeys(
    UpdateSelectedSectorKeysEvent event,
    Emitter<SectorsState> emit,
  ) async {
    emit(
      state.copyWith(
        selectedBistSectorKeys: event.selectedFilterKeys,
      ),
    );
  }

  
  FutureOr<void> _onDispose(
    OnDisposeEvent event,
    Emitter<SectorsState> emit,
  ) async {
    emit(
      state.copyWith(
        selectedBistSectorKeys: [],
        bistSymbolList: [],
      ),
    );
  }
}
