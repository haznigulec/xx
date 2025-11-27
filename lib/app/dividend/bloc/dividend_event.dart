import 'package:piapiri_v2/core/bloc/bloc/bloc_event.dart';

abstract class DividendEvent extends PEvent {}

class GetSymbolDividentEvent extends DividendEvent {
  final String symbolName;
  GetSymbolDividentEvent({
    required this.symbolName,
  });
}

class GetSymbolDividentHistoryEvent extends DividendEvent {
  final String symbolName;
  GetSymbolDividentHistoryEvent({
    required this.symbolName,
  });
}

class GetIncomingDividentEvent extends DividendEvent {
  GetIncomingDividentEvent();
}
