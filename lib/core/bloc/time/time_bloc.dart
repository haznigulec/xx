import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piapiri_v2/core/api/mqtt_client/mqtt_client_helper.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/time/time_event.dart';
import 'package:piapiri_v2/core/bloc/time/time_state.dart';
import 'package:piapiri_v2/core/gen/Timestamp/Timestamp.pb.dart';

class TimeBloc extends PBloc<TimeState> {
  TimeBloc() : super(initialState: const TimeState()) {
    on<TimeConnectEvent>(_onConnect);
    on<TimeUpdateEvent>(_onUpdate);
  }

  FutureOr<void> _onConnect(
    TimeConnectEvent event,
    Emitter<TimeState> emit,
  ) {
    MqttClientHelper.subscribeTimeStamp();
  }

  FutureOr<void> _onUpdate(TimeUpdateEvent event, Emitter<TimeState> emit) {
    TimeMessage? mxTime;
    TimeMessage? bistPPTime;
    TimeMessage? bistViopTime;
    TimeMessage? bistEXTime;
    switch (event.time.source) {
      case 'MX':
        mxTime = event.time;
        break;
      case 'BISTPP':
        bistPPTime = event.time;
        break;
      case 'BISTEX':
        bistEXTime = event.time;
        break;
      case 'BISTVIOP':
        bistViopTime = event.time;
        break;
      default:
        break;
    }

    DateTime? now = mxTime != null
        ? DateTime.fromMicrosecondsSinceEpoch(
            mxTime.timestamp.toInt(),
          )
        : null;
    emit(
      state.copyWith(
        mxTime: mxTime,
        bistPPTime: bistPPTime,
        bistEXTime: bistEXTime,
        bistViopTime: bistViopTime,
        now: now,
      ),
    );
  }
}
