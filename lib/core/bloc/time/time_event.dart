import 'package:piapiri_v2/core/bloc/bloc/bloc_event.dart';
import 'package:piapiri_v2/core/gen/Timestamp/Timestamp.pb.dart';

abstract class TimeEvent extends PEvent {}

class TimeConnectEvent extends TimeEvent {
  TimeConnectEvent();
}

class TimeUpdateEvent extends TimeEvent {
  final TimeMessage time;
  TimeUpdateEvent(this.time);
}
