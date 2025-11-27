// This is a generated file - do not edit.
//
// Generated from Ranker/Ranker.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class Symbol extends $pb.GeneratedMessage {
  factory Symbol({
    $core.String? key,
    $core.double? value,
    $core.double? last,
    $core.double? priceChange,
    $core.double? additionalValue,
    $core.double? ask,
    $core.double? bid,
  }) {
    final result = create();
    if (key != null) result.key = key;
    if (value != null) result.value = value;
    if (last != null) result.last = last;
    if (priceChange != null) result.priceChange = priceChange;
    if (additionalValue != null) result.additionalValue = additionalValue;
    if (ask != null) result.ask = ask;
    if (bid != null) result.bid = bid;
    return result;
  }

  Symbol._();

  factory Symbol.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory Symbol.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Symbol', package: const $pb.PackageName(_omitMessageNames ? '' : 'messages'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'key')
    ..a<$core.double>(2, _omitFieldNames ? '' : 'value', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'last', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'priceChange', $pb.PbFieldType.OD, protoName: 'priceChange')
    ..a<$core.double>(5, _omitFieldNames ? '' : 'additionalValue', $pb.PbFieldType.OD, protoName: 'additionalValue')
    ..a<$core.double>(6, _omitFieldNames ? '' : 'ask', $pb.PbFieldType.OD)
    ..a<$core.double>(7, _omitFieldNames ? '' : 'bid', $pb.PbFieldType.OD)
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Symbol clone() => Symbol()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Symbol copyWith(void Function(Symbol) updates) => super.copyWith((message) => updates(message as Symbol)) as Symbol;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Symbol create() => Symbol._();
  @$core.override
  Symbol createEmptyInstance() => create();
  static $pb.PbList<Symbol> createRepeated() => $pb.PbList<Symbol>();
  @$core.pragma('dart2js:noInline')
  static Symbol getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Symbol>(create);
  static Symbol? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get key => $_getSZ(0);
  @$pb.TagNumber(1)
  set key($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearKey() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get value => $_getN(1);
  @$pb.TagNumber(2)
  set value($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearValue() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get last => $_getN(2);
  @$pb.TagNumber(3)
  set last($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLast() => $_has(2);
  @$pb.TagNumber(3)
  void clearLast() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get priceChange => $_getN(3);
  @$pb.TagNumber(4)
  set priceChange($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPriceChange() => $_has(3);
  @$pb.TagNumber(4)
  void clearPriceChange() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get additionalValue => $_getN(4);
  @$pb.TagNumber(5)
  set additionalValue($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAdditionalValue() => $_has(4);
  @$pb.TagNumber(5)
  void clearAdditionalValue() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get ask => $_getN(5);
  @$pb.TagNumber(6)
  set ask($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAsk() => $_has(5);
  @$pb.TagNumber(6)
  void clearAsk() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get bid => $_getN(6);
  @$pb.TagNumber(7)
  set bid($core.double value) => $_setDouble(6, value);
  @$pb.TagNumber(7)
  $core.bool hasBid() => $_has(6);
  @$pb.TagNumber(7)
  void clearBid() => $_clearField(7);
}

class RankMessage extends $pb.GeneratedMessage {
  factory RankMessage({
    $core.Iterable<Symbol>? symbols,
    $core.Iterable<Symbol>? bist30,
    $core.Iterable<Symbol>? bist100,
  }) {
    final result = create();
    if (symbols != null) result.symbols.addAll(symbols);
    if (bist30 != null) result.bist30.addAll(bist30);
    if (bist100 != null) result.bist100.addAll(bist100);
    return result;
  }

  RankMessage._();

  factory RankMessage.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory RankMessage.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RankMessage', package: const $pb.PackageName(_omitMessageNames ? '' : 'messages'), createEmptyInstance: create)
    ..pc<Symbol>(1, _omitFieldNames ? '' : 'symbols', $pb.PbFieldType.PM, subBuilder: Symbol.create)
    ..pc<Symbol>(2, _omitFieldNames ? '' : 'bist30', $pb.PbFieldType.PM, subBuilder: Symbol.create)
    ..pc<Symbol>(3, _omitFieldNames ? '' : 'bist100', $pb.PbFieldType.PM, subBuilder: Symbol.create)
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RankMessage clone() => RankMessage()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RankMessage copyWith(void Function(RankMessage) updates) => super.copyWith((message) => updates(message as RankMessage)) as RankMessage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RankMessage create() => RankMessage._();
  @$core.override
  RankMessage createEmptyInstance() => create();
  static $pb.PbList<RankMessage> createRepeated() => $pb.PbList<RankMessage>();
  @$core.pragma('dart2js:noInline')
  static RankMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RankMessage>(create);
  static RankMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Symbol> get symbols => $_getList(0);

  @$pb.TagNumber(2)
  $pb.PbList<Symbol> get bist30 => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<Symbol> get bist100 => $_getList(2);
}


const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
