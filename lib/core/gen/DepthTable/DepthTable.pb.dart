// This is a generated file - do not edit.
//
// Generated from DepthTable/DepthTable.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'DepthTable.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'DepthTable.pbenum.dart';

class DepthCell extends $pb.GeneratedMessage {
  factory DepthCell({
    $core.double? price,
    $fixnum.Int64? quantity,
    $fixnum.Int64? timestamp,
    $fixnum.Int64? orderCount,
  }) {
    final result = create();
    if (price != null) result.price = price;
    if (quantity != null) result.quantity = quantity;
    if (timestamp != null) result.timestamp = timestamp;
    if (orderCount != null) result.orderCount = orderCount;
    return result;
  }

  DepthCell._();

  factory DepthCell.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory DepthCell.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DepthCell', package: const $pb.PackageName(_omitMessageNames ? '' : 'messages'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'price', $pb.PbFieldType.QD)
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'quantity', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(3, _omitFieldNames ? '' : 'timestamp', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(4, _omitFieldNames ? '' : 'orderCount', $pb.PbFieldType.Q6, protoName: 'orderCount', defaultOrMaker: $fixnum.Int64.ZERO)
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DepthCell clone() => DepthCell()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DepthCell copyWith(void Function(DepthCell) updates) => super.copyWith((message) => updates(message as DepthCell)) as DepthCell;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DepthCell create() => DepthCell._();
  @$core.override
  DepthCell createEmptyInstance() => create();
  static $pb.PbList<DepthCell> createRepeated() => $pb.PbList<DepthCell>();
  @$core.pragma('dart2js:noInline')
  static DepthCell getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DepthCell>(create);
  static DepthCell? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get price => $_getN(0);
  @$pb.TagNumber(1)
  set price($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPrice() => $_has(0);
  @$pb.TagNumber(1)
  void clearPrice() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get quantity => $_getI64(1);
  @$pb.TagNumber(2)
  set quantity($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasQuantity() => $_has(1);
  @$pb.TagNumber(2)
  void clearQuantity() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get timestamp => $_getI64(2);
  @$pb.TagNumber(3)
  set timestamp($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTimestamp() => $_has(2);
  @$pb.TagNumber(3)
  void clearTimestamp() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get orderCount => $_getI64(3);
  @$pb.TagNumber(4)
  set orderCount($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOrderCount() => $_has(3);
  @$pb.TagNumber(4)
  void clearOrderCount() => $_clearField(4);
}

class DepthTableMessage extends $pb.GeneratedMessage {
  factory DepthTableMessage({
    $core.String? symbol,
    $core.String? dateSymbol,
    $fixnum.Int64? timestamp,
    $core.Iterable<DepthCell>? asks,
    $core.Iterable<DepthCell>? bids,
    DepthTableMessage_Action? action,
    DepthTableMessage_BidAsk? bidAsk,
    $core.int? row,
    $core.double? actionPrice,
    $fixnum.Int64? actionQuantity,
    $fixnum.Int64? actionOrderCount,
  }) {
    final result = create();
    if (symbol != null) result.symbol = symbol;
    if (dateSymbol != null) result.dateSymbol = dateSymbol;
    if (timestamp != null) result.timestamp = timestamp;
    if (asks != null) result.asks.addAll(asks);
    if (bids != null) result.bids.addAll(bids);
    if (action != null) result.action = action;
    if (bidAsk != null) result.bidAsk = bidAsk;
    if (row != null) result.row = row;
    if (actionPrice != null) result.actionPrice = actionPrice;
    if (actionQuantity != null) result.actionQuantity = actionQuantity;
    if (actionOrderCount != null) result.actionOrderCount = actionOrderCount;
    return result;
  }

  DepthTableMessage._();

  factory DepthTableMessage.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory DepthTableMessage.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DepthTableMessage', package: const $pb.PackageName(_omitMessageNames ? '' : 'messages'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'symbol')
    ..aOS(2, _omitFieldNames ? '' : 'dateSymbol', protoName: 'dateSymbol')
    ..aInt64(3, _omitFieldNames ? '' : 'timestamp')
    ..pc<DepthCell>(4, _omitFieldNames ? '' : 'asks', $pb.PbFieldType.PM, subBuilder: DepthCell.create)
    ..pc<DepthCell>(5, _omitFieldNames ? '' : 'bids', $pb.PbFieldType.PM, subBuilder: DepthCell.create)
    ..e<DepthTableMessage_Action>(6, _omitFieldNames ? '' : 'action', $pb.PbFieldType.OE, defaultOrMaker: DepthTableMessage_Action.I, valueOf: DepthTableMessage_Action.valueOf, enumValues: DepthTableMessage_Action.values)
    ..e<DepthTableMessage_BidAsk>(7, _omitFieldNames ? '' : 'bidAsk', $pb.PbFieldType.OE, protoName: 'bidAsk', defaultOrMaker: DepthTableMessage_BidAsk.A, valueOf: DepthTableMessage_BidAsk.valueOf, enumValues: DepthTableMessage_BidAsk.values)
    ..a<$core.int>(8, _omitFieldNames ? '' : 'row', $pb.PbFieldType.O3)
    ..a<$core.double>(9, _omitFieldNames ? '' : 'actionPrice', $pb.PbFieldType.OD, protoName: 'actionPrice')
    ..aInt64(10, _omitFieldNames ? '' : 'actionQuantity', protoName: 'actionQuantity')
    ..aInt64(11, _omitFieldNames ? '' : 'actionOrderCount', protoName: 'actionOrderCount')
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DepthTableMessage clone() => DepthTableMessage()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DepthTableMessage copyWith(void Function(DepthTableMessage) updates) => super.copyWith((message) => updates(message as DepthTableMessage)) as DepthTableMessage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DepthTableMessage create() => DepthTableMessage._();
  @$core.override
  DepthTableMessage createEmptyInstance() => create();
  static $pb.PbList<DepthTableMessage> createRepeated() => $pb.PbList<DepthTableMessage>();
  @$core.pragma('dart2js:noInline')
  static DepthTableMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DepthTableMessage>(create);
  static DepthTableMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get symbol => $_getSZ(0);
  @$pb.TagNumber(1)
  set symbol($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSymbol() => $_has(0);
  @$pb.TagNumber(1)
  void clearSymbol() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get dateSymbol => $_getSZ(1);
  @$pb.TagNumber(2)
  set dateSymbol($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDateSymbol() => $_has(1);
  @$pb.TagNumber(2)
  void clearDateSymbol() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get timestamp => $_getI64(2);
  @$pb.TagNumber(3)
  set timestamp($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTimestamp() => $_has(2);
  @$pb.TagNumber(3)
  void clearTimestamp() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<DepthCell> get asks => $_getList(3);

  @$pb.TagNumber(5)
  $pb.PbList<DepthCell> get bids => $_getList(4);

  @$pb.TagNumber(6)
  DepthTableMessage_Action get action => $_getN(5);
  @$pb.TagNumber(6)
  set action(DepthTableMessage_Action value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasAction() => $_has(5);
  @$pb.TagNumber(6)
  void clearAction() => $_clearField(6);

  @$pb.TagNumber(7)
  DepthTableMessage_BidAsk get bidAsk => $_getN(6);
  @$pb.TagNumber(7)
  set bidAsk(DepthTableMessage_BidAsk value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasBidAsk() => $_has(6);
  @$pb.TagNumber(7)
  void clearBidAsk() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get row => $_getIZ(7);
  @$pb.TagNumber(8)
  set row($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasRow() => $_has(7);
  @$pb.TagNumber(8)
  void clearRow() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.double get actionPrice => $_getN(8);
  @$pb.TagNumber(9)
  set actionPrice($core.double value) => $_setDouble(8, value);
  @$pb.TagNumber(9)
  $core.bool hasActionPrice() => $_has(8);
  @$pb.TagNumber(9)
  void clearActionPrice() => $_clearField(9);

  @$pb.TagNumber(10)
  $fixnum.Int64 get actionQuantity => $_getI64(9);
  @$pb.TagNumber(10)
  set actionQuantity($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(10)
  $core.bool hasActionQuantity() => $_has(9);
  @$pb.TagNumber(10)
  void clearActionQuantity() => $_clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get actionOrderCount => $_getI64(10);
  @$pb.TagNumber(11)
  set actionOrderCount($fixnum.Int64 value) => $_setInt64(10, value);
  @$pb.TagNumber(11)
  $core.bool hasActionOrderCount() => $_has(10);
  @$pb.TagNumber(11)
  void clearActionOrderCount() => $_clearField(11);
}


const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
