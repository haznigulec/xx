import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:p_core/utils/log_utils.dart';
import 'package:piapiri_v2/core/api/client/matriks_mqtt_client.dart';
import 'package:piapiri_v2/core/api/mqtt_client/mqtt_client_helper.dart';
import 'package:piapiri_v2/core/api/model/proto_model/trade/trade_model.dart';
import 'package:piapiri_v2/core/api/model/proto_model/trade/trade_proto_extensions.dart';
import 'package:piapiri_v2/core/api/mqtt_client/mqtt_client_safe_extension.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/bloc/matriks/matriks_bloc.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';

class MqttTradeController extends ChangeNotifier {
  MqttServerClient? mqttClient;
  late Function(Trade) _onGetData;

  Future<void> initializeAndConnect({
    bool isRealtime = false,
    required Function(Trade) onGetData,
  }) async {
    _onGetData = onGetData;
    try {
      if (!isConnectedToBroker()) {
        String password = await getIt<PPApi>().matriksService.getMatriksTokenByQueue();
        mqttClient = await MatriksMQTTClient().connect(
          endpoint: isRealtime
              ? getIt<MatriksBloc>().state.endpoints?.mqtt?.mxTrade?.qos?.wss?.rt ?? ''
              : getIt<MatriksBloc>().state.endpoints?.mqtt?.mxTrade?.qos?.wss?.dl ?? '',
          clientIdentifier: 'TRADE',
          password: password,
          isRealtime: isRealtime,
        );

        startListeningMessages();
      }
    } catch (e) {
      LogUtils.pLog('MQTTCONTROLLER::client exception - $e');
      mqttClient?.disconnect();
    }
  }

  void reSubscribeSymbols() {
    MqttClientHelper().reSubscribeSymbols(
      isConnectedToBroker(),
    );
  }

  bool isConnectedToBroker() {
    bool isConnected = false;
    if (mqttClient?.connectionStatus != null) {
      isConnected = mqttClient?.connectionStatus!.state == MqttConnectionState.connected;
    }
    return isConnected;
  }

  Future onConnected() async {
    LogUtils.pLog('connected successfully');
    return true;
  }

  Future onSubscribed(String topic) async {}

  Future onUnSubscribed(String? topic) async {
    LogUtils.pLog('unsubscribed on topic: $topic');
  }

  Future onDisconnected() async {
    LogUtils.pLog('disconnected');

    return true;
  }

  Future subscribe({required MarketListModel symbol}) async {
    SymbolTypes symbolType = stringToSymbolType(symbol.type);
    String topicFormat = getIt<MatriksBloc>().state.topics['mqtt']['trade']?[symbolType.matriks]?['topic'] ?? '';
    String topic = topicFormat.replaceAll('%s', symbol.symbolCode);

    final isActiveSubs = mqttClient?.hasSubscriptionsManager() ?? false;
    if (!isActiveSubs) return;

    MqttSubscriptionStatus? status = mqttClient?.getSubscriptionsStatus(topic);
    if (status == MqttSubscriptionStatus.doesNotExist) {
      mqttClient?.subscribe(
        topic,
        MqttQos.atMostOnce,
      );
    }
  }

  Future unSubscribeToMQTT({required String symbolName}) async {
    String topic = 'mx/trade/$symbolName@lvl2';

    final isActiveSubs = mqttClient?.hasSubscriptionsManager() ?? false;
    if (!isActiveSubs) return;

    MqttSubscriptionStatus? status = mqttClient?.getSubscriptionsStatus(topic);
    if (status == MqttSubscriptionStatus.active) {
      mqttClient?.unsubscribe(topic);
    }
  }

  void disconnect() {
    if (isConnectedToBroker()) {
      mqttClient?.disconnect();
    }
  }

  void startListeningMessages() {
    mqttClient?.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttMessage message = c[0].payload;
      final String topic = c[0].topic;
      if (message is MqttPublishMessage && !topic.endsWith('/messenger')) {
        final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
        final Trade trade = tradeBytesToPiapiri(
          recMess.payload.message.buffer.asUint8List(),
        );
        _onGetData(trade);
        notifyListeners();
      }
    });
  }

  bool isDerivative(String topic) {
    return topic.contains('/derivative');
  }
}
