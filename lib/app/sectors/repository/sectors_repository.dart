import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/sector_model.dart';

abstract class SectorsRepository {
  Future<List<SectorModel>> getBistSectors();

  Future<List<MarketListModel>> getEquityListBySectors({
    required List<String> sectorList,
  });
}
