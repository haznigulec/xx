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

import 'package:protobuf/protobuf.dart' as $pb;

class TopOfTheBookMessage_Action extends $pb.ProtobufEnum {
  static const TopOfTheBookMessage_Action I = TopOfTheBookMessage_Action._(0, _omitEnumNames ? '' : 'I');
  static const TopOfTheBookMessage_Action U = TopOfTheBookMessage_Action._(1, _omitEnumNames ? '' : 'U');
  static const TopOfTheBookMessage_Action D = TopOfTheBookMessage_Action._(2, _omitEnumNames ? '' : 'D');

  static const $core.List<TopOfTheBookMessage_Action> values = <TopOfTheBookMessage_Action> [
    I,
    U,
    D,
  ];

  static final $core.List<TopOfTheBookMessage_Action?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 2);
  static TopOfTheBookMessage_Action? valueOf($core.int value) =>  value < 0 || value >= _byValue.length ? null : _byValue[value];

  const TopOfTheBookMessage_Action._(super.value, super.name);
}

class TopOfTheBookMessage_BidAsk extends $pb.ProtobufEnum {
  static const TopOfTheBookMessage_BidAsk A = TopOfTheBookMessage_BidAsk._(0, _omitEnumNames ? '' : 'A');
  static const TopOfTheBookMessage_BidAsk B = TopOfTheBookMessage_BidAsk._(1, _omitEnumNames ? '' : 'B');

  static const $core.List<TopOfTheBookMessage_BidAsk> values = <TopOfTheBookMessage_BidAsk> [
    A,
    B,
  ];

  static final $core.List<TopOfTheBookMessage_BidAsk?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 1);
  static TopOfTheBookMessage_BidAsk? valueOf($core.int value) =>  value < 0 || value >= _byValue.length ? null : _byValue[value];

  const TopOfTheBookMessage_BidAsk._(super.value, super.name);
}


const $core.bool _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
