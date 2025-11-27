import 'package:piapiri_v2/core/bloc/bloc/bloc_event.dart';

abstract class AdvicesEvent extends PEvent {}

class GetAdvicesEvent extends AdvicesEvent {
  final String? symbolName;
  final bool fetchRoboSignals;
  final String mainGroup;

  GetAdvicesEvent({
    this.symbolName,
    this.fetchRoboSignals = false,
    required this.mainGroup,
  });
}

class GetAdviceHistoryEvent extends AdvicesEvent {
  final String? symbolName;
  final String mainGroup;
  final int year;

  GetAdviceHistoryEvent({
    this.symbolName,
    required this.mainGroup,
    required this.year,
  });
}
