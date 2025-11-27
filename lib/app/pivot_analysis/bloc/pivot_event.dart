import 'package:piapiri_v2/core/bloc/bloc/bloc_event.dart';

abstract class PivotEvent extends PEvent {}

class GetPivotAnalysisEvent extends PivotEvent {
  final String symbol;

  GetPivotAnalysisEvent({
    required this.symbol,
  });
}
