import 'package:mqtt_client/mqtt_client.dart';
import 'package:piapiri_v2/core/api/mqtt_client/mqtt_warrant_dl_stats_controller.dart';
import 'package:piapiri_v2/core/api/mqtt_client/mqtt_warrant_rt_stats_controller.dart';
import 'package:piapiri_v2/core/bloc/matriks/matriks_bloc.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_bloc.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_event.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:tw_queue/tw_queue.dart';

class MqttWarrantStatsClientHelper {
  static void subscribe({
    required String statsKey,
    required String unsubStatsKey,
  }) async {
    getIt<TWQueue>(instanceName: 'MQTT').add(
      () => _prepareSubscription(
        statsKey: statsKey,
        unsubStatsKey: unsubStatsKey,
      ),
    );
  }

  static void unsubcribe({
    required String statsKey,
  }) async {
    getIt<TWQueue>(instanceName: 'MQTT').add(
      () => _prepareUnsubscribe(
        statsKey: statsKey,
      ),
    );
  }

  static Future<void> _prepareSubscription({
    required String statsKey,
    required String unsubStatsKey,
  }) async {
    Map<String, dynamic> mqttTopics = getIt<MatriksBloc>().state.topics['mqtt']['statsWarrant'];
    String topic = mqttTopics[statsKey]['topic'];
    String unsubTopic = unsubStatsKey.isNotEmpty ? mqttTopics[unsubStatsKey]['topic'] : '';
    bool isRealtime = mqttTopics[statsKey]['qos'] == 'rt';
    if (isRealtime) {
      await _subscribeToRT(
        topic,
        unsubTopic,
      );
    } else {
      await _subscribeToDL(
        topic,
        unsubTopic,
      );
    }
  }

  static Future<void> _prepareUnsubscribe({
    required String statsKey,
  }) async {
    Map<String, dynamic> mqttTopics = getIt<MatriksBloc>().state.topics['mqtt']['statsWarrant'];
    String topic = mqttTopics[statsKey]['topic'];
    await getIt<MqttWarrantDLStatsController>().unSubscribeToMQTT(
      unsubscribeTopic: topic,
    );
    await getIt<MqttWarrantRTStatsController>().unSubscribeToMQTT(
      unsubscribeTopic: topic,
    );
  }

  static Future<void> _subscribeToRT(
    String topic,
    String unsubTopic,
  ) async {
    await getIt<MqttWarrantRTStatsController>().initializeAndConnect(
      onGetData: (rankerList) {
        getIt<SymbolBloc>().add(
          SymbolUpdateWarrantRankerListEvent(
            rankerList: rankerList,
            topic: topic,
          ),
        );
      },
    );
    await getIt<MqttWarrantRTStatsController>().subscribe(topic: topic).then((Subscription? sub) async {
      if (sub != null && unsubTopic.isNotEmpty) {
        await getIt<MqttWarrantDLStatsController>().unSubscribeToMQTT(
          unsubscribeTopic: unsubTopic,
        );
        await getIt<MqttWarrantRTStatsController>().unSubscribeToMQTT(
          unsubscribeTopic: unsubTopic,
        );
      }
    });
  }

  static Future<void> _subscribeToDL(
    String topic,
    String unsubTopic,
  ) async {
    await getIt<MqttWarrantDLStatsController>().initializeAndConnect(
      onGetData: (rankerList) {
        getIt<SymbolBloc>().add(
          SymbolUpdateWarrantRankerListEvent(
            rankerList: rankerList,
            topic: topic,
          ),
        );
      },
    );
    await getIt<MqttWarrantDLStatsController>().subscribe(topic: topic).then((Subscription? sub) async {
      if (sub != null && unsubTopic.isNotEmpty) {
        await getIt<MqttWarrantDLStatsController>().unSubscribeToMQTT(
          unsubscribeTopic: unsubTopic,
        );
        await getIt<MqttWarrantRTStatsController>().unSubscribeToMQTT(
          unsubscribeTopic: unsubTopic,
        );
      }
    });
  }
}
