import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:p_core/extensions/date_time_extensions.dart';
import 'package:piapiri_v2/core/api/model/proto_model/derivative/derivative_model.dart';
import 'package:piapiri_v2/core/api/model/proto_model/ranker/ranker_model.dart';
import 'package:piapiri_v2/core/api/model/proto_model/symbol/symbol_model.dart';

class MarketListModel extends Equatable {
  final String symbolCode;
  final String symbolDesc;
  final String actionType;
  final double ask;
  final int askSize;
  final double basePrice;
  final double beta100;
  final double bid;
  final int bidSize;
  final int brutSwap;
  final double capital;
  final double cashNetDividend;
  final double circulationShare;
  final double circulationSharePer;
  final double dailyHigh;
  final double dailyLow;
  final double dailyQuantity;
  final double dailyVolume;
  final double dayClose;
  final double days30DifPer;
  final double days7DifPer;
  final String description;
  final double difference;
  final double differencePercent;
  final int direction;
  final double dividendYield;
  final double eqPrice;
  final double eqQuantity;
  final double eqRemainingAskQuantity;
  final double eqRemainingBidQuantity;
  final double equity;
  final double fiftytwoWeekDifPer;
  final int fractionCount;
  final List<dynamic> graphData;
  final double high;
  final double incrementalQuantity;
  final double initialMargin;
  final String issuer;
  final bool isSymbol;
  final double last;
  final double lastQuantity;
  final double limitDown;
  final double limitUp;
  final double low;
  final double marValBookVal;
  final double marketValue;
  final double marketValueUsd;
  final String marketMaker;
  final double marketMakerAsk;
  final double marketMakerAskClose;
  final double marketMakerBid;
  final double marketMakerBidClose;
  final String maturity;
  final double monthClose;
  final double monthHigh;
  final double monthLow;
  final double monthPriceMean;
  final num multiplier;
  final double netProceeds;
  final double open;
  final bool openForTrade;
  final int openInterest;
  final double openInterestChange;
  final String optionClass;
  final String optionType;
  final String period;
  final double preSettlement;
  final double prevYearClose;
  final double priceMean;
  final double priceProceeds;
  final double priceStep;
  final double quantity;
  final double rate;
  final String riskLevel;
  final bool sessionIsOpen;
  final double shiftedNetProceed;
  final double settlement;
  final double settlementPerDif;
  final double sevenDaysDifPer;
  final int stockStatus;
  final String stockSymbolCode;
  final double strikePrice;
  final String symbolGroup;
  final int symbolId;
  final String symbolType;
  final double theoricalPrice;
  final double theoricelPDifPer;
  final double thirtyDaysDifPer;
  final double totalTradeCount;
  final String tradeDate;
  final int tradeFraction;
  final String type;
  final String underlying;
  final String updateDate;
  final int untilMaturity;
  final double volume;
  final double week52DifPer;
  final double weekClose;
  final double weekHigh;
  final double weekLow;
  final double weekPriceMean;
  final double xu030Weight;
  final double xu050Weight;
  final double xu100Weight;
  final double yearClose;
  final double yearHigh;
  final double yearLow;
  final double yearPriceMean;
  final String marketCode;
  final String exchangeCode;
  final String swapType;
  final String subMarketCode;
  final int tradeStatus;
  final int decimalCount;
  final String? sectorCode;

  const MarketListModel({
    required this.symbolCode,
    required this.updateDate,
    this.type = 'EQUITY',
    this.actionType = '',
    this.ask = 0,
    this.askSize = 0,
    this.basePrice = 0,
    this.beta100 = 0,
    this.bid = 0,
    this.bidSize = 0,
    this.brutSwap = 0,
    this.capital = 0,
    this.cashNetDividend = 0,
    this.circulationShare = 0,
    this.circulationSharePer = 0,
    this.dailyHigh = 0,
    this.dailyLow = 0,
    this.dailyQuantity = 0,
    this.dailyVolume = 0,
    this.dayClose = 0,
    this.days30DifPer = 0,
    this.days7DifPer = 0,
    this.description = '',
    this.difference = 0,
    this.differencePercent = 0,
    this.direction = 0,
    this.dividendYield = 0,
    this.eqPrice = 0,
    this.eqQuantity = 0,
    this.eqRemainingAskQuantity = 0,
    this.eqRemainingBidQuantity = 0,
    this.equity = 0,
    this.fiftytwoWeekDifPer = 0,
    this.fractionCount = 0,
    this.graphData = const [],
    this.high = 0,
    this.incrementalQuantity = 0,
    this.initialMargin = 0,
    this.issuer = '',
    this.isSymbol = true,
    this.last = 0,
    this.lastQuantity = 0,
    this.limitDown = 0,
    this.limitUp = 0,
    this.low = 0,
    this.marValBookVal = 0,
    this.marketValue = 0,
    this.marketValueUsd = 0,
    this.marketMaker = '',
    this.marketMakerAsk = 0,
    this.marketMakerAskClose = 0,
    this.marketMakerBid = 0,
    this.marketMakerBidClose = 0,
    this.maturity = '',
    this.monthClose = 0,
    this.monthHigh = 0,
    this.monthLow = 0,
    this.monthPriceMean = 0,
    this.multiplier = 0,
    this.netProceeds = 0,
    this.open = 0,
    this.openForTrade = false,
    this.openInterest = 0,
    this.openInterestChange = 0,
    this.optionClass = '',
    this.optionType = '',
    this.period = '',
    this.preSettlement = 0,
    this.prevYearClose = 0,
    this.priceMean = 0,
    this.priceProceeds = 0,
    this.priceStep = 0,
    this.quantity = 0,
    this.rate = 0,
    this.riskLevel = '',
    this.sessionIsOpen = false,
    this.shiftedNetProceed = 0,
    this.settlement = 0,
    this.settlementPerDif = 0,
    this.sevenDaysDifPer = 0,
    this.stockStatus = 0,
    this.stockSymbolCode = '',
    this.strikePrice = 0,
    this.symbolDesc = '',
    this.symbolGroup = '',
    this.symbolId = 0,
    this.symbolType = '',
    this.theoricalPrice = 0,
    this.theoricelPDifPer = 0,
    this.thirtyDaysDifPer = 0,
    this.totalTradeCount = 0,
    this.tradeDate = '',
    this.tradeFraction = 0,
    this.underlying = '',
    this.untilMaturity = 0,
    this.volume = 0,
    this.week52DifPer = 0,
    this.weekClose = 0,
    this.weekHigh = 0,
    this.weekLow = 0,
    this.weekPriceMean = 0,
    this.xu030Weight = 0,
    this.xu050Weight = 0,
    this.xu100Weight = 0,
    this.yearClose = 0,
    this.yearHigh = 0,
    this.yearLow = 0,
    this.yearPriceMean = 0,
    this.marketCode = '',
    this.exchangeCode = '',
    this.swapType = '',
    this.subMarketCode = '',
    this.tradeStatus = 0,
    this.decimalCount = 0,
    this.sectorCode,
  });

  MarketListModel copyWith({
    String? symbolCode,
    String? symbolDesc,
    String? actionType,
    double? ask,
    int? askSize,
    double? basePrice,
    double? beta100,
    double? bid,
    int? bidSize,
    int? brutSwap,
    double? capital,
    double? cashNetDividend,
    double? circulationShare,
    double? circulationSharePer,
    double? dailyHigh,
    double? dailyLow,
    double? dailyQuantity,
    double? dailyVolume,
    double? dayClose,
    double? days30DifPer,
    double? days7DifPer,
    String? description,
    double? difference,
    double? differencePercent,
    int? direction,
    double? dividendYield,
    double? eqPrice,
    double? eqQuantity,
    double? eqRemainingAskQuantity,
    double? eqRemainingBidQuantity,
    double? equity,
    double? fiftytwoWeekDifPer,
    int? fractionCount,
    List<dynamic>? graphData,
    double? high,
    double? incrementalQuantity,
    double? initialMargin,
    String? issuer,
    double? last,
    double? lastQuantity,
    double? limitDown,
    double? limitUp,
    double? low,
    double? marValBookVal,
    double? marketValue,
    double? marketValueUsd,
    String? marketMaker,
    double? marketMakerAsk,
    double? marketMakerAskClose,
    double? marketMakerBid,
    double? marketMakerBidClose,
    String? maturity,
    double? monthClose,
    double? monthHigh,
    double? monthLow,
    double? monthPriceMean,
    num? multiplier,
    double? netProceeds,
    double? open,
    bool? openForTrade,
    int? openInterest,
    double? openInterestChange,
    String? optionClass,
    String? optionType,
    String? period,
    double? preSettlement,
    double? prevYearClose,
    double? priceMean,
    double? priceProceeds,
    double? priceStep,
    double? quantity,
    double? rate,
    String? riskLevel,
    bool? sessionIsOpen,
    double? shiftedNetProceed,
    double? settlement,
    double? settlementPerDif,
    double? sevenDaysDifPer,
    int? stockStatus,
    String? stockSymbolCode,
    double? strikePrice,
    String? symbolGroup,
    int? symbolId,
    String? symbolType,
    double? theoricalPrice,
    double? theoricelPDifPer,
    double? thirtyDaysDifPer,
    double? totalTradeCount,
    String? tradeDate,
    int? tradeFraction,
    String? type,
    String? underlying,
    String? updateDate,
    int? untilMaturity,
    double? volume,
    double? week52DifPer,
    double? weekClose,
    double? weekHigh,
    double? weekLow,
    double? weekPriceMean,
    double? xu030Weight,
    double? xu050Weight,
    double? xu100Weight,
    double? yearClose,
    double? yearHigh,
    double? yearLow,
    double? yearPriceMean,
    String? marketCode,
    String? exchangeCode,
    String? swapType,
    String? viopListCode,
    int? tradeStatus,
    int? decimalCount,
    String? sectorCode,
  }) {
    return MarketListModel(
      actionType: actionType ?? this.actionType,
      ask: ask ?? this.ask,
      askSize: askSize ?? this.askSize,
      basePrice: basePrice ?? this.basePrice,
      beta100: beta100 ?? this.beta100,
      bid: bid ?? this.bid,
      bidSize: bidSize ?? this.bidSize,
      brutSwap: brutSwap ?? this.brutSwap,
      capital: capital ?? this.capital,
      cashNetDividend: cashNetDividend ?? this.cashNetDividend,
      circulationShare: circulationShare ?? this.circulationShare,
      circulationSharePer: circulationSharePer ?? this.circulationSharePer,
      dailyHigh: dailyHigh ?? this.dailyHigh,
      dailyLow: dailyLow ?? this.dailyLow,
      dailyQuantity: dailyQuantity ?? this.dailyQuantity,
      dailyVolume: dailyVolume ?? this.dailyVolume,
      dayClose: dayClose ?? this.dayClose,
      days30DifPer: days30DifPer ?? this.days30DifPer,
      days7DifPer: days7DifPer ?? this.days7DifPer,
      description: description ?? this.description,
      difference: difference ?? this.difference,
      differencePercent: differencePercent ?? this.differencePercent,
      direction: direction ?? this.direction,
      dividendYield: dividendYield ?? this.dividendYield,
      eqPrice: eqPrice ?? this.eqPrice,
      eqQuantity: eqQuantity ?? this.eqQuantity,
      eqRemainingAskQuantity: eqRemainingAskQuantity ?? this.eqRemainingAskQuantity,
      eqRemainingBidQuantity: eqRemainingBidQuantity ?? this.eqRemainingBidQuantity,
      equity: equity ?? this.equity,
      fiftytwoWeekDifPer: fiftytwoWeekDifPer ?? this.fiftytwoWeekDifPer,
      fractionCount: fractionCount ?? this.fractionCount,
      graphData: graphData ?? this.graphData,
      high: high ?? this.high,
      incrementalQuantity: incrementalQuantity ?? this.incrementalQuantity,
      initialMargin: initialMargin ?? this.initialMargin,
      issuer: issuer ?? this.issuer,
      last: last ?? this.last,
      lastQuantity: lastQuantity ?? this.lastQuantity,
      limitDown: limitDown ?? this.limitDown,
      limitUp: limitUp ?? this.limitUp,
      low: low ?? this.low,
      marValBookVal: marValBookVal ?? this.marValBookVal,
      marketValue: marketValue ?? this.marketValue,
      marketValueUsd: marketValueUsd ?? this.marketValueUsd,
      marketMaker: marketMaker ?? this.marketMaker,
      marketMakerAsk: marketMakerAsk ?? this.marketMakerAsk,
      marketMakerAskClose: marketMakerAskClose ?? this.marketMakerAskClose,
      marketMakerBid: marketMakerBid ?? this.marketMakerBid,
      marketMakerBidClose: marketMakerBidClose ?? this.marketMakerBidClose,
      maturity: maturity ?? this.maturity,
      monthClose: monthClose ?? this.monthClose,
      monthHigh: monthHigh ?? this.monthHigh,
      monthLow: monthLow ?? this.monthLow,
      monthPriceMean: monthPriceMean ?? this.monthPriceMean,
      multiplier: multiplier ?? this.multiplier,
      netProceeds: netProceeds ?? this.netProceeds,
      open: open ?? this.open,
      openForTrade: openForTrade ?? this.openForTrade,
      openInterest: openInterest ?? this.openInterest,
      openInterestChange: openInterestChange ?? this.openInterestChange,
      optionClass: optionClass ?? this.optionClass,
      optionType: optionType ?? this.optionType,
      period: period ?? this.period,
      preSettlement: preSettlement ?? this.preSettlement,
      prevYearClose: prevYearClose ?? this.prevYearClose,
      priceMean: priceMean ?? this.priceMean,
      priceProceeds: priceProceeds ?? this.priceProceeds,
      priceStep: priceStep ?? this.priceStep,
      quantity: quantity ?? this.quantity,
      rate: rate ?? this.rate,
      riskLevel: riskLevel ?? this.riskLevel,
      sessionIsOpen: sessionIsOpen ?? this.sessionIsOpen,
      shiftedNetProceed: shiftedNetProceed ?? this.shiftedNetProceed,
      settlement: settlement ?? this.settlement,
      settlementPerDif: settlementPerDif ?? this.settlementPerDif,
      sevenDaysDifPer: sevenDaysDifPer ?? this.sevenDaysDifPer,
      stockStatus: stockStatus ?? this.stockStatus,
      stockSymbolCode: stockSymbolCode ?? this.stockSymbolCode,
      strikePrice: strikePrice ?? this.strikePrice,
      symbolCode: symbolCode ?? this.symbolCode,
      symbolDesc: symbolDesc ?? this.symbolDesc,
      symbolGroup: symbolGroup ?? this.symbolGroup,
      symbolId: symbolId ?? this.symbolId,
      symbolType: symbolType ?? this.symbolType,
      theoricalPrice: theoricalPrice ?? this.theoricalPrice,
      theoricelPDifPer: theoricelPDifPer ?? this.theoricelPDifPer,
      thirtyDaysDifPer: thirtyDaysDifPer ?? this.thirtyDaysDifPer,
      totalTradeCount: totalTradeCount ?? this.totalTradeCount,
      tradeDate: tradeDate ?? this.tradeDate,
      tradeFraction: tradeFraction ?? this.tradeFraction,
      type: type ?? this.type,
      underlying: underlying ?? this.underlying,
      updateDate: updateDate ?? this.updateDate,
      untilMaturity: untilMaturity ?? this.untilMaturity,
      volume: volume ?? this.volume,
      week52DifPer: week52DifPer ?? this.week52DifPer,
      weekClose: weekClose ?? this.weekClose,
      weekHigh: weekHigh ?? this.weekHigh,
      weekLow: weekLow ?? this.weekLow,
      weekPriceMean: weekPriceMean ?? this.weekPriceMean,
      xu030Weight: xu030Weight ?? this.xu030Weight,
      xu050Weight: xu050Weight ?? this.xu050Weight,
      xu100Weight: xu100Weight ?? this.xu100Weight,
      yearClose: yearClose ?? this.yearClose,
      yearHigh: yearHigh ?? this.yearHigh,
      yearLow: yearLow ?? this.yearLow,
      yearPriceMean: yearPriceMean ?? this.yearPriceMean,
      marketCode: marketCode ?? this.marketCode,
      exchangeCode: exchangeCode ?? this.exchangeCode,
      swapType: swapType ?? this.swapType,
      subMarketCode: viopListCode ?? subMarketCode,
      tradeStatus: tradeStatus ?? this.tradeStatus,
      decimalCount: decimalCount ?? this.decimalCount,
      sectorCode: sectorCode ?? this.sectorCode,
    );
  }

  MarketListModel updateDerivative(Derivative symbol) {
    double volume = symbol.volume == 0 ? this.volume : symbol.volume;
    double dayClose = symbol.dayClose == 0 ? this.dayClose : symbol.dayClose;
    double differencePercent = 0;
    double difference = 0;
    double last = symbol.last == 0 ? this.last : symbol.last;
    double ask = symbol.ask == 0 ? this.ask : symbol.ask;
    double bid = symbol.bid == 0 ? this.bid : symbol.bid;
    if (last != 0 || volume != 0) {
      difference = last - dayClose;
      differencePercent = dayClose != 0 ? (difference / dayClose * 100) : 0;
    } else if (last == 0 && ask == 0 && bid == 0) {
      double eqPrice = symbol.eqPrice == 0 ? this.eqPrice : symbol.eqPrice;
      double open = symbol.open == 0 ? this.open : symbol.open;
      if (eqPrice != 0) {
      difference = eqPrice - dayClose;
      differencePercent = dayClose != 0 ? (difference / dayClose * 100) : 0;
      } else if (open != 0) {
        difference = open - dayClose;
        differencePercent = dayClose != 0 ? (difference / dayClose * 100) : 0;
      }

    }
    return MarketListModel(
      symbolCode: symbolCode,
      updateDate: symbol.updateDate == ''
          ? updateDate
          : symbol.updateDate.contains('T')
              ? DateFormat('yyyy-MM-ddTHH:mm:ss.SSS+Z').parseUtc(symbol.updateDate).formatTime()
              : DateFormat('yyyy-MM-dd HH:mm:ss.SSS').parseUtc(symbol.updateDate).formatTime(),
      type: type,
      actionType: symbol.actionType == '' ? actionType : symbol.actionType,
      ask: symbol.ask == 0 ? ask : symbol.ask,
      askSize: symbol.askSize == 0 ? askSize : symbol.askSize,
      basePrice: basePrice,
      beta100: beta100,
      bid: symbol.bid == 0 ? bid : symbol.bid,
      bidSize: symbol.bidSize == 0 ? bidSize : symbol.bidSize,
      brutSwap: symbol.brutSwap == 0 ? brutSwap : symbol.brutSwap,
      capital: capital,
      cashNetDividend: cashNetDividend,
      circulationShare: circulationShare,
      circulationSharePer: circulationSharePer,
      dailyHigh: symbol.dailyHigh == 0 ? dailyHigh : symbol.dailyHigh,
      dailyLow: symbol.dailyLow == 0 ? dailyLow : symbol.dailyLow,
      dailyQuantity: symbol.dailyQuantity == 0 ? dailyQuantity : symbol.dailyQuantity,
      dailyVolume: symbol.dailyVolume == 0 ? dailyVolume : symbol.dailyVolume,
      dayClose: symbol.dayClose == 0 ? dayClose : symbol.dayClose,
      days30DifPer: days30DifPer == 0 ? symbol.thirtyDaysDifPer : days30DifPer,
      days7DifPer: days7DifPer == 0 ? symbol.sevenDaysDifPer : days7DifPer,
      description: description,
      difference: difference,
      differencePercent: differencePercent,
      direction: direction,
      dividendYield: dividendYield,
      eqPrice: symbol.eqPrice == 0 ? eqPrice : symbol.eqPrice,
      eqQuantity: symbol.eqQuantity == 0 ? eqQuantity : symbol.eqQuantity,
      eqRemainingAskQuantity:
          symbol.eqRemainingAskQuantity == 0 ? eqRemainingAskQuantity : symbol.eqRemainingAskQuantity,
      eqRemainingBidQuantity:
          symbol.eqRemainingBidQuantity == 0 ? eqRemainingBidQuantity : symbol.eqRemainingBidQuantity,
      equity: equity,
      fiftytwoWeekDifPer: symbol.fiftytwoWeekDifPer == 0 ? fiftytwoWeekDifPer : symbol.fiftytwoWeekDifPer,
      fractionCount: symbol.fractionCount == 0 ? fractionCount : symbol.fractionCount,
      high: symbol.high == 0 ? high : symbol.high,
      incrementalQuantity: symbol.incrementalQuantity == 0 ? incrementalQuantity : symbol.incrementalQuantity,
      initialMargin: symbol.initialMargin == 0 ? initialMargin : symbol.initialMargin,
      issuer: issuer,
      isSymbol: false,
      last: last,
      lastQuantity: symbol.lastQuantity == 0 ? lastQuantity : symbol.lastQuantity,
      limitDown: symbol.limitDown == 0 ? limitDown : symbol.limitDown,
      limitUp: symbol.limitUp == 0 ? limitUp : symbol.limitUp,
      low: symbol.low == 0 ? low : symbol.low,
      marValBookVal: marValBookVal,
      marketValue: marketValue,
      marketValueUsd: marketValueUsd,
      marketMaker: symbol.marketMaker == '' ? marketMaker : symbol.marketMaker,
      marketMakerAsk: symbol.marketMakerAsk == 0 ? marketMakerAsk : symbol.marketMakerAsk,
      marketMakerAskClose: symbol.marketMakerAskClose == 0 ? marketMakerAskClose : symbol.marketMakerAskClose,
      marketMakerBid: symbol.marketMakerBid == 0 ? marketMakerBid : symbol.marketMakerBid,
      marketMakerBidClose: symbol.marketMakerBidClose == 0 ? marketMakerBidClose : symbol.marketMakerBidClose,
      maturity: symbol.maturity == '' ? maturity : symbol.maturity,
      monthClose: symbol.monthClose == 0 ? monthClose : symbol.monthClose,
      monthHigh: symbol.monthHigh == 0 ? monthHigh : symbol.monthHigh,
      monthLow: symbol.monthLow == 0 ? monthLow : symbol.monthLow,
      monthPriceMean: symbol.monthPriceMean == 0 ? monthPriceMean : symbol.monthPriceMean,
      multiplier: multiplier,
      netProceeds: netProceeds,
      open: symbol.open == 0 ? open : symbol.open,
      openForTrade: symbol.openForTrade != openForTrade ? symbol.openForTrade : openForTrade,
      openInterest: symbol.openInterest == 0 ? openInterest : symbol.openInterest,
      openInterestChange: symbol.openInterestChange == 0 ? openInterestChange : symbol.openInterestChange,
      optionClass: optionClass,
      optionType: optionType,
      period: period,
      preSettlement: symbol.preSettlement == 0 ? preSettlement : symbol.preSettlement,
      prevYearClose: symbol.prevYearClose == 0 ? prevYearClose : symbol.prevYearClose,
      priceMean: symbol.priceMean == 0 ? priceMean : symbol.priceMean,
      priceProceeds: priceProceeds,
      priceStep: symbol.priceStep == 0 ? priceStep : symbol.priceStep,
      quantity: symbol.quantity == 0 ? quantity : symbol.quantity,
      rate: symbol.rate == 0 ? rate : symbol.rate,
      riskLevel: symbol.riskLevel == '' ? riskLevel : symbol.riskLevel,
      sessionIsOpen: sessionIsOpen,
      shiftedNetProceed: shiftedNetProceed,
      settlement: symbol.settlement == 0 ? settlement : symbol.settlement,
      settlementPerDif: symbol.settlementPerDif == 0 ? settlementPerDif : symbol.settlementPerDif,
      sevenDaysDifPer: symbol.sevenDaysDifPer == 0 ? sevenDaysDifPer : symbol.sevenDaysDifPer,
      stockStatus: symbol.stockStatus == 0 ? stockStatus : symbol.stockStatus,
      stockSymbolCode: stockSymbolCode,
      strikePrice: symbol.strikePrice == 0 ? strikePrice : symbol.strikePrice,
      symbolDesc: symbol.symbolDesc == '' ? symbolDesc : symbol.symbolDesc,
      symbolGroup: symbolGroup,
      symbolId: symbol.symbolId == 0 ? symbolId : symbol.symbolId,
      symbolType: symbolType,
      theoricalPrice: symbol.theoricalPrice == 0 ? theoricalPrice : symbol.theoricalPrice,
      theoricelPDifPer: symbol.theoricelPDifPer == 0 ? theoricelPDifPer : symbol.theoricelPDifPer,
      thirtyDaysDifPer: symbol.thirtyDaysDifPer == 0 ? thirtyDaysDifPer : symbol.thirtyDaysDifPer,
      totalTradeCount: symbol.totalTradeCount == 0 ? totalTradeCount : symbol.totalTradeCount,
      tradeDate: symbol.tradeDate == '' ? tradeDate : symbol.tradeDate,
      tradeFraction: tradeFraction,
      underlying: underlying,
      untilMaturity: untilMaturity,
      volume: symbol.volume == 0 ? volume : symbol.volume,
      week52DifPer: week52DifPer == 0 ? symbol.fiftytwoWeekDifPer : week52DifPer,
      weekClose: symbol.weekClose == 0 ? weekClose : symbol.weekClose,
      weekHigh: symbol.weekHigh == 0 ? weekHigh : symbol.weekHigh,
      weekLow: symbol.weekLow == 0 ? weekLow : symbol.weekLow,
      weekPriceMean: symbol.weekPriceMean == 0 ? weekPriceMean : symbol.weekPriceMean,
      xu030Weight: xu030Weight,
      xu050Weight: xu050Weight,
      xu100Weight: xu100Weight,
      yearClose: symbol.yearClose == 0 ? yearClose : symbol.yearClose,
      yearHigh: symbol.yearHigh == 0 ? yearHigh : symbol.yearHigh,
      yearLow: symbol.yearLow == 0 ? yearLow : symbol.yearLow,
      yearPriceMean: symbol.yearPriceMean == 0 ? yearPriceMean : symbol.yearPriceMean,
      marketCode: marketCode,
      swapType: swapType,
      subMarketCode: subMarketCode,
      tradeStatus: tradeStatus,
      decimalCount: decimalCount,
    );
  }

  MarketListModel updateSymbol(SymbolModel symbol) {
    double volume = symbol.volume == 0 ? this.volume : symbol.volume;
    double dayClose = symbol.dayClose == 0 ? this.dayClose : symbol.dayClose;
    double differencePercent = 0;
    double difference = 0;
    double last = symbol.last == 0 ? this.last : symbol.last;
    double ask = symbol.ask == 0 ? this.ask : symbol.ask;
    double bid = symbol.bid == 0 ? this.bid : symbol.bid;
    double eqPrice = symbol.eqPrice == 0 ? this.eqPrice : symbol.eqPrice;
    if (last == 0 && ask == 0 && bid == 0 && eqPrice != 0) {
      difference = eqPrice - dayClose;
      differencePercent = dayClose != 0 ? (difference / dayClose * 100) : 0;
      differencePercent = (differencePercent * 100).roundToDouble() / 100;
    } else if (last != 0 || volume != 0) {
      difference = last - dayClose;
      differencePercent = dayClose != 0 ? (difference / dayClose * 100) : 0;
      differencePercent = (differencePercent * 100).roundToDouble() / 100;
    }
    return MarketListModel(
      symbolCode: symbolCode,
      updateDate: symbol.updateDate == ''
          ? updateDate
          : DateFormat('HH:mm:ss').format(
              symbol.updateDate.contains('T')
                  ? DateFormat('yyyy-MM-ddTHH:mm:ss.SSS+Z').parseUtc(symbol.updateDate)
                  : DateFormat('yyyy-MM-dd HH:mm:ss.SSS').parseUtc(symbol.updateDate),
            ),
      type: type,
      actionType: symbol.actionType == '' ? actionType : symbol.actionType,
      ask: symbol.ask == 0 ? ask : symbol.ask,
      askSize: symbol.askSize == 0 ? askSize : symbol.askSize,
      basePrice: symbol.basePrice == 0 ? basePrice : symbol.basePrice,
      beta100: symbol.beta100 == 0 ? beta100 : symbol.beta100,
      bid: symbol.bid == 0 ? bid : symbol.bid,
      bidSize: symbol.bidSize == 0 ? bidSize : symbol.bidSize,
      brutSwap: symbol.brutSwap == 0 ? brutSwap : symbol.brutSwap,
      capital: symbol.capital == 0 ? capital : symbol.capital,
      cashNetDividend: symbol.cashNetDividend == 0 ? cashNetDividend : symbol.cashNetDividend,
      circulationShare: symbol.circulationShare == 0 ? circulationShare : symbol.circulationShare,
      circulationSharePer: symbol.circulationSharePer == 0 ? circulationSharePer : symbol.circulationSharePer,
      dailyHigh: symbol.dailyHigh == 0 ? dailyHigh : symbol.dailyHigh,
      dailyLow: symbol.dailyLow == 0 ? dailyLow : symbol.dailyLow,
      dailyQuantity: symbol.dailyQuantity == 0 ? dailyQuantity : symbol.dailyQuantity,
      dailyVolume: symbol.dailyVolume == 0 ? dailyVolume : symbol.dailyVolume,
      dayClose: symbol.dayClose == 0 ? dayClose : symbol.dayClose,
      days30DifPer: symbol.days30DifPer == 0 ? days30DifPer : symbol.days30DifPer,
      days7DifPer: symbol.days7DifPer == 0 ? days7DifPer : symbol.days7DifPer,
      description: description,
      difference: difference,
      differencePercent: differencePercent,
      direction: symbol.direction == 0 ? direction : symbol.direction,
      dividendYield: symbol.dividendYield == 0 ? dividendYield : symbol.dividendYield,
      eqPrice: symbol.eqPrice == 0 ? eqPrice : symbol.eqPrice,
      eqQuantity: symbol.eqQuantity == 0 ? eqQuantity : symbol.eqQuantity,
      eqRemainingAskQuantity:
          symbol.eqRemainingAskQuantity == 0 ? eqRemainingAskQuantity : symbol.eqRemainingAskQuantity,
      eqRemainingBidQuantity:
          symbol.eqRemainingBidQuantity == 0 ? eqRemainingBidQuantity : symbol.eqRemainingBidQuantity,
      equity: equity == 0 ? symbol.equity : equity,
      fiftytwoWeekDifPer: fiftytwoWeekDifPer,
      fractionCount: symbol.fractionCount == 0 ? fractionCount : symbol.fractionCount,
      graphData: graphData,
      high: symbol.high == 0 ? high : symbol.high,
      incrementalQuantity: symbol.incrementalQuantity == 0 ? incrementalQuantity : symbol.incrementalQuantity,
      initialMargin: initialMargin,
      issuer: issuer,
      isSymbol: true,
      last: last,
      lastQuantity: symbol.lastQuantity == 0 ? lastQuantity : symbol.lastQuantity,
      limitDown: symbol.limitDown == 0 ? limitDown : symbol.limitDown,
      limitUp: symbol.limitUp == 0 ? limitUp : symbol.limitUp,
      low: symbol.low == 0 ? low : symbol.low,
      marValBookVal: symbol.marValBookVal == 0 ? marValBookVal : symbol.marValBookVal,
      marketValue: symbol.marketValue == 0 ? marketValue : symbol.marketValue,
      marketValueUsd: symbol.marketValueUsd == 0 ? marketValueUsd : symbol.marketValueUsd,
      marketMaker: marketMaker,
      marketMakerAsk: marketMakerAsk,
      marketMakerAskClose: marketMakerAskClose,
      marketMakerBid: marketMakerBid,
      marketMakerBidClose: marketMakerBidClose,
      maturity: maturity,
      monthClose: symbol.monthClose == 0 ? monthClose : symbol.monthClose,
      monthHigh: symbol.monthHigh == 0 ? monthHigh : symbol.monthHigh,
      monthLow: symbol.monthLow == 0 ? monthLow : symbol.monthLow,
      monthPriceMean: symbol.monthPriceMean == 0 ? monthPriceMean : symbol.monthPriceMean,
      multiplier: multiplier,
      netProceeds: symbol.netProceeds == 0 ? netProceeds : symbol.netProceeds,
      open: symbol.open == 0 ? open : symbol.open,
      openForTrade: symbol.openForTrade != openForTrade ? symbol.openForTrade : openForTrade,
      openInterest: openInterest,
      openInterestChange: openInterestChange,
      optionClass: optionClass,
      optionType: optionType,
      period: symbol.period == '' ? period : symbol.period,
      preSettlement: preSettlement,
      prevYearClose: symbol.prevYearClose == 0 ? prevYearClose : symbol.prevYearClose,
      priceMean: symbol.priceMean == 0 ? priceMean : symbol.priceMean,
      priceProceeds: symbol.priceProceeds == 0 ? priceProceeds : symbol.priceProceeds,
      priceStep: symbol.priceStep == 0 ? priceStep : symbol.priceStep,
      quantity: symbol.quantity == 0 ? quantity : symbol.quantity,
      rate: rate,
      riskLevel: riskLevel,
      sessionIsOpen: symbol.sessionIsOpen != sessionIsOpen ? symbol.sessionIsOpen : sessionIsOpen,
      shiftedNetProceed: symbol.shiftedNetProceed == 0 ? shiftedNetProceed : symbol.shiftedNetProceed,
      settlement: settlement,
      settlementPerDif: settlementPerDif,
      sevenDaysDifPer: sevenDaysDifPer,
      stockStatus: symbol.stockStatus == 0 ? stockStatus : symbol.stockStatus,
      stockSymbolCode: stockSymbolCode,
      strikePrice: strikePrice,
      symbolDesc: symbol.symbolDesc == '' ? symbolDesc : symbol.symbolDesc,
      symbolGroup: symbol.symbolGroup == '' ? symbolGroup : symbol.symbolGroup,
      symbolId: symbol.symbolId == 0 ? symbolId : symbol.symbolId,
      symbolType: symbol.symbolType == '' ? symbolType : symbol.symbolType,
      theoricalPrice: theoricalPrice,
      theoricelPDifPer: theoricelPDifPer,
      thirtyDaysDifPer: thirtyDaysDifPer,
      totalTradeCount: symbol.totalTradeCount == 0 ? totalTradeCount : symbol.totalTradeCount,
      tradeDate: symbol.tradeDate == '' ? tradeDate : symbol.tradeDate,
      tradeFraction: symbol.tradeFraction == 0 ? tradeFraction : symbol.tradeFraction,
      underlying: underlying,
      untilMaturity: untilMaturity,
      volume: symbol.volume == 0 ? volume : symbol.volume,
      week52DifPer: symbol.week52DifPer == 0 ? weekClose : symbol.weekClose,
      weekClose: symbol.weekClose == 0 ? weekClose : symbol.weekClose,
      weekHigh: symbol.weekHigh == 0 ? weekHigh : symbol.weekHigh,
      weekLow: symbol.weekLow == 0 ? weekLow : symbol.weekLow,
      weekPriceMean: symbol.weekPriceMean == 0 ? weekPriceMean : symbol.weekPriceMean,
      xu030Weight: symbol.xu030Weight == 0 ? xu030Weight : symbol.xu030Weight,
      xu050Weight: symbol.xu050Weight == 0 ? xu050Weight : symbol.xu050Weight,
      xu100Weight: symbol.xu100Weight == 0 ? xu100Weight : symbol.xu100Weight,
      yearClose: symbol.yearClose == 0 ? yearClose : symbol.yearClose,
      yearHigh: symbol.yearHigh == 0 ? yearHigh : symbol.yearHigh,
      yearLow: symbol.yearLow == 0 ? yearLow : symbol.yearLow,
      yearPriceMean: symbol.yearPriceMean == 0 ? yearPriceMean : symbol.yearPriceMean,
      marketCode: marketCode,
      swapType: swapType,
      subMarketCode: subMarketCode,
      tradeStatus: tradeStatus,
      decimalCount: decimalCount,
    );
  }

  factory MarketListModel.fromRanker(Ranker ranker) {
    return MarketListModel(
      updateDate: '',
      symbolCode: ranker.key ?? '',
      last: ranker.last ?? 0.0,
      differencePercent: ranker.priceChange ?? 0.0,
      ask: ranker.ask ?? 0.0,
      bid: ranker.bid ?? 0.0,
      volume: ranker.value ?? 0.0,
    );
  }

  @override
  List<Object?> get props => [
        actionType,
        ask,
        askSize,
        basePrice,
        beta100,
        bid,
        bidSize,
        brutSwap,
        capital,
        cashNetDividend,
        circulationShare,
        circulationSharePer,
        dailyHigh,
        dailyLow,
        dailyQuantity,
        dailyVolume,
        dayClose,
        days30DifPer,
        days7DifPer,
        description,
        difference,
        differencePercent,
        direction,
        dividendYield,
        eqPrice,
        eqQuantity,
        eqRemainingAskQuantity,
        eqRemainingBidQuantity,
        equity,
        fiftytwoWeekDifPer,
        fractionCount,
        graphData,
        high,
        incrementalQuantity,
        initialMargin,
        issuer,
        last,
        lastQuantity,
        limitDown,
        limitUp,
        low,
        marValBookVal,
        marketValue,
        marketValueUsd,
        marketMaker,
        marketMakerAsk,
        marketMakerAskClose,
        marketMakerBid,
        marketMakerBidClose,
        maturity,
        monthClose,
        monthHigh,
        monthLow,
        monthPriceMean,
        multiplier,
        netProceeds,
        open,
        openForTrade,
        openInterest,
        openInterestChange,
        optionClass,
        optionType,
        period,
        preSettlement,
        prevYearClose,
        priceMean,
        priceProceeds,
        priceStep,
        quantity,
        rate,
        riskLevel,
        sessionIsOpen,
        shiftedNetProceed,
        settlement,
        settlementPerDif,
        sevenDaysDifPer,
        stockStatus,
        stockSymbolCode,
        strikePrice,
        symbolCode,
        symbolDesc,
        symbolGroup,
        symbolId,
        symbolType,
        theoricalPrice,
        theoricelPDifPer,
        thirtyDaysDifPer,
        totalTradeCount,
        tradeDate,
        tradeFraction,
        type,
        underlying,
        updateDate,
        untilMaturity,
        volume,
        week52DifPer,
        weekClose,
        weekHigh,
        weekLow,
        weekPriceMean,
        xu030Weight,
        xu050Weight,
        xu100Weight,
        yearClose,
        yearHigh,
        yearLow,
        yearPriceMean,
        marketCode,
        exchangeCode,
        swapType,
        subMarketCode,
        tradeStatus,
        decimalCount,
        sectorCode,
      ];
}
