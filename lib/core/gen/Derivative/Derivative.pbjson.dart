// This is a generated file - do not edit.
//
// Generated from Derivative/Derivative.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use derivativeMessageDescriptor instead')
const DerivativeMessage$json = {
  '1': 'DerivativeMessage',
  '2': [
    {'1': 'symbolId', '3': 1, '4': 2, '5': 5, '10': 'symbolId'},
    {'1': 'symbolCode', '3': 2, '4': 1, '5': 9, '10': 'symbolCode'},
    {'1': 'symbolDesc', '3': 3, '4': 1, '5': 9, '10': 'symbolDesc'},
    {'1': 'updateDate', '3': 4, '4': 1, '5': 9, '10': 'updateDate'},
    {'1': 'bid', '3': 5, '4': 1, '5': 1, '10': 'bid'},
    {'1': 'ask', '3': 6, '4': 1, '5': 1, '10': 'ask'},
    {'1': 'low', '3': 7, '4': 1, '5': 1, '10': 'low'},
    {'1': 'high', '3': 8, '4': 1, '5': 1, '10': 'high'},
    {'1': 'last', '3': 9, '4': 1, '5': 1, '10': 'last'},
    {'1': 'dayClose', '3': 10, '4': 1, '5': 1, '10': 'dayClose'},
    {'1': 'fractionCount', '3': 11, '4': 1, '5': 5, '10': 'fractionCount'},
    {'1': 'strikePrice', '3': 12, '4': 1, '5': 1, '10': 'strikePrice'},
    {'1': 'maturity', '3': 13, '4': 1, '5': 9, '10': 'maturity'},
    {'1': 'underlying', '3': 14, '4': 1, '5': 9, '10': 'underlying'},
    {'1': 'optionClass', '3': 15, '4': 1, '5': 14, '6': '.messages.DerivativeMessage.OptionClass', '10': 'optionClass'},
    {'1': 'dailyLow', '3': 16, '4': 1, '5': 1, '10': 'dailyLow'},
    {'1': 'dailyHigh', '3': 17, '4': 1, '5': 1, '10': 'dailyHigh'},
    {'1': 'quantity', '3': 18, '4': 1, '5': 1, '10': 'quantity'},
    {'1': 'volume', '3': 19, '4': 1, '5': 1, '10': 'volume'},
    {'1': 'difference', '3': 20, '4': 1, '5': 1, '10': 'difference'},
    {'1': 'differencePercent', '3': 21, '4': 1, '5': 1, '10': 'differencePercent'},
    {'1': 'sevenDaysDifPer', '3': 22, '4': 1, '5': 1, '10': 'sevenDaysDifPer'},
    {'1': 'thirtyDaysDifPer', '3': 23, '4': 1, '5': 1, '10': 'thirtyDaysDifPer'},
    {'1': 'fiftytwoWeekDifPer', '3': 24, '4': 1, '5': 1, '10': 'fiftytwoWeekDifPer'},
    {'1': 'monthHigh', '3': 25, '4': 1, '5': 1, '10': 'monthHigh'},
    {'1': 'monthLow', '3': 26, '4': 1, '5': 1, '10': 'monthLow'},
    {'1': 'yearHigh', '3': 27, '4': 1, '5': 1, '10': 'yearHigh'},
    {'1': 'yearLow', '3': 28, '4': 1, '5': 1, '10': 'yearLow'},
    {'1': 'priceMean', '3': 29, '4': 1, '5': 1, '10': 'priceMean'},
    {'1': 'limitUp', '3': 30, '4': 1, '5': 1, '10': 'limitUp'},
    {'1': 'limitDown', '3': 31, '4': 1, '5': 1, '10': 'limitDown'},
    {'1': 'settlement', '3': 32, '4': 1, '5': 1, '10': 'settlement'},
    {'1': 'settlementPerDif', '3': 33, '4': 1, '5': 1, '10': 'settlementPerDif'},
    {'1': 'openInterest', '3': 34, '4': 1, '5': 3, '10': 'openInterest'},
    {'1': 'theoricalPrice', '3': 35, '4': 1, '5': 1, '10': 'theoricalPrice'},
    {'1': 'theoricelPDifPer', '3': 36, '4': 1, '5': 1, '10': 'theoricelPDifPer'},
    {'1': 'dailyVolume', '3': 37, '4': 1, '5': 1, '10': 'dailyVolume'},
    {'1': 'priceStep', '3': 38, '4': 1, '5': 1, '10': 'priceStep'},
    {'1': 'openForTrade', '3': 39, '4': 1, '5': 8, '10': 'openForTrade'},
    {'1': 'tradeDate', '3': 40, '4': 1, '5': 9, '10': 'tradeDate'},
    {'1': 'open', '3': 41, '4': 1, '5': 1, '10': 'open'},
    {'1': 'dailyQuantity', '3': 42, '4': 1, '5': 1, '10': 'dailyQuantity'},
    {'1': 'actionType', '3': 43, '4': 1, '5': 9, '10': 'actionType'},
    {
      '1': 'brutSwap',
      '3': 44,
      '4': 1,
      '5': 5,
      '8': {'3': true},
      '10': 'brutSwap',
    },
    {'1': 'totalTradeCount', '3': 45, '4': 1, '5': 1, '10': 'totalTradeCount'},
    {'1': 'lastQuantity', '3': 46, '4': 1, '5': 1, '10': 'lastQuantity'},
    {'1': 'openInterestChange', '3': 47, '4': 1, '5': 1, '10': 'openInterestChange'},
    {'1': 'weekLow', '3': 48, '4': 1, '5': 1, '10': 'weekLow'},
    {'1': 'weekHigh', '3': 49, '4': 1, '5': 1, '10': 'weekHigh'},
    {'1': 'weekClose', '3': 50, '4': 1, '5': 1, '10': 'weekClose'},
    {'1': 'monthClose', '3': 51, '4': 1, '5': 1, '10': 'monthClose'},
    {'1': 'yearClose', '3': 52, '4': 1, '5': 1, '10': 'yearClose'},
    {'1': 'preSettlement', '3': 53, '4': 1, '5': 1, '10': 'preSettlement'},
    {'1': 'askSize', '3': 54, '4': 1, '5': 3, '10': 'askSize'},
    {'1': 'bidSize', '3': 55, '4': 1, '5': 3, '10': 'bidSize'},
    {'1': 'rate', '3': 56, '4': 1, '5': 1, '10': 'rate'},
    {'1': 'marketMaker', '3': 57, '4': 1, '5': 9, '10': 'marketMaker'},
    {'1': 'marketMakerAsk', '3': 58, '4': 1, '5': 1, '10': 'marketMakerAsk'},
    {'1': 'marketMakerBid', '3': 59, '4': 1, '5': 1, '10': 'marketMakerBid'},
    {'1': 'prevYearClose', '3': 60, '4': 1, '5': 1, '10': 'prevYearClose'},
    {'1': 'riskLevel', '3': 61, '4': 1, '5': 9, '10': 'riskLevel'},
    {'1': 'marketMakerAskClose', '3': 62, '4': 1, '5': 1, '10': 'marketMakerAskClose'},
    {'1': 'marketMakerBidClose', '3': 63, '4': 1, '5': 1, '10': 'marketMakerBidClose'},
    {'1': 'weekPriceMean', '3': 64, '4': 1, '5': 1, '10': 'weekPriceMean'},
    {'1': 'monthPriceMean', '3': 65, '4': 1, '5': 1, '10': 'monthPriceMean'},
    {'1': 'yearPriceMean', '3': 66, '4': 1, '5': 1, '10': 'yearPriceMean'},
    {'1': 'incrementalQuantity', '3': 67, '4': 1, '5': 1, '7': '0', '10': 'incrementalQuantity'},
    {'1': 'publishReason', '3': 68, '4': 1, '5': 14, '6': '.messages.DerivativeMessage.PublishReason', '7': 'UPDATE', '10': 'publishReason'},
    {'1': 'stockStatus', '3': 69, '4': 1, '5': 5, '10': 'stockStatus'},
    {'1': 'eqPrice', '3': 70, '4': 1, '5': 1, '10': 'eqPrice'},
    {'1': 'eqQuantity', '3': 71, '4': 1, '5': 1, '10': 'eqQuantity'},
    {'1': 'eqRemainingBidQuantity', '3': 72, '4': 1, '5': 1, '10': 'eqRemainingBidQuantity'},
    {'1': 'eqRemainingAskQuantity', '3': 73, '4': 1, '5': 1, '10': 'eqRemainingAskQuantity'},
    {'1': 'initialMargin', '3': 74, '4': 1, '5': 1, '10': 'initialMargin'},
  ],
  '4': [DerivativeMessage_OptionClass$json, DerivativeMessage_PublishReason$json],
};

@$core.Deprecated('Use derivativeMessageDescriptor instead')
const DerivativeMessage_OptionClass$json = {
  '1': 'OptionClass',
  '2': [
    {'1': 'P', '2': 0},
    {'1': 'C', '2': 1},
  ],
};

@$core.Deprecated('Use derivativeMessageDescriptor instead')
const DerivativeMessage_PublishReason$json = {
  '1': 'PublishReason',
  '2': [
    {'1': 'UPDATE', '2': 0},
    {'1': 'REFRESH', '2': 1},
  ],
};

/// Descriptor for `DerivativeMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List derivativeMessageDescriptor = $convert.base64Decode(
    'ChFEZXJpdmF0aXZlTWVzc2FnZRIaCghzeW1ib2xJZBgBIAIoBVIIc3ltYm9sSWQSHgoKc3ltYm'
    '9sQ29kZRgCIAEoCVIKc3ltYm9sQ29kZRIeCgpzeW1ib2xEZXNjGAMgASgJUgpzeW1ib2xEZXNj'
    'Eh4KCnVwZGF0ZURhdGUYBCABKAlSCnVwZGF0ZURhdGUSEAoDYmlkGAUgASgBUgNiaWQSEAoDYX'
    'NrGAYgASgBUgNhc2sSEAoDbG93GAcgASgBUgNsb3cSEgoEaGlnaBgIIAEoAVIEaGlnaBISCgRs'
    'YXN0GAkgASgBUgRsYXN0EhoKCGRheUNsb3NlGAogASgBUghkYXlDbG9zZRIkCg1mcmFjdGlvbk'
    'NvdW50GAsgASgFUg1mcmFjdGlvbkNvdW50EiAKC3N0cmlrZVByaWNlGAwgASgBUgtzdHJpa2VQ'
    'cmljZRIaCghtYXR1cml0eRgNIAEoCVIIbWF0dXJpdHkSHgoKdW5kZXJseWluZxgOIAEoCVIKdW'
    '5kZXJseWluZxJJCgtvcHRpb25DbGFzcxgPIAEoDjInLm1lc3NhZ2VzLkRlcml2YXRpdmVNZXNz'
    'YWdlLk9wdGlvbkNsYXNzUgtvcHRpb25DbGFzcxIaCghkYWlseUxvdxgQIAEoAVIIZGFpbHlMb3'
    'cSHAoJZGFpbHlIaWdoGBEgASgBUglkYWlseUhpZ2gSGgoIcXVhbnRpdHkYEiABKAFSCHF1YW50'
    'aXR5EhYKBnZvbHVtZRgTIAEoAVIGdm9sdW1lEh4KCmRpZmZlcmVuY2UYFCABKAFSCmRpZmZlcm'
    'VuY2USLAoRZGlmZmVyZW5jZVBlcmNlbnQYFSABKAFSEWRpZmZlcmVuY2VQZXJjZW50EigKD3Nl'
    'dmVuRGF5c0RpZlBlchgWIAEoAVIPc2V2ZW5EYXlzRGlmUGVyEioKEHRoaXJ0eURheXNEaWZQZX'
    'IYFyABKAFSEHRoaXJ0eURheXNEaWZQZXISLgoSZmlmdHl0d29XZWVrRGlmUGVyGBggASgBUhJm'
    'aWZ0eXR3b1dlZWtEaWZQZXISHAoJbW9udGhIaWdoGBkgASgBUgltb250aEhpZ2gSGgoIbW9udG'
    'hMb3cYGiABKAFSCG1vbnRoTG93EhoKCHllYXJIaWdoGBsgASgBUgh5ZWFySGlnaBIYCgd5ZWFy'
    'TG93GBwgASgBUgd5ZWFyTG93EhwKCXByaWNlTWVhbhgdIAEoAVIJcHJpY2VNZWFuEhgKB2xpbW'
    'l0VXAYHiABKAFSB2xpbWl0VXASHAoJbGltaXREb3duGB8gASgBUglsaW1pdERvd24SHgoKc2V0'
    'dGxlbWVudBggIAEoAVIKc2V0dGxlbWVudBIqChBzZXR0bGVtZW50UGVyRGlmGCEgASgBUhBzZX'
    'R0bGVtZW50UGVyRGlmEiIKDG9wZW5JbnRlcmVzdBgiIAEoA1IMb3BlbkludGVyZXN0EiYKDnRo'
    'ZW9yaWNhbFByaWNlGCMgASgBUg50aGVvcmljYWxQcmljZRIqChB0aGVvcmljZWxQRGlmUGVyGC'
    'QgASgBUhB0aGVvcmljZWxQRGlmUGVyEiAKC2RhaWx5Vm9sdW1lGCUgASgBUgtkYWlseVZvbHVt'
    'ZRIcCglwcmljZVN0ZXAYJiABKAFSCXByaWNlU3RlcBIiCgxvcGVuRm9yVHJhZGUYJyABKAhSDG'
    '9wZW5Gb3JUcmFkZRIcCgl0cmFkZURhdGUYKCABKAlSCXRyYWRlRGF0ZRISCgRvcGVuGCkgASgB'
    'UgRvcGVuEiQKDWRhaWx5UXVhbnRpdHkYKiABKAFSDWRhaWx5UXVhbnRpdHkSHgoKYWN0aW9uVH'
    'lwZRgrIAEoCVIKYWN0aW9uVHlwZRIeCghicnV0U3dhcBgsIAEoBUICGAFSCGJydXRTd2FwEigK'
    'D3RvdGFsVHJhZGVDb3VudBgtIAEoAVIPdG90YWxUcmFkZUNvdW50EiIKDGxhc3RRdWFudGl0eR'
    'guIAEoAVIMbGFzdFF1YW50aXR5Ei4KEm9wZW5JbnRlcmVzdENoYW5nZRgvIAEoAVISb3Blbklu'
    'dGVyZXN0Q2hhbmdlEhgKB3dlZWtMb3cYMCABKAFSB3dlZWtMb3cSGgoId2Vla0hpZ2gYMSABKA'
    'FSCHdlZWtIaWdoEhwKCXdlZWtDbG9zZRgyIAEoAVIJd2Vla0Nsb3NlEh4KCm1vbnRoQ2xvc2UY'
    'MyABKAFSCm1vbnRoQ2xvc2USHAoJeWVhckNsb3NlGDQgASgBUgl5ZWFyQ2xvc2USJAoNcHJlU2'
    'V0dGxlbWVudBg1IAEoAVINcHJlU2V0dGxlbWVudBIYCgdhc2tTaXplGDYgASgDUgdhc2tTaXpl'
    'EhgKB2JpZFNpemUYNyABKANSB2JpZFNpemUSEgoEcmF0ZRg4IAEoAVIEcmF0ZRIgCgttYXJrZX'
    'RNYWtlchg5IAEoCVILbWFya2V0TWFrZXISJgoObWFya2V0TWFrZXJBc2sYOiABKAFSDm1hcmtl'
    'dE1ha2VyQXNrEiYKDm1hcmtldE1ha2VyQmlkGDsgASgBUg5tYXJrZXRNYWtlckJpZBIkCg1wcm'
    'V2WWVhckNsb3NlGDwgASgBUg1wcmV2WWVhckNsb3NlEhwKCXJpc2tMZXZlbBg9IAEoCVIJcmlz'
    'a0xldmVsEjAKE21hcmtldE1ha2VyQXNrQ2xvc2UYPiABKAFSE21hcmtldE1ha2VyQXNrQ2xvc2'
    'USMAoTbWFya2V0TWFrZXJCaWRDbG9zZRg/IAEoAVITbWFya2V0TWFrZXJCaWRDbG9zZRIkCg13'
    'ZWVrUHJpY2VNZWFuGEAgASgBUg13ZWVrUHJpY2VNZWFuEiYKDm1vbnRoUHJpY2VNZWFuGEEgAS'
    'gBUg5tb250aFByaWNlTWVhbhIkCg15ZWFyUHJpY2VNZWFuGEIgASgBUg15ZWFyUHJpY2VNZWFu'
    'EjMKE2luY3JlbWVudGFsUXVhbnRpdHkYQyABKAE6ATBSE2luY3JlbWVudGFsUXVhbnRpdHkSVw'
    'oNcHVibGlzaFJlYXNvbhhEIAEoDjIpLm1lc3NhZ2VzLkRlcml2YXRpdmVNZXNzYWdlLlB1Ymxp'
    'c2hSZWFzb246BlVQREFURVINcHVibGlzaFJlYXNvbhIgCgtzdG9ja1N0YXR1cxhFIAEoBVILc3'
    'RvY2tTdGF0dXMSGAoHZXFQcmljZRhGIAEoAVIHZXFQcmljZRIeCgplcVF1YW50aXR5GEcgASgB'
    'UgplcVF1YW50aXR5EjYKFmVxUmVtYWluaW5nQmlkUXVhbnRpdHkYSCABKAFSFmVxUmVtYWluaW'
    '5nQmlkUXVhbnRpdHkSNgoWZXFSZW1haW5pbmdBc2tRdWFudGl0eRhJIAEoAVIWZXFSZW1haW5p'
    'bmdBc2tRdWFudGl0eRIkCg1pbml0aWFsTWFyZ2luGEogASgBUg1pbml0aWFsTWFyZ2luIhsKC0'
    '9wdGlvbkNsYXNzEgUKAVAQABIFCgFDEAEiKAoNUHVibGlzaFJlYXNvbhIKCgZVUERBVEUQABIL'
    'CgdSRUZSRVNIEAE=');

