class BookletModel {
  final int orderID;
  final int timestamp;
  final double quantity;
  final double price;

  BookletModel({
    required this.orderID,
    required this.timestamp,
    required this.quantity,
    required this.price,
  });

  factory BookletModel.fromJson(Map<String, dynamic> json) {
    return BookletModel(
      orderID: json['orderID'] ?? 0,
      timestamp: json['timestamp'] ?? 0,
      quantity: (json['quantity'] ?? 0).toDouble(),
      price: (json['price'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderID': orderID,
      'timestamp': timestamp,
      'quantity': quantity,
      'price': price,
    };
  }
}

enum TopOfTheBookAction { I, U, D } // Insert, Update, Delete

enum TopOfTheBookBidAsk { A, B } // Ask, Bid

class TopOfTheBookMessageModel {
  final String symbol;
  final List<BookletModel> asks;
  final List<BookletModel> bids;
  final TopOfTheBookAction action;
  final TopOfTheBookBidAsk bidAsk;
  final int affectedRow;

  TopOfTheBookMessageModel({
    required this.symbol,
    required this.asks,
    required this.bids,
    required this.action,
    required this.bidAsk,
    required this.affectedRow,
  });

  factory TopOfTheBookMessageModel.fromJson(Map<String, dynamic> json) {
    return TopOfTheBookMessageModel(
      symbol: json['symbol'] ?? '',
      asks: (json['asks'] as List<dynamic>? ?? []).map((e) => BookletModel.fromJson(e)).toList(),
      bids: (json['bids'] as List<dynamic>? ?? []).map((e) => BookletModel.fromJson(e)).toList(),
      action: TopOfTheBookAction.values.firstWhere(
        (e) => e.name == (json['action'] ?? 'I'),
        orElse: () => TopOfTheBookAction.I,
      ),
      bidAsk: TopOfTheBookBidAsk.values.firstWhere(
        (e) => e.name == (json['bidAsk'] ?? 'A'),
        orElse: () => TopOfTheBookBidAsk.A,
      ),
      affectedRow: json['affectedRow'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'asks': asks.map((e) => e.toJson()).toList(),
      'bids': bids.map((e) => e.toJson()).toList(),
      'action': action.name,
      'bidAsk': bidAsk.name,
      'affectedRow': affectedRow,
    };
  }
}
