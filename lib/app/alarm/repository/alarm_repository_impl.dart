import 'package:piapiri_v2/app/alarm/repository/alarm_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/database/db_helper.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';

class AlarmRepositoryImpl extends AlarmRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  Future<ApiResponse> setPriceAlarm({
    required symbolName,
    required price,
    required condition,
    required expireDate,
    required note,
    required url,
  }) {
    return getIt<PPApi>().alarmService.setPriceAlarm(
          symbolName: symbolName,
          price: price,
          condition: condition,
          expireDate: expireDate,
          note: note,
          url: url,
        );
  }

  @override
  Future<ApiResponse> getAlarms({
    required url,
  }) {
    return getIt<PPApi>().alarmService.getAlarms(
          url,
        );
  }

  @override
  Future<ApiResponse> getNotificationUnReadCount() {
    return getIt<PPApi>().alarmService.getNotificationUnReadCount();
  }

  @override
  Future<ApiResponse> removeAlarm({
    required id,
    required url,
  }) {
    return getIt<PPApi>().alarmService.removeAlarm(
          id: id,
          url: url,
        );
  }

  @override
  Future<ApiResponse> setNewsAlarm({
    required symbolName,
    required url,
  }) {
    return getIt<PPApi>().alarmService.setNewsAlarm(
          symbolName: symbolName,
          url: url,
        );
  }

  @override
  Future<ApiResponse> setPriceAlarmStatus({
    required alarmId,
  }) {
    return getIt<PPApi>().alarmService.setPriceAlarmStatus(
          alarmId: alarmId,
        );
  }

  @override
  Future<List<MarketListModel>> getDetailsOfSymbols({
    required List<String> symbolCodes,
  }) async {
    List<Map<String, dynamic>> selectedListItems = await _dbHelper.getDetailsOfSymbols(symbolCodes);
    List<MarketListModel> selectedSymbolList = selectedListItems
        .map(
          (e) => MarketListModel(
            symbolCode: e['Name'],
            updateDate: '',
            type: e['TypeCode'],
            marketCode: e['MarketCode'] ?? '',
            underlying: e['UnderlyingName'] ?? '',
            description: e['Description'] ?? '',
          ),
        )
        .toList();
    return selectedSymbolList;
  }
}
