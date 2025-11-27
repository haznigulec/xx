// This is a generated file - do not edit.
//
// Generated from RankedSymbols/RankedSymbols.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class Line extends $pb.GeneratedMessage {
  factory Line({
    $core.String? symbol,
    $core.Iterable<$core.double>? value,
  }) {
    final result = create();
    if (symbol != null) result.symbol = symbol;
    if (value != null) result.value.addAll(value);
    return result;
  }

  Line._();

  factory Line.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory Line.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Line', package: const $pb.PackageName(_omitMessageNames ? '' : 'messages'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'symbol')
    ..p<$core.double>(2, _omitFieldNames ? '' : 'value', $pb.PbFieldType.PD)
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Line clone() => Line()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Line copyWith(void Function(Line) updates) => super.copyWith((message) => updates(message as Line)) as Line;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Line create() => Line._();
  @$core.override
  Line createEmptyInstance() => create();
  static $pb.PbList<Line> createRepeated() => $pb.PbList<Line>();
  @$core.pragma('dart2js:noInline')
  static Line getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Line>(create);
  static Line? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get symbol => $_getSZ(0);
  @$pb.TagNumber(1)
  set symbol($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSymbol() => $_has(0);
  @$pb.TagNumber(1)
  void clearSymbol() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.double> get value => $_getList(1);
}

class RankedSymbolsMessage extends $pb.GeneratedMessage {
  factory RankedSymbolsMessage({
    $core.Iterable<Line>? lines,
    $core.Iterable<$core.String>? field,
  }) {
    final result = create();
    if (lines != null) result.lines.addAll(lines);
    if (field != null) result.field.addAll(field);
    return result;
  }

  RankedSymbolsMessage._();

  factory RankedSymbolsMessage.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory RankedSymbolsMessage.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RankedSymbolsMessage', package: const $pb.PackageName(_omitMessageNames ? '' : 'messages'), createEmptyInstance: create)
    ..pc<Line>(1, _omitFieldNames ? '' : 'lines', $pb.PbFieldType.PM, subBuilder: Line.create)
    ..pPS(2, _omitFieldNames ? '' : 'field')
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RankedSymbolsMessage clone() => RankedSymbolsMessage()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RankedSymbolsMessage copyWith(void Function(RankedSymbolsMessage) updates) => super.copyWith((message) => updates(message as RankedSymbolsMessage)) as RankedSymbolsMessage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RankedSymbolsMessage create() => RankedSymbolsMessage._();
  @$core.override
  RankedSymbolsMessage createEmptyInstance() => create();
  static $pb.PbList<RankedSymbolsMessage> createRepeated() => $pb.PbList<RankedSymbolsMessage>();
  @$core.pragma('dart2js:noInline')
  static RankedSymbolsMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RankedSymbolsMessage>(create);
  static RankedSymbolsMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Line> get lines => $_getList(0);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get field => $_getList(1);
}


const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
