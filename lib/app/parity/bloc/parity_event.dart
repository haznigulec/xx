import 'package:piapiri_v2/core/bloc/bloc/bloc_event.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/parity_enum.dart';

abstract class ParityEvent extends PEvent {}

class ParitySetMarketEvent extends ParityEvent {
  final ParityEnum parity;
  final int parityIndex;
  final Function(List<MarketListModel>)? callback;

  ParitySetMarketEvent({
    required this.parity,
    required this.parityIndex,
    this.callback,
  });
}
