class UsSymbolQuote {
  final double bidPrice;
  final int bidSize;
  final double askPrice;
  final int askSize;
  final int timestamp;

  UsSymbolQuote({
    required this.bidPrice,
    required this.bidSize,
    required this.askPrice,
    required this.askSize,
    required this.timestamp,
  });

  UsSymbolQuote copyWith({
    double? bidPrice,
    int? bidSize,
    double? askPrice,
    int? askSize,
    int? timestamp,
  }) =>
      UsSymbolQuote(
        bidPrice: bidPrice ?? this.bidPrice,
        bidSize: bidSize ?? this.bidSize,
        askPrice: askPrice ?? this.askPrice,
        askSize: askSize ?? this.askSize,
        timestamp: timestamp ?? this.timestamp,
      );

  factory UsSymbolQuote.fromJson(Map<String, dynamic> json) => UsSymbolQuote(
        bidPrice: (json['p'] as num).toDouble(),
        bidSize: json['s'] as int,
        askPrice: (json['P'] as num).toDouble(),
        askSize: json['S'] as int,
        timestamp: json['t'] as int,
      );

  Map<String, dynamic> toJson() => {
        'p': bidPrice,
        's': bidSize,
        'P': askPrice,
        'S': askSize,
        't': timestamp,
      };
}
