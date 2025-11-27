// This is a generated file - do not edit.
//
// Generated from Timestamp/Timestamp.proto.

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

class TimeMessage extends $pb.GeneratedMessage {
  factory TimeMessage({
    $fixnum.Int64? timestamp,
    $core.String? source,
    $core.bool? isBistPPHoliday,
    $core.bool? isBistPPOpen,
  }) {
    final result = create();
    if (timestamp != null) result.timestamp = timestamp;
    if (source != null) result.source = source;
    if (isBistPPHoliday != null) result.isBistPPHoliday = isBistPPHoliday;
    if (isBistPPOpen != null) result.isBistPPOpen = isBistPPOpen;
    return result;
  }

  TimeMessage._();

  factory TimeMessage.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory TimeMessage.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TimeMessage', package: const $pb.PackageName(_omitMessageNames ? '' : 'messages'), createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'timestamp')
    ..aOS(2, _omitFieldNames ? '' : 'source')
    ..aOB(3, _omitFieldNames ? '' : 'isBistPPHoliday', protoName: 'isBistPPHoliday')
    ..aOB(4, _omitFieldNames ? '' : 'isBistPPOpen', protoName: 'isBistPPOpen')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TimeMessage clone() => TimeMessage()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TimeMessage copyWith(void Function(TimeMessage) updates) => super.copyWith((message) => updates(message as TimeMessage)) as TimeMessage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TimeMessage create() => TimeMessage._();
  @$core.override
  TimeMessage createEmptyInstance() => create();
  static $pb.PbList<TimeMessage> createRepeated() => $pb.PbList<TimeMessage>();
  @$core.pragma('dart2js:noInline')
  static TimeMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TimeMessage>(create);
  static TimeMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get timestamp => $_getI64(0);
  @$pb.TagNumber(1)
  set timestamp($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTimestamp() => $_has(0);
  @$pb.TagNumber(1)
  void clearTimestamp() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get source => $_getSZ(1);
  @$pb.TagNumber(2)
  set source($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSource() => $_has(1);
  @$pb.TagNumber(2)
  void clearSource() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get isBistPPHoliday => $_getBF(2);
  @$pb.TagNumber(3)
  set isBistPPHoliday($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIsBistPPHoliday() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsBistPPHoliday() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get isBistPPOpen => $_getBF(3);
  @$pb.TagNumber(4)
  set isBistPPOpen($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIsBistPPOpen() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsBistPPOpen() => $_clearField(4);
}


const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
