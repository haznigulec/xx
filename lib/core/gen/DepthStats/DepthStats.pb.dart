// This is a generated file - do not edit.
//
// Generated from DepthStats/DepthStats.proto.

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

class DepthStatsMessage extends $pb.GeneratedMessage {
  factory DepthStatsMessage({
    $fixnum.Int64? timestamp,
    $core.double? totalBidWAvg,
    $core.double? totalAskWAvg,
    $core.double? totalBidQuantity,
    $core.double? totalAskQuantity,
  }) {
    final result = create();
    if (timestamp != null) result.timestamp = timestamp;
    if (totalBidWAvg != null) result.totalBidWAvg = totalBidWAvg;
    if (totalAskWAvg != null) result.totalAskWAvg = totalAskWAvg;
    if (totalBidQuantity != null) result.totalBidQuantity = totalBidQuantity;
    if (totalAskQuantity != null) result.totalAskQuantity = totalAskQuantity;
    return result;
  }

  DepthStatsMessage._();

  factory DepthStatsMessage.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory DepthStatsMessage.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DepthStatsMessage', package: const $pb.PackageName(_omitMessageNames ? '' : 'messages'), createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'timestamp')
    ..a<$core.double>(2, _omitFieldNames ? '' : 'totalBidWAvg', $pb.PbFieldType.OD, protoName: 'totalBidWAvg')
    ..a<$core.double>(3, _omitFieldNames ? '' : 'totalAskWAvg', $pb.PbFieldType.OD, protoName: 'totalAskWAvg')
    ..a<$core.double>(4, _omitFieldNames ? '' : 'totalBidQuantity', $pb.PbFieldType.OD, protoName: 'totalBidQuantity')
    ..a<$core.double>(5, _omitFieldNames ? '' : 'totalAskQuantity', $pb.PbFieldType.OD, protoName: 'totalAskQuantity')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DepthStatsMessage clone() => DepthStatsMessage()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DepthStatsMessage copyWith(void Function(DepthStatsMessage) updates) => super.copyWith((message) => updates(message as DepthStatsMessage)) as DepthStatsMessage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DepthStatsMessage create() => DepthStatsMessage._();
  @$core.override
  DepthStatsMessage createEmptyInstance() => create();
  static $pb.PbList<DepthStatsMessage> createRepeated() => $pb.PbList<DepthStatsMessage>();
  @$core.pragma('dart2js:noInline')
  static DepthStatsMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DepthStatsMessage>(create);
  static DepthStatsMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get timestamp => $_getI64(0);
  @$pb.TagNumber(1)
  set timestamp($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTimestamp() => $_has(0);
  @$pb.TagNumber(1)
  void clearTimestamp() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get totalBidWAvg => $_getN(1);
  @$pb.TagNumber(2)
  set totalBidWAvg($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotalBidWAvg() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalBidWAvg() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get totalAskWAvg => $_getN(2);
  @$pb.TagNumber(3)
  set totalAskWAvg($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTotalAskWAvg() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalAskWAvg() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get totalBidQuantity => $_getN(3);
  @$pb.TagNumber(4)
  set totalBidQuantity($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTotalBidQuantity() => $_has(3);
  @$pb.TagNumber(4)
  void clearTotalBidQuantity() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get totalAskQuantity => $_getN(4);
  @$pb.TagNumber(5)
  set totalAskQuantity($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTotalAskQuantity() => $_has(4);
  @$pb.TagNumber(5)
  void clearTotalAskQuantity() => $_clearField(5);
}


const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
