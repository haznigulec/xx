// This is a generated file - do not edit.
//
// Generated from Derivative/Derivative.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'Derivative.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'Derivative.pbenum.dart';

class DerivativeMessage extends $pb.GeneratedMessage {
  factory DerivativeMessage({
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
    $core.double? strikePrice,
    $core.String? maturity,
    $core.String? underlying,
    DerivativeMessage_OptionClass? optionClass,
    $core.double? dailyLow,
    $core.double? dailyHigh,
    $core.double? quantity,
    $core.double? volume,
    $core.double? difference,
    $core.double? differencePercent,
    $core.double? sevenDaysDifPer,
    $core.double? thirtyDaysDifPer,
    $core.double? fiftytwoWeekDifPer,
    $core.double? monthHigh,
    $core.double? monthLow,
    $core.double? yearHigh,
    $core.double? yearLow,
    $core.double? priceMean,
    $core.double? limitUp,
    $core.double? limitDown,
    $core.double? settlement,
    $core.double? settlementPerDif,
    $fixnum.Int64? openInterest,
    $core.double? theoricalPrice,
    $core.double? theoricelPDifPer,
    $core.double? dailyVolume,
    $core.double? priceStep,
    $core.bool? openForTrade,
    $core.String? tradeDate,
    $core.double? open,
    $core.double? dailyQuantity,
    $core.String? actionType,
  @$core.Deprecated('This field is deprecated.')
    $core.int? brutSwap,
    $core.double? totalTradeCount,
    $core.double? lastQuantity,
    $core.double? openInterestChange,
    $core.double? weekLow,
    $core.double? weekHigh,
    $core.double? weekClose,
    $core.double? monthClose,
    $core.double? yearClose,
    $core.double? preSettlement,
    $fixnum.Int64? askSize,
    $fixnum.Int64? bidSize,
    $core.double? rate,
    $core.String? marketMaker,
    $core.double? marketMakerAsk,
    $core.double? marketMakerBid,
    $core.double? prevYearClose,
    $core.String? riskLevel,
    $core.double? marketMakerAskClose,
    $core.double? marketMakerBidClose,
    $core.double? weekPriceMean,
    $core.double? monthPriceMean,
    $core.double? yearPriceMean,
    $core.double? incrementalQuantity,
    DerivativeMessage_PublishReason? publishReason,
    $core.int? stockStatus,
    $core.double? eqPrice,
    $core.double? eqQuantity,
    $core.double? eqRemainingBidQuantity,
    $core.double? eqRemainingAskQuantity,
    $core.double? initialMargin,
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
    if (strikePrice != null) result.strikePrice = strikePrice;
    if (maturity != null) result.maturity = maturity;
    if (underlying != null) result.underlying = underlying;
    if (optionClass != null) result.optionClass = optionClass;
    if (dailyLow != null) result.dailyLow = dailyLow;
    if (dailyHigh != null) result.dailyHigh = dailyHigh;
    if (quantity != null) result.quantity = quantity;
    if (volume != null) result.volume = volume;
    if (difference != null) result.difference = difference;
    if (differencePercent != null) result.differencePercent = differencePercent;
    if (sevenDaysDifPer != null) result.sevenDaysDifPer = sevenDaysDifPer;
    if (thirtyDaysDifPer != null) result.thirtyDaysDifPer = thirtyDaysDifPer;
    if (fiftytwoWeekDifPer != null) result.fiftytwoWeekDifPer = fiftytwoWeekDifPer;
    if (monthHigh != null) result.monthHigh = monthHigh;
    if (monthLow != null) result.monthLow = monthLow;
    if (yearHigh != null) result.yearHigh = yearHigh;
    if (yearLow != null) result.yearLow = yearLow;
    if (priceMean != null) result.priceMean = priceMean;
    if (limitUp != null) result.limitUp = limitUp;
    if (limitDown != null) result.limitDown = limitDown;
    if (settlement != null) result.settlement = settlement;
    if (settlementPerDif != null) result.settlementPerDif = settlementPerDif;
    if (openInterest != null) result.openInterest = openInterest;
    if (theoricalPrice != null) result.theoricalPrice = theoricalPrice;
    if (theoricelPDifPer != null) result.theoricelPDifPer = theoricelPDifPer;
    if (dailyVolume != null) result.dailyVolume = dailyVolume;
    if (priceStep != null) result.priceStep = priceStep;
    if (openForTrade != null) result.openForTrade = openForTrade;
    if (tradeDate != null) result.tradeDate = tradeDate;
    if (open != null) result.open = open;
    if (dailyQuantity != null) result.dailyQuantity = dailyQuantity;
    if (actionType != null) result.actionType = actionType;
    if (brutSwap != null) result.brutSwap = brutSwap;
    if (totalTradeCount != null) result.totalTradeCount = totalTradeCount;
    if (lastQuantity != null) result.lastQuantity = lastQuantity;
    if (openInterestChange != null) result.openInterestChange = openInterestChange;
    if (weekLow != null) result.weekLow = weekLow;
    if (weekHigh != null) result.weekHigh = weekHigh;
    if (weekClose != null) result.weekClose = weekClose;
    if (monthClose != null) result.monthClose = monthClose;
    if (yearClose != null) result.yearClose = yearClose;
    if (preSettlement != null) result.preSettlement = preSettlement;
    if (askSize != null) result.askSize = askSize;
    if (bidSize != null) result.bidSize = bidSize;
    if (rate != null) result.rate = rate;
    if (marketMaker != null) result.marketMaker = marketMaker;
    if (marketMakerAsk != null) result.marketMakerAsk = marketMakerAsk;
    if (marketMakerBid != null) result.marketMakerBid = marketMakerBid;
    if (prevYearClose != null) result.prevYearClose = prevYearClose;
    if (riskLevel != null) result.riskLevel = riskLevel;
    if (marketMakerAskClose != null) result.marketMakerAskClose = marketMakerAskClose;
    if (marketMakerBidClose != null) result.marketMakerBidClose = marketMakerBidClose;
    if (weekPriceMean != null) result.weekPriceMean = weekPriceMean;
    if (monthPriceMean != null) result.monthPriceMean = monthPriceMean;
    if (yearPriceMean != null) result.yearPriceMean = yearPriceMean;
    if (incrementalQuantity != null) result.incrementalQuantity = incrementalQuantity;
    if (publishReason != null) result.publishReason = publishReason;
    if (stockStatus != null) result.stockStatus = stockStatus;
    if (eqPrice != null) result.eqPrice = eqPrice;
    if (eqQuantity != null) result.eqQuantity = eqQuantity;
    if (eqRemainingBidQuantity != null) result.eqRemainingBidQuantity = eqRemainingBidQuantity;
    if (eqRemainingAskQuantity != null) result.eqRemainingAskQuantity = eqRemainingAskQuantity;
    if (initialMargin != null) result.initialMargin = initialMargin;
    return result;
  }

  DerivativeMessage._();

  factory DerivativeMessage.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory DerivativeMessage.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DerivativeMessage', package: const $pb.PackageName(_omitMessageNames ? '' : 'messages'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'symbolId', $pb.PbFieldType.Q3, protoName: 'symbolId')
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
    ..a<$core.double>(12, _omitFieldNames ? '' : 'strikePrice', $pb.PbFieldType.OD, protoName: 'strikePrice')
    ..aOS(13, _omitFieldNames ? '' : 'maturity')
    ..aOS(14, _omitFieldNames ? '' : 'underlying')
    ..e<DerivativeMessage_OptionClass>(15, _omitFieldNames ? '' : 'optionClass', $pb.PbFieldType.OE, protoName: 'optionClass', defaultOrMaker: DerivativeMessage_OptionClass.P, valueOf: DerivativeMessage_OptionClass.valueOf, enumValues: DerivativeMessage_OptionClass.values)
    ..a<$core.double>(16, _omitFieldNames ? '' : 'dailyLow', $pb.PbFieldType.OD, protoName: 'dailyLow')
    ..a<$core.double>(17, _omitFieldNames ? '' : 'dailyHigh', $pb.PbFieldType.OD, protoName: 'dailyHigh')
    ..a<$core.double>(18, _omitFieldNames ? '' : 'quantity', $pb.PbFieldType.OD)
    ..a<$core.double>(19, _omitFieldNames ? '' : 'volume', $pb.PbFieldType.OD)
    ..a<$core.double>(20, _omitFieldNames ? '' : 'difference', $pb.PbFieldType.OD)
    ..a<$core.double>(21, _omitFieldNames ? '' : 'differencePercent', $pb.PbFieldType.OD, protoName: 'differencePercent')
    ..a<$core.double>(22, _omitFieldNames ? '' : 'sevenDaysDifPer', $pb.PbFieldType.OD, protoName: 'sevenDaysDifPer')
    ..a<$core.double>(23, _omitFieldNames ? '' : 'thirtyDaysDifPer', $pb.PbFieldType.OD, protoName: 'thirtyDaysDifPer')
    ..a<$core.double>(24, _omitFieldNames ? '' : 'fiftytwoWeekDifPer', $pb.PbFieldType.OD, protoName: 'fiftytwoWeekDifPer')
    ..a<$core.double>(25, _omitFieldNames ? '' : 'monthHigh', $pb.PbFieldType.OD, protoName: 'monthHigh')
    ..a<$core.double>(26, _omitFieldNames ? '' : 'monthLow', $pb.PbFieldType.OD, protoName: 'monthLow')
    ..a<$core.double>(27, _omitFieldNames ? '' : 'yearHigh', $pb.PbFieldType.OD, protoName: 'yearHigh')
    ..a<$core.double>(28, _omitFieldNames ? '' : 'yearLow', $pb.PbFieldType.OD, protoName: 'yearLow')
    ..a<$core.double>(29, _omitFieldNames ? '' : 'priceMean', $pb.PbFieldType.OD, protoName: 'priceMean')
    ..a<$core.double>(30, _omitFieldNames ? '' : 'limitUp', $pb.PbFieldType.OD, protoName: 'limitUp')
    ..a<$core.double>(31, _omitFieldNames ? '' : 'limitDown', $pb.PbFieldType.OD, protoName: 'limitDown')
    ..a<$core.double>(32, _omitFieldNames ? '' : 'settlement', $pb.PbFieldType.OD)
    ..a<$core.double>(33, _omitFieldNames ? '' : 'settlementPerDif', $pb.PbFieldType.OD, protoName: 'settlementPerDif')
    ..aInt64(34, _omitFieldNames ? '' : 'openInterest', protoName: 'openInterest')
    ..a<$core.double>(35, _omitFieldNames ? '' : 'theoricalPrice', $pb.PbFieldType.OD, protoName: 'theoricalPrice')
    ..a<$core.double>(36, _omitFieldNames ? '' : 'theoricelPDifPer', $pb.PbFieldType.OD, protoName: 'theoricelPDifPer')
    ..a<$core.double>(37, _omitFieldNames ? '' : 'dailyVolume', $pb.PbFieldType.OD, protoName: 'dailyVolume')
    ..a<$core.double>(38, _omitFieldNames ? '' : 'priceStep', $pb.PbFieldType.OD, protoName: 'priceStep')
    ..aOB(39, _omitFieldNames ? '' : 'openForTrade', protoName: 'openForTrade')
    ..aOS(40, _omitFieldNames ? '' : 'tradeDate', protoName: 'tradeDate')
    ..a<$core.double>(41, _omitFieldNames ? '' : 'open', $pb.PbFieldType.OD)
    ..a<$core.double>(42, _omitFieldNames ? '' : 'dailyQuantity', $pb.PbFieldType.OD, protoName: 'dailyQuantity')
    ..aOS(43, _omitFieldNames ? '' : 'actionType', protoName: 'actionType')
    ..a<$core.int>(44, _omitFieldNames ? '' : 'brutSwap', $pb.PbFieldType.O3, protoName: 'brutSwap')
    ..a<$core.double>(45, _omitFieldNames ? '' : 'totalTradeCount', $pb.PbFieldType.OD, protoName: 'totalTradeCount')
    ..a<$core.double>(46, _omitFieldNames ? '' : 'lastQuantity', $pb.PbFieldType.OD, protoName: 'lastQuantity')
    ..a<$core.double>(47, _omitFieldNames ? '' : 'openInterestChange', $pb.PbFieldType.OD, protoName: 'openInterestChange')
    ..a<$core.double>(48, _omitFieldNames ? '' : 'weekLow', $pb.PbFieldType.OD, protoName: 'weekLow')
    ..a<$core.double>(49, _omitFieldNames ? '' : 'weekHigh', $pb.PbFieldType.OD, protoName: 'weekHigh')
    ..a<$core.double>(50, _omitFieldNames ? '' : 'weekClose', $pb.PbFieldType.OD, protoName: 'weekClose')
    ..a<$core.double>(51, _omitFieldNames ? '' : 'monthClose', $pb.PbFieldType.OD, protoName: 'monthClose')
    ..a<$core.double>(52, _omitFieldNames ? '' : 'yearClose', $pb.PbFieldType.OD, protoName: 'yearClose')
    ..a<$core.double>(53, _omitFieldNames ? '' : 'preSettlement', $pb.PbFieldType.OD, protoName: 'preSettlement')
    ..aInt64(54, _omitFieldNames ? '' : 'askSize', protoName: 'askSize')
    ..aInt64(55, _omitFieldNames ? '' : 'bidSize', protoName: 'bidSize')
    ..a<$core.double>(56, _omitFieldNames ? '' : 'rate', $pb.PbFieldType.OD)
    ..aOS(57, _omitFieldNames ? '' : 'marketMaker', protoName: 'marketMaker')
    ..a<$core.double>(58, _omitFieldNames ? '' : 'marketMakerAsk', $pb.PbFieldType.OD, protoName: 'marketMakerAsk')
    ..a<$core.double>(59, _omitFieldNames ? '' : 'marketMakerBid', $pb.PbFieldType.OD, protoName: 'marketMakerBid')
    ..a<$core.double>(60, _omitFieldNames ? '' : 'prevYearClose', $pb.PbFieldType.OD, protoName: 'prevYearClose')
    ..aOS(61, _omitFieldNames ? '' : 'riskLevel', protoName: 'riskLevel')
    ..a<$core.double>(62, _omitFieldNames ? '' : 'marketMakerAskClose', $pb.PbFieldType.OD, protoName: 'marketMakerAskClose')
    ..a<$core.double>(63, _omitFieldNames ? '' : 'marketMakerBidClose', $pb.PbFieldType.OD, protoName: 'marketMakerBidClose')
    ..a<$core.double>(64, _omitFieldNames ? '' : 'weekPriceMean', $pb.PbFieldType.OD, protoName: 'weekPriceMean')
    ..a<$core.double>(65, _omitFieldNames ? '' : 'monthPriceMean', $pb.PbFieldType.OD, protoName: 'monthPriceMean')
    ..a<$core.double>(66, _omitFieldNames ? '' : 'yearPriceMean', $pb.PbFieldType.OD, protoName: 'yearPriceMean')
    ..a<$core.double>(67, _omitFieldNames ? '' : 'incrementalQuantity', $pb.PbFieldType.OD, protoName: 'incrementalQuantity')
    ..e<DerivativeMessage_PublishReason>(68, _omitFieldNames ? '' : 'publishReason', $pb.PbFieldType.OE, protoName: 'publishReason', defaultOrMaker: DerivativeMessage_PublishReason.UPDATE, valueOf: DerivativeMessage_PublishReason.valueOf, enumValues: DerivativeMessage_PublishReason.values)
    ..a<$core.int>(69, _omitFieldNames ? '' : 'stockStatus', $pb.PbFieldType.O3, protoName: 'stockStatus')
    ..a<$core.double>(70, _omitFieldNames ? '' : 'eqPrice', $pb.PbFieldType.OD, protoName: 'eqPrice')
    ..a<$core.double>(71, _omitFieldNames ? '' : 'eqQuantity', $pb.PbFieldType.OD, protoName: 'eqQuantity')
    ..a<$core.double>(72, _omitFieldNames ? '' : 'eqRemainingBidQuantity', $pb.PbFieldType.OD, protoName: 'eqRemainingBidQuantity')
    ..a<$core.double>(73, _omitFieldNames ? '' : 'eqRemainingAskQuantity', $pb.PbFieldType.OD, protoName: 'eqRemainingAskQuantity')
    ..a<$core.double>(74, _omitFieldNames ? '' : 'initialMargin', $pb.PbFieldType.OD, protoName: 'initialMargin')
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DerivativeMessage clone() => DerivativeMessage()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DerivativeMessage copyWith(void Function(DerivativeMessage) updates) => super.copyWith((message) => updates(message as DerivativeMessage)) as DerivativeMessage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DerivativeMessage create() => DerivativeMessage._();
  @$core.override
  DerivativeMessage createEmptyInstance() => create();
  static $pb.PbList<DerivativeMessage> createRepeated() => $pb.PbList<DerivativeMessage>();
  @$core.pragma('dart2js:noInline')
  static DerivativeMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DerivativeMessage>(create);
  static DerivativeMessage? _defaultInstance;

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
  $core.double get strikePrice => $_getN(11);
  @$pb.TagNumber(12)
  set strikePrice($core.double value) => $_setDouble(11, value);
  @$pb.TagNumber(12)
  $core.bool hasStrikePrice() => $_has(11);
  @$pb.TagNumber(12)
  void clearStrikePrice() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get maturity => $_getSZ(12);
  @$pb.TagNumber(13)
  set maturity($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasMaturity() => $_has(12);
  @$pb.TagNumber(13)
  void clearMaturity() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get underlying => $_getSZ(13);
  @$pb.TagNumber(14)
  set underlying($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasUnderlying() => $_has(13);
  @$pb.TagNumber(14)
  void clearUnderlying() => $_clearField(14);

  @$pb.TagNumber(15)
  DerivativeMessage_OptionClass get optionClass => $_getN(14);
  @$pb.TagNumber(15)
  set optionClass(DerivativeMessage_OptionClass value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasOptionClass() => $_has(14);
  @$pb.TagNumber(15)
  void clearOptionClass() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.double get dailyLow => $_getN(15);
  @$pb.TagNumber(16)
  set dailyLow($core.double value) => $_setDouble(15, value);
  @$pb.TagNumber(16)
  $core.bool hasDailyLow() => $_has(15);
  @$pb.TagNumber(16)
  void clearDailyLow() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.double get dailyHigh => $_getN(16);
  @$pb.TagNumber(17)
  set dailyHigh($core.double value) => $_setDouble(16, value);
  @$pb.TagNumber(17)
  $core.bool hasDailyHigh() => $_has(16);
  @$pb.TagNumber(17)
  void clearDailyHigh() => $_clearField(17);

  @$pb.TagNumber(18)
  $core.double get quantity => $_getN(17);
  @$pb.TagNumber(18)
  set quantity($core.double value) => $_setDouble(17, value);
  @$pb.TagNumber(18)
  $core.bool hasQuantity() => $_has(17);
  @$pb.TagNumber(18)
  void clearQuantity() => $_clearField(18);

  @$pb.TagNumber(19)
  $core.double get volume => $_getN(18);
  @$pb.TagNumber(19)
  set volume($core.double value) => $_setDouble(18, value);
  @$pb.TagNumber(19)
  $core.bool hasVolume() => $_has(18);
  @$pb.TagNumber(19)
  void clearVolume() => $_clearField(19);

  @$pb.TagNumber(20)
  $core.double get difference => $_getN(19);
  @$pb.TagNumber(20)
  set difference($core.double value) => $_setDouble(19, value);
  @$pb.TagNumber(20)
  $core.bool hasDifference() => $_has(19);
  @$pb.TagNumber(20)
  void clearDifference() => $_clearField(20);

  @$pb.TagNumber(21)
  $core.double get differencePercent => $_getN(20);
  @$pb.TagNumber(21)
  set differencePercent($core.double value) => $_setDouble(20, value);
  @$pb.TagNumber(21)
  $core.bool hasDifferencePercent() => $_has(20);
  @$pb.TagNumber(21)
  void clearDifferencePercent() => $_clearField(21);

  @$pb.TagNumber(22)
  $core.double get sevenDaysDifPer => $_getN(21);
  @$pb.TagNumber(22)
  set sevenDaysDifPer($core.double value) => $_setDouble(21, value);
  @$pb.TagNumber(22)
  $core.bool hasSevenDaysDifPer() => $_has(21);
  @$pb.TagNumber(22)
  void clearSevenDaysDifPer() => $_clearField(22);

  @$pb.TagNumber(23)
  $core.double get thirtyDaysDifPer => $_getN(22);
  @$pb.TagNumber(23)
  set thirtyDaysDifPer($core.double value) => $_setDouble(22, value);
  @$pb.TagNumber(23)
  $core.bool hasThirtyDaysDifPer() => $_has(22);
  @$pb.TagNumber(23)
  void clearThirtyDaysDifPer() => $_clearField(23);

  @$pb.TagNumber(24)
  $core.double get fiftytwoWeekDifPer => $_getN(23);
  @$pb.TagNumber(24)
  set fiftytwoWeekDifPer($core.double value) => $_setDouble(23, value);
  @$pb.TagNumber(24)
  $core.bool hasFiftytwoWeekDifPer() => $_has(23);
  @$pb.TagNumber(24)
  void clearFiftytwoWeekDifPer() => $_clearField(24);

  @$pb.TagNumber(25)
  $core.double get monthHigh => $_getN(24);
  @$pb.TagNumber(25)
  set monthHigh($core.double value) => $_setDouble(24, value);
  @$pb.TagNumber(25)
  $core.bool hasMonthHigh() => $_has(24);
  @$pb.TagNumber(25)
  void clearMonthHigh() => $_clearField(25);

  @$pb.TagNumber(26)
  $core.double get monthLow => $_getN(25);
  @$pb.TagNumber(26)
  set monthLow($core.double value) => $_setDouble(25, value);
  @$pb.TagNumber(26)
  $core.bool hasMonthLow() => $_has(25);
  @$pb.TagNumber(26)
  void clearMonthLow() => $_clearField(26);

  @$pb.TagNumber(27)
  $core.double get yearHigh => $_getN(26);
  @$pb.TagNumber(27)
  set yearHigh($core.double value) => $_setDouble(26, value);
  @$pb.TagNumber(27)
  $core.bool hasYearHigh() => $_has(26);
  @$pb.TagNumber(27)
  void clearYearHigh() => $_clearField(27);

  @$pb.TagNumber(28)
  $core.double get yearLow => $_getN(27);
  @$pb.TagNumber(28)
  set yearLow($core.double value) => $_setDouble(27, value);
  @$pb.TagNumber(28)
  $core.bool hasYearLow() => $_has(27);
  @$pb.TagNumber(28)
  void clearYearLow() => $_clearField(28);

  @$pb.TagNumber(29)
  $core.double get priceMean => $_getN(28);
  @$pb.TagNumber(29)
  set priceMean($core.double value) => $_setDouble(28, value);
  @$pb.TagNumber(29)
  $core.bool hasPriceMean() => $_has(28);
  @$pb.TagNumber(29)
  void clearPriceMean() => $_clearField(29);

  @$pb.TagNumber(30)
  $core.double get limitUp => $_getN(29);
  @$pb.TagNumber(30)
  set limitUp($core.double value) => $_setDouble(29, value);
  @$pb.TagNumber(30)
  $core.bool hasLimitUp() => $_has(29);
  @$pb.TagNumber(30)
  void clearLimitUp() => $_clearField(30);

  @$pb.TagNumber(31)
  $core.double get limitDown => $_getN(30);
  @$pb.TagNumber(31)
  set limitDown($core.double value) => $_setDouble(30, value);
  @$pb.TagNumber(31)
  $core.bool hasLimitDown() => $_has(30);
  @$pb.TagNumber(31)
  void clearLimitDown() => $_clearField(31);

  @$pb.TagNumber(32)
  $core.double get settlement => $_getN(31);
  @$pb.TagNumber(32)
  set settlement($core.double value) => $_setDouble(31, value);
  @$pb.TagNumber(32)
  $core.bool hasSettlement() => $_has(31);
  @$pb.TagNumber(32)
  void clearSettlement() => $_clearField(32);

  @$pb.TagNumber(33)
  $core.double get settlementPerDif => $_getN(32);
  @$pb.TagNumber(33)
  set settlementPerDif($core.double value) => $_setDouble(32, value);
  @$pb.TagNumber(33)
  $core.bool hasSettlementPerDif() => $_has(32);
  @$pb.TagNumber(33)
  void clearSettlementPerDif() => $_clearField(33);

  @$pb.TagNumber(34)
  $fixnum.Int64 get openInterest => $_getI64(33);
  @$pb.TagNumber(34)
  set openInterest($fixnum.Int64 value) => $_setInt64(33, value);
  @$pb.TagNumber(34)
  $core.bool hasOpenInterest() => $_has(33);
  @$pb.TagNumber(34)
  void clearOpenInterest() => $_clearField(34);

  @$pb.TagNumber(35)
  $core.double get theoricalPrice => $_getN(34);
  @$pb.TagNumber(35)
  set theoricalPrice($core.double value) => $_setDouble(34, value);
  @$pb.TagNumber(35)
  $core.bool hasTheoricalPrice() => $_has(34);
  @$pb.TagNumber(35)
  void clearTheoricalPrice() => $_clearField(35);

  @$pb.TagNumber(36)
  $core.double get theoricelPDifPer => $_getN(35);
  @$pb.TagNumber(36)
  set theoricelPDifPer($core.double value) => $_setDouble(35, value);
  @$pb.TagNumber(36)
  $core.bool hasTheoricelPDifPer() => $_has(35);
  @$pb.TagNumber(36)
  void clearTheoricelPDifPer() => $_clearField(36);

  @$pb.TagNumber(37)
  $core.double get dailyVolume => $_getN(36);
  @$pb.TagNumber(37)
  set dailyVolume($core.double value) => $_setDouble(36, value);
  @$pb.TagNumber(37)
  $core.bool hasDailyVolume() => $_has(36);
  @$pb.TagNumber(37)
  void clearDailyVolume() => $_clearField(37);

  @$pb.TagNumber(38)
  $core.double get priceStep => $_getN(37);
  @$pb.TagNumber(38)
  set priceStep($core.double value) => $_setDouble(37, value);
  @$pb.TagNumber(38)
  $core.bool hasPriceStep() => $_has(37);
  @$pb.TagNumber(38)
  void clearPriceStep() => $_clearField(38);

  @$pb.TagNumber(39)
  $core.bool get openForTrade => $_getBF(38);
  @$pb.TagNumber(39)
  set openForTrade($core.bool value) => $_setBool(38, value);
  @$pb.TagNumber(39)
  $core.bool hasOpenForTrade() => $_has(38);
  @$pb.TagNumber(39)
  void clearOpenForTrade() => $_clearField(39);

  @$pb.TagNumber(40)
  $core.String get tradeDate => $_getSZ(39);
  @$pb.TagNumber(40)
  set tradeDate($core.String value) => $_setString(39, value);
  @$pb.TagNumber(40)
  $core.bool hasTradeDate() => $_has(39);
  @$pb.TagNumber(40)
  void clearTradeDate() => $_clearField(40);

  @$pb.TagNumber(41)
  $core.double get open => $_getN(40);
  @$pb.TagNumber(41)
  set open($core.double value) => $_setDouble(40, value);
  @$pb.TagNumber(41)
  $core.bool hasOpen() => $_has(40);
  @$pb.TagNumber(41)
  void clearOpen() => $_clearField(41);

  @$pb.TagNumber(42)
  $core.double get dailyQuantity => $_getN(41);
  @$pb.TagNumber(42)
  set dailyQuantity($core.double value) => $_setDouble(41, value);
  @$pb.TagNumber(42)
  $core.bool hasDailyQuantity() => $_has(41);
  @$pb.TagNumber(42)
  void clearDailyQuantity() => $_clearField(42);

  @$pb.TagNumber(43)
  $core.String get actionType => $_getSZ(42);
  @$pb.TagNumber(43)
  set actionType($core.String value) => $_setString(42, value);
  @$pb.TagNumber(43)
  $core.bool hasActionType() => $_has(42);
  @$pb.TagNumber(43)
  void clearActionType() => $_clearField(43);

  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(44)
  $core.int get brutSwap => $_getIZ(43);
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(44)
  set brutSwap($core.int value) => $_setSignedInt32(43, value);
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(44)
  $core.bool hasBrutSwap() => $_has(43);
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(44)
  void clearBrutSwap() => $_clearField(44);

  @$pb.TagNumber(45)
  $core.double get totalTradeCount => $_getN(44);
  @$pb.TagNumber(45)
  set totalTradeCount($core.double value) => $_setDouble(44, value);
  @$pb.TagNumber(45)
  $core.bool hasTotalTradeCount() => $_has(44);
  @$pb.TagNumber(45)
  void clearTotalTradeCount() => $_clearField(45);

  @$pb.TagNumber(46)
  $core.double get lastQuantity => $_getN(45);
  @$pb.TagNumber(46)
  set lastQuantity($core.double value) => $_setDouble(45, value);
  @$pb.TagNumber(46)
  $core.bool hasLastQuantity() => $_has(45);
  @$pb.TagNumber(46)
  void clearLastQuantity() => $_clearField(46);

  @$pb.TagNumber(47)
  $core.double get openInterestChange => $_getN(46);
  @$pb.TagNumber(47)
  set openInterestChange($core.double value) => $_setDouble(46, value);
  @$pb.TagNumber(47)
  $core.bool hasOpenInterestChange() => $_has(46);
  @$pb.TagNumber(47)
  void clearOpenInterestChange() => $_clearField(47);

  @$pb.TagNumber(48)
  $core.double get weekLow => $_getN(47);
  @$pb.TagNumber(48)
  set weekLow($core.double value) => $_setDouble(47, value);
  @$pb.TagNumber(48)
  $core.bool hasWeekLow() => $_has(47);
  @$pb.TagNumber(48)
  void clearWeekLow() => $_clearField(48);

  @$pb.TagNumber(49)
  $core.double get weekHigh => $_getN(48);
  @$pb.TagNumber(49)
  set weekHigh($core.double value) => $_setDouble(48, value);
  @$pb.TagNumber(49)
  $core.bool hasWeekHigh() => $_has(48);
  @$pb.TagNumber(49)
  void clearWeekHigh() => $_clearField(49);

  @$pb.TagNumber(50)
  $core.double get weekClose => $_getN(49);
  @$pb.TagNumber(50)
  set weekClose($core.double value) => $_setDouble(49, value);
  @$pb.TagNumber(50)
  $core.bool hasWeekClose() => $_has(49);
  @$pb.TagNumber(50)
  void clearWeekClose() => $_clearField(50);

  @$pb.TagNumber(51)
  $core.double get monthClose => $_getN(50);
  @$pb.TagNumber(51)
  set monthClose($core.double value) => $_setDouble(50, value);
  @$pb.TagNumber(51)
  $core.bool hasMonthClose() => $_has(50);
  @$pb.TagNumber(51)
  void clearMonthClose() => $_clearField(51);

  @$pb.TagNumber(52)
  $core.double get yearClose => $_getN(51);
  @$pb.TagNumber(52)
  set yearClose($core.double value) => $_setDouble(51, value);
  @$pb.TagNumber(52)
  $core.bool hasYearClose() => $_has(51);
  @$pb.TagNumber(52)
  void clearYearClose() => $_clearField(52);

  @$pb.TagNumber(53)
  $core.double get preSettlement => $_getN(52);
  @$pb.TagNumber(53)
  set preSettlement($core.double value) => $_setDouble(52, value);
  @$pb.TagNumber(53)
  $core.bool hasPreSettlement() => $_has(52);
  @$pb.TagNumber(53)
  void clearPreSettlement() => $_clearField(53);

  @$pb.TagNumber(54)
  $fixnum.Int64 get askSize => $_getI64(53);
  @$pb.TagNumber(54)
  set askSize($fixnum.Int64 value) => $_setInt64(53, value);
  @$pb.TagNumber(54)
  $core.bool hasAskSize() => $_has(53);
  @$pb.TagNumber(54)
  void clearAskSize() => $_clearField(54);

  @$pb.TagNumber(55)
  $fixnum.Int64 get bidSize => $_getI64(54);
  @$pb.TagNumber(55)
  set bidSize($fixnum.Int64 value) => $_setInt64(54, value);
  @$pb.TagNumber(55)
  $core.bool hasBidSize() => $_has(54);
  @$pb.TagNumber(55)
  void clearBidSize() => $_clearField(55);

  @$pb.TagNumber(56)
  $core.double get rate => $_getN(55);
  @$pb.TagNumber(56)
  set rate($core.double value) => $_setDouble(55, value);
  @$pb.TagNumber(56)
  $core.bool hasRate() => $_has(55);
  @$pb.TagNumber(56)
  void clearRate() => $_clearField(56);

  @$pb.TagNumber(57)
  $core.String get marketMaker => $_getSZ(56);
  @$pb.TagNumber(57)
  set marketMaker($core.String value) => $_setString(56, value);
  @$pb.TagNumber(57)
  $core.bool hasMarketMaker() => $_has(56);
  @$pb.TagNumber(57)
  void clearMarketMaker() => $_clearField(57);

  @$pb.TagNumber(58)
  $core.double get marketMakerAsk => $_getN(57);
  @$pb.TagNumber(58)
  set marketMakerAsk($core.double value) => $_setDouble(57, value);
  @$pb.TagNumber(58)
  $core.bool hasMarketMakerAsk() => $_has(57);
  @$pb.TagNumber(58)
  void clearMarketMakerAsk() => $_clearField(58);

  @$pb.TagNumber(59)
  $core.double get marketMakerBid => $_getN(58);
  @$pb.TagNumber(59)
  set marketMakerBid($core.double value) => $_setDouble(58, value);
  @$pb.TagNumber(59)
  $core.bool hasMarketMakerBid() => $_has(58);
  @$pb.TagNumber(59)
  void clearMarketMakerBid() => $_clearField(59);

  @$pb.TagNumber(60)
  $core.double get prevYearClose => $_getN(59);
  @$pb.TagNumber(60)
  set prevYearClose($core.double value) => $_setDouble(59, value);
  @$pb.TagNumber(60)
  $core.bool hasPrevYearClose() => $_has(59);
  @$pb.TagNumber(60)
  void clearPrevYearClose() => $_clearField(60);

  @$pb.TagNumber(61)
  $core.String get riskLevel => $_getSZ(60);
  @$pb.TagNumber(61)
  set riskLevel($core.String value) => $_setString(60, value);
  @$pb.TagNumber(61)
  $core.bool hasRiskLevel() => $_has(60);
  @$pb.TagNumber(61)
  void clearRiskLevel() => $_clearField(61);

  @$pb.TagNumber(62)
  $core.double get marketMakerAskClose => $_getN(61);
  @$pb.TagNumber(62)
  set marketMakerAskClose($core.double value) => $_setDouble(61, value);
  @$pb.TagNumber(62)
  $core.bool hasMarketMakerAskClose() => $_has(61);
  @$pb.TagNumber(62)
  void clearMarketMakerAskClose() => $_clearField(62);

  @$pb.TagNumber(63)
  $core.double get marketMakerBidClose => $_getN(62);
  @$pb.TagNumber(63)
  set marketMakerBidClose($core.double value) => $_setDouble(62, value);
  @$pb.TagNumber(63)
  $core.bool hasMarketMakerBidClose() => $_has(62);
  @$pb.TagNumber(63)
  void clearMarketMakerBidClose() => $_clearField(63);

  @$pb.TagNumber(64)
  $core.double get weekPriceMean => $_getN(63);
  @$pb.TagNumber(64)
  set weekPriceMean($core.double value) => $_setDouble(63, value);
  @$pb.TagNumber(64)
  $core.bool hasWeekPriceMean() => $_has(63);
  @$pb.TagNumber(64)
  void clearWeekPriceMean() => $_clearField(64);

  @$pb.TagNumber(65)
  $core.double get monthPriceMean => $_getN(64);
  @$pb.TagNumber(65)
  set monthPriceMean($core.double value) => $_setDouble(64, value);
  @$pb.TagNumber(65)
  $core.bool hasMonthPriceMean() => $_has(64);
  @$pb.TagNumber(65)
  void clearMonthPriceMean() => $_clearField(65);

  @$pb.TagNumber(66)
  $core.double get yearPriceMean => $_getN(65);
  @$pb.TagNumber(66)
  set yearPriceMean($core.double value) => $_setDouble(65, value);
  @$pb.TagNumber(66)
  $core.bool hasYearPriceMean() => $_has(65);
  @$pb.TagNumber(66)
  void clearYearPriceMean() => $_clearField(66);

  @$pb.TagNumber(67)
  $core.double get incrementalQuantity => $_getN(66);
  @$pb.TagNumber(67)
  set incrementalQuantity($core.double value) => $_setDouble(66, value);
  @$pb.TagNumber(67)
  $core.bool hasIncrementalQuantity() => $_has(66);
  @$pb.TagNumber(67)
  void clearIncrementalQuantity() => $_clearField(67);

  @$pb.TagNumber(68)
  DerivativeMessage_PublishReason get publishReason => $_getN(67);
  @$pb.TagNumber(68)
  set publishReason(DerivativeMessage_PublishReason value) => $_setField(68, value);
  @$pb.TagNumber(68)
  $core.bool hasPublishReason() => $_has(67);
  @$pb.TagNumber(68)
  void clearPublishReason() => $_clearField(68);

  @$pb.TagNumber(69)
  $core.int get stockStatus => $_getIZ(68);
  @$pb.TagNumber(69)
  set stockStatus($core.int value) => $_setSignedInt32(68, value);
  @$pb.TagNumber(69)
  $core.bool hasStockStatus() => $_has(68);
  @$pb.TagNumber(69)
  void clearStockStatus() => $_clearField(69);

  @$pb.TagNumber(70)
  $core.double get eqPrice => $_getN(69);
  @$pb.TagNumber(70)
  set eqPrice($core.double value) => $_setDouble(69, value);
  @$pb.TagNumber(70)
  $core.bool hasEqPrice() => $_has(69);
  @$pb.TagNumber(70)
  void clearEqPrice() => $_clearField(70);

  @$pb.TagNumber(71)
  $core.double get eqQuantity => $_getN(70);
  @$pb.TagNumber(71)
  set eqQuantity($core.double value) => $_setDouble(70, value);
  @$pb.TagNumber(71)
  $core.bool hasEqQuantity() => $_has(70);
  @$pb.TagNumber(71)
  void clearEqQuantity() => $_clearField(71);

  @$pb.TagNumber(72)
  $core.double get eqRemainingBidQuantity => $_getN(71);
  @$pb.TagNumber(72)
  set eqRemainingBidQuantity($core.double value) => $_setDouble(71, value);
  @$pb.TagNumber(72)
  $core.bool hasEqRemainingBidQuantity() => $_has(71);
  @$pb.TagNumber(72)
  void clearEqRemainingBidQuantity() => $_clearField(72);

  @$pb.TagNumber(73)
  $core.double get eqRemainingAskQuantity => $_getN(72);
  @$pb.TagNumber(73)
  set eqRemainingAskQuantity($core.double value) => $_setDouble(72, value);
  @$pb.TagNumber(73)
  $core.bool hasEqRemainingAskQuantity() => $_has(72);
  @$pb.TagNumber(73)
  void clearEqRemainingAskQuantity() => $_clearField(73);

  @$pb.TagNumber(74)
  $core.double get initialMargin => $_getN(73);
  @$pb.TagNumber(74)
  set initialMargin($core.double value) => $_setDouble(73, value);
  @$pb.TagNumber(74)
  $core.bool hasInitialMargin() => $_has(73);
  @$pb.TagNumber(74)
  void clearInitialMargin() => $_clearField(74);
}


const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
