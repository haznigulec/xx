import 'dart:convert';

import 'package:p_core/utils/log_utils.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_bloc.dart';
import 'package:piapiri_v2/core/api/client/websocket_client.dart';
import 'package:piapiri_v2/core/config/app_config.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';

class PolygonWSSController {
  WebSocketClient? client;
  late Function(String) _onGetData;

  Future<void> initializeAndConnect({
    required Function(String) onGetData,
  }) async {
    _onGetData = onGetData;
    if (client == null || !client!.isConnected) {
      client = WebSocketClient(
          '${AppConfig.instance.polygonWssUrl}?apikey=${getIt<UsEquityBloc>().state.capraWebsocketApikey}');

      // Connect to the WebSocket server
      client?.connect();

      // Listen for messages
      startListeningMessages();

    }
  }
  // This method is used to handle incoming messages from the WebSocket server
  void startListeningMessages() {
    client?.messages.listen(
      (msg) {
        _onGetData(msg);
      },
      onError: (e) => LogUtils.pLog('WebSocket::Error::$e'),
      onDone: () => LogUtils.pLog('WebSocket::Done'),
    );
  }
  
  void subscribe({
    required List<String> symbolList,
  }) {
    LogUtils.pLog('WebSocket::Sub Attempt::$symbolList');
    if (client?.isConnected ?? false) {
      client?.send(
        json.encode(
          {
            "action": "subscribe",
            "params": symbolList.map((symbol) => "FMV.$symbol").join(',').toString(),
          }, // Assuming FMV is the correct prefix for your symbols
        ),
      );
    }
  }

  void unsubscribe({
    required List<String> symbolList,
  }) {
    LogUtils.pLog('WebSocket::Unsub Attempt::$symbolList');
    if (client?.isConnected ?? false) {
      client?.send(
        json.encode(
          {
            "action": "unsubscribe",
            "params": symbolList.map((symbol) => "FMV.$symbol").join(',').toString(),
          }, // Assuming FMV is the correct prefix for your symbols
        ),
      );
    }
  }

  void disconnect() {
    if (client?.isConnected ?? false) {
      client?.disconnect();
    }
  }
}
