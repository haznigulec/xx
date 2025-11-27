class Trade {
  String symbol;
  String orderNo;
  double price;
  int quantity;
  String activeBidOrAsk;
  int timestamp;
  String buyer;
  String seller;
  bool isTradeEx;

  Trade(
      {required this.symbol,
      required this.orderNo,
      required this.price,
      required this.quantity,
      required this.activeBidOrAsk,
      required this.timestamp,
      required this.buyer,
      required this.seller,
      required this.isTradeEx,});
}
