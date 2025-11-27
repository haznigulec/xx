class UsSymbolBar {
  final double open;
  final double high;
  final double low;
  final double close;
  final double volume;
  final double? volumeWeight; // VWAP
  final int? numberOfTrades; // sadece dakika seviyesinde olabilir
  final int? timestamp;

  UsSymbolBar({
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
    this.volumeWeight,
    this.numberOfTrades,
    this.timestamp,
  });

  UsSymbolBar copyWith({
    double? open,
    double? high,
    double? low,
    double? close,
    double? volume,
    double? volumeWeight,
    int? numberOfTrades,
    int? timestamp,
  }) =>
      UsSymbolBar(
        open: open ?? this.open,
        high: high ?? this.high,
        low: low ?? this.low,
        close: close ?? this.close,
        volume: volume ?? this.volume,
        volumeWeight: volumeWeight ?? this.volumeWeight,
        numberOfTrades: numberOfTrades ?? this.numberOfTrades,
        timestamp: timestamp ?? this.timestamp,
      );

  factory UsSymbolBar.fromJson(Map<String, dynamic> json) => UsSymbolBar(
        open: (json['o'] as num).toDouble(),
        high: (json['h'] as num).toDouble(),
        low: (json['l'] as num).toDouble(),
        close: (json['c'] as num).toDouble(),
        volume: (json['v'] as num).toDouble(),
        volumeWeight: json['vw'] != null ? (json['vw'] as num).toDouble() : null,
        numberOfTrades: json['n'] as int?,
        timestamp: json['t'] as int?,
      );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'o': open,
      'h': high,
      'l': low,
      'c': close,
      'v': volume,
    };
    if (volumeWeight != null) data['vw'] = volumeWeight;
    if (numberOfTrades != null) data['n'] = numberOfTrades;
    if (timestamp != null) data['t'] = timestamp;
    return data;
  }
}
