import 'package:piapiri_v2/core/bloc/bloc/bloc_event.dart';

abstract class StageAnalysisEvent extends PEvent {}

class StageAnalysisListEvent extends StageAnalysisEvent {
  final String symbol;

  StageAnalysisListEvent({
    required this.symbol,
  });
}
