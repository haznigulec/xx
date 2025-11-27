import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piapiri_v2/app/depth/bloc/depth_event.dart';
import 'package:piapiri_v2/app/depth/bloc/depth_state.dart';
import 'package:piapiri_v2/core/api/model/proto_model/trade/trade_model.dart';
import 'package:piapiri_v2/core/api/mqtt_client/mqtt_depth_controller.dart';
import 'package:piapiri_v2/core/api/model/proto_model/depth/depth_model.dart';
import 'package:piapiri_v2/core/api/model/proto_model/depthstats/depthstats_model.dart';
import 'package:piapiri_v2/core/api/mqtt_client/mqtt_trade_controller.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/bloc/matriks/matriks_bloc.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';

class DepthBloc extends PBloc<DepthState> {
  DepthBloc() : super(initialState: const DepthState()) {
    on<ConnectDepthEvent>(_onConnectDepth);
    on<ConnectTradeEvent>(_onConnectTrade);
    on<UpdateDepthEvent>(_onUpdateDepth);
    on<UpdateTradeEvent>(_onUpdateTrade);
    on<UpdateStatsEvent>(_onUpdateStats);
    on<UpdateExtendedEvent>(_onUpdateExtended);
    on<SetStageEvent>(_onSetStage);
    on<DisconnectEvent>(_onDisconnect);
  }

  FutureOr<void> _onConnectDepth(
    ConnectDepthEvent event,
    Emitter<DepthState> emit,
  ) async {
    MqttDepthController mqttDepthController = getIt<MqttDepthController>();
    bool isConnected = mqttDepthController.isConnectedToBroker();
    emit(
      state.copyWith(
        type: isConnected ? PageState.success : PageState.loading,
      ),
    );
    int stage = event.stage;
    int extendedStage = state.extendedStage;
    String matriksSymbolType = stringToSymbolType(event.symbol.type).matriks;
    Map<String, dynamic> topics = getIt<MatriksBloc>().state.topics['mqtt'];
    Map<String, dynamic> depthTopics = topics['depth'];
    Map<String, dynamic>? depthExtendedTopics = topics['depthExtended'];
    bool isExtendedEnabled = depthExtendedTopics != null && depthExtendedTopics[matriksSymbolType] != null;
    if (event.stage > 10) {
      stage = 10;
      if (isExtendedEnabled) {
        extendedStage = event.stage - 10;
      } else {
        extendedStage = 0;
      }
    } else {
      extendedStage = 0;
    }
    await mqttDepthController.initializeAndConnect(
      isRealtime: depthTopics[matriksSymbolType]?['qos'] == 'rt',
      onGetDepthData: (Depth depth) {
        add(UpdateDepthEvent(depth: depth));
      },
      onGetDepthStatsData: (DepthStats depthStats) {
        add(UpdateStatsEvent(depthStats: depthStats));
      },
      onGetDepthExtendedData: (Depth depthExtended) {
        add(UpdateExtendedEvent(depth: depthExtended));
      },
      onSubscribe: () {},
      onSubscribed: () {},
      onGetBookletData: (_) {},
    );
    await mqttDepthController.subscribe(symbol: event.symbol);
    if (extendedStage > 0 && isExtendedEnabled) {
      await mqttDepthController.subscribe(
        symbol: event.symbol,
        depthType: DepthType.depthExtended,
      );
    }
    if (event.isDepthStatsEnabled) {
      await mqttDepthController.subscribe(
        symbol: event.symbol,
        depthType: DepthType.depthstats,
      );
    }
    emit(
      extendedStage == 0
          ? DepthState(
              type: state.type,
              depth: state.depth,
              depthStats: state.depthStats,
              stage: isConnected ? state.stage : stage,
              extendedStage: extendedStage,
              tradeList: state.tradeList,
            )
          : state.copyWith(
              stage: isConnected ? state.stage : stage,
              extendedStage: extendedStage,
            ),
    );
    await Future.delayed(const Duration(seconds: 5), () {
      if (state.depth == null) {
        emit(
          state.copyWith(
            type: PageState.success,
          ),
        );
      }
    });
  }

  FutureOr<void> _onConnectTrade(
    ConnectTradeEvent event,
    Emitter<DepthState> emit,
  ) async {
    emit(
      state.copyWith(
        type: getIt<MqttTradeController>().isConnectedToBroker() ? PageState.success : PageState.loading,
      ),
    );
    String matriksSymbolType = stringToSymbolType(event.symbol.type).matriks;

    await getIt<MqttTradeController>().initializeAndConnect(
      isRealtime: getIt<MatriksBloc>().state.topics['mqtt']['trade'][matriksSymbolType]?['qos'] == 'rt',
      onGetData: (trade) => add(UpdateTradeEvent(trade: trade)),
    );
    await getIt<MqttTradeController>().subscribe(symbol: event.symbol);
  }

  FutureOr<void> _onUpdateDepth(
    UpdateDepthEvent event,
    Emitter<DepthState> emit,
  ) {
    emit(
      state.copyWith(
        type: PageState.success,
        depth: event.depth,
      ),
    );
  }

  FutureOr<void> _onUpdateTrade(
    UpdateTradeEvent event,
    Emitter<DepthState> emit,
  ) {
    List<Trade> stateTradeList = List.from(state.tradeList);
    stateTradeList.insert(0, event.trade);
    if (stateTradeList.length > 20) {
      stateTradeList = stateTradeList.sublist(0, 20);
    }
    emit(
      state.copyWith(
        type: PageState.success,
        tradeList: stateTradeList,
      ),
    );
  }

  FutureOr<void> _onUpdateStats(
    UpdateStatsEvent event,
    Emitter<DepthState> emit,
  ) {
    emit(
      state.copyWith(
        type: PageState.success,
        depthStats: event.depthStats,
      ),
    );
  }

  FutureOr<void> _onUpdateExtended(
    UpdateExtendedEvent event,
    Emitter<DepthState> emit,
  ) {
    emit(
      state.copyWith(
        type: PageState.success,
        depthExtended: event.depth,
      ),
    );
  }

  FutureOr<void> _onSetStage(
    SetStageEvent event,
    Emitter<DepthState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    int stage = event.stage;
    int extendedStage = state.extendedStage;
    if (event.stage > 10) {
      stage = 10;
      extendedStage = event.stage - 10;
    } else {
      extendedStage = 0;
    }
    if (extendedStage > 0) {
      String matriksSymbolType = stringToSymbolType(event.symbol.type).matriks;

      await getIt<MqttDepthController>().initializeAndConnect(
        isRealtime: getIt<MatriksBloc>().state.topics['mqtt']['depth']?[matriksSymbolType]?['qos'] == 'rt',
        onGetDepthData: (Depth depth) {
          add(UpdateDepthEvent(depth: depth));
        },
        onGetDepthStatsData: (DepthStats depthStats) {
          add(UpdateStatsEvent(depthStats: depthStats));
        },
        onGetDepthExtendedData: (Depth depthExtended) {
          add(UpdateExtendedEvent(depth: depthExtended));
        },
        onSubscribe: () {},
        onSubscribed: () {},
        onGetBookletData: (_) {},
      );
      await getIt<MqttDepthController>().subscribe(
        symbol: event.symbol,
        depthType: DepthType.depthExtended,
      );
    }

    emit(
      extendedStage == 0
          ? DepthState(
              type: PageState.success,
              depth: state.depth,
              depthStats: state.depthStats,
              stage: stage,
              extendedStage: extendedStage,
              tradeList: state.tradeList,
            )
          : state.copyWith(
              type: PageState.success,
              stage: stage,
              extendedStage: extendedStage,
            ),
    );
  }

  FutureOr<void> _onDisconnect(
    DisconnectEvent event,
    Emitter<DepthState> emit,
  ) {
    getIt<MqttDepthController>().disconnect();
    getIt<MqttTradeController>().disconnect();
    emit(
      const DepthState(
        type: PageState.initial,
        depth: null,
        depthStats: null,
        stage: 3,
        extendedStage: 0,
        tradeList: [],
      ),
    );
  }

}
