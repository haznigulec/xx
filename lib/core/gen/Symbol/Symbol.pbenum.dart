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

import 'package:protobuf/protobuf.dart' as $pb;

class SymbolMessage_PublishReason extends $pb.ProtobufEnum {
  static const SymbolMessage_PublishReason UPDATE = SymbolMessage_PublishReason._(0, _omitEnumNames ? '' : 'UPDATE');
  static const SymbolMessage_PublishReason REFRESH = SymbolMessage_PublishReason._(1, _omitEnumNames ? '' : 'REFRESH');

  static const $core.List<SymbolMessage_PublishReason> values = <SymbolMessage_PublishReason> [
    UPDATE,
    REFRESH,
  ];

  static final $core.List<SymbolMessage_PublishReason?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 1);
  static SymbolMessage_PublishReason? valueOf($core.int value) =>  value < 0 || value >= _byValue.length ? null : _byValue[value];

  const SymbolMessage_PublishReason._(super.value, super.name);
}


const $core.bool _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
