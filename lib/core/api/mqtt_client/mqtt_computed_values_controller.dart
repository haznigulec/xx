import 'dart:developer';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:p_core/utils/log_utils.dart';
import 'package:piapiri_v2/core/api/client/matriks_mqtt_client.dart';
import 'package:piapiri_v2/core/api/model/proto_model/computed_values/computed_values.dart';
import 'package:piapiri_v2/core/api/model/proto_model/computed_values/computed_values_extension.dart';
import 'package:piapiri_v2/core/api/model/proto_model/messenger/messenger_extension.dart';
import 'package:piapiri_v2/core/api/mqtt_client/mqtt_client_safe_extension.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/bloc/matriks/matriks_bloc.dart';
import 'package:piapiri_v2/core/config/matriks_info.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/gen/ComputedValues/ComputedValues.pb.dart';
import 'package:piapiri_v2/core/gen/Messenger/Messenger.pb.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';

class MqttComputedValuesController {
  MqttServerClient? mqttClient;
  late SymbolTypes _symbolType;
  late Function(ComputedValues) _onGetData;
  late Function(ComputedValues)? _onGotFirstResponse;

  Future<void> initializeAndConnect({
    required SymbolTypes symbolType,
    required Function(ComputedValues) onGetData,
    bool isRealtime = false,
  }) async {
    _onGetData = onGetData;
    _symbolType = symbolType;
    try {
      if (!isConnectedToBroker()) {
        String password = await getIt<PPApi>().matriksService.getMatriksTokenByQueue();
        Ws? endpointWs = _symbolType == SymbolTypes.warrant
            ? getIt<MatriksBloc>().state.endpoints?.mqtt?.mxAnalyticsWarrant?.qos?.wss
            : getIt<MatriksBloc>().state.endpoints?.mqtt?.mxAnalyticsOption?.qos?.wss;
        mqttClient = await MatriksMQTTClient().connect(
          endpoint: isRealtime ? endpointWs?.rt ?? '' : endpointWs?.dl ?? '',
          clientIdentifier: 'ANALYTICS',
          password: password,
          onSubscribed: onSubscribed,
          isRealtime: isRealtime,
        );

        startListeningMessages();
      }
    } catch (e) {
      LogUtils.pLog('MQTTANALYTICSCONTROLLER::CLIENT::EXCEPTION-[$e]');
      mqttClient?.disconnect();
    }
  }

  bool isConnectedToBroker() {
    bool isConnected = false;
    if (mqttClient?.connectionStatus != null) {
      isConnected = mqttClient?.connectionStatus?.state == MqttConnectionState.connected;
    }
    return isConnected;
  }

  Future onConnected() async {
    LogUtils.pLog('connected successfully');
    return true;
  }

  void onSubscribed(String topic) {
    getFirstData();
  }

  Future onUnSubscribed(String? topic) async {
    LogUtils.pLog('unsubscribed on topic: $topic');
  }

  Future onDisconnected() async {
    LogUtils.pLog('disconnected');

    return true;
  }

  void subscribe({
    required String topic,
    Function(ComputedValues)? onGotFirstResponse,
  }) {
    _onGotFirstResponse = onGotFirstResponse;
    LogUtils.pLog('MQTT::Sub Attempt::$topic');
    if (!isSubscribed(topic: topic)) {
      LogUtils.pLog('MQTT::Subscribe::$topic');
      mqttClient?.subscribe(
        topic,
        MqttQos.atMostOnce,
      );
    }
  }

  bool isSubscribed({required String topic}) {
    final isActiveSubs = mqttClient?.hasSubscriptionsManager() ?? false;
    if (!isActiveSubs) return false;

    MqttSubscriptionStatus? status = mqttClient?.getSubscriptionsStatus(topic);
    return status == MqttSubscriptionStatus.active;
  }

  void unSubscribeToMQTT({required String topic}) {
    final isActiveSubs = mqttClient?.hasSubscriptionsManager() ?? false;
    if (!isActiveSubs) return;

    MqttSubscriptionStatus? status = mqttClient?.getSubscriptionsStatus(topic);
    if (status == MqttSubscriptionStatus.active) {
      LogUtils.pLog('MQTT::Unsubscribe::$topic');
      mqttClient?.unsubscribe(topic, expectAcknowledge: true);
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
      if (message is MqttPublishMessage) {
        if (!topic.endsWith('/messenger')) {
          updateData(
            topic: topic,
            publishMessage: message,
          );
        } else {
          final symbolfirst = MessengerMessage.fromBuffer(message.payload.message.buffer.asUint8List()).toPP();
          log(symbolfirst.toString());
        }
      }
    });
  }

  void getFirstData() async {
    List<MqttReceivedMessage<MqttMessage>> firstMessage = await mqttClient?.updates?.first ?? [];
    if (firstMessage[0].payload is MqttPublishMessage) {
      MqttPublishMessage message = firstMessage[0].payload as MqttPublishMessage;
      if (!firstMessage[0].topic.endsWith('/messenger')) {
        LogUtils.pLog('FIRST: ${firstMessage[0].topic}');
        updateData(
          topic: firstMessage[0].topic,
          publishMessage: message,
          onGotFirstResponse: _onGotFirstResponse,
        );
      } else {
        final symbolfirst = MessengerMessage.fromBuffer(message.payload.message.buffer.asUint8List()).toPP();
        log(symbolfirst.toString());
      }
    }
  }

  void updateData({
    required String topic,
    required MqttPublishMessage publishMessage,
    Function(ComputedValues)? onGotFirstResponse,
  }) {
    final symbolfirst = ComputedValuesMessage.fromBuffer(publishMessage.payload.message.buffer.asUint8List()).toPP();
    _onGetData(symbolfirst);
    onGotFirstResponse?.call(symbolfirst);
  }

  bool isDerivative(String topic) {
    return topic.contains('/derivative');
  }
}
