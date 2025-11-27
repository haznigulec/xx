import 'dart:convert';

import 'package:piapiri_v2/app/sectors/repository/sectors_repository.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/database/db_helper.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/sector_model.dart';

class SectorsRepositoryImpl extends SectorsRepository {
  DatabaseHelper dbHelper = DatabaseHelper();

  /// Firebaseden aldigi sektorlerin kodlarini databasede bulunduklarini dogruladiktan sonra model dondurur..
  @override
  Future<List<SectorModel>> getBistSectors() async {
    List<String> sectorCodes = await dbHelper.getSectorCodes();
    List<Map<String, dynamic>> sectorsData =
        List<Map<String, dynamic>>.from(json.decode(remoteConfig.getString('sectors')));
    return sectorsData.map((e) {
      List<String> filteredSectors = (e['sectors'] as List<dynamic>)
          .map((s) => s.toString())
          .where((sector) => sectorCodes.contains(sector))
          .toList();
      return SectorModel(groupName: e['groupName'], sectors: filteredSectors);
    }).toList();
  }

  /// Verilen sektorlerin hisselerini databaseden ceker.
  @override
  Future<List<MarketListModel>> getEquityListBySectors({
    required List<String> sectorList,
  }) async {
    List<Map<String, dynamic>> equityData = await dbHelper.getEquityBySectors(sectorList);

    return equityData
        .map(
          (e) => MarketListModel(
            symbolCode: e['Name'],
            updateDate: '',
            type: e['TypeCode'],
            underlying: e['UnderlyingName'] ?? '',
            marketCode: e['MarketCode'] ?? '',
            description: e['Description'] ?? '',
            swapType: e['SwapType'] ?? '',
            actionType: e['ActionType'] ?? '',
            issuer: e['Issuer'] ?? '',
          ),
        )
        .toList();
  }
}
