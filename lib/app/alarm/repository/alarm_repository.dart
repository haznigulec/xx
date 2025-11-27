import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';

abstract class AlarmRepository {
  Future<ApiResponse> setPriceAlarm({
    required symbolName,
    required price,
    required condition,
    required expireDate,
    required note,
    required url,
  });

  Future<ApiResponse> setPriceAlarmStatus({
    required alarmId,
  });

  Future<ApiResponse> setNewsAlarm({
    required symbolName,
    required url,
  });

  Future<ApiResponse> removeAlarm({
    required id,
    required url,
  });

  Future<ApiResponse> getAlarms({
    required url,
  });

  Future<ApiResponse> getNotificationUnReadCount();

  Future<List<MarketListModel>> getDetailsOfSymbols({
    required List<String> symbolCodes,
  });
}
