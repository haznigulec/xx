import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:p_core/utils/log_utils.dart';
import 'package:piapiri_v2/core/api/client/matriks_mqtt_client.dart';
import 'package:piapiri_v2/core/api/mqtt_client/mqtt_client_helper.dart';
import 'package:piapiri_v2/core/api/model/proto_model/ranker/ranker_extension.dart';
import 'package:piapiri_v2/core/api/model/proto_model/ranker/ranker_model.dart';
import 'package:piapiri_v2/core/api/mqtt_client/mqtt_client_safe_extension.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/bloc/matriks/matriks_bloc.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';

class MqttRTStatsController {
  MqttServerClient? mqttClient;
  late Function(List<Ranker>) _onGetData;

  Future<void> initializeAndConnect({
    required Function(List<Ranker>) onGetData,
  }) async {
    _onGetData = onGetData;
    try {
      if (!isConnectedToBroker()) {
        String password = await getIt<PPApi>().matriksService.getMatriksTokenByQueue();
        mqttClient = await MatriksMQTTClient().connect(
          endpoint: getIt<MatriksBloc>().state.endpoints?.mqtt?.mxStatsLow?.qos?.wss?.rt ?? '',
          clientIdentifier: 'STATS::RT',
          password: password,
        );

        startListeningMessages();
      }
    } catch (e) {
      LogUtils.pLog('MQTTSTATSCONTROLLER::CLIENT::EXCEPTION-[$e]');
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

  Future<Subscription?> subscribe({required String topic}) async {
    final isActiveSubs = mqttClient?.hasSubscriptionsManager() ?? false;
    if (!isActiveSubs) return null;

    MqttSubscriptionStatus? status = mqttClient?.getSubscriptionsStatus(topic);
    if (status == MqttSubscriptionStatus.doesNotExist) {
      return mqttClient?.subscribe(
        topic,
        MqttQos.atMostOnce,
      );
    }
    return null;
  }

  Future unSubscribeToMQTT({required String unsubscribeTopic}) async {
    final isActiveSubs = mqttClient?.hasSubscriptionsManager() ?? false;
    if (!isActiveSubs) return;

    MqttSubscriptionStatus? status = mqttClient?.getSubscriptionsStatus(unsubscribeTopic);
    if (status == MqttSubscriptionStatus.active) {
      mqttClient?.unsubscribe(
        unsubscribeTopic,
        expectAcknowledge: true,
      );
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
        final rankerMarket = rankerBytesToPiapiri(message.payload.message.buffer.asUint8List());
        _onGetData(rankerMarket.symbols);
      }
    });
  }

  bool isDerivative(String topic) {
    return topic.contains('/derivative');
  }
}
