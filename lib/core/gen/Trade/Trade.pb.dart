// This is a generated file - do not edit.
//
// Generated from Trade/Trade.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class TradeMessage extends $pb.GeneratedMessage {
  factory TradeMessage({
    $core.String? symbol,
    $core.String? orderNo,
    $core.double? price,
    $fixnum.Int64? quantity,
    $core.String? activeBidOrAsk,
    $fixnum.Int64? timestamp,
    $core.String? buyer,
    $core.String? seller,
    $core.bool? isTradeEx,
  }) {
    final result = create();
    if (symbol != null) result.symbol = symbol;
    if (orderNo != null) result.orderNo = orderNo;
    if (price != null) result.price = price;
    if (quantity != null) result.quantity = quantity;
    if (activeBidOrAsk != null) result.activeBidOrAsk = activeBidOrAsk;
    if (timestamp != null) result.timestamp = timestamp;
    if (buyer != null) result.buyer = buyer;
    if (seller != null) result.seller = seller;
    if (isTradeEx != null) result.isTradeEx = isTradeEx;
    return result;
  }

  TradeMessage._();

  factory TradeMessage.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory TradeMessage.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TradeMessage', package: const $pb.PackageName(_omitMessageNames ? '' : 'messages'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'symbol')
    ..aOS(2, _omitFieldNames ? '' : 'orderNo', protoName: 'orderNo')
    ..a<$core.double>(3, _omitFieldNames ? '' : 'price', $pb.PbFieldType.OF)
    ..aInt64(4, _omitFieldNames ? '' : 'quantity')
    ..aOS(5, _omitFieldNames ? '' : 'activeBidOrAsk', protoName: 'activeBidOrAsk')
    ..aInt64(6, _omitFieldNames ? '' : 'timestamp')
    ..aOS(7, _omitFieldNames ? '' : 'buyer')
    ..aOS(8, _omitFieldNames ? '' : 'seller')
    ..aOB(9, _omitFieldNames ? '' : 'isTradeEx', protoName: 'isTradeEx')
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TradeMessage clone() => TradeMessage()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TradeMessage copyWith(void Function(TradeMessage) updates) => super.copyWith((message) => updates(message as TradeMessage)) as TradeMessage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TradeMessage create() => TradeMessage._();
  @$core.override
  TradeMessage createEmptyInstance() => create();
  static $pb.PbList<TradeMessage> createRepeated() => $pb.PbList<TradeMessage>();
  @$core.pragma('dart2js:noInline')
  static TradeMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TradeMessage>(create);
  static TradeMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get symbol => $_getSZ(0);
  @$pb.TagNumber(1)
  set symbol($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSymbol() => $_has(0);
  @$pb.TagNumber(1)
  void clearSymbol() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get orderNo => $_getSZ(1);
  @$pb.TagNumber(2)
  set orderNo($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOrderNo() => $_has(1);
  @$pb.TagNumber(2)
  void clearOrderNo() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get price => $_getN(2);
  @$pb.TagNumber(3)
  set price($core.double value) => $_setFloat(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPrice() => $_has(2);
  @$pb.TagNumber(3)
  void clearPrice() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get quantity => $_getI64(3);
  @$pb.TagNumber(4)
  set quantity($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasQuantity() => $_has(3);
  @$pb.TagNumber(4)
  void clearQuantity() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get activeBidOrAsk => $_getSZ(4);
  @$pb.TagNumber(5)
  set activeBidOrAsk($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasActiveBidOrAsk() => $_has(4);
  @$pb.TagNumber(5)
  void clearActiveBidOrAsk() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get timestamp => $_getI64(5);
  @$pb.TagNumber(6)
  set timestamp($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTimestamp() => $_has(5);
  @$pb.TagNumber(6)
  void clearTimestamp() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get buyer => $_getSZ(6);
  @$pb.TagNumber(7)
  set buyer($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasBuyer() => $_has(6);
  @$pb.TagNumber(7)
  void clearBuyer() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get seller => $_getSZ(7);
  @$pb.TagNumber(8)
  set seller($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasSeller() => $_has(7);
  @$pb.TagNumber(8)
  void clearSeller() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get isTradeEx => $_getBF(8);
  @$pb.TagNumber(9)
  set isTradeEx($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasIsTradeEx() => $_has(8);
  @$pb.TagNumber(9)
  void clearIsTradeEx() => $_clearField(9);
}


const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
