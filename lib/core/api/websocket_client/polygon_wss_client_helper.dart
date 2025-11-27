import 'dart:convert';

import 'package:p_core/utils/log_utils.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_bloc.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_event.dart';
import 'package:piapiri_v2/core/api/websocket_client/polygon_wss_controller.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';

class PolygonWSSClientHelper {
  static void subscribe({
    required List<String> symbolList,
  }) async {
    await getIt<PolygonWSSController>().initializeAndConnect(
      onGetData: _onGetData,
    );
    getIt<PolygonWSSController>().subscribe(symbolList: symbolList);
  }

  static void unsubscribe({
    required List<String> symbolList,
  }) async {
    await getIt<PolygonWSSController>().initializeAndConnect(
      onGetData: _onGetData,
    );
    getIt<PolygonWSSController>().unsubscribe(symbolList: symbolList);
  }

  static void _onGetData(String msg) {
    Map<String, dynamic> data = json.decode(msg);
      if (data['ev'] == 'status') {
        _statusHandler(data);
      return;
      }
      if (data['ev'] == 'FMV') {
        getIt<UsEquityBloc>().add(
          UpdateUsSymbolEvent(
            symbolName: data['sym'],
            price: (data['fmv'] is num) ? (data['fmv'] as num).toDouble() : 0.0,
            timestamp: data['t'] as int,
          ),
        );
      }
    
  }

  static void _statusHandler(Map<String, dynamic> statusMsg) {
    UsEquityBloc usEquityBloc = getIt<UsEquityBloc>();
    if (statusMsg['status'] == 'connected') {
      LogUtils.pLog('WebSocket::Connected to Polygon WSS');
      return;
    }
    if (statusMsg['status'] == 'auth_success') {
      LogUtils.pLog('WebSocket::Authenticated successfully');
      return;
    }
    if (statusMsg['status'] == 'success') {
      if (statusMsg['message'].startsWith('subscribed:')) {
        List<String> symbols = List<String>.from(
          statusMsg['message'].split(':').last.trim().split('|').map(
                (s) => s.trim().replaceAll('FMV.', ''),
              ),
        );
        for (String symbol in symbols) {
          LogUtils.pLog('WebSocket::Subscription successful for $symbol');
        }
        usEquityBloc.add(
          ChangeSubscriptionStatusEvent(
            symbolList: symbols,
            isSubscribed: true,
          ),
        );
        return;
      }
      if (statusMsg['message'].startsWith('unsubscribed:')) {
        List<String> symbols = List<String>.from(
          statusMsg['message'].split(':').last.trim().split('|').map(
                (s) => s.trim().replaceAll('FMV.', ''),
              ),
        );
        for (String symbol in symbols) {
          LogUtils.pLog('WebSocket::Unsubscription successful for $symbol');
        }

        usEquityBloc.add(
          ChangeSubscriptionStatusEvent(
            symbolList: symbols,
            isSubscribed: false,
          ),
        );

        return;
      }
      LogUtils.pLog('WebSocket::Subscription message: ${statusMsg['message']}');
      return;
    }
    LogUtils.pLog('WebSocket::Unexpected::$statusMsg');
  }
}
