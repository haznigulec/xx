// This is a generated file - do not edit.
//
// Generated from DepthTable/DepthTable.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use depthCellDescriptor instead')
const DepthCell$json = {
  '1': 'DepthCell',
  '2': [
    {'1': 'price', '3': 1, '4': 2, '5': 1, '10': 'price'},
    {'1': 'quantity', '3': 2, '4': 2, '5': 3, '10': 'quantity'},
    {'1': 'timestamp', '3': 3, '4': 2, '5': 3, '10': 'timestamp'},
    {'1': 'orderCount', '3': 4, '4': 2, '5': 3, '10': 'orderCount'},
  ],
};

/// Descriptor for `DepthCell`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List depthCellDescriptor = $convert.base64Decode(
    'CglEZXB0aENlbGwSFAoFcHJpY2UYASACKAFSBXByaWNlEhoKCHF1YW50aXR5GAIgAigDUghxdW'
    'FudGl0eRIcCgl0aW1lc3RhbXAYAyACKANSCXRpbWVzdGFtcBIeCgpvcmRlckNvdW50GAQgAigD'
    'UgpvcmRlckNvdW50');

@$core.Deprecated('Use depthTableMessageDescriptor instead')
const DepthTableMessage$json = {
  '1': 'DepthTableMessage',
  '2': [
    {'1': 'symbol', '3': 1, '4': 2, '5': 9, '10': 'symbol'},
    {'1': 'dateSymbol', '3': 2, '4': 1, '5': 9, '10': 'dateSymbol'},
    {'1': 'timestamp', '3': 3, '4': 1, '5': 3, '10': 'timestamp'},
    {'1': 'asks', '3': 4, '4': 3, '5': 11, '6': '.messages.DepthCell', '10': 'asks'},
    {'1': 'bids', '3': 5, '4': 3, '5': 11, '6': '.messages.DepthCell', '10': 'bids'},
    {'1': 'action', '3': 6, '4': 1, '5': 14, '6': '.messages.DepthTableMessage.Action', '10': 'action'},
    {'1': 'bidAsk', '3': 7, '4': 1, '5': 14, '6': '.messages.DepthTableMessage.BidAsk', '10': 'bidAsk'},
    {'1': 'row', '3': 8, '4': 1, '5': 5, '10': 'row'},
    {'1': 'actionPrice', '3': 9, '4': 1, '5': 1, '10': 'actionPrice'},
    {'1': 'actionQuantity', '3': 10, '4': 1, '5': 3, '10': 'actionQuantity'},
    {'1': 'actionOrderCount', '3': 11, '4': 1, '5': 3, '10': 'actionOrderCount'},
  ],
  '4': [DepthTableMessage_Action$json, DepthTableMessage_BidAsk$json],
};

@$core.Deprecated('Use depthTableMessageDescriptor instead')
const DepthTableMessage_Action$json = {
  '1': 'Action',
  '2': [
    {'1': 'I', '2': 0},
    {'1': 'U', '2': 1},
    {'1': 'D', '2': 2},
  ],
};

@$core.Deprecated('Use depthTableMessageDescriptor instead')
const DepthTableMessage_BidAsk$json = {
  '1': 'BidAsk',
  '2': [
    {'1': 'A', '2': 0},
    {'1': 'B', '2': 1},
  ],
};

/// Descriptor for `DepthTableMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List depthTableMessageDescriptor = $convert.base64Decode(
    'ChFEZXB0aFRhYmxlTWVzc2FnZRIWCgZzeW1ib2wYASACKAlSBnN5bWJvbBIeCgpkYXRlU3ltYm'
    '9sGAIgASgJUgpkYXRlU3ltYm9sEhwKCXRpbWVzdGFtcBgDIAEoA1IJdGltZXN0YW1wEicKBGFz'
    'a3MYBCADKAsyEy5tZXNzYWdlcy5EZXB0aENlbGxSBGFza3MSJwoEYmlkcxgFIAMoCzITLm1lc3'
    'NhZ2VzLkRlcHRoQ2VsbFIEYmlkcxI6CgZhY3Rpb24YBiABKA4yIi5tZXNzYWdlcy5EZXB0aFRh'
    'YmxlTWVzc2FnZS5BY3Rpb25SBmFjdGlvbhI6CgZiaWRBc2sYByABKA4yIi5tZXNzYWdlcy5EZX'
    'B0aFRhYmxlTWVzc2FnZS5CaWRBc2tSBmJpZEFzaxIQCgNyb3cYCCABKAVSA3JvdxIgCgthY3Rp'
    'b25QcmljZRgJIAEoAVILYWN0aW9uUHJpY2USJgoOYWN0aW9uUXVhbnRpdHkYCiABKANSDmFjdG'
    'lvblF1YW50aXR5EioKEGFjdGlvbk9yZGVyQ291bnQYCyABKANSEGFjdGlvbk9yZGVyQ291bnQi'
    'HQoGQWN0aW9uEgUKAUkQABIFCgFVEAESBQoBRBACIhYKBkJpZEFzaxIFCgFBEAASBQoBQhAB');

