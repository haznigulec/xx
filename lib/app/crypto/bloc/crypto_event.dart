import 'package:piapiri_v2/core/bloc/bloc/bloc_event.dart';
import 'package:piapiri_v2/core/model/crypto_enum.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';

abstract class CryptoEvent extends PEvent {}

class CryptoSetMarketEvent extends CryptoEvent {
  final CryptoEnum selectedMarket;
  final Function(List<MarketListModel>)? callback;

  CryptoSetMarketEvent({
    required this.selectedMarket,
    this.callback,
  });
}
