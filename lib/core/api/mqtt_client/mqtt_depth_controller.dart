import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:p_core/utils/log_utils.dart';
import 'package:piapiri_v2/core/api/client/matriks_mqtt_client.dart';
import 'package:piapiri_v2/core/api/model/proto_model/booklet/booklet_model.dart';
import 'package:piapiri_v2/core/api/model/proto_model/booklet/booklet_model_extension.dart';
import 'package:piapiri_v2/core/api/model/proto_model/depth/depth_model.dart';
import 'package:piapiri_v2/core/api/model/proto_model/depth/depth_proto_extensions.dart';
import 'package:piapiri_v2/core/api/model/proto_model/depthstats/depthstats_model.dart';
import 'package:piapiri_v2/core/api/model/proto_model/depthstats/depthstats_proto_extensions.dart';
import 'package:piapiri_v2/core/api/mqtt_client/mqtt_client_helper.dart';
import 'package:piapiri_v2/core/api/mqtt_client/mqtt_client_safe_extension.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/bloc/matriks/matriks_bloc.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';

class MqttDepthController extends ChangeNotifier {
  MqttServerClient? mqttClient;
  late Function(Depth) _onGetDepthData;
  late Function(DepthStats) _onGetDepthStatshData;
  late Function(Depth) _onGetDepthExtendedData;
  late Function(TopOfTheBookMessageModel) _onGetBookletData;
  late Function() _onSubscribe;
  late Function() _onSubscribed;

  Future<void> initializeAndConnect({
    bool isRealtime = false,
    required Function(Depth) onGetDepthData,
    required Function(DepthStats) onGetDepthStatsData,
    required Function(Depth) onGetDepthExtendedData,
    required Function(TopOfTheBookMessageModel) onGetBookletData,
    required Function() onSubscribe,
    required Function() onSubscribed,
  }) async {
    _onGetDepthData = onGetDepthData;
    _onGetDepthStatshData = onGetDepthStatsData;
    _onGetDepthExtendedData = onGetDepthExtendedData;
    _onGetBookletData = onGetBookletData;
    _onSubscribe = onSubscribe;
    _onSubscribed = onSubscribed;
    try {
      if (!isConnectedToBroker()) {
        String password = await getIt<PPApi>().matriksService.getMatriksTokenByQueue();
        mqttClient = await MatriksMQTTClient().connect(
          endpoint: isRealtime
              ? getIt<MatriksBloc>().state.endpoints?.mqtt?.mxDepth?.qos?.wss?.rt ?? ''
              : getIt<MatriksBloc>().state.endpoints?.mqtt?.mxDepth?.qos?.wss?.dl ?? '',
          clientIdentifier: 'DEPTH',
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

  Future onSubscribed(String topic) async {
    _onSubscribed();
  }

  Future onUnSubscribed(String? topic) async {
    LogUtils.pLog('unsubscribed on topic: $topic');
  }

  Future onDisconnected() async {
    LogUtils.pLog('disconnected');

    return true;
  }

  Future subscribe({
    required MarketListModel symbol,
    DepthType depthType = DepthType.depth,
  }) async {
    _onSubscribe();
    SymbolTypes symbolType = stringToSymbolType(symbol.type);
    Map<String, dynamic> depthTopics = getIt<MatriksBloc>().state.topics['mqtt'][depthType.name][symbolType.matriks];
    String topicFormat = depthTopics['topic'] ?? '';
    if (topicFormat.isNotEmpty) {
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
  }

  Future subscribeBooklet({
    required MarketListModel symbol,
  }) async {
    _onSubscribe();
    SymbolTypes symbolType = stringToSymbolType(symbol.type);
    Map<String, dynamic> bookletTopics = getIt<MatriksBloc>().state.topics['mqtt']['booklet'][symbolType.matriks];
    String topicFormat = bookletTopics['topic'] ?? '';
    if (topicFormat.isNotEmpty) {
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
  }

  Future unSubscribeBookletToMQTT({
    required String symbolName,
  }) async {
    String topic = 'mx/booklet/$symbolName';

    final isActiveSubs = mqttClient?.hasSubscriptionsManager() ?? false;
    if (!isActiveSubs) return;

    MqttSubscriptionStatus? status = mqttClient?.getSubscriptionsStatus(topic);
    if (status == MqttSubscriptionStatus.active) {
      mqttClient?.unsubscribe(topic);
    }
  }

  Future unSubscribeToMQTT({
    required String symbolName,
    DepthType depthType = DepthType.depth,
  }) async {
    String topic = 'mx/depth/$symbolName@lvl2';
    if (depthType == DepthType.depthstats) {
      topic = 'mx/depthstats/$symbolName';
    }
    if (depthType == DepthType.depthExtended) {
      topic = 'mx/depth/$symbolName@lvl3';
    }

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
    mqttClient?.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) async {
      final MqttMessage message = c[0].payload;
      final String topic = c[0].topic;
      if (message is MqttPublishMessage && !topic.endsWith('/messenger')) {
        final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
        if (topic.contains('booklet')) {
          final TopOfTheBookMessageModel topOfTheBookMessage =
              topOfBookBytesToPiapiri(message.payload.message.buffer.asUint8List());
          LogUtils.pLog('TOP OF THE BOOK::');
          _onGetBookletData(topOfTheBookMessage);
        } else if (topic.contains('depthstats')) {
          final DepthStats depthStats = depthstatsBytesToPiapiri(message.payload.message.buffer.asUint8List());
          _onGetDepthStatshData(depthStats);
          LogUtils.pLog('Depth::');
        } else {
          if (topic.endsWith('@lvl3')) {
            final Depth depthExtended = depthBytesToPiapiri(message.payload.message.buffer.asUint8List());
            LogUtils.pLog('Depth::');
            _onGetDepthExtendedData(depthExtended);
          } else {
            LogUtils.pLog('Depth::');
            final Depth depth = depthBytesToPiapiri(message.payload.message.buffer.asUint8List());
            _onGetDepthData(depth);
          }
        }
        notifyListeners();
      }
    });
  }

  bool isDerivative(String topic) {
    return topic.contains('/derivative');
  }
}

enum DepthType {
  depth,
  depthExtended,
  depthstats,
}
