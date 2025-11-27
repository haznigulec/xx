class UsSymbolTrade {
  final String id;
  final double price;
  final int size;
  final int exchange;
  final List<int>? conditions;
  final int? timestamp;

  UsSymbolTrade({
    required this.id,
    required this.price,
    required this.size,
    required this.exchange,
    this.conditions,
    this.timestamp,
  });

  UsSymbolTrade copyWith({
    String? id,
    double? price,
    int? size,
    int? exchange,
    List<int>? conditions,
    int? timestamp,
  }) =>
      UsSymbolTrade(
        id: id ?? this.id,
        price: price ?? this.price,
        size: size ?? this.size,
        exchange: exchange ?? this.exchange,
        conditions: conditions ?? this.conditions,
        timestamp: timestamp ?? this.timestamp,
      );

  factory UsSymbolTrade.fromJson(Map<String, dynamic> json) => UsSymbolTrade(
        id: json['i'] as String,
        price: (json['p'] as num).toDouble(),
        size: json['s'] as int,
        exchange: json['x'] as int,
        conditions: (json['c'] as List?)?.map((e) => e as int).toList(),
        timestamp: json['t'] as int?,
      );

  Map<String, dynamic> toJson() {
    final data = {
      'i': id,
      'p': price,
      's': size,
      'x': exchange,
    };
    if (conditions != null) data['c'] = conditions!;
    if (timestamp != null) data['t'] = timestamp!;
    return data;
  }
}
