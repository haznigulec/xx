import 'package:piapiri_v2/core/api/model/proto_model/booklet/booklet_model.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_event.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';

abstract class BookletEvent extends PEvent {}

class ConnectEvent extends BookletEvent {
  final MarketListModel symbol;

  ConnectEvent({
    required this.symbol,
  });
}

class UpdateBookletEvent extends BookletEvent {
  final TopOfTheBookMessageModel booklet;

  UpdateBookletEvent({
    required this.booklet,
  });
}

class DisconnectEvent extends BookletEvent {}
