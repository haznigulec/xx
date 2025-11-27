import 'package:piapiri_v2/core/bloc/bloc/bloc_event.dart';

abstract class TwitterEvent extends PEvent {}

class GetListEvent extends TwitterEvent {
  final String symbol;

  GetListEvent({
    required this.symbol,
  });
}
