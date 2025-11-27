// This is a generated file - do not edit.
//
// Generated from Ranker/Ranker.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use symbolDescriptor instead')
const Symbol$json = {
  '1': 'Symbol',
  '2': [
    {'1': 'key', '3': 1, '4': 2, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 1, '10': 'value'},
    {'1': 'last', '3': 3, '4': 1, '5': 1, '10': 'last'},
    {'1': 'priceChange', '3': 4, '4': 1, '5': 1, '10': 'priceChange'},
    {'1': 'additionalValue', '3': 5, '4': 1, '5': 1, '10': 'additionalValue'},
    {'1': 'ask', '3': 6, '4': 1, '5': 1, '10': 'ask'},
    {'1': 'bid', '3': 7, '4': 1, '5': 1, '10': 'bid'},
  ],
};

/// Descriptor for `Symbol`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List symbolDescriptor = $convert.base64Decode(
    'CgZTeW1ib2wSEAoDa2V5GAEgAigJUgNrZXkSFAoFdmFsdWUYAiABKAFSBXZhbHVlEhIKBGxhc3'
    'QYAyABKAFSBGxhc3QSIAoLcHJpY2VDaGFuZ2UYBCABKAFSC3ByaWNlQ2hhbmdlEigKD2FkZGl0'
    'aW9uYWxWYWx1ZRgFIAEoAVIPYWRkaXRpb25hbFZhbHVlEhAKA2FzaxgGIAEoAVIDYXNrEhAKA2'
    'JpZBgHIAEoAVIDYmlk');

@$core.Deprecated('Use rankMessageDescriptor instead')
const RankMessage$json = {
  '1': 'RankMessage',
  '2': [
    {'1': 'symbols', '3': 1, '4': 3, '5': 11, '6': '.messages.Symbol', '10': 'symbols'},
    {'1': 'bist30', '3': 2, '4': 3, '5': 11, '6': '.messages.Symbol', '10': 'bist30'},
    {'1': 'bist100', '3': 3, '4': 3, '5': 11, '6': '.messages.Symbol', '10': 'bist100'},
  ],
};

/// Descriptor for `RankMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rankMessageDescriptor = $convert.base64Decode(
    'CgtSYW5rTWVzc2FnZRIqCgdzeW1ib2xzGAEgAygLMhAubWVzc2FnZXMuU3ltYm9sUgdzeW1ib2'
    'xzEigKBmJpc3QzMBgCIAMoCzIQLm1lc3NhZ2VzLlN5bWJvbFIGYmlzdDMwEioKB2Jpc3QxMDAY'
    'AyADKAsyEC5tZXNzYWdlcy5TeW1ib2xSB2Jpc3QxMDA=');

