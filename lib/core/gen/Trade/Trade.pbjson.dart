// This is a generated file - do not edit.
//
// Generated from Trade/Trade.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use tradeMessageDescriptor instead')
const TradeMessage$json = {
  '1': 'TradeMessage',
  '2': [
    {'1': 'symbol', '3': 1, '4': 2, '5': 9, '10': 'symbol'},
    {'1': 'orderNo', '3': 2, '4': 1, '5': 9, '10': 'orderNo'},
    {'1': 'price', '3': 3, '4': 1, '5': 2, '10': 'price'},
    {'1': 'quantity', '3': 4, '4': 1, '5': 3, '10': 'quantity'},
    {'1': 'activeBidOrAsk', '3': 5, '4': 1, '5': 9, '10': 'activeBidOrAsk'},
    {'1': 'timestamp', '3': 6, '4': 1, '5': 3, '10': 'timestamp'},
    {'1': 'buyer', '3': 7, '4': 1, '5': 9, '10': 'buyer'},
    {'1': 'seller', '3': 8, '4': 1, '5': 9, '10': 'seller'},
    {'1': 'isTradeEx', '3': 9, '4': 1, '5': 8, '10': 'isTradeEx'},
  ],
};

/// Descriptor for `TradeMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tradeMessageDescriptor = $convert.base64Decode(
    'CgxUcmFkZU1lc3NhZ2USFgoGc3ltYm9sGAEgAigJUgZzeW1ib2wSGAoHb3JkZXJObxgCIAEoCV'
    'IHb3JkZXJObxIUCgVwcmljZRgDIAEoAlIFcHJpY2USGgoIcXVhbnRpdHkYBCABKANSCHF1YW50'
    'aXR5EiYKDmFjdGl2ZUJpZE9yQXNrGAUgASgJUg5hY3RpdmVCaWRPckFzaxIcCgl0aW1lc3RhbX'
    'AYBiABKANSCXRpbWVzdGFtcBIUCgVidXllchgHIAEoCVIFYnV5ZXISFgoGc2VsbGVyGAggASgJ'
    'UgZzZWxsZXISHAoJaXNUcmFkZUV4GAkgASgIUglpc1RyYWRlRXg=');

