// This is a generated file - do not edit.
//
// Generated from ComputedValues/ComputedValues.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class ComputedValuesMessage extends $pb.GeneratedMessage {
  factory ComputedValuesMessage({
    $core.String? symbol,
    $core.String? updateDate,
    $core.String? optionClass,
    $core.double? strikePrice,
    $core.double? impliedVolatility,
    $core.double? instrinsicValue,
    $core.double? timeValue,
    $core.double? leverage,
    $core.double? delta,
    $core.double? gamma,
    $core.double? theta,
    $core.double? vega,
    $core.double? rho,
    $core.double? breakEven,
    $core.double? omega,
    $core.double? sensitivity,
  }) {
    final result = create();
    if (symbol != null) result.symbol = symbol;
    if (updateDate != null) result.updateDate = updateDate;
    if (optionClass != null) result.optionClass = optionClass;
    if (strikePrice != null) result.strikePrice = strikePrice;
    if (impliedVolatility != null) result.impliedVolatility = impliedVolatility;
    if (instrinsicValue != null) result.instrinsicValue = instrinsicValue;
    if (timeValue != null) result.timeValue = timeValue;
    if (leverage != null) result.leverage = leverage;
    if (delta != null) result.delta = delta;
    if (gamma != null) result.gamma = gamma;
    if (theta != null) result.theta = theta;
    if (vega != null) result.vega = vega;
    if (rho != null) result.rho = rho;
    if (breakEven != null) result.breakEven = breakEven;
    if (omega != null) result.omega = omega;
    if (sensitivity != null) result.sensitivity = sensitivity;
    return result;
  }

  ComputedValuesMessage._();

  factory ComputedValuesMessage.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory ComputedValuesMessage.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ComputedValuesMessage', package: const $pb.PackageName(_omitMessageNames ? '' : 'messages'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'symbol')
    ..aOS(2, _omitFieldNames ? '' : 'updateDate', protoName: 'updateDate')
    ..aOS(3, _omitFieldNames ? '' : 'optionClass', protoName: 'optionClass')
    ..a<$core.double>(4, _omitFieldNames ? '' : 'strikePrice', $pb.PbFieldType.OD, protoName: 'strikePrice')
    ..a<$core.double>(5, _omitFieldNames ? '' : 'impliedVolatility', $pb.PbFieldType.OD, protoName: 'impliedVolatility')
    ..a<$core.double>(6, _omitFieldNames ? '' : 'instrinsicValue', $pb.PbFieldType.OD, protoName: 'instrinsicValue')
    ..a<$core.double>(7, _omitFieldNames ? '' : 'timeValue', $pb.PbFieldType.OD, protoName: 'timeValue')
    ..a<$core.double>(8, _omitFieldNames ? '' : 'leverage', $pb.PbFieldType.OD)
    ..a<$core.double>(9, _omitFieldNames ? '' : 'delta', $pb.PbFieldType.OD)
    ..a<$core.double>(10, _omitFieldNames ? '' : 'gamma', $pb.PbFieldType.OD)
    ..a<$core.double>(11, _omitFieldNames ? '' : 'theta', $pb.PbFieldType.OD)
    ..a<$core.double>(12, _omitFieldNames ? '' : 'vega', $pb.PbFieldType.OD)
    ..a<$core.double>(13, _omitFieldNames ? '' : 'rho', $pb.PbFieldType.OD)
    ..a<$core.double>(14, _omitFieldNames ? '' : 'breakEven', $pb.PbFieldType.OD, protoName: 'breakEven')
    ..a<$core.double>(15, _omitFieldNames ? '' : 'omega', $pb.PbFieldType.OD)
    ..a<$core.double>(16, _omitFieldNames ? '' : 'sensitivity', $pb.PbFieldType.OD)
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ComputedValuesMessage clone() => ComputedValuesMessage()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ComputedValuesMessage copyWith(void Function(ComputedValuesMessage) updates) => super.copyWith((message) => updates(message as ComputedValuesMessage)) as ComputedValuesMessage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ComputedValuesMessage create() => ComputedValuesMessage._();
  @$core.override
  ComputedValuesMessage createEmptyInstance() => create();
  static $pb.PbList<ComputedValuesMessage> createRepeated() => $pb.PbList<ComputedValuesMessage>();
  @$core.pragma('dart2js:noInline')
  static ComputedValuesMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ComputedValuesMessage>(create);
  static ComputedValuesMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get symbol => $_getSZ(0);
  @$pb.TagNumber(1)
  set symbol($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSymbol() => $_has(0);
  @$pb.TagNumber(1)
  void clearSymbol() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get updateDate => $_getSZ(1);
  @$pb.TagNumber(2)
  set updateDate($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUpdateDate() => $_has(1);
  @$pb.TagNumber(2)
  void clearUpdateDate() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get optionClass => $_getSZ(2);
  @$pb.TagNumber(3)
  set optionClass($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOptionClass() => $_has(2);
  @$pb.TagNumber(3)
  void clearOptionClass() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get strikePrice => $_getN(3);
  @$pb.TagNumber(4)
  set strikePrice($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasStrikePrice() => $_has(3);
  @$pb.TagNumber(4)
  void clearStrikePrice() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get impliedVolatility => $_getN(4);
  @$pb.TagNumber(5)
  set impliedVolatility($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasImpliedVolatility() => $_has(4);
  @$pb.TagNumber(5)
  void clearImpliedVolatility() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get instrinsicValue => $_getN(5);
  @$pb.TagNumber(6)
  set instrinsicValue($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasInstrinsicValue() => $_has(5);
  @$pb.TagNumber(6)
  void clearInstrinsicValue() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get timeValue => $_getN(6);
  @$pb.TagNumber(7)
  set timeValue($core.double value) => $_setDouble(6, value);
  @$pb.TagNumber(7)
  $core.bool hasTimeValue() => $_has(6);
  @$pb.TagNumber(7)
  void clearTimeValue() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.double get leverage => $_getN(7);
  @$pb.TagNumber(8)
  set leverage($core.double value) => $_setDouble(7, value);
  @$pb.TagNumber(8)
  $core.bool hasLeverage() => $_has(7);
  @$pb.TagNumber(8)
  void clearLeverage() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.double get delta => $_getN(8);
  @$pb.TagNumber(9)
  set delta($core.double value) => $_setDouble(8, value);
  @$pb.TagNumber(9)
  $core.bool hasDelta() => $_has(8);
  @$pb.TagNumber(9)
  void clearDelta() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.double get gamma => $_getN(9);
  @$pb.TagNumber(10)
  set gamma($core.double value) => $_setDouble(9, value);
  @$pb.TagNumber(10)
  $core.bool hasGamma() => $_has(9);
  @$pb.TagNumber(10)
  void clearGamma() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.double get theta => $_getN(10);
  @$pb.TagNumber(11)
  set theta($core.double value) => $_setDouble(10, value);
  @$pb.TagNumber(11)
  $core.bool hasTheta() => $_has(10);
  @$pb.TagNumber(11)
  void clearTheta() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.double get vega => $_getN(11);
  @$pb.TagNumber(12)
  set vega($core.double value) => $_setDouble(11, value);
  @$pb.TagNumber(12)
  $core.bool hasVega() => $_has(11);
  @$pb.TagNumber(12)
  void clearVega() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.double get rho => $_getN(12);
  @$pb.TagNumber(13)
  set rho($core.double value) => $_setDouble(12, value);
  @$pb.TagNumber(13)
  $core.bool hasRho() => $_has(12);
  @$pb.TagNumber(13)
  void clearRho() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.double get breakEven => $_getN(13);
  @$pb.TagNumber(14)
  set breakEven($core.double value) => $_setDouble(13, value);
  @$pb.TagNumber(14)
  $core.bool hasBreakEven() => $_has(13);
  @$pb.TagNumber(14)
  void clearBreakEven() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.double get omega => $_getN(14);
  @$pb.TagNumber(15)
  set omega($core.double value) => $_setDouble(14, value);
  @$pb.TagNumber(15)
  $core.bool hasOmega() => $_has(14);
  @$pb.TagNumber(15)
  void clearOmega() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.double get sensitivity => $_getN(15);
  @$pb.TagNumber(16)
  set sensitivity($core.double value) => $_setDouble(15, value);
  @$pb.TagNumber(16)
  $core.bool hasSensitivity() => $_has(15);
  @$pb.TagNumber(16)
  void clearSensitivity() => $_clearField(16);
}


const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
