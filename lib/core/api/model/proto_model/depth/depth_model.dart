import 'package:piapiri_v2/core/gen/DepthTable/DepthTable.pb.dart';

class Depth {
  String symbol;
  String dateSymbol;
  int timestamp;
  List<DepthCell> asks;
  List<DepthCell> bids;
  DepthTableMessage_Action action;
  DepthTableMessage_BidAsk bidAsk;
  int row;
  double actionPrice;
  int actionQuantity;
  int actionOrderCount;

  Depth({
    required this.symbol,
    required this.dateSymbol,
    required this.timestamp,
    required this.asks,
    required this.bids,
    required this.action,
    required this.bidAsk,
    required this.row,
    required this.actionPrice,
    required this.actionQuantity,
    required this.actionOrderCount,
  });
}
