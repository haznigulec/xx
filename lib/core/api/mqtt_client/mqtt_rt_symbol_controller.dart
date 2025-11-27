import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:p_core/utils/log_utils.dart';
import 'package:piapiri_v2/core/api/client/matriks_mqtt_client.dart';
import 'package:piapiri_v2/core/api/mqtt_client/mqtt_client_helper.dart';
import 'package:piapiri_v2/core/api/model/proto_model/base_symbol/base_symbol.dart';
import 'package:piapiri_v2/core/api/model/proto_model/derivative/derivative_proto_extension.dart';
import 'package:piapiri_v2/core/api/model/proto_model/symbol/proto_extensions.dart';
import 'package:piapiri_v2/core/api/mqtt_client/mqtt_client_safe_extension.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/bloc/matriks/matriks_bloc.dart';
import 'package:piapiri_v2/core/bloc/time/time_bloc.dart';
import 'package:piapiri_v2/core/bloc/time/time_event.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/gen/Timestamp/Timestamp.pb.dart';

class MqttRTSymbolController {
  MqttServerClient? mqttClient;
  late Function(BaseSymbol) _onGetData;
  late Function(BaseSymbol)? _onGotFirstResponse;

  Future<void> initializeAndConnect({
    required Function(BaseSymbol) onGetData,
  }) async {
    _onGetData = onGetData;
    try {
      if (!isConnectedToBroker()) {
        String password = await getIt<PPApi>().matriksService.getMatriksTokenByQueue();
        mqttClient = await MatriksMQTTClient().connect(
          endpoint: getIt<MatriksBloc>().state.endpoints?.mqtt?.mxSymbol?.qos?.wss?.rt ?? '',
          clientIdentifier: 'MARKET::RT',
          password: password,
          onSubscribed: onSubscribed,
          isRealtime: true,
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
    Function(BaseSymbol)? onGotFirstResponse,
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

  Future<void> unSubscribeToMQTT({required String topic}) async {
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
      if (isTimeStamp(topic)) {
        TimeMessage timeMessage =
            TimeMessage.fromBuffer((message as MqttPublishMessage).payload.message.buffer.asUint8List());
        getIt<TimeBloc>().add(
          TimeUpdateEvent(timeMessage),
        );
      } else if (message is MqttPublishMessage && !topic.endsWith('/messenger')) {
        updateData(
          topic: topic,
          publishMessage: message,
        );
      }
    });
  }

  void getFirstData() async {
    List<MqttReceivedMessage<MqttMessage>> firstMessage = await mqttClient?.updates?.first ?? [];
    if (isTimeStamp(firstMessage[0].topic)) {
      TimeMessage timeMessage =
          TimeMessage.fromBuffer((firstMessage[0].payload as MqttPublishMessage).payload.message.buffer.asUint8List());
      getIt<TimeBloc>().add(
        TimeUpdateEvent(timeMessage),
      );
    } else if (firstMessage[0].payload is MqttPublishMessage && !firstMessage[0].topic.endsWith('/messenger')) {
      updateData(
        topic: firstMessage[0].topic,
        publishMessage: firstMessage[0].payload as MqttPublishMessage,
        onGotFirstResponse: _onGotFirstResponse,
      );
    }
  }

  void updateData({
    required String topic,
    required MqttPublishMessage publishMessage,
    Function(BaseSymbol)? onGotFirstResponse,
  }) {
    final symbolfirst = isDerivative(topic)
        ? derivativeBytesToPiapiri(
            publishMessage.payload.message.buffer.asUint8List(),
          )
        : symbolBytesToPiapiri(
            publishMessage.payload.message.buffer.asUint8List(),
          );
    _onGetData(symbolfirst);
    onGotFirstResponse?.call(symbolfirst);
  }

  bool isDerivative(String topic) {
    return topic.contains('/derivative');
  }

  bool isTimeStamp(String topic) {
    return topic.contains('mx/timestamp');
  }
}
