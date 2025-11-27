import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/sector_model.dart';

class SectorsState extends PState {
  final List<SectorModel> bistSectors;
  final List<MarketListModel> bistSymbolList;
  final List<String> selectedBistSectorKeys;

  const SectorsState({
    super.type = PageState.initial,
    super.error,
    this.bistSectors = const [],
    this.bistSymbolList = const [],
    this.selectedBistSectorKeys = const [],
  });

  @override
  SectorsState copyWith({
    PageState? type,
    PBlocError? error,
    List<SectorModel>? bistSectors,
    List<MarketListModel>? bistSymbolList,
    List<String>? selectedBistSectorKeys,
  }) {
    return SectorsState(
      type: type ?? this.type,
      error: error ?? this.error,
      bistSectors: bistSectors ?? this.bistSectors,
      bistSymbolList: bistSymbolList ?? this.bistSymbolList,
      selectedBistSectorKeys: selectedBistSectorKeys ?? this.selectedBistSectorKeys,
    );
  }

  @override
  List<Object?> get props => [
        type,
        error,
        bistSectors,
        bistSymbolList,
        selectedBistSectorKeys,
      ];
}
