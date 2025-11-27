import 'package:piapiri_v2/core/bloc/bloc/bloc_event.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/sector_model.dart';

abstract class SectorsEvent extends PEvent {}

class GetBistSectorsEvent extends SectorsEvent {
  final Function(List<SectorModel>)? callback;
  GetBistSectorsEvent({
    this.callback,
  });
}

class GetEquityListBySectorEvent extends SectorsEvent {
  final String sectorGroupName;
  final List<String> sectorList;
  final Function(List<MarketListModel>)? callback;
  GetEquityListBySectorEvent({
    required this.sectorGroupName,
    required this.sectorList,
    this.callback,
  });
}

class UpdateSelectedSectorKeysEvent extends SectorsEvent {
  final List<String> selectedFilterKeys;
  UpdateSelectedSectorKeysEvent({
    required this.selectedFilterKeys,
  });
}

class OnDisposeEvent extends SectorsEvent {}
