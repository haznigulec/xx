import 'package:collection/collection.dart';
import 'package:piapiri_v2/core/api/mqtt_client/mqtt_dl_symbol_controller.dart';
import 'package:piapiri_v2/core/api/mqtt_client/mqtt_rt_symbol_controller.dart';
import 'package:piapiri_v2/core/api/model/proto_model/base_symbol/base_symbol.dart';
import 'package:piapiri_v2/core/bloc/matriks/matriks_bloc.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_bloc.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_event.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:tw_queue/tw_queue.dart';

class MqttClientHelper {
  /// Aktif subscribe edilmiş semboller
  static final Set<String> _activeSymbols = {};
  static final Set<String> _pendingUnsubscribe = {};

  /// Symbol subscribe
  static Future<void> subscribeSymbol({
    required MarketListModel symbol,
    Function(BaseSymbol)? onGotFirstResponse,
    Function()? onSubscribedAlready,
  }) {
    // Eğer unsubscribe bekleniyorsa sub iptal
    if (_pendingUnsubscribe.contains(symbol.symbolCode)) {
      return Future.value();
    }

    _activeSymbols.add(symbol.symbolCode);

    return getIt<TWQueue>(instanceName: 'MQTT').add(() async {
      // Yine final check yap
      if (_pendingUnsubscribe.contains(symbol.symbolCode)) return;

      await _prepareSubscription(
        symbol: symbol,
        onGotFirstResponse: onGotFirstResponse,
        onSubcribedAlready: onSubscribedAlready,
      );
    });
  }

  /// Symbol unsubscribe
  static Future<void> unsubscribeSymbol({
    required MarketListModel symbol,
  }) {
    _activeSymbols.remove(symbol.symbolCode);
    _pendingUnsubscribe.add(symbol.symbolCode);

    return getIt<TWQueue>(instanceName: 'MQTT').add(() async {
      // Eğer tekrar sub edilmişse unsubscribe iptal et
      if (_activeSymbols.contains(symbol.symbolCode)) {
        _pendingUnsubscribe.remove(symbol.symbolCode);
        return;
      }

      SymbolTypes symbolType = stringToSymbolType(symbol.type);
      Map<String, dynamic> mqttTopics = getIt<MatriksBloc>().state.topics['mqtt'];
      String topicFormat = mqttTopics['market'][symbolType.matriks]['topic'];
      bool isRealtime = mqttTopics['market'][symbolType.matriks]['qos'] == 'rt';
      String topic = topicFormat.replaceAll('%s', symbol.symbolCode);

      if (isRealtime) {
        await _unsubscribeFromRT(topic);
      } else {
        await unsubscribeFromDL(topic);
      }

      await _unsubscribeVQ(
        mqttTopics,
        symbolType.matriks,
        symbol.symbolCode,
      );

      // İş bitti → pending unsub kaldır
      _pendingUnsubscribe.remove(symbol.symbolCode);
    });
  }

  /// TimeStamp subscribe
  static Future<void> subscribeTimeStamp({
    Function(BaseSymbol)? onGotFirstResponse,
    Function()? onSubscribedAlready,
  }) {
    return getIt<TWQueue>(instanceName: 'MQTT').add(
      () async {
        String topic = 'mx/timestamp';
        await getIt<MqttRTSymbolController>().initializeAndConnect(
          onGetData: (symbol) => getIt<SymbolBloc>().add(
            SymbolUpdateListData(symbol: symbol),
          ),
        );
        if (getIt<MqttRTSymbolController>().isSubscribed(topic: topic)) {
          onSubscribedAlready?.call();
        } else {
          getIt<MqttRTSymbolController>().subscribe(
            topic: topic,
            onGotFirstResponse: onGotFirstResponse,
          );
        }
      },
    );
  }

  /// --- Internal Subscribe/Unsubscribe helpers ---

  static Future<void> subscribeToDL(
    String topic,
    Function(BaseSymbol)? onGotFirstResponse,
    Function()? onSubcribedAlready,
  ) async {
    await getIt<MqttDLSymbolController>().initializeAndConnect(
      onGetData: (symbol) {
        getIt<SymbolBloc>().add(SymbolUpdateListData(symbol: symbol));
      },
    );
    if (getIt<MqttDLSymbolController>().isSubscribed(topic: topic)) {
      onSubcribedAlready?.call();
    } else {
      getIt<MqttDLSymbolController>().subscribe(
        topic: topic,
        onGotFirstResponse: onGotFirstResponse,
      );
    }
  }

  static Future<void> _subscribeToRT(
    String topic,
    Function(BaseSymbol)? onGotFirstResponse,
    Function()? onSubcribedAlready,
  ) async {
    await getIt<MqttRTSymbolController>().initializeAndConnect(
      onGetData: (symbol) {
        getIt<SymbolBloc>().add(SymbolUpdateListData(symbol: symbol));
      },
    );
    if (getIt<MqttRTSymbolController>().isSubscribed(topic: topic)) {
      onSubcribedAlready?.call();
    } else {
      getIt<MqttRTSymbolController>().subscribe(
        topic: topic,
        onGotFirstResponse: onGotFirstResponse,
      );
    }
  }

  static Future<void> unsubscribeFromDL(
    String topic,
  ) async {
    await getIt<MqttDLSymbolController>().initializeAndConnect(
      onGetData: (symbol) => getIt<SymbolBloc>().add(
        SymbolUpdateListData(
          symbol: symbol,
        ),
      ),
    );
    getIt<MqttDLSymbolController>().unSubscribeToMQTT(
      topic: topic,
    );
  }

  static Future<void> _unsubscribeFromRT(String topic) async {
    await getIt<MqttRTSymbolController>().unSubscribeToMQTT(topic: topic);
  }

  /// Subscribe VQ topics (ama sadece aktif semboller için!)
  static Future<void> _subscribeVQ(
    Map<String, dynamic> mqttTopics,
    String symbolType,
    String symbolCode,
    Function(BaseSymbol)? onGotFirstResponse,
    Function()? onSubcribedAlready,
  ) async {
    if (!_activeSymbols.contains(symbolCode)) return;

    Map<String, dynamic> symbolDetail = mqttTopics['market'][symbolType];
    Map<String, dynamic>? symbolCodeException = _exceptionChecker(symbolDetail, symbolCode, true);

    String vqTopic = '';
    bool isRealtime = false;

    if (symbolCodeException != null) {
      vqTopic = symbolCodeException['topic'];
      isRealtime = symbolCodeException['qos'] == 'rt';
    } else if (mqttTopics['VQ'] != null && mqttTopics['VQ'][symbolType] != null) {
      vqTopic = mqttTopics['VQ'][symbolType]['topic'];
      isRealtime = mqttTopics['VQ'][symbolType]['qos'] == 'rt';
    }

    if (vqTopic.isNotEmpty) {
      String vqTopicWithSymbol = vqTopic.replaceAll('%s', symbolCode);
      if (isRealtime) {
        await _subscribeToRT(vqTopicWithSymbol, onGotFirstResponse, onSubcribedAlready);
      } else {
        await subscribeToDL(vqTopicWithSymbol, onGotFirstResponse, onSubcribedAlready);
      }
    }
  }

  /// Unsubscribe VQ topics
  static Future<void> _unsubscribeVQ(
    Map<String, dynamic> mqttTopics,
    String symbolType,
    String symbolCode,
  ) async {
    if (mqttTopics['VQ'] != null && mqttTopics['VQ'][symbolType] != null) {
      String vqTopic = mqttTopics['VQ'][symbolType]['topic'];
      bool isRealtime = mqttTopics['VQ'][symbolType]['qos'] == 'rt';
      String vqTopicWithSymbol = vqTopic.replaceAll('%s', symbolCode);
      if (isRealtime) {
        await _unsubscribeFromRT(vqTopicWithSymbol);
      } else {
        await unsubscribeFromDL(vqTopicWithSymbol);
      }
    }
  }

  /// Hazırlık fonksiyonu: normal + VQ subscribe
  static Future<void> _prepareSubscription({
    required MarketListModel symbol,
    Function(BaseSymbol)? onGotFirstResponse,
    Function()? onSubcribedAlready,
  }) async {
    // Başlangıçta pending unsub check
    if (_pendingUnsubscribe.contains(symbol.symbolCode)) {
      return;
    }

    SymbolTypes symbolType = stringToSymbolType(symbol.type);
    Map<String, dynamic> mqttTopics = getIt<MatriksBloc>().state.topics['mqtt'];
    Map<String, dynamic> symbolDetail = mqttTopics['market'][symbolType.matriks];
    Map<String, dynamic>? symbolCodeException = _exceptionChecker(symbolDetail, symbol.symbolCode, false);

    String topicFormat = symbolCodeException?['topic'] ?? symbolDetail['topic'];
    bool isRealtime = (symbolCodeException?['qos'] ?? symbolDetail['qos']) == 'rt';
    String topic = topicFormat.replaceAll('%s', symbol.symbolCode);

    // Final check
    if (_pendingUnsubscribe.contains(symbol.symbolCode)) {
      return;
    }

    if (isRealtime) {
      await _subscribeToRT(topic, onGotFirstResponse, onSubcribedAlready);
    } else {
      await subscribeToDL(topic, onGotFirstResponse, onSubcribedAlready);
    }

    // VQ sub öncesinde de check
    if (_activeSymbols.contains(symbol.symbolCode) && !_pendingUnsubscribe.contains(symbol.symbolCode)) {
      await _subscribeVQ(
        mqttTopics,
        symbolType.matriks,
        symbol.symbolCode,
        onGotFirstResponse,
        onSubcribedAlready,
      );
    }
  }

  /// Re-subscribe helper
  void reSubscribeSymbols(bool isConnected) {
    if (!isConnected) {
      List<MarketListModel> selectedListItems = List.from(getIt<SymbolBloc>().state.watchingItems);

      getIt<SymbolBloc>().add(
        SymbolSubTopicsEvent(symbols: selectedListItems),
      );
    }
  }

  /// Exception checker
  static Map<String, dynamic>? _exceptionChecker(
    Map<String, dynamic> symbolDetail,
    String symbolCode,
    bool checkVq,
  ) {
    if (symbolDetail['additionalException'] != null) {
      List<dynamic> symbolCodeExceptions = (symbolDetail['additionalException'] as List<dynamic>)
          .where((element) => element['code'] == 'symbolCode')
          .toList();

      if (symbolCodeExceptions.isNotEmpty) {
        Map<String, dynamic>? symbolCodeException = symbolCodeExceptions.firstWhereOrNull(
          (element) =>
              (element['value'] as List<dynamic>).contains(symbolCode) &&
              element['topic'].toString().endsWith('vq') == checkVq,
        );
        return symbolCodeException;
      }
    }
    return null;
  }

  /// Full disconnect
  static void disconnect() {
    getIt<MqttRTSymbolController>().disconnect();
    getIt<MqttDLSymbolController>().disconnect();
  }
}
