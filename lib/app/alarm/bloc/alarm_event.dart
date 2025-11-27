import 'package:flutter/material.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_event.dart';
import 'package:piapiri_v2/core/model/alarm_validity_enum.dart';

abstract class AlarmEvent extends PEvent {}

class SetPriceAlarmEvent extends AlarmEvent {
  final String condition;
  final double price;
  final String symbolName;
  final AlarmValidityEnum validity;
  final String note;
  final Function(bool) callback;

  SetPriceAlarmEvent({
    required this.condition,
    required this.price,
    required this.symbolName,
    required this.validity,
    required this.note,
    required this.callback,
  });
}

class SetNewsAlarmEvent extends AlarmEvent {
  final String symbolName;

  SetNewsAlarmEvent({
    required this.symbolName,
  });
}

class SetPriceAlarmStatusEvent extends AlarmEvent {
  final String alarmId;

  SetPriceAlarmStatusEvent({
    required this.alarmId,
  });
}

class GetAlarmsEvent extends AlarmEvent {}

class RemoveAlarmEvent extends AlarmEvent {
  final String id;
  final VoidCallback callback;

  RemoveAlarmEvent({
    required this.id,
    required this.callback,
  });
}

class ResetAlarmEvent extends AlarmEvent {}
