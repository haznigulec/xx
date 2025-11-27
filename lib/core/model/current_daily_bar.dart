class CurrentDailyBar {
  String? symbol;
  String? timeUtc;
  double? open;
  double? high;
  double? low;
  double? close;
  double? volume;
  double? vwap;
  int? tradeCount;

  CurrentDailyBar({
    this.symbol,
    this.timeUtc,
    this.open,
    this.high,
    this.low,
    this.close,
    this.volume,
    this.vwap,
    this.tradeCount,
  });

  CurrentDailyBar.fromJson(Map<String, dynamic> json) {
    symbol = json['symbol'];
    timeUtc = DateTime.fromMillisecondsSinceEpoch(json['t']).add(const Duration(hours: 3)).toIso8601String();
    open = json['o']?.toDouble();
    high = json['h']?.toDouble();
    low = json['l']?.toDouble();
    close = json['c']?.toDouble();
    volume = json['v']?.toDouble();
    vwap = json['vw']?.toDouble();
    tradeCount = json['n'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['symbol'] = symbol;
    data['timeUtc'] = timeUtc;
    data['open'] = open;
    data['high'] = high;
    data['low'] = low;
    data['close'] = close;
    data['volume'] = volume;
    data['vwap'] = vwap;
    data['tradeCount'] = tradeCount;
    return data;
  }
}
