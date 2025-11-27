import 'package:piapiri_v2/core/model/us_market_status_enum.dart';

class UsSymbolSnapshot {
  final String? name;
  final String ticker;
  final String? type;
  final UsMarketStatus? marketStatus;
  final SessionData? session;
  final double? fmv;
  final bool isSubscribed;

  UsSymbolSnapshot({
    this.name,
    required this.ticker,
    this.type,
    this.marketStatus,
    this.session,
    this.fmv,
    this.isSubscribed = false,
  });

  factory UsSymbolSnapshot.fromJson(Map<String, dynamic> json) {
    return UsSymbolSnapshot(
      name: json['name'],
      ticker: json['ticker'],
      type: json['type'],
      marketStatus: UsMarketStatus.values.firstWhere((e) => e.value == json['market_status']),
      session: json['session'] != null ? SessionData.fromJson(json['session']) : null,
      fmv: (json['fmv'] as num?)?.toDouble(),
    );
  }

  UsSymbolSnapshot copyWith({
    String? name,
    String? ticker,
    String? type,
    UsMarketStatus? marketStatus,
    SessionData? session,
    double? fmv,
    bool? isSubscribed,
  }) {
    return UsSymbolSnapshot(
      name: name ?? this.name,
      ticker: ticker ?? this.ticker,
      type: type ?? this.type,
      marketStatus: marketStatus ?? this.marketStatus,
      session: session ?? this.session,
      fmv: fmv ?? this.fmv,
      isSubscribed: isSubscribed ?? this.isSubscribed,
    );
  }
}

class SessionData {
  final double? price;
  final double? earlyTradingChange;
  final double? earlyTradingChangePercent;
  final double? lateTradingChange;
  final double? lateTradingChangePercent;
  final double? regularTradingChange;
  final double? regularTradingChangePercent;
  final double? close;
  final double? high;
  final double? low;
  final double? open;
  final double? volume;
  final double? previousClose;
  final int? timestamp;

  SessionData({
    this.price,
    this.earlyTradingChange,
    this.earlyTradingChangePercent,
    this.lateTradingChange,
    this.lateTradingChangePercent,
    this.regularTradingChange,
    this.regularTradingChangePercent,
    this.close,
    this.high,
    this.low,
    this.open,
    this.volume,
    this.previousClose,
    this.timestamp,
  });

  SessionData copyWith({
    double? price,
    double? earlyTradingChange,
    double? earlyTradingChangePercent,
    double? lateTradingChange,
    double? lateTradingChangePercent,
    double? regularTradingChange,
    double? regularTradingChangePercent,
    double? close,
    double? high,
    double? low,
    double? open,
    double? volume,
    double? previousClose,
    int? timestamp,
  }) {
    return SessionData(
      price: price ?? this.price,
      earlyTradingChange: earlyTradingChange ?? this.earlyTradingChange,
      earlyTradingChangePercent: earlyTradingChangePercent ?? this.earlyTradingChangePercent,
      lateTradingChange: lateTradingChange ?? this.lateTradingChange,
      lateTradingChangePercent: lateTradingChangePercent ?? this.lateTradingChangePercent,
      regularTradingChange: regularTradingChange ?? this.regularTradingChange,
      regularTradingChangePercent: regularTradingChangePercent ?? this.regularTradingChangePercent,
      close: close ?? this.close,
      high: high ?? this.high,
      low: low ?? this.low,
      open: open ?? this.open,
      volume: volume ?? this.volume,
      previousClose: previousClose ?? this.previousClose,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  factory SessionData.fromJson(Map<String, dynamic> json) {
    return SessionData(
        price: (json['price'] as num?)?.toDouble(),
      earlyTradingChange: (json['early_trading_change'] as num?)?.toDouble(),
      earlyTradingChangePercent: (json['early_trading_change_percent'] as num?)?.toDouble(),
      lateTradingChange: (json['late_trading_change'] as num?)?.toDouble(),
      lateTradingChangePercent: (json['late_trading_change_percent'] as num?)?.toDouble(),
        regularTradingChange:
            (json['regular_trading_change'] as num?)?.toDouble() ?? (json['change'] as num?)?.toDouble(),
        regularTradingChangePercent: (json['regular_trading_change_percent'] as num?)?.toDouble() ??
            (json['change_percent'] as num?)?.toDouble(),
      close: (json['close'] as num?)?.toDouble(),
      high: (json['high'] as num?)?.toDouble(),
      low: (json['low'] as num?)?.toDouble(),
      open: (json['open'] as num?)?.toDouble(),
      volume: (json['volume'] as num?)?.toDouble(),
      previousClose: (json['previous_close'] as num?)?.toDouble(),
        timestamp: (json['last_updated'] as num?)?.toInt()
    );
  }
}
