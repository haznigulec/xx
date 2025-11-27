import 'package:mqtt_client/mqtt_server_client.dart';

extension MqttClientSafeExtension on MqttServerClient {
  bool hasSubscriptionsManager() {
    return updates != null;
  }
}
