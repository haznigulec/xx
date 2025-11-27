// This is a generated file - do not edit.
//
// Generated from Booklet/TopOfTheBook.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use orderDescriptor instead')
const Order$json = {
  '1': 'Order',
  '2': [
    {'1': 'orderID', '3': 1, '4': 1, '5': 3, '10': 'orderID'},
    {'1': 'timestamp', '3': 2, '4': 1, '5': 3, '10': 'timestamp'},
    {'1': 'quantity', '3': 3, '4': 1, '5': 1, '10': 'quantity'},
    {'1': 'price', '3': 4, '4': 1, '5': 1, '10': 'price'},
  ],
};

/// Descriptor for `Order`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orderDescriptor = $convert.base64Decode(
    'CgVPcmRlchIYCgdvcmRlcklEGAEgASgDUgdvcmRlcklEEhwKCXRpbWVzdGFtcBgCIAEoA1IJdG'
    'ltZXN0YW1wEhoKCHF1YW50aXR5GAMgASgBUghxdWFudGl0eRIUCgVwcmljZRgEIAEoAVIFcHJp'
    'Y2U=');

@$core.Deprecated('Use topOfTheBookMessageDescriptor instead')
const TopOfTheBookMessage$json = {
  '1': 'TopOfTheBookMessage',
  '2': [
    {'1': 'symbol', '3': 1, '4': 1, '5': 9, '10': 'symbol'},
    {'1': 'asks', '3': 2, '4': 3, '5': 11, '6': '.messages.Order', '10': 'asks'},
    {'1': 'bids', '3': 3, '4': 3, '5': 11, '6': '.messages.Order', '10': 'bids'},
    {'1': 'action', '3': 4, '4': 1, '5': 14, '6': '.messages.TopOfTheBookMessage.Action', '10': 'action'},
    {'1': 'bidAsk', '3': 5, '4': 1, '5': 14, '6': '.messages.TopOfTheBookMessage.BidAsk', '10': 'bidAsk'},
    {'1': 'affectedRow', '3': 6, '4': 1, '5': 5, '10': 'affectedRow'},
  ],
  '4': [TopOfTheBookMessage_Action$json, TopOfTheBookMessage_BidAsk$json],
};

@$core.Deprecated('Use topOfTheBookMessageDescriptor instead')
const TopOfTheBookMessage_Action$json = {
  '1': 'Action',
  '2': [
    {'1': 'I', '2': 0},
    {'1': 'U', '2': 1},
    {'1': 'D', '2': 2},
  ],
};

@$core.Deprecated('Use topOfTheBookMessageDescriptor instead')
const TopOfTheBookMessage_BidAsk$json = {
  '1': 'BidAsk',
  '2': [
    {'1': 'A', '2': 0},
    {'1': 'B', '2': 1},
  ],
};

/// Descriptor for `TopOfTheBookMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List topOfTheBookMessageDescriptor = $convert.base64Decode(
    'ChNUb3BPZlRoZUJvb2tNZXNzYWdlEhYKBnN5bWJvbBgBIAEoCVIGc3ltYm9sEiMKBGFza3MYAi'
    'ADKAsyDy5tZXNzYWdlcy5PcmRlclIEYXNrcxIjCgRiaWRzGAMgAygLMg8ubWVzc2FnZXMuT3Jk'
    'ZXJSBGJpZHMSPAoGYWN0aW9uGAQgASgOMiQubWVzc2FnZXMuVG9wT2ZUaGVCb29rTWVzc2FnZS'
    '5BY3Rpb25SBmFjdGlvbhI8CgZiaWRBc2sYBSABKA4yJC5tZXNzYWdlcy5Ub3BPZlRoZUJvb2tN'
    'ZXNzYWdlLkJpZEFza1IGYmlkQXNrEiAKC2FmZmVjdGVkUm93GAYgASgFUgthZmZlY3RlZFJvdy'
    'IdCgZBY3Rpb24SBQoBSRAAEgUKAVUQARIFCgFEEAIiFgoGQmlkQXNrEgUKAUEQABIFCgFCEAE=');

