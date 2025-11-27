import 'package:mqtt_client/mqtt_client.dart';
import 'package:piapiri_v2/core/api/mqtt_client/mqtt_dl_stats_controller.dart';
import 'package:piapiri_v2/core/api/mqtt_client/mqtt_rt_stats_controller.dart';
import 'package:piapiri_v2/core/bloc/matriks/matriks_bloc.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_bloc.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_event.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:tw_queue/tw_queue.dart';

class MqttStatsClientHelper {
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
    Map<String, dynamic> mqttTopics = getIt<MatriksBloc>().state.topics['mqtt']['stats'];
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
    Map<String, dynamic> mqttTopics = getIt<MatriksBloc>().state.topics['mqtt']['stats'];
    String topic = mqttTopics[statsKey]['topic'];
    await getIt<MqttDLStatsController>().unSubscribeToMQTT(
      unsubscribeTopic: topic,
    );
    await getIt<MqttRTStatsController>().unSubscribeToMQTT(
      unsubscribeTopic: topic,
    );
  }

  static Future<void> _subscribeToRT(
    String topic,
    String unsubTopic,
  ) async {
    await getIt<MqttRTStatsController>().initializeAndConnect(
      onGetData: (rankerList) {
        getIt<SymbolBloc>().add(
          SymbolUpdateEquityRankerListEvent(
            rankerList: rankerList,
            topic: topic,
          ),
        );
      },
    );
    await getIt<MqttRTStatsController>().subscribe(topic: topic).then((Subscription? sub) async {
      if (sub != null && unsubTopic.isNotEmpty) {
        await getIt<MqttDLStatsController>().unSubscribeToMQTT(
          unsubscribeTopic: unsubTopic,
        );
        await getIt<MqttRTStatsController>().unSubscribeToMQTT(
          unsubscribeTopic: unsubTopic,
        );
      }
    });
  }

  static Future<void> _subscribeToDL(
    String topic,
    String unsubTopic,
  ) async {
    await getIt<MqttDLStatsController>().initializeAndConnect(
      onGetData: (rankerList) {
        getIt<SymbolBloc>().add(
          SymbolUpdateEquityRankerListEvent(
            rankerList: rankerList,
            topic: topic,
          ),
        );
      },
    );
    await getIt<MqttDLStatsController>().subscribe(topic: topic).then((Subscription? sub) async {
      if (sub != null && unsubTopic.isNotEmpty) {
        await getIt<MqttDLStatsController>().unSubscribeToMQTT(
          unsubscribeTopic: unsubTopic,
        );
        await getIt<MqttRTStatsController>().unSubscribeToMQTT(
          unsubscribeTopic: unsubTopic,
        );
      }
    });
  }
}
