// This is a generated file - do not edit.
//
// Generated from Messenger/Messenger.proto.

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

class MessengerMessage extends $pb.GeneratedMessage {
  factory MessengerMessage({
    $core.String? code,
    $core.String? from,
    $fixnum.Int64? timestamp,
    $core.String? contentType,
    $core.String? subject,
    $core.String? content,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (from != null) result.from = from;
    if (timestamp != null) result.timestamp = timestamp;
    if (contentType != null) result.contentType = contentType;
    if (subject != null) result.subject = subject;
    if (content != null) result.content = content;
    return result;
  }

  MessengerMessage._();

  factory MessengerMessage.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory MessengerMessage.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MessengerMessage', package: const $pb.PackageName(_omitMessageNames ? '' : 'messages'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'from')
    ..aInt64(3, _omitFieldNames ? '' : 'timestamp')
    ..a<$core.String>(4, _omitFieldNames ? '' : 'contentType', $pb.PbFieldType.OS, protoName: 'contentType', defaultOrMaker: 'text/plain')
    ..aOS(5, _omitFieldNames ? '' : 'subject')
    ..aOS(6, _omitFieldNames ? '' : 'content')
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MessengerMessage clone() => MessengerMessage()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MessengerMessage copyWith(void Function(MessengerMessage) updates) => super.copyWith((message) => updates(message as MessengerMessage)) as MessengerMessage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MessengerMessage create() => MessengerMessage._();
  @$core.override
  MessengerMessage createEmptyInstance() => create();
  static $pb.PbList<MessengerMessage> createRepeated() => $pb.PbList<MessengerMessage>();
  @$core.pragma('dart2js:noInline')
  static MessengerMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MessengerMessage>(create);
  static MessengerMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get from => $_getSZ(1);
  @$pb.TagNumber(2)
  set from($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFrom() => $_has(1);
  @$pb.TagNumber(2)
  void clearFrom() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get timestamp => $_getI64(2);
  @$pb.TagNumber(3)
  set timestamp($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTimestamp() => $_has(2);
  @$pb.TagNumber(3)
  void clearTimestamp() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get contentType => $_getS(3, 'text/plain');
  @$pb.TagNumber(4)
  set contentType($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasContentType() => $_has(3);
  @$pb.TagNumber(4)
  void clearContentType() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get subject => $_getSZ(4);
  @$pb.TagNumber(5)
  set subject($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSubject() => $_has(4);
  @$pb.TagNumber(5)
  void clearSubject() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get content => $_getSZ(5);
  @$pb.TagNumber(6)
  set content($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasContent() => $_has(5);
  @$pb.TagNumber(6)
  void clearContent() => $_clearField(6);
}


const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
