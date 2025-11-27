import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piapiri_v2/app/booklet/bloc/booklet_event.dart';
import 'package:piapiri_v2/app/booklet/bloc/booklet_state.dart';
import 'package:piapiri_v2/core/api/model/proto_model/booklet/booklet_model.dart';
import 'package:piapiri_v2/core/api/mqtt_client/mqtt_depth_controller.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/bloc/matriks/matriks_bloc.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';

class BookletBloc extends PBloc<BookletState> {
  BookletBloc() : super(initialState: const BookletState()) {
    on<ConnectEvent>(_onConnect);
    on<UpdateBookletEvent>(_onUpdateBooklet);
    on<DisconnectEvent>(_onDisconnect);
  }

  FutureOr<void> _onConnect(
    ConnectEvent event,
    Emitter<BookletState> emit,
  ) async {
    emit(
      state.copyWith(
        type: getIt<MqttDepthController>().isConnectedToBroker() ? PageState.success : PageState.loading,
      ),
    );
    String matriksSymbolType = stringToSymbolType(event.symbol.type).matriks;
    Map<String, dynamic> topics = getIt<MatriksBloc>().state.topics['mqtt'];
    Map<String, dynamic> bookletTopics = topics['booklet'];
    await getIt<MqttDepthController>().initializeAndConnect(
      isRealtime: bookletTopics[matriksSymbolType]?['qos'] == 'rt',
      onGetDepthData: (_) {},
      onGetDepthStatsData: (_) {},
      onGetDepthExtendedData: (_) {},
      onSubscribe: () {},
      onSubscribed: () {},
      onGetBookletData: (TopOfTheBookMessageModel booklet) {
        add(UpdateBookletEvent(booklet: booklet));
      },
    );
    await getIt<MqttDepthController>().subscribeBooklet(symbol: event.symbol);
    await Future.delayed(const Duration(seconds: 5), () {
      if (state.booklet == null) {
        emit(
          state.copyWith(
            type: PageState.success,
          ),
        );
      }
    });
  }

  FutureOr<void> _onUpdateBooklet(
    UpdateBookletEvent event,
    Emitter<BookletState> emit,
  ) {
    emit(
      state.copyWith(
        booklet: event.booklet,
        type: PageState.success,
      ),
    );
  }

  FutureOr<void> _onDisconnect(
    DisconnectEvent event,
    Emitter<BookletState> emit,
  ) {
    getIt<MqttDepthController>().disconnect();
    emit(
      const BookletState(
        type: PageState.initial,
        booklet: null,
      ),
    );
  }
}
