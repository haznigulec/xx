abstract class BaseSymbol {
  final String actionType;
  final String symbolCode;
  final String symbolDesc;
  final String tradeDate;
  final String updateDate;
  final bool openForTrade;
  final double ask;
  final double bid;
  final double dailyHigh;
  final double dailyLow;
  final double dailyQuantity;
  final double dailyVolume;
  final double dayClose;
  final double difference;
  final double differencePercent;
  final double eqPrice;
  final double eqQuantity;
  final double eqRemainingAskQuantity;
  final double eqRemainingBidQuantity;
  final double high;
  final double incrementalQuantity;
  final double last;
  final double lastQuantity;
  final double limitDown;
  final double limitUp;
  final double low;
  final double monthClose;
  final double monthHigh;
  final double monthLow;
  final double monthPriceMean;
  final double open;
  final double prevYearClose;
  final double priceMean;
  final double priceStep;
  final double quantity;
  final double totalTradeCount;
  final double volume;
  final double weekClose;
  final double weekHigh;
  final double weekLow;
  final double weekPriceMean;
  final double yearClose;
  final double yearHigh;
  final double yearLow;
  final double yearPriceMean;
  final int askSize;
  final int bidSize;
  final int brutSwap;
  final int fractionCount;
  final int stockStatus;
  final int symbolId;

  BaseSymbol({
    required this.actionType,
    required this.symbolCode,
    required this.symbolDesc,
    required this.tradeDate,
    required this.updateDate,
    required this.openForTrade,
    required this.ask,
    required this.bid,
    required this.dailyHigh,
    required this.dailyLow,
    required this.dailyQuantity,
    required this.dailyVolume,
    required this.dayClose,
    required this.difference,
    required this.differencePercent,
    required this.eqPrice,
    required this.eqQuantity,
    required this.eqRemainingAskQuantity,
    required this.eqRemainingBidQuantity,
    required this.high,
    required this.incrementalQuantity,
    required this.last,
    required this.lastQuantity,
    required this.limitDown,
    required this.limitUp,
    required this.low,
    required this.monthClose,
    required this.monthHigh,
    required this.monthLow,
    required this.monthPriceMean,
    required this.open,
    required this.prevYearClose,
    required this.priceMean,
    required this.priceStep,
    required this.quantity,
    required this.totalTradeCount,
    required this.volume,
    required this.weekClose,
    required this.weekHigh,
    required this.weekLow,
    required this.weekPriceMean,
    required this.yearClose,
    required this.yearHigh,
    required this.yearLow,
    required this.yearPriceMean,
    required this.askSize,
    required this.bidSize,
    required this.brutSwap,
    required this.fractionCount,
    required this.stockStatus,
    required this.symbolId,
  });
}
