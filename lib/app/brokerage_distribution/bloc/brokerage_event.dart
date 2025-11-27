import 'package:piapiri_v2/core/bloc/bloc/bloc_event.dart';

abstract class BrokerageEvent extends PEvent {}

class BrokerageFetchEvent extends BrokerageEvent {
  final String symbol;
  final int top;
  final DateTime? startDate;
  final DateTime? endDate;

  BrokerageFetchEvent({
    required this.symbol,
    required this.top,
    this.startDate,
    this.endDate,
  });
}
