import 'dart:convert';

import 'package:piapiri_v2/core/api/client/api_client.dart';
import 'package:piapiri_v2/core/api/client/matriks_api_client.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/bloc/matriks/matriks_bloc.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/user_model.dart';

class AlarmService {
  final ApiClient api;
  final MatriksApiClient matriksApiClient;

  AlarmService(this.api, this.matriksApiClient);

  static const String _setPriceAlarmUrl = '/Alarm/createtradealarm';
  static const String _setNewsAlarmUrl = '/Alarm/createnewsalarm';
  static const String _getNotificationCountByCustomerId = '/CmsNotification/getnotificationcountbycustomerextid';

  Future<ApiResponse> setPriceAlarm({
    required String symbolName,
    required double price,
    required String condition,
    required int expireDate,
    required String note,
    required String url,
  }) {
    String conditionType = condition == '>' ? 'ge' : 'le';
    return matriksApiClient.post(
      url,
      body: {
        'when': [
          {
            conditionType: [
              '$symbolName.last@rt',
              price,
            ],
          }
        ],
        'then': [
          {
            'send': {
              'url': 'post://unlumenkul',
            },
            'message': jsonEncode({
              'matriksRuleId': '{{id}}',
              'customerExtId': UserModel.instance.customerId,
              'symbol': symbolName,
              'type': 'PRICE',
            }),
            'subject': '',
          },
        ],
        'wait_until_threshold': true,
        'note': note,
        'keep_until': expireDate,
      },
    );
  }

  Future<ApiResponse> setMatriksRulePriceAlarm({
    required String symbolName,
    required double price,
    required String condition,
    required String expireDate,
    required String note,
    required String ruleId,
  }) {
    return api.post(
      _setPriceAlarmUrl,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'symbol': symbolName,
        'price': price,
        'condition': condition,
        'expireDate': expireDate,
        'note': note,
        'matriksRuleId': ruleId,
      },
    );
  }

  Future<ApiResponse> setPriceAlarmStatus({
    required String alarmId,
  }) {
    return matriksApiClient.put(
      '${getIt<MatriksBloc>().state.endpoints!.rest!.arf!.insertRule?.url ?? ''}/?id=$alarmId&active=true',
    );
  }

  Future<ApiResponse> setNewsAlarm({
    required String symbolName,
    required String url,
  }) {
    return matriksApiClient.post(
      url,
      body: {
        'when': [
          {
            'contains': [
              'news.symbol@rt',
              symbolName,
            ],
          }
        ],
        'then': [
          {
            'send': {
              'url': 'post://unlumenkul',
            },
            'message': jsonEncode({
              'matriksRuleId': '{{id}}',
              'customerExtId': UserModel.instance.customerId,
              'newsId': '{{news_id}}',
              'newsHeadline': '{{news_headline}}',
              'type': 'NEWS',
            }),
            'subject': '',
          },
        ],
      },
    );
  }

  Future<ApiResponse> setMatriksRuleNewsAlarm({
    required String symbolName,
    required String ruleId,
  }) {
    return api.post(
      _setNewsAlarmUrl,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'symbol': symbolName,
        'sources': [],
        'matriksRuleId': ruleId,
      },
    );
  }

  Future<ApiResponse> removeAlarm({
    required String id,
    required String url,
  }) {
    return matriksApiClient.delete('$url?id=$id');
  }

  Future<ApiResponse> getAlarms(
    String url,
  ) {
    return matriksApiClient.get(
      url,
    );
  }

  Future<ApiResponse> getNotificationUnReadCount() async {
    return api.post(
      _getNotificationCountByCustomerId,
      tokenized: true,
      body: {
        'customerextid': UserModel.instance.customerId,
      },
    );
  }
}
