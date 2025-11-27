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

import 'package:protobuf/protobuf.dart' as $pb;

class DepthTableMessage_Action extends $pb.ProtobufEnum {
  static const DepthTableMessage_Action I = DepthTableMessage_Action._(0, _omitEnumNames ? '' : 'I');
  static const DepthTableMessage_Action U = DepthTableMessage_Action._(1, _omitEnumNames ? '' : 'U');
  static const DepthTableMessage_Action D = DepthTableMessage_Action._(2, _omitEnumNames ? '' : 'D');

  static const $core.List<DepthTableMessage_Action> values = <DepthTableMessage_Action> [
    I,
    U,
    D,
  ];

  static final $core.List<DepthTableMessage_Action?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 2);
  static DepthTableMessage_Action? valueOf($core.int value) =>  value < 0 || value >= _byValue.length ? null : _byValue[value];

  const DepthTableMessage_Action._(super.value, super.name);
}

class DepthTableMessage_BidAsk extends $pb.ProtobufEnum {
  static const DepthTableMessage_BidAsk A = DepthTableMessage_BidAsk._(0, _omitEnumNames ? '' : 'A');
  static const DepthTableMessage_BidAsk B = DepthTableMessage_BidAsk._(1, _omitEnumNames ? '' : 'B');

  static const $core.List<DepthTableMessage_BidAsk> values = <DepthTableMessage_BidAsk> [
    A,
    B,
  ];

  static final $core.List<DepthTableMessage_BidAsk?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 1);
  static DepthTableMessage_BidAsk? valueOf($core.int value) =>  value < 0 || value >= _byValue.length ? null : _byValue[value];

  const DepthTableMessage_BidAsk._(super.value, super.name);
}


const $core.bool _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
