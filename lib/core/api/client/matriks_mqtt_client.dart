import 'dart:async';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:p_core/utils/log_utils.dart';

class MatriksMQTTClient {
  String usernamee = 'JWT';
  late String _identifier;
  late String _identifierSuffix;

  Future<MqttServerClient> connect({
    required String endpoint,
    String clientIdentifier = '',
    required String password,
    bool isRealtime = false,
    Function(String)? onSubscribed,
  }) async {
    _identifier = clientIdentifier;
    _identifierSuffix = isRealtime ? 'RT' : 'DL';
    MqttServerClient client = MqttServerClient(
      endpoint,
      clientIdentifier,
      maxConnectionAttempts: 3,
    );
    client.logging(on: false);
    client.port = 443;
    client.setProtocolV31();
    client.keepAlivePeriod = 100;
    client.connectTimeoutPeriod = 3000;
    client.disconnectOnNoResponsePeriod = 1500;
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
    client.onUnsubscribed = onUnsubscribed;
    client.onSubscribed = onSubscribed;
    client.onSubscribeFail = onSubscribeFail;
    client.pongCallback = pong;
    client.useWebSocket = true;
    final connMessage = MqttConnectMessage()
        .withClientIdentifier('$clientIdentifier::${isRealtime ? 'RT' : 'DL'}')
        .withWillTopic('willtopic')
        .withWillMessage('Will message')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    client.connectionMessage = connMessage;
    try {
      await client.connect(
        usernamee,
        password,
      );
    } catch (e) {
      client.disconnect();
    }
    return client;
  }

  // connection succeeded
  void onConnected() {
    LogUtils.pLog('MQTT::$_identifier::$_identifierSuffix::Connected');
  }

  // unconnected
  void onDisconnected() {
    LogUtils.pLog('MQTT::$_identifier::$_identifierSuffix::Disconnected');
  }

  // subscribe to topic succeeded
  // void onSubscribed(String topic) {
  //   log('$_identifier::$_identifierSuffix Subscribed: $topic');
  // }

  // subscribe to topic failed
  void onSubscribeFail(String topic) {
    LogUtils.pLog('MQTT::$_identifier::$_identifierSuffix::Failed::$topic');
  }

  // unsubscribe succeeded
  void onUnsubscribed(String? topic) {
    LogUtils.pLog('MQTT::$_identifier::$_identifierSuffix::Unsubscribed::$topic');
  }

  // PING response received
  void pong() {}
}
