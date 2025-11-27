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

import 'package:protobuf/protobuf.dart' as $pb;

class DerivativeMessage_OptionClass extends $pb.ProtobufEnum {
  static const DerivativeMessage_OptionClass P = DerivativeMessage_OptionClass._(0, _omitEnumNames ? '' : 'P');
  static const DerivativeMessage_OptionClass C = DerivativeMessage_OptionClass._(1, _omitEnumNames ? '' : 'C');

  static const $core.List<DerivativeMessage_OptionClass> values = <DerivativeMessage_OptionClass> [
    P,
    C,
  ];

  static final $core.List<DerivativeMessage_OptionClass?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 1);
  static DerivativeMessage_OptionClass? valueOf($core.int value) =>  value < 0 || value >= _byValue.length ? null : _byValue[value];

  const DerivativeMessage_OptionClass._(super.value, super.name);
}

class DerivativeMessage_PublishReason extends $pb.ProtobufEnum {
  static const DerivativeMessage_PublishReason UPDATE = DerivativeMessage_PublishReason._(0, _omitEnumNames ? '' : 'UPDATE');
  static const DerivativeMessage_PublishReason REFRESH = DerivativeMessage_PublishReason._(1, _omitEnumNames ? '' : 'REFRESH');

  static const $core.List<DerivativeMessage_PublishReason> values = <DerivativeMessage_PublishReason> [
    UPDATE,
    REFRESH,
  ];

  static final $core.List<DerivativeMessage_PublishReason?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 1);
  static DerivativeMessage_PublishReason? valueOf($core.int value) =>  value < 0 || value >= _byValue.length ? null : _byValue[value];

  const DerivativeMessage_PublishReason._(super.value, super.name);
}


const $core.bool _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
