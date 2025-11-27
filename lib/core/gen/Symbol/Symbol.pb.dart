// This is a generated file - do not edit.
//
// Generated from Symbol/Symbol.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'Symbol.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'Symbol.pbenum.dart';

class SymbolMessage extends $pb.GeneratedMessage {
  factory SymbolMessage({
    $core.int? symbolId,
    $core.String? symbolCode,
    $core.String? symbolDesc,
    $core.String? updateDate,
    $core.double? bid,
    $core.double? ask,
    $core.double? low,
    $core.double? high,
    $core.double? last,
    $core.double? dayClose,
    $core.int? fractionCount,
    $core.double? dailyLow,
    $core.double? dailyHigh,
    $core.double? quantity,
    $core.double? volume,
    $core.double? difference,
    $core.double? differencePercent,
    $core.double? days7DifPer,
    $core.double? days30DifPer,
    $core.double? week52DifPer,
    $core.double? monthHigh,
    $core.double? monthLow,
    $core.double? yearHigh,
    $core.double? yearLow,
    $core.double? priceMean,
    $core.double? limitUp,
    $core.double? limitDown,
    $core.double? netProceeds,
    $core.double? priceProceeds,
    $core.double? marketValue,
    $core.double? marketValueUsd,
    $core.double? marValBookVal,
    $core.double? equity,
    $core.double? capital,
    $core.double? circulationShare,
    $core.double? circulationSharePer,
    $core.String? symbolGroup,
    $core.double? dailyVolume,
    $core.bool? sessionIsOpen,
  @$core.Deprecated('This field is deprecated.')
    $core.bool? openForTrade,
    $core.double? priceStep,
    $core.double? basePrice,
    $core.String? symbolType,
    $core.int? tradeFraction,
    $core.String? stockSymbolCode,
    $core.String? tradeDate,
    $core.double? open,
    $core.double? dailyQuantity,
    $core.String? actionType,
  @$core.Deprecated('This field is deprecated.')
    $core.int? brutSwap,
    $core.double? totalTradeCount,
    $core.double? lastQuantity,
    $core.double? weekLow,
    $core.double? weekHigh,
    $core.double? weekClose,
    $core.double? monthClose,
    $core.double? yearClose,
    $core.String? period,
    $core.double? shiftedNetProceed,
    $fixnum.Int64? askSize,
    $fixnum.Int64? bidSize,
    $core.double? eqPrice,
    $core.double? eqQuantity,
    $core.double? eqRemainingBidQuantity,
    $core.double? eqRemainingAskQuantity,
    $core.double? prevYearClose,
    $core.int? direction,
    $core.double? weekPriceMean,
    $core.double? monthPriceMean,
    $core.double? yearPriceMean,
    $core.double? beta100,
    $core.double? cashNetDividend,
    $core.double? dividendYield,
    $core.int? stockStatus,
    $core.double? incrementalQuantity,
    SymbolMessage_PublishReason? publishReason,
    $core.double? xu030Weight,
    $core.double? xu050Weight,
    $core.double? xu100Weight,
    $core.double? netDebt,
    $core.double? shiftedEbitda,
  }) {
    final result = create();
    if (symbolId != null) result.symbolId = symbolId;
    if (symbolCode != null) result.symbolCode = symbolCode;
    if (symbolDesc != null) result.symbolDesc = symbolDesc;
    if (updateDate != null) result.updateDate = updateDate;
    if (bid != null) result.bid = bid;
    if (ask != null) result.ask = ask;
    if (low != null) result.low = low;
    if (high != null) result.high = high;
    if (last != null) result.last = last;
    if (dayClose != null) result.dayClose = dayClose;
    if (fractionCount != null) result.fractionCount = fractionCount;
    if (dailyLow != null) result.dailyLow = dailyLow;
    if (dailyHigh != null) result.dailyHigh = dailyHigh;
    if (quantity != null) result.quantity = quantity;
    if (volume != null) result.volume = volume;
    if (difference != null) result.difference = difference;
    if (differencePercent != null) result.differencePercent = differencePercent;
    if (days7DifPer != null) result.days7DifPer = days7DifPer;
    if (days30DifPer != null) result.days30DifPer = days30DifPer;
    if (week52DifPer != null) result.week52DifPer = week52DifPer;
    if (monthHigh != null) result.monthHigh = monthHigh;
    if (monthLow != null) result.monthLow = monthLow;
    if (yearHigh != null) result.yearHigh = yearHigh;
    if (yearLow != null) result.yearLow = yearLow;
    if (priceMean != null) result.priceMean = priceMean;
    if (limitUp != null) result.limitUp = limitUp;
    if (limitDown != null) result.limitDown = limitDown;
    if (netProceeds != null) result.netProceeds = netProceeds;
    if (priceProceeds != null) result.priceProceeds = priceProceeds;
    if (marketValue != null) result.marketValue = marketValue;
    if (marketValueUsd != null) result.marketValueUsd = marketValueUsd;
    if (marValBookVal != null) result.marValBookVal = marValBookVal;
    if (equity != null) result.equity = equity;
    if (capital != null) result.capital = capital;
    if (circulationShare != null) result.circulationShare = circulationShare;
    if (circulationSharePer != null) result.circulationSharePer = circulationSharePer;
    if (symbolGroup != null) result.symbolGroup = symbolGroup;
    if (dailyVolume != null) result.dailyVolume = dailyVolume;
    if (sessionIsOpen != null) result.sessionIsOpen = sessionIsOpen;
    if (openForTrade != null) result.openForTrade = openForTrade;
    if (priceStep != null) result.priceStep = priceStep;
    if (basePrice != null) result.basePrice = basePrice;
    if (symbolType != null) result.symbolType = symbolType;
    if (tradeFraction != null) result.tradeFraction = tradeFraction;
    if (stockSymbolCode != null) result.stockSymbolCode = stockSymbolCode;
    if (tradeDate != null) result.tradeDate = tradeDate;
    if (open != null) result.open = open;
    if (dailyQuantity != null) result.dailyQuantity = dailyQuantity;
    if (actionType != null) result.actionType = actionType;
    if (brutSwap != null) result.brutSwap = brutSwap;
    if (totalTradeCount != null) result.totalTradeCount = totalTradeCount;
    if (lastQuantity != null) result.lastQuantity = lastQuantity;
    if (weekLow != null) result.weekLow = weekLow;
    if (weekHigh != null) result.weekHigh = weekHigh;
    if (weekClose != null) result.weekClose = weekClose;
    if (monthClose != null) result.monthClose = monthClose;
    if (yearClose != null) result.yearClose = yearClose;
    if (period != null) result.period = period;
    if (shiftedNetProceed != null) result.shiftedNetProceed = shiftedNetProceed;
    if (askSize != null) result.askSize = askSize;
    if (bidSize != null) result.bidSize = bidSize;
    if (eqPrice != null) result.eqPrice = eqPrice;
    if (eqQuantity != null) result.eqQuantity = eqQuantity;
    if (eqRemainingBidQuantity != null) result.eqRemainingBidQuantity = eqRemainingBidQuantity;
    if (eqRemainingAskQuantity != null) result.eqRemainingAskQuantity = eqRemainingAskQuantity;
    if (prevYearClose != null) result.prevYearClose = prevYearClose;
    if (direction != null) result.direction = direction;
    if (weekPriceMean != null) result.weekPriceMean = weekPriceMean;
    if (monthPriceMean != null) result.monthPriceMean = monthPriceMean;
    if (yearPriceMean != null) result.yearPriceMean = yearPriceMean;
    if (beta100 != null) result.beta100 = beta100;
    if (cashNetDividend != null) result.cashNetDividend = cashNetDividend;
    if (dividendYield != null) result.dividendYield = dividendYield;
    if (stockStatus != null) result.stockStatus = stockStatus;
    if (incrementalQuantity != null) result.incrementalQuantity = incrementalQuantity;
    if (publishReason != null) result.publishReason = publishReason;
    if (xu030Weight != null) result.xu030Weight = xu030Weight;
    if (xu050Weight != null) result.xu050Weight = xu050Weight;
    if (xu100Weight != null) result.xu100Weight = xu100Weight;
    if (netDebt != null) result.netDebt = netDebt;
    if (shiftedEbitda != null) result.shiftedEbitda = shiftedEbitda;
    return result;
  }

  SymbolMessage._();

  factory SymbolMessage.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory SymbolMessage.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SymbolMessage', package: const $pb.PackageName(_omitMessageNames ? '' : 'messages'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'symbolId', $pb.PbFieldType.QS3, protoName: 'symbolId')
    ..aOS(2, _omitFieldNames ? '' : 'symbolCode', protoName: 'symbolCode')
    ..aOS(3, _omitFieldNames ? '' : 'symbolDesc', protoName: 'symbolDesc')
    ..aOS(4, _omitFieldNames ? '' : 'updateDate', protoName: 'updateDate')
    ..a<$core.double>(5, _omitFieldNames ? '' : 'bid', $pb.PbFieldType.OD)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'ask', $pb.PbFieldType.OD)
    ..a<$core.double>(7, _omitFieldNames ? '' : 'low', $pb.PbFieldType.OD)
    ..a<$core.double>(8, _omitFieldNames ? '' : 'high', $pb.PbFieldType.OD)
    ..a<$core.double>(9, _omitFieldNames ? '' : 'last', $pb.PbFieldType.OD)
    ..a<$core.double>(10, _omitFieldNames ? '' : 'dayClose', $pb.PbFieldType.OD, protoName: 'dayClose')
    ..a<$core.int>(11, _omitFieldNames ? '' : 'fractionCount', $pb.PbFieldType.O3, protoName: 'fractionCount')
    ..a<$core.double>(12, _omitFieldNames ? '' : 'dailyLow', $pb.PbFieldType.OD, protoName: 'dailyLow')
    ..a<$core.double>(13, _omitFieldNames ? '' : 'dailyHigh', $pb.PbFieldType.OD, protoName: 'dailyHigh')
    ..a<$core.double>(14, _omitFieldNames ? '' : 'quantity', $pb.PbFieldType.OD)
    ..a<$core.double>(15, _omitFieldNames ? '' : 'volume', $pb.PbFieldType.OD)
    ..a<$core.double>(16, _omitFieldNames ? '' : 'difference', $pb.PbFieldType.OD)
    ..a<$core.double>(17, _omitFieldNames ? '' : 'differencePercent', $pb.PbFieldType.OD, protoName: 'differencePercent')
    ..a<$core.double>(18, _omitFieldNames ? '' : 'days7DifPer', $pb.PbFieldType.OD, protoName: 'days7DifPer')
    ..a<$core.double>(19, _omitFieldNames ? '' : 'days30DifPer', $pb.PbFieldType.OD, protoName: 'days30DifPer')
    ..a<$core.double>(20, _omitFieldNames ? '' : 'week52DifPer', $pb.PbFieldType.OD, protoName: 'week52DifPer')
    ..a<$core.double>(21, _omitFieldNames ? '' : 'monthHigh', $pb.PbFieldType.OD, protoName: 'monthHigh')
    ..a<$core.double>(22, _omitFieldNames ? '' : 'monthLow', $pb.PbFieldType.OD, protoName: 'monthLow')
    ..a<$core.double>(23, _omitFieldNames ? '' : 'yearHigh', $pb.PbFieldType.OD, protoName: 'yearHigh')
    ..a<$core.double>(24, _omitFieldNames ? '' : 'yearLow', $pb.PbFieldType.OD, protoName: 'yearLow')
    ..a<$core.double>(25, _omitFieldNames ? '' : 'priceMean', $pb.PbFieldType.OD, protoName: 'priceMean')
    ..a<$core.double>(26, _omitFieldNames ? '' : 'limitUp', $pb.PbFieldType.OD, protoName: 'limitUp')
    ..a<$core.double>(27, _omitFieldNames ? '' : 'limitDown', $pb.PbFieldType.OD, protoName: 'limitDown')
    ..a<$core.double>(28, _omitFieldNames ? '' : 'netProceeds', $pb.PbFieldType.OD, protoName: 'netProceeds')
    ..a<$core.double>(29, _omitFieldNames ? '' : 'priceProceeds', $pb.PbFieldType.OD, protoName: 'priceProceeds')
    ..a<$core.double>(30, _omitFieldNames ? '' : 'marketValue', $pb.PbFieldType.OD, protoName: 'marketValue')
    ..a<$core.double>(31, _omitFieldNames ? '' : 'marketValueUsd', $pb.PbFieldType.OD, protoName: 'marketValueUsd')
    ..a<$core.double>(32, _omitFieldNames ? '' : 'marValBookVal', $pb.PbFieldType.OD, protoName: 'marValBookVal')
    ..a<$core.double>(33, _omitFieldNames ? '' : 'equity', $pb.PbFieldType.OD)
    ..a<$core.double>(34, _omitFieldNames ? '' : 'capital', $pb.PbFieldType.OD)
    ..a<$core.double>(35, _omitFieldNames ? '' : 'circulationShare', $pb.PbFieldType.OD, protoName: 'circulationShare')
    ..a<$core.double>(36, _omitFieldNames ? '' : 'circulationSharePer', $pb.PbFieldType.OD, protoName: 'circulationSharePer')
    ..aOS(37, _omitFieldNames ? '' : 'symbolGroup', protoName: 'symbolGroup')
    ..a<$core.double>(38, _omitFieldNames ? '' : 'dailyVolume', $pb.PbFieldType.OD, protoName: 'dailyVolume')
    ..aOB(39, _omitFieldNames ? '' : 'sessionIsOpen', protoName: 'sessionIsOpen')
    ..aOB(40, _omitFieldNames ? '' : 'openForTrade', protoName: 'openForTrade')
    ..a<$core.double>(41, _omitFieldNames ? '' : 'priceStep', $pb.PbFieldType.OD, protoName: 'priceStep')
    ..a<$core.double>(42, _omitFieldNames ? '' : 'basePrice', $pb.PbFieldType.OD, protoName: 'basePrice')
    ..aOS(43, _omitFieldNames ? '' : 'symbolType', protoName: 'symbolType')
    ..a<$core.int>(44, _omitFieldNames ? '' : 'tradeFraction', $pb.PbFieldType.O3, protoName: 'tradeFraction')
    ..aOS(45, _omitFieldNames ? '' : 'stockSymbolCode', protoName: 'stockSymbolCode')
    ..aOS(46, _omitFieldNames ? '' : 'tradeDate', protoName: 'tradeDate')
    ..a<$core.double>(47, _omitFieldNames ? '' : 'open', $pb.PbFieldType.OD)
    ..a<$core.double>(48, _omitFieldNames ? '' : 'dailyQuantity', $pb.PbFieldType.OD, protoName: 'dailyQuantity')
    ..aOS(49, _omitFieldNames ? '' : 'actionType', protoName: 'actionType')
    ..a<$core.int>(50, _omitFieldNames ? '' : 'brutSwap', $pb.PbFieldType.O3, protoName: 'brutSwap')
    ..a<$core.double>(51, _omitFieldNames ? '' : 'totalTradeCount', $pb.PbFieldType.OD, protoName: 'totalTradeCount')
    ..a<$core.double>(52, _omitFieldNames ? '' : 'lastQuantity', $pb.PbFieldType.OD, protoName: 'lastQuantity')
    ..a<$core.double>(53, _omitFieldNames ? '' : 'weekLow', $pb.PbFieldType.OD, protoName: 'weekLow')
    ..a<$core.double>(54, _omitFieldNames ? '' : 'weekHigh', $pb.PbFieldType.OD, protoName: 'weekHigh')
    ..a<$core.double>(55, _omitFieldNames ? '' : 'weekClose', $pb.PbFieldType.OD, protoName: 'weekClose')
    ..a<$core.double>(56, _omitFieldNames ? '' : 'monthClose', $pb.PbFieldType.OD, protoName: 'monthClose')
    ..a<$core.double>(57, _omitFieldNames ? '' : 'yearClose', $pb.PbFieldType.OD, protoName: 'yearClose')
    ..aOS(58, _omitFieldNames ? '' : 'period')
    ..a<$core.double>(59, _omitFieldNames ? '' : 'shiftedNetProceed', $pb.PbFieldType.OD, protoName: 'shiftedNetProceed')
    ..aInt64(60, _omitFieldNames ? '' : 'askSize', protoName: 'askSize')
    ..aInt64(61, _omitFieldNames ? '' : 'bidSize', protoName: 'bidSize')
    ..a<$core.double>(62, _omitFieldNames ? '' : 'eqPrice', $pb.PbFieldType.OD, protoName: 'eqPrice')
    ..a<$core.double>(63, _omitFieldNames ? '' : 'eqQuantity', $pb.PbFieldType.OD, protoName: 'eqQuantity')
    ..a<$core.double>(64, _omitFieldNames ? '' : 'eqRemainingBidQuantity', $pb.PbFieldType.OD, protoName: 'eqRemainingBidQuantity')
    ..a<$core.double>(65, _omitFieldNames ? '' : 'eqRemainingAskQuantity', $pb.PbFieldType.OD, protoName: 'eqRemainingAskQuantity')
    ..a<$core.double>(66, _omitFieldNames ? '' : 'prevYearClose', $pb.PbFieldType.OD, protoName: 'prevYearClose')
    ..a<$core.int>(67, _omitFieldNames ? '' : 'direction', $pb.PbFieldType.O3)
    ..a<$core.double>(68, _omitFieldNames ? '' : 'weekPriceMean', $pb.PbFieldType.OD, protoName: 'weekPriceMean')
    ..a<$core.double>(69, _omitFieldNames ? '' : 'monthPriceMean', $pb.PbFieldType.OD, protoName: 'monthPriceMean')
    ..a<$core.double>(70, _omitFieldNames ? '' : 'yearPriceMean', $pb.PbFieldType.OD, protoName: 'yearPriceMean')
    ..a<$core.double>(71, _omitFieldNames ? '' : 'beta100', $pb.PbFieldType.OD)
    ..a<$core.double>(72, _omitFieldNames ? '' : 'cashNetDividend', $pb.PbFieldType.OD, protoName: 'cashNetDividend')
    ..a<$core.double>(73, _omitFieldNames ? '' : 'dividendYield', $pb.PbFieldType.OD, protoName: 'dividendYield')
    ..a<$core.int>(74, _omitFieldNames ? '' : 'stockStatus', $pb.PbFieldType.O3, protoName: 'stockStatus')
    ..a<$core.double>(75, _omitFieldNames ? '' : 'incrementalQuantity', $pb.PbFieldType.OD, protoName: 'incrementalQuantity')
    ..e<SymbolMessage_PublishReason>(76, _omitFieldNames ? '' : 'publishReason', $pb.PbFieldType.OE, protoName: 'publishReason', defaultOrMaker: SymbolMessage_PublishReason.UPDATE, valueOf: SymbolMessage_PublishReason.valueOf, enumValues: SymbolMessage_PublishReason.values)
    ..a<$core.double>(77, _omitFieldNames ? '' : 'xu030Weight', $pb.PbFieldType.OD, protoName: 'xu030Weight')
    ..a<$core.double>(78, _omitFieldNames ? '' : 'xu050Weight', $pb.PbFieldType.OD, protoName: 'xu050Weight')
    ..a<$core.double>(79, _omitFieldNames ? '' : 'xu100Weight', $pb.PbFieldType.OD, protoName: 'xu100Weight')
    ..a<$core.double>(80, _omitFieldNames ? '' : 'netDebt', $pb.PbFieldType.OD, protoName: 'netDebt')
    ..a<$core.double>(81, _omitFieldNames ? '' : 'shiftedEbitda', $pb.PbFieldType.OD, protoName: 'shiftedEbitda')
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SymbolMessage clone() => SymbolMessage()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SymbolMessage copyWith(void Function(SymbolMessage) updates) => super.copyWith((message) => updates(message as SymbolMessage)) as SymbolMessage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SymbolMessage create() => SymbolMessage._();
  @$core.override
  SymbolMessage createEmptyInstance() => create();
  static $pb.PbList<SymbolMessage> createRepeated() => $pb.PbList<SymbolMessage>();
  @$core.pragma('dart2js:noInline')
  static SymbolMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SymbolMessage>(create);
  static SymbolMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get symbolId => $_getIZ(0);
  @$pb.TagNumber(1)
  set symbolId($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSymbolId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSymbolId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get symbolCode => $_getSZ(1);
  @$pb.TagNumber(2)
  set symbolCode($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSymbolCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearSymbolCode() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get symbolDesc => $_getSZ(2);
  @$pb.TagNumber(3)
  set symbolDesc($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSymbolDesc() => $_has(2);
  @$pb.TagNumber(3)
  void clearSymbolDesc() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get updateDate => $_getSZ(3);
  @$pb.TagNumber(4)
  set updateDate($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUpdateDate() => $_has(3);
  @$pb.TagNumber(4)
  void clearUpdateDate() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get bid => $_getN(4);
  @$pb.TagNumber(5)
  set bid($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasBid() => $_has(4);
  @$pb.TagNumber(5)
  void clearBid() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get ask => $_getN(5);
  @$pb.TagNumber(6)
  set ask($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAsk() => $_has(5);
  @$pb.TagNumber(6)
  void clearAsk() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get low => $_getN(6);
  @$pb.TagNumber(7)
  set low($core.double value) => $_setDouble(6, value);
  @$pb.TagNumber(7)
  $core.bool hasLow() => $_has(6);
  @$pb.TagNumber(7)
  void clearLow() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.double get high => $_getN(7);
  @$pb.TagNumber(8)
  set high($core.double value) => $_setDouble(7, value);
  @$pb.TagNumber(8)
  $core.bool hasHigh() => $_has(7);
  @$pb.TagNumber(8)
  void clearHigh() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.double get last => $_getN(8);
  @$pb.TagNumber(9)
  set last($core.double value) => $_setDouble(8, value);
  @$pb.TagNumber(9)
  $core.bool hasLast() => $_has(8);
  @$pb.TagNumber(9)
  void clearLast() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.double get dayClose => $_getN(9);
  @$pb.TagNumber(10)
  set dayClose($core.double value) => $_setDouble(9, value);
  @$pb.TagNumber(10)
  $core.bool hasDayClose() => $_has(9);
  @$pb.TagNumber(10)
  void clearDayClose() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get fractionCount => $_getIZ(10);
  @$pb.TagNumber(11)
  set fractionCount($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasFractionCount() => $_has(10);
  @$pb.TagNumber(11)
  void clearFractionCount() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.double get dailyLow => $_getN(11);
  @$pb.TagNumber(12)
  set dailyLow($core.double value) => $_setDouble(11, value);
  @$pb.TagNumber(12)
  $core.bool hasDailyLow() => $_has(11);
  @$pb.TagNumber(12)
  void clearDailyLow() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.double get dailyHigh => $_getN(12);
  @$pb.TagNumber(13)
  set dailyHigh($core.double value) => $_setDouble(12, value);
  @$pb.TagNumber(13)
  $core.bool hasDailyHigh() => $_has(12);
  @$pb.TagNumber(13)
  void clearDailyHigh() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.double get quantity => $_getN(13);
  @$pb.TagNumber(14)
  set quantity($core.double value) => $_setDouble(13, value);
  @$pb.TagNumber(14)
  $core.bool hasQuantity() => $_has(13);
  @$pb.TagNumber(14)
  void clearQuantity() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.double get volume => $_getN(14);
  @$pb.TagNumber(15)
  set volume($core.double value) => $_setDouble(14, value);
  @$pb.TagNumber(15)
  $core.bool hasVolume() => $_has(14);
  @$pb.TagNumber(15)
  void clearVolume() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.double get difference => $_getN(15);
  @$pb.TagNumber(16)
  set difference($core.double value) => $_setDouble(15, value);
  @$pb.TagNumber(16)
  $core.bool hasDifference() => $_has(15);
  @$pb.TagNumber(16)
  void clearDifference() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.double get differencePercent => $_getN(16);
  @$pb.TagNumber(17)
  set differencePercent($core.double value) => $_setDouble(16, value);
  @$pb.TagNumber(17)
  $core.bool hasDifferencePercent() => $_has(16);
  @$pb.TagNumber(17)
  void clearDifferencePercent() => $_clearField(17);

  @$pb.TagNumber(18)
  $core.double get days7DifPer => $_getN(17);
  @$pb.TagNumber(18)
  set days7DifPer($core.double value) => $_setDouble(17, value);
  @$pb.TagNumber(18)
  $core.bool hasDays7DifPer() => $_has(17);
  @$pb.TagNumber(18)
  void clearDays7DifPer() => $_clearField(18);

  @$pb.TagNumber(19)
  $core.double get days30DifPer => $_getN(18);
  @$pb.TagNumber(19)
  set days30DifPer($core.double value) => $_setDouble(18, value);
  @$pb.TagNumber(19)
  $core.bool hasDays30DifPer() => $_has(18);
  @$pb.TagNumber(19)
  void clearDays30DifPer() => $_clearField(19);

  @$pb.TagNumber(20)
  $core.double get week52DifPer => $_getN(19);
  @$pb.TagNumber(20)
  set week52DifPer($core.double value) => $_setDouble(19, value);
  @$pb.TagNumber(20)
  $core.bool hasWeek52DifPer() => $_has(19);
  @$pb.TagNumber(20)
  void clearWeek52DifPer() => $_clearField(20);

  @$pb.TagNumber(21)
  $core.double get monthHigh => $_getN(20);
  @$pb.TagNumber(21)
  set monthHigh($core.double value) => $_setDouble(20, value);
  @$pb.TagNumber(21)
  $core.bool hasMonthHigh() => $_has(20);
  @$pb.TagNumber(21)
  void clearMonthHigh() => $_clearField(21);

  @$pb.TagNumber(22)
  $core.double get monthLow => $_getN(21);
  @$pb.TagNumber(22)
  set monthLow($core.double value) => $_setDouble(21, value);
  @$pb.TagNumber(22)
  $core.bool hasMonthLow() => $_has(21);
  @$pb.TagNumber(22)
  void clearMonthLow() => $_clearField(22);

  @$pb.TagNumber(23)
  $core.double get yearHigh => $_getN(22);
  @$pb.TagNumber(23)
  set yearHigh($core.double value) => $_setDouble(22, value);
  @$pb.TagNumber(23)
  $core.bool hasYearHigh() => $_has(22);
  @$pb.TagNumber(23)
  void clearYearHigh() => $_clearField(23);

  @$pb.TagNumber(24)
  $core.double get yearLow => $_getN(23);
  @$pb.TagNumber(24)
  set yearLow($core.double value) => $_setDouble(23, value);
  @$pb.TagNumber(24)
  $core.bool hasYearLow() => $_has(23);
  @$pb.TagNumber(24)
  void clearYearLow() => $_clearField(24);

  @$pb.TagNumber(25)
  $core.double get priceMean => $_getN(24);
  @$pb.TagNumber(25)
  set priceMean($core.double value) => $_setDouble(24, value);
  @$pb.TagNumber(25)
  $core.bool hasPriceMean() => $_has(24);
  @$pb.TagNumber(25)
  void clearPriceMean() => $_clearField(25);

  @$pb.TagNumber(26)
  $core.double get limitUp => $_getN(25);
  @$pb.TagNumber(26)
  set limitUp($core.double value) => $_setDouble(25, value);
  @$pb.TagNumber(26)
  $core.bool hasLimitUp() => $_has(25);
  @$pb.TagNumber(26)
  void clearLimitUp() => $_clearField(26);

  @$pb.TagNumber(27)
  $core.double get limitDown => $_getN(26);
  @$pb.TagNumber(27)
  set limitDown($core.double value) => $_setDouble(26, value);
  @$pb.TagNumber(27)
  $core.bool hasLimitDown() => $_has(26);
  @$pb.TagNumber(27)
  void clearLimitDown() => $_clearField(27);

  @$pb.TagNumber(28)
  $core.double get netProceeds => $_getN(27);
  @$pb.TagNumber(28)
  set netProceeds($core.double value) => $_setDouble(27, value);
  @$pb.TagNumber(28)
  $core.bool hasNetProceeds() => $_has(27);
  @$pb.TagNumber(28)
  void clearNetProceeds() => $_clearField(28);

  @$pb.TagNumber(29)
  $core.double get priceProceeds => $_getN(28);
  @$pb.TagNumber(29)
  set priceProceeds($core.double value) => $_setDouble(28, value);
  @$pb.TagNumber(29)
  $core.bool hasPriceProceeds() => $_has(28);
  @$pb.TagNumber(29)
  void clearPriceProceeds() => $_clearField(29);

  @$pb.TagNumber(30)
  $core.double get marketValue => $_getN(29);
  @$pb.TagNumber(30)
  set marketValue($core.double value) => $_setDouble(29, value);
  @$pb.TagNumber(30)
  $core.bool hasMarketValue() => $_has(29);
  @$pb.TagNumber(30)
  void clearMarketValue() => $_clearField(30);

  @$pb.TagNumber(31)
  $core.double get marketValueUsd => $_getN(30);
  @$pb.TagNumber(31)
  set marketValueUsd($core.double value) => $_setDouble(30, value);
  @$pb.TagNumber(31)
  $core.bool hasMarketValueUsd() => $_has(30);
  @$pb.TagNumber(31)
  void clearMarketValueUsd() => $_clearField(31);

  @$pb.TagNumber(32)
  $core.double get marValBookVal => $_getN(31);
  @$pb.TagNumber(32)
  set marValBookVal($core.double value) => $_setDouble(31, value);
  @$pb.TagNumber(32)
  $core.bool hasMarValBookVal() => $_has(31);
  @$pb.TagNumber(32)
  void clearMarValBookVal() => $_clearField(32);

  @$pb.TagNumber(33)
  $core.double get equity => $_getN(32);
  @$pb.TagNumber(33)
  set equity($core.double value) => $_setDouble(32, value);
  @$pb.TagNumber(33)
  $core.bool hasEquity() => $_has(32);
  @$pb.TagNumber(33)
  void clearEquity() => $_clearField(33);

  @$pb.TagNumber(34)
  $core.double get capital => $_getN(33);
  @$pb.TagNumber(34)
  set capital($core.double value) => $_setDouble(33, value);
  @$pb.TagNumber(34)
  $core.bool hasCapital() => $_has(33);
  @$pb.TagNumber(34)
  void clearCapital() => $_clearField(34);

  @$pb.TagNumber(35)
  $core.double get circulationShare => $_getN(34);
  @$pb.TagNumber(35)
  set circulationShare($core.double value) => $_setDouble(34, value);
  @$pb.TagNumber(35)
  $core.bool hasCirculationShare() => $_has(34);
  @$pb.TagNumber(35)
  void clearCirculationShare() => $_clearField(35);

  @$pb.TagNumber(36)
  $core.double get circulationSharePer => $_getN(35);
  @$pb.TagNumber(36)
  set circulationSharePer($core.double value) => $_setDouble(35, value);
  @$pb.TagNumber(36)
  $core.bool hasCirculationSharePer() => $_has(35);
  @$pb.TagNumber(36)
  void clearCirculationSharePer() => $_clearField(36);

  @$pb.TagNumber(37)
  $core.String get symbolGroup => $_getSZ(36);
  @$pb.TagNumber(37)
  set symbolGroup($core.String value) => $_setString(36, value);
  @$pb.TagNumber(37)
  $core.bool hasSymbolGroup() => $_has(36);
  @$pb.TagNumber(37)
  void clearSymbolGroup() => $_clearField(37);

  @$pb.TagNumber(38)
  $core.double get dailyVolume => $_getN(37);
  @$pb.TagNumber(38)
  set dailyVolume($core.double value) => $_setDouble(37, value);
  @$pb.TagNumber(38)
  $core.bool hasDailyVolume() => $_has(37);
  @$pb.TagNumber(38)
  void clearDailyVolume() => $_clearField(38);

  @$pb.TagNumber(39)
  $core.bool get sessionIsOpen => $_getBF(38);
  @$pb.TagNumber(39)
  set sessionIsOpen($core.bool value) => $_setBool(38, value);
  @$pb.TagNumber(39)
  $core.bool hasSessionIsOpen() => $_has(38);
  @$pb.TagNumber(39)
  void clearSessionIsOpen() => $_clearField(39);

  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(40)
  $core.bool get openForTrade => $_getBF(39);
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(40)
  set openForTrade($core.bool value) => $_setBool(39, value);
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(40)
  $core.bool hasOpenForTrade() => $_has(39);
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(40)
  void clearOpenForTrade() => $_clearField(40);

  @$pb.TagNumber(41)
  $core.double get priceStep => $_getN(40);
  @$pb.TagNumber(41)
  set priceStep($core.double value) => $_setDouble(40, value);
  @$pb.TagNumber(41)
  $core.bool hasPriceStep() => $_has(40);
  @$pb.TagNumber(41)
  void clearPriceStep() => $_clearField(41);

  @$pb.TagNumber(42)
  $core.double get basePrice => $_getN(41);
  @$pb.TagNumber(42)
  set basePrice($core.double value) => $_setDouble(41, value);
  @$pb.TagNumber(42)
  $core.bool hasBasePrice() => $_has(41);
  @$pb.TagNumber(42)
  void clearBasePrice() => $_clearField(42);

  @$pb.TagNumber(43)
  $core.String get symbolType => $_getSZ(42);
  @$pb.TagNumber(43)
  set symbolType($core.String value) => $_setString(42, value);
  @$pb.TagNumber(43)
  $core.bool hasSymbolType() => $_has(42);
  @$pb.TagNumber(43)
  void clearSymbolType() => $_clearField(43);

  @$pb.TagNumber(44)
  $core.int get tradeFraction => $_getIZ(43);
  @$pb.TagNumber(44)
  set tradeFraction($core.int value) => $_setSignedInt32(43, value);
  @$pb.TagNumber(44)
  $core.bool hasTradeFraction() => $_has(43);
  @$pb.TagNumber(44)
  void clearTradeFraction() => $_clearField(44);

  @$pb.TagNumber(45)
  $core.String get stockSymbolCode => $_getSZ(44);
  @$pb.TagNumber(45)
  set stockSymbolCode($core.String value) => $_setString(44, value);
  @$pb.TagNumber(45)
  $core.bool hasStockSymbolCode() => $_has(44);
  @$pb.TagNumber(45)
  void clearStockSymbolCode() => $_clearField(45);

  @$pb.TagNumber(46)
  $core.String get tradeDate => $_getSZ(45);
  @$pb.TagNumber(46)
  set tradeDate($core.String value) => $_setString(45, value);
  @$pb.TagNumber(46)
  $core.bool hasTradeDate() => $_has(45);
  @$pb.TagNumber(46)
  void clearTradeDate() => $_clearField(46);

  @$pb.TagNumber(47)
  $core.double get open => $_getN(46);
  @$pb.TagNumber(47)
  set open($core.double value) => $_setDouble(46, value);
  @$pb.TagNumber(47)
  $core.bool hasOpen() => $_has(46);
  @$pb.TagNumber(47)
  void clearOpen() => $_clearField(47);

  @$pb.TagNumber(48)
  $core.double get dailyQuantity => $_getN(47);
  @$pb.TagNumber(48)
  set dailyQuantity($core.double value) => $_setDouble(47, value);
  @$pb.TagNumber(48)
  $core.bool hasDailyQuantity() => $_has(47);
  @$pb.TagNumber(48)
  void clearDailyQuantity() => $_clearField(48);

  @$pb.TagNumber(49)
  $core.String get actionType => $_getSZ(48);
  @$pb.TagNumber(49)
  set actionType($core.String value) => $_setString(48, value);
  @$pb.TagNumber(49)
  $core.bool hasActionType() => $_has(48);
  @$pb.TagNumber(49)
  void clearActionType() => $_clearField(49);

  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(50)
  $core.int get brutSwap => $_getIZ(49);
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(50)
  set brutSwap($core.int value) => $_setSignedInt32(49, value);
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(50)
  $core.bool hasBrutSwap() => $_has(49);
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(50)
  void clearBrutSwap() => $_clearField(50);

  @$pb.TagNumber(51)
  $core.double get totalTradeCount => $_getN(50);
  @$pb.TagNumber(51)
  set totalTradeCount($core.double value) => $_setDouble(50, value);
  @$pb.TagNumber(51)
  $core.bool hasTotalTradeCount() => $_has(50);
  @$pb.TagNumber(51)
  void clearTotalTradeCount() => $_clearField(51);

  @$pb.TagNumber(52)
  $core.double get lastQuantity => $_getN(51);
  @$pb.TagNumber(52)
  set lastQuantity($core.double value) => $_setDouble(51, value);
  @$pb.TagNumber(52)
  $core.bool hasLastQuantity() => $_has(51);
  @$pb.TagNumber(52)
  void clearLastQuantity() => $_clearField(52);

  @$pb.TagNumber(53)
  $core.double get weekLow => $_getN(52);
  @$pb.TagNumber(53)
  set weekLow($core.double value) => $_setDouble(52, value);
  @$pb.TagNumber(53)
  $core.bool hasWeekLow() => $_has(52);
  @$pb.TagNumber(53)
  void clearWeekLow() => $_clearField(53);

  @$pb.TagNumber(54)
  $core.double get weekHigh => $_getN(53);
  @$pb.TagNumber(54)
  set weekHigh($core.double value) => $_setDouble(53, value);
  @$pb.TagNumber(54)
  $core.bool hasWeekHigh() => $_has(53);
  @$pb.TagNumber(54)
  void clearWeekHigh() => $_clearField(54);

  @$pb.TagNumber(55)
  $core.double get weekClose => $_getN(54);
  @$pb.TagNumber(55)
  set weekClose($core.double value) => $_setDouble(54, value);
  @$pb.TagNumber(55)
  $core.bool hasWeekClose() => $_has(54);
  @$pb.TagNumber(55)
  void clearWeekClose() => $_clearField(55);

  @$pb.TagNumber(56)
  $core.double get monthClose => $_getN(55);
  @$pb.TagNumber(56)
  set monthClose($core.double value) => $_setDouble(55, value);
  @$pb.TagNumber(56)
  $core.bool hasMonthClose() => $_has(55);
  @$pb.TagNumber(56)
  void clearMonthClose() => $_clearField(56);

  @$pb.TagNumber(57)
  $core.double get yearClose => $_getN(56);
  @$pb.TagNumber(57)
  set yearClose($core.double value) => $_setDouble(56, value);
  @$pb.TagNumber(57)
  $core.bool hasYearClose() => $_has(56);
  @$pb.TagNumber(57)
  void clearYearClose() => $_clearField(57);

  @$pb.TagNumber(58)
  $core.String get period => $_getSZ(57);
  @$pb.TagNumber(58)
  set period($core.String value) => $_setString(57, value);
  @$pb.TagNumber(58)
  $core.bool hasPeriod() => $_has(57);
  @$pb.TagNumber(58)
  void clearPeriod() => $_clearField(58);

  @$pb.TagNumber(59)
  $core.double get shiftedNetProceed => $_getN(58);
  @$pb.TagNumber(59)
  set shiftedNetProceed($core.double value) => $_setDouble(58, value);
  @$pb.TagNumber(59)
  $core.bool hasShiftedNetProceed() => $_has(58);
  @$pb.TagNumber(59)
  void clearShiftedNetProceed() => $_clearField(59);

  @$pb.TagNumber(60)
  $fixnum.Int64 get askSize => $_getI64(59);
  @$pb.TagNumber(60)
  set askSize($fixnum.Int64 value) => $_setInt64(59, value);
  @$pb.TagNumber(60)
  $core.bool hasAskSize() => $_has(59);
  @$pb.TagNumber(60)
  void clearAskSize() => $_clearField(60);

  @$pb.TagNumber(61)
  $fixnum.Int64 get bidSize => $_getI64(60);
  @$pb.TagNumber(61)
  set bidSize($fixnum.Int64 value) => $_setInt64(60, value);
  @$pb.TagNumber(61)
  $core.bool hasBidSize() => $_has(60);
  @$pb.TagNumber(61)
  void clearBidSize() => $_clearField(61);

  @$pb.TagNumber(62)
  $core.double get eqPrice => $_getN(61);
  @$pb.TagNumber(62)
  set eqPrice($core.double value) => $_setDouble(61, value);
  @$pb.TagNumber(62)
  $core.bool hasEqPrice() => $_has(61);
  @$pb.TagNumber(62)
  void clearEqPrice() => $_clearField(62);

  @$pb.TagNumber(63)
  $core.double get eqQuantity => $_getN(62);
  @$pb.TagNumber(63)
  set eqQuantity($core.double value) => $_setDouble(62, value);
  @$pb.TagNumber(63)
  $core.bool hasEqQuantity() => $_has(62);
  @$pb.TagNumber(63)
  void clearEqQuantity() => $_clearField(63);

  @$pb.TagNumber(64)
  $core.double get eqRemainingBidQuantity => $_getN(63);
  @$pb.TagNumber(64)
  set eqRemainingBidQuantity($core.double value) => $_setDouble(63, value);
  @$pb.TagNumber(64)
  $core.bool hasEqRemainingBidQuantity() => $_has(63);
  @$pb.TagNumber(64)
  void clearEqRemainingBidQuantity() => $_clearField(64);

  @$pb.TagNumber(65)
  $core.double get eqRemainingAskQuantity => $_getN(64);
  @$pb.TagNumber(65)
  set eqRemainingAskQuantity($core.double value) => $_setDouble(64, value);
  @$pb.TagNumber(65)
  $core.bool hasEqRemainingAskQuantity() => $_has(64);
  @$pb.TagNumber(65)
  void clearEqRemainingAskQuantity() => $_clearField(65);

  @$pb.TagNumber(66)
  $core.double get prevYearClose => $_getN(65);
  @$pb.TagNumber(66)
  set prevYearClose($core.double value) => $_setDouble(65, value);
  @$pb.TagNumber(66)
  $core.bool hasPrevYearClose() => $_has(65);
  @$pb.TagNumber(66)
  void clearPrevYearClose() => $_clearField(66);

  @$pb.TagNumber(67)
  $core.int get direction => $_getIZ(66);
  @$pb.TagNumber(67)
  set direction($core.int value) => $_setSignedInt32(66, value);
  @$pb.TagNumber(67)
  $core.bool hasDirection() => $_has(66);
  @$pb.TagNumber(67)
  void clearDirection() => $_clearField(67);

  @$pb.TagNumber(68)
  $core.double get weekPriceMean => $_getN(67);
  @$pb.TagNumber(68)
  set weekPriceMean($core.double value) => $_setDouble(67, value);
  @$pb.TagNumber(68)
  $core.bool hasWeekPriceMean() => $_has(67);
  @$pb.TagNumber(68)
  void clearWeekPriceMean() => $_clearField(68);

  @$pb.TagNumber(69)
  $core.double get monthPriceMean => $_getN(68);
  @$pb.TagNumber(69)
  set monthPriceMean($core.double value) => $_setDouble(68, value);
  @$pb.TagNumber(69)
  $core.bool hasMonthPriceMean() => $_has(68);
  @$pb.TagNumber(69)
  void clearMonthPriceMean() => $_clearField(69);

  @$pb.TagNumber(70)
  $core.double get yearPriceMean => $_getN(69);
  @$pb.TagNumber(70)
  set yearPriceMean($core.double value) => $_setDouble(69, value);
  @$pb.TagNumber(70)
  $core.bool hasYearPriceMean() => $_has(69);
  @$pb.TagNumber(70)
  void clearYearPriceMean() => $_clearField(70);

  @$pb.TagNumber(71)
  $core.double get beta100 => $_getN(70);
  @$pb.TagNumber(71)
  set beta100($core.double value) => $_setDouble(70, value);
  @$pb.TagNumber(71)
  $core.bool hasBeta100() => $_has(70);
  @$pb.TagNumber(71)
  void clearBeta100() => $_clearField(71);

  @$pb.TagNumber(72)
  $core.double get cashNetDividend => $_getN(71);
  @$pb.TagNumber(72)
  set cashNetDividend($core.double value) => $_setDouble(71, value);
  @$pb.TagNumber(72)
  $core.bool hasCashNetDividend() => $_has(71);
  @$pb.TagNumber(72)
  void clearCashNetDividend() => $_clearField(72);

  @$pb.TagNumber(73)
  $core.double get dividendYield => $_getN(72);
  @$pb.TagNumber(73)
  set dividendYield($core.double value) => $_setDouble(72, value);
  @$pb.TagNumber(73)
  $core.bool hasDividendYield() => $_has(72);
  @$pb.TagNumber(73)
  void clearDividendYield() => $_clearField(73);

  @$pb.TagNumber(74)
  $core.int get stockStatus => $_getIZ(73);
  @$pb.TagNumber(74)
  set stockStatus($core.int value) => $_setSignedInt32(73, value);
  @$pb.TagNumber(74)
  $core.bool hasStockStatus() => $_has(73);
  @$pb.TagNumber(74)
  void clearStockStatus() => $_clearField(74);

  @$pb.TagNumber(75)
  $core.double get incrementalQuantity => $_getN(74);
  @$pb.TagNumber(75)
  set incrementalQuantity($core.double value) => $_setDouble(74, value);
  @$pb.TagNumber(75)
  $core.bool hasIncrementalQuantity() => $_has(74);
  @$pb.TagNumber(75)
  void clearIncrementalQuantity() => $_clearField(75);

  @$pb.TagNumber(76)
  SymbolMessage_PublishReason get publishReason => $_getN(75);
  @$pb.TagNumber(76)
  set publishReason(SymbolMessage_PublishReason value) => $_setField(76, value);
  @$pb.TagNumber(76)
  $core.bool hasPublishReason() => $_has(75);
  @$pb.TagNumber(76)
  void clearPublishReason() => $_clearField(76);

  @$pb.TagNumber(77)
  $core.double get xu030Weight => $_getN(76);
  @$pb.TagNumber(77)
  set xu030Weight($core.double value) => $_setDouble(76, value);
  @$pb.TagNumber(77)
  $core.bool hasXu030Weight() => $_has(76);
  @$pb.TagNumber(77)
  void clearXu030Weight() => $_clearField(77);

  @$pb.TagNumber(78)
  $core.double get xu050Weight => $_getN(77);
  @$pb.TagNumber(78)
  set xu050Weight($core.double value) => $_setDouble(77, value);
  @$pb.TagNumber(78)
  $core.bool hasXu050Weight() => $_has(77);
  @$pb.TagNumber(78)
  void clearXu050Weight() => $_clearField(78);

  @$pb.TagNumber(79)
  $core.double get xu100Weight => $_getN(78);
  @$pb.TagNumber(79)
  set xu100Weight($core.double value) => $_setDouble(78, value);
  @$pb.TagNumber(79)
  $core.bool hasXu100Weight() => $_has(78);
  @$pb.TagNumber(79)
  void clearXu100Weight() => $_clearField(79);

  @$pb.TagNumber(80)
  $core.double get netDebt => $_getN(79);
  @$pb.TagNumber(80)
  set netDebt($core.double value) => $_setDouble(79, value);
  @$pb.TagNumber(80)
  $core.bool hasNetDebt() => $_has(79);
  @$pb.TagNumber(80)
  void clearNetDebt() => $_clearField(80);

  @$pb.TagNumber(81)
  $core.double get shiftedEbitda => $_getN(80);
  @$pb.TagNumber(81)
  set shiftedEbitda($core.double value) => $_setDouble(80, value);
  @$pb.TagNumber(81)
  $core.bool hasShiftedEbitda() => $_has(80);
  @$pb.TagNumber(81)
  void clearShiftedEbitda() => $_clearField(81);
}


const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
