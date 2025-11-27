// This is a generated file - do not edit.
//
// Generated from Booklet/TopOfTheBook.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'TopOfTheBook.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'TopOfTheBook.pbenum.dart';

class Order extends $pb.GeneratedMessage {
  factory Order({
    $fixnum.Int64? orderID,
    $fixnum.Int64? timestamp,
    $core.double? quantity,
    $core.double? price,
  }) {
    final result = create();
    if (orderID != null) result.orderID = orderID;
    if (timestamp != null) result.timestamp = timestamp;
    if (quantity != null) result.quantity = quantity;
    if (price != null) result.price = price;
    return result;
  }

  Order._();

  factory Order.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory Order.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Order', package: const $pb.PackageName(_omitMessageNames ? '' : 'messages'), createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'orderID', protoName: 'orderID')
    ..aInt64(2, _omitFieldNames ? '' : 'timestamp')
    ..a<$core.double>(3, _omitFieldNames ? '' : 'quantity', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'price', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Order clone() => Order()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Order copyWith(void Function(Order) updates) => super.copyWith((message) => updates(message as Order)) as Order;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Order create() => Order._();
  @$core.override
  Order createEmptyInstance() => create();
  static $pb.PbList<Order> createRepeated() => $pb.PbList<Order>();
  @$core.pragma('dart2js:noInline')
  static Order getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Order>(create);
  static Order? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get orderID => $_getI64(0);
  @$pb.TagNumber(1)
  set orderID($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOrderID() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrderID() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get timestamp => $_getI64(1);
  @$pb.TagNumber(2)
  set timestamp($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTimestamp() => $_has(1);
  @$pb.TagNumber(2)
  void clearTimestamp() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get quantity => $_getN(2);
  @$pb.TagNumber(3)
  set quantity($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasQuantity() => $_has(2);
  @$pb.TagNumber(3)
  void clearQuantity() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get price => $_getN(3);
  @$pb.TagNumber(4)
  set price($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPrice() => $_has(3);
  @$pb.TagNumber(4)
  void clearPrice() => $_clearField(4);
}

class TopOfTheBookMessage extends $pb.GeneratedMessage {
  factory TopOfTheBookMessage({
    $core.String? symbol,
    $core.Iterable<Order>? asks,
    $core.Iterable<Order>? bids,
    TopOfTheBookMessage_Action? action,
    TopOfTheBookMessage_BidAsk? bidAsk,
    $core.int? affectedRow,
  }) {
    final result = create();
    if (symbol != null) result.symbol = symbol;
    if (asks != null) result.asks.addAll(asks);
    if (bids != null) result.bids.addAll(bids);
    if (action != null) result.action = action;
    if (bidAsk != null) result.bidAsk = bidAsk;
    if (affectedRow != null) result.affectedRow = affectedRow;
    return result;
  }

  TopOfTheBookMessage._();

  factory TopOfTheBookMessage.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory TopOfTheBookMessage.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TopOfTheBookMessage', package: const $pb.PackageName(_omitMessageNames ? '' : 'messages'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'symbol')
    ..pc<Order>(2, _omitFieldNames ? '' : 'asks', $pb.PbFieldType.PM, subBuilder: Order.create)
    ..pc<Order>(3, _omitFieldNames ? '' : 'bids', $pb.PbFieldType.PM, subBuilder: Order.create)
    ..e<TopOfTheBookMessage_Action>(4, _omitFieldNames ? '' : 'action', $pb.PbFieldType.OE, defaultOrMaker: TopOfTheBookMessage_Action.I, valueOf: TopOfTheBookMessage_Action.valueOf, enumValues: TopOfTheBookMessage_Action.values)
    ..e<TopOfTheBookMessage_BidAsk>(5, _omitFieldNames ? '' : 'bidAsk', $pb.PbFieldType.OE, protoName: 'bidAsk', defaultOrMaker: TopOfTheBookMessage_BidAsk.A, valueOf: TopOfTheBookMessage_BidAsk.valueOf, enumValues: TopOfTheBookMessage_BidAsk.values)
    ..a<$core.int>(6, _omitFieldNames ? '' : 'affectedRow', $pb.PbFieldType.O3, protoName: 'affectedRow')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TopOfTheBookMessage clone() => TopOfTheBookMessage()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TopOfTheBookMessage copyWith(void Function(TopOfTheBookMessage) updates) => super.copyWith((message) => updates(message as TopOfTheBookMessage)) as TopOfTheBookMessage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TopOfTheBookMessage create() => TopOfTheBookMessage._();
  @$core.override
  TopOfTheBookMessage createEmptyInstance() => create();
  static $pb.PbList<TopOfTheBookMessage> createRepeated() => $pb.PbList<TopOfTheBookMessage>();
  @$core.pragma('dart2js:noInline')
  static TopOfTheBookMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TopOfTheBookMessage>(create);
  static TopOfTheBookMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get symbol => $_getSZ(0);
  @$pb.TagNumber(1)
  set symbol($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSymbol() => $_has(0);
  @$pb.TagNumber(1)
  void clearSymbol() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<Order> get asks => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<Order> get bids => $_getList(2);

  @$pb.TagNumber(4)
  TopOfTheBookMessage_Action get action => $_getN(3);
  @$pb.TagNumber(4)
  set action(TopOfTheBookMessage_Action value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasAction() => $_has(3);
  @$pb.TagNumber(4)
  void clearAction() => $_clearField(4);

  @$pb.TagNumber(5)
  TopOfTheBookMessage_BidAsk get bidAsk => $_getN(4);
  @$pb.TagNumber(5)
  set bidAsk(TopOfTheBookMessage_BidAsk value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasBidAsk() => $_has(4);
  @$pb.TagNumber(5)
  void clearBidAsk() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get affectedRow => $_getIZ(5);
  @$pb.TagNumber(6)
  set affectedRow($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAffectedRow() => $_has(5);
  @$pb.TagNumber(6)
  void clearAffectedRow() => $_clearField(6);
}


const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
