import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:p_core/utils/log_utils.dart';
import 'package:piapiri_v2/core/api/client/matriks_mqtt_client.dart';
import 'package:piapiri_v2/core/api/mqtt_client/mqtt_client_helper.dart';
import 'package:piapiri_v2/core/api/mqtt_client/mqtt_client_safe_extension.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/bloc/matriks/matriks_bloc.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/gen/RankedSymbols/RankedSymbols.pb.dart';

class MqttRTViopStatsController {
  MqttServerClient? mqttClient;
  late Function(RankedSymbolsMessage) _onGetData;

  Future<void> initializeAndConnect({
    required Function(RankedSymbolsMessage) onGetData,
  }) async {
    _onGetData = onGetData;
    try {
      if (!isConnectedToBroker()) {
        String password = await getIt<PPApi>().matriksService.getMatriksTokenByQueue();
        mqttClient = await MatriksMQTTClient().connect(
          endpoint: getIt<MatriksBloc>().state.endpoints?.mqtt?.mxStatsFutureLow?.qos?.wss?.rt ?? '',
          clientIdentifier: 'VIOPSTATS',
          password: password,
        );

        startListeningMessages();
      }
    } catch (e) {
      LogUtils.pLog('MQTTVIOPSTATSCONTROLLER::CLIENT::EXCEPTION-[$e]');
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
        final RankedSymbolsMessage rankedSymbolsMessage = RankedSymbolsMessage.fromBuffer(
          message.payload.message.buffer.asUint8List(),
        );
        _onGetData(rankedSymbolsMessage);
      }
    });
  }
}
