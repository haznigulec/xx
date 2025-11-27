// This is a generated file - do not edit.
//
// Generated from News/news.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use relatedNewsDescriptor instead')
const RelatedNews$json = {
  '1': 'RelatedNews',
  '2': [
    {'1': 'id', '3': 1, '4': 2, '5': 9, '10': 'id'},
    {'1': 'headline', '3': 2, '4': 2, '5': 9, '10': 'headline'},
  ],
};

/// Descriptor for `RelatedNews`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List relatedNewsDescriptor = $convert.base64Decode(
    'CgtSZWxhdGVkTmV3cxIOCgJpZBgBIAIoCVICaWQSGgoIaGVhZGxpbmUYAiACKAlSCGhlYWRsaW'
    '5l');

@$core.Deprecated('Use newsMessageDescriptor instead')
const NewsMessage$json = {
  '1': 'NewsMessage',
  '2': [
    {'1': 'id', '3': 1, '4': 2, '5': 9, '10': 'id'},
    {'1': 'isFlash', '3': 2, '4': 1, '5': 8, '7': 'false', '10': 'isFlash'},
    {'1': 'deleted', '3': 3, '4': 1, '5': 8, '7': 'false', '10': 'deleted'},
    {'1': 'timestamp', '3': 4, '4': 1, '5': 3, '10': 'timestamp'},
    {'1': 'headline', '3': 5, '4': 1, '5': 9, '10': 'headline'},
    {'1': 'content', '3': 6, '4': 1, '5': 9, '10': 'content'},
    {'1': 'source', '3': 7, '4': 3, '5': 9, '10': 'source'},
    {'1': 'category', '3': 8, '4': 3, '5': 9, '10': 'category'},
    {'1': 'symbol', '3': 9, '4': 3, '5': 9, '10': 'symbol'},
    {'1': 'language', '3': 10, '4': 1, '5': 9, '7': 'TR', '10': 'language'},
    {'1': 'attachment', '3': 11, '4': 3, '5': 9, '10': 'attachment'},
    {'1': 'dailyNewsNo', '3': 12, '4': 1, '5': 9, '10': 'dailyNewsNo'},
    {'1': 'chainId', '3': 13, '4': 1, '5': 9, '10': 'chainId'},
    {'1': 'relatedNews', '3': 14, '4': 3, '5': 11, '6': '.messages.RelatedNews', '10': 'relatedNews'},
  ],
};

/// Descriptor for `NewsMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List newsMessageDescriptor = $convert.base64Decode(
    'CgtOZXdzTWVzc2FnZRIOCgJpZBgBIAIoCVICaWQSHwoHaXNGbGFzaBgCIAEoCDoFZmFsc2VSB2'
    'lzRmxhc2gSHwoHZGVsZXRlZBgDIAEoCDoFZmFsc2VSB2RlbGV0ZWQSHAoJdGltZXN0YW1wGAQg'
    'ASgDUgl0aW1lc3RhbXASGgoIaGVhZGxpbmUYBSABKAlSCGhlYWRsaW5lEhgKB2NvbnRlbnQYBi'
    'ABKAlSB2NvbnRlbnQSFgoGc291cmNlGAcgAygJUgZzb3VyY2USGgoIY2F0ZWdvcnkYCCADKAlS'
    'CGNhdGVnb3J5EhYKBnN5bWJvbBgJIAMoCVIGc3ltYm9sEh4KCGxhbmd1YWdlGAogASgJOgJUUl'
    'IIbGFuZ3VhZ2USHgoKYXR0YWNobWVudBgLIAMoCVIKYXR0YWNobWVudBIgCgtkYWlseU5ld3NO'
    'bxgMIAEoCVILZGFpbHlOZXdzTm8SGAoHY2hhaW5JZBgNIAEoCVIHY2hhaW5JZBI3CgtyZWxhdG'
    'VkTmV3cxgOIAMoCzIVLm1lc3NhZ2VzLlJlbGF0ZWROZXdzUgtyZWxhdGVkTmV3cw==');

