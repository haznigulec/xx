// This is a generated file - do not edit.
//
// Generated from Symbol/Symbol.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use symbolMessageDescriptor instead')
const SymbolMessage$json = {
  '1': 'SymbolMessage',
  '2': [
    {'1': 'symbolId', '3': 1, '4': 2, '5': 17, '10': 'symbolId'},
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
    {'1': 'dailyLow', '3': 12, '4': 1, '5': 1, '10': 'dailyLow'},
    {'1': 'dailyHigh', '3': 13, '4': 1, '5': 1, '10': 'dailyHigh'},
    {'1': 'quantity', '3': 14, '4': 1, '5': 1, '10': 'quantity'},
    {'1': 'volume', '3': 15, '4': 1, '5': 1, '10': 'volume'},
    {'1': 'difference', '3': 16, '4': 1, '5': 1, '10': 'difference'},
    {'1': 'differencePercent', '3': 17, '4': 1, '5': 1, '10': 'differencePercent'},
    {'1': 'days7DifPer', '3': 18, '4': 1, '5': 1, '10': 'days7DifPer'},
    {'1': 'days30DifPer', '3': 19, '4': 1, '5': 1, '10': 'days30DifPer'},
    {'1': 'week52DifPer', '3': 20, '4': 1, '5': 1, '10': 'week52DifPer'},
    {'1': 'monthHigh', '3': 21, '4': 1, '5': 1, '10': 'monthHigh'},
    {'1': 'monthLow', '3': 22, '4': 1, '5': 1, '10': 'monthLow'},
    {'1': 'yearHigh', '3': 23, '4': 1, '5': 1, '10': 'yearHigh'},
    {'1': 'yearLow', '3': 24, '4': 1, '5': 1, '10': 'yearLow'},
    {'1': 'priceMean', '3': 25, '4': 1, '5': 1, '10': 'priceMean'},
    {'1': 'limitUp', '3': 26, '4': 1, '5': 1, '10': 'limitUp'},
    {'1': 'limitDown', '3': 27, '4': 1, '5': 1, '10': 'limitDown'},
    {'1': 'netProceeds', '3': 28, '4': 1, '5': 1, '10': 'netProceeds'},
    {'1': 'priceProceeds', '3': 29, '4': 1, '5': 1, '10': 'priceProceeds'},
    {'1': 'marketValue', '3': 30, '4': 1, '5': 1, '10': 'marketValue'},
    {'1': 'marketValueUsd', '3': 31, '4': 1, '5': 1, '10': 'marketValueUsd'},
    {'1': 'marValBookVal', '3': 32, '4': 1, '5': 1, '10': 'marValBookVal'},
    {'1': 'equity', '3': 33, '4': 1, '5': 1, '10': 'equity'},
    {'1': 'capital', '3': 34, '4': 1, '5': 1, '10': 'capital'},
    {'1': 'circulationShare', '3': 35, '4': 1, '5': 1, '10': 'circulationShare'},
    {'1': 'circulationSharePer', '3': 36, '4': 1, '5': 1, '10': 'circulationSharePer'},
    {'1': 'symbolGroup', '3': 37, '4': 1, '5': 9, '10': 'symbolGroup'},
    {'1': 'dailyVolume', '3': 38, '4': 1, '5': 1, '10': 'dailyVolume'},
    {'1': 'sessionIsOpen', '3': 39, '4': 1, '5': 8, '10': 'sessionIsOpen'},
    {
      '1': 'openForTrade',
      '3': 40,
      '4': 1,
      '5': 8,
      '8': {'3': true},
      '10': 'openForTrade',
    },
    {'1': 'priceStep', '3': 41, '4': 1, '5': 1, '10': 'priceStep'},
    {'1': 'basePrice', '3': 42, '4': 1, '5': 1, '10': 'basePrice'},
    {'1': 'symbolType', '3': 43, '4': 1, '5': 9, '10': 'symbolType'},
    {'1': 'tradeFraction', '3': 44, '4': 1, '5': 5, '10': 'tradeFraction'},
    {'1': 'stockSymbolCode', '3': 45, '4': 1, '5': 9, '10': 'stockSymbolCode'},
    {'1': 'tradeDate', '3': 46, '4': 1, '5': 9, '10': 'tradeDate'},
    {'1': 'open', '3': 47, '4': 1, '5': 1, '10': 'open'},
    {'1': 'dailyQuantity', '3': 48, '4': 1, '5': 1, '10': 'dailyQuantity'},
    {'1': 'actionType', '3': 49, '4': 1, '5': 9, '10': 'actionType'},
    {
      '1': 'brutSwap',
      '3': 50,
      '4': 1,
      '5': 5,
      '8': {'3': true},
      '10': 'brutSwap',
    },
    {'1': 'totalTradeCount', '3': 51, '4': 1, '5': 1, '10': 'totalTradeCount'},
    {'1': 'lastQuantity', '3': 52, '4': 1, '5': 1, '10': 'lastQuantity'},
    {'1': 'weekLow', '3': 53, '4': 1, '5': 1, '10': 'weekLow'},
    {'1': 'weekHigh', '3': 54, '4': 1, '5': 1, '10': 'weekHigh'},
    {'1': 'weekClose', '3': 55, '4': 1, '5': 1, '10': 'weekClose'},
    {'1': 'monthClose', '3': 56, '4': 1, '5': 1, '10': 'monthClose'},
    {'1': 'yearClose', '3': 57, '4': 1, '5': 1, '10': 'yearClose'},
    {'1': 'period', '3': 58, '4': 1, '5': 9, '10': 'period'},
    {'1': 'shiftedNetProceed', '3': 59, '4': 1, '5': 1, '10': 'shiftedNetProceed'},
    {'1': 'askSize', '3': 60, '4': 1, '5': 3, '10': 'askSize'},
    {'1': 'bidSize', '3': 61, '4': 1, '5': 3, '10': 'bidSize'},
    {'1': 'eqPrice', '3': 62, '4': 1, '5': 1, '10': 'eqPrice'},
    {'1': 'eqQuantity', '3': 63, '4': 1, '5': 1, '10': 'eqQuantity'},
    {'1': 'eqRemainingBidQuantity', '3': 64, '4': 1, '5': 1, '10': 'eqRemainingBidQuantity'},
    {'1': 'eqRemainingAskQuantity', '3': 65, '4': 1, '5': 1, '10': 'eqRemainingAskQuantity'},
    {'1': 'prevYearClose', '3': 66, '4': 1, '5': 1, '10': 'prevYearClose'},
    {'1': 'direction', '3': 67, '4': 1, '5': 5, '10': 'direction'},
    {'1': 'weekPriceMean', '3': 68, '4': 1, '5': 1, '10': 'weekPriceMean'},
    {'1': 'monthPriceMean', '3': 69, '4': 1, '5': 1, '10': 'monthPriceMean'},
    {'1': 'yearPriceMean', '3': 70, '4': 1, '5': 1, '10': 'yearPriceMean'},
    {'1': 'beta100', '3': 71, '4': 1, '5': 1, '10': 'beta100'},
    {'1': 'cashNetDividend', '3': 72, '4': 1, '5': 1, '10': 'cashNetDividend'},
    {'1': 'dividendYield', '3': 73, '4': 1, '5': 1, '10': 'dividendYield'},
    {'1': 'stockStatus', '3': 74, '4': 1, '5': 5, '10': 'stockStatus'},
    {'1': 'incrementalQuantity', '3': 75, '4': 1, '5': 1, '7': '0', '10': 'incrementalQuantity'},
    {'1': 'publishReason', '3': 76, '4': 1, '5': 14, '6': '.messages.SymbolMessage.PublishReason', '7': 'UPDATE', '10': 'publishReason'},
    {'1': 'xu030Weight', '3': 77, '4': 1, '5': 1, '10': 'xu030Weight'},
    {'1': 'xu050Weight', '3': 78, '4': 1, '5': 1, '10': 'xu050Weight'},
    {'1': 'xu100Weight', '3': 79, '4': 1, '5': 1, '10': 'xu100Weight'},
    {'1': 'netDebt', '3': 80, '4': 1, '5': 1, '10': 'netDebt'},
    {'1': 'shiftedEbitda', '3': 81, '4': 1, '5': 1, '10': 'shiftedEbitda'},
  ],
  '4': [SymbolMessage_PublishReason$json],
};

@$core.Deprecated('Use symbolMessageDescriptor instead')
const SymbolMessage_PublishReason$json = {
  '1': 'PublishReason',
  '2': [
    {'1': 'UPDATE', '2': 0},
    {'1': 'REFRESH', '2': 1},
  ],
};

/// Descriptor for `SymbolMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List symbolMessageDescriptor = $convert.base64Decode(
    'Cg1TeW1ib2xNZXNzYWdlEhoKCHN5bWJvbElkGAEgAigRUghzeW1ib2xJZBIeCgpzeW1ib2xDb2'
    'RlGAIgASgJUgpzeW1ib2xDb2RlEh4KCnN5bWJvbERlc2MYAyABKAlSCnN5bWJvbERlc2MSHgoK'
    'dXBkYXRlRGF0ZRgEIAEoCVIKdXBkYXRlRGF0ZRIQCgNiaWQYBSABKAFSA2JpZBIQCgNhc2sYBi'
    'ABKAFSA2FzaxIQCgNsb3cYByABKAFSA2xvdxISCgRoaWdoGAggASgBUgRoaWdoEhIKBGxhc3QY'
    'CSABKAFSBGxhc3QSGgoIZGF5Q2xvc2UYCiABKAFSCGRheUNsb3NlEiQKDWZyYWN0aW9uQ291bn'
    'QYCyABKAVSDWZyYWN0aW9uQ291bnQSGgoIZGFpbHlMb3cYDCABKAFSCGRhaWx5TG93EhwKCWRh'
    'aWx5SGlnaBgNIAEoAVIJZGFpbHlIaWdoEhoKCHF1YW50aXR5GA4gASgBUghxdWFudGl0eRIWCg'
    'Z2b2x1bWUYDyABKAFSBnZvbHVtZRIeCgpkaWZmZXJlbmNlGBAgASgBUgpkaWZmZXJlbmNlEiwK'
    'EWRpZmZlcmVuY2VQZXJjZW50GBEgASgBUhFkaWZmZXJlbmNlUGVyY2VudBIgCgtkYXlzN0RpZl'
    'BlchgSIAEoAVILZGF5czdEaWZQZXISIgoMZGF5czMwRGlmUGVyGBMgASgBUgxkYXlzMzBEaWZQ'
    'ZXISIgoMd2VlazUyRGlmUGVyGBQgASgBUgx3ZWVrNTJEaWZQZXISHAoJbW9udGhIaWdoGBUgAS'
    'gBUgltb250aEhpZ2gSGgoIbW9udGhMb3cYFiABKAFSCG1vbnRoTG93EhoKCHllYXJIaWdoGBcg'
    'ASgBUgh5ZWFySGlnaBIYCgd5ZWFyTG93GBggASgBUgd5ZWFyTG93EhwKCXByaWNlTWVhbhgZIA'
    'EoAVIJcHJpY2VNZWFuEhgKB2xpbWl0VXAYGiABKAFSB2xpbWl0VXASHAoJbGltaXREb3duGBsg'
    'ASgBUglsaW1pdERvd24SIAoLbmV0UHJvY2VlZHMYHCABKAFSC25ldFByb2NlZWRzEiQKDXByaW'
    'NlUHJvY2VlZHMYHSABKAFSDXByaWNlUHJvY2VlZHMSIAoLbWFya2V0VmFsdWUYHiABKAFSC21h'
    'cmtldFZhbHVlEiYKDm1hcmtldFZhbHVlVXNkGB8gASgBUg5tYXJrZXRWYWx1ZVVzZBIkCg1tYX'
    'JWYWxCb29rVmFsGCAgASgBUg1tYXJWYWxCb29rVmFsEhYKBmVxdWl0eRghIAEoAVIGZXF1aXR5'
    'EhgKB2NhcGl0YWwYIiABKAFSB2NhcGl0YWwSKgoQY2lyY3VsYXRpb25TaGFyZRgjIAEoAVIQY2'
    'lyY3VsYXRpb25TaGFyZRIwChNjaXJjdWxhdGlvblNoYXJlUGVyGCQgASgBUhNjaXJjdWxhdGlv'
    'blNoYXJlUGVyEiAKC3N5bWJvbEdyb3VwGCUgASgJUgtzeW1ib2xHcm91cBIgCgtkYWlseVZvbH'
    'VtZRgmIAEoAVILZGFpbHlWb2x1bWUSJAoNc2Vzc2lvbklzT3BlbhgnIAEoCFINc2Vzc2lvbklz'
    'T3BlbhImCgxvcGVuRm9yVHJhZGUYKCABKAhCAhgBUgxvcGVuRm9yVHJhZGUSHAoJcHJpY2VTdG'
    'VwGCkgASgBUglwcmljZVN0ZXASHAoJYmFzZVByaWNlGCogASgBUgliYXNlUHJpY2USHgoKc3lt'
    'Ym9sVHlwZRgrIAEoCVIKc3ltYm9sVHlwZRIkCg10cmFkZUZyYWN0aW9uGCwgASgFUg10cmFkZU'
    'ZyYWN0aW9uEigKD3N0b2NrU3ltYm9sQ29kZRgtIAEoCVIPc3RvY2tTeW1ib2xDb2RlEhwKCXRy'
    'YWRlRGF0ZRguIAEoCVIJdHJhZGVEYXRlEhIKBG9wZW4YLyABKAFSBG9wZW4SJAoNZGFpbHlRdW'
    'FudGl0eRgwIAEoAVINZGFpbHlRdWFudGl0eRIeCgphY3Rpb25UeXBlGDEgASgJUgphY3Rpb25U'
    'eXBlEh4KCGJydXRTd2FwGDIgASgFQgIYAVIIYnJ1dFN3YXASKAoPdG90YWxUcmFkZUNvdW50GD'
    'MgASgBUg90b3RhbFRyYWRlQ291bnQSIgoMbGFzdFF1YW50aXR5GDQgASgBUgxsYXN0UXVhbnRp'
    'dHkSGAoHd2Vla0xvdxg1IAEoAVIHd2Vla0xvdxIaCgh3ZWVrSGlnaBg2IAEoAVIId2Vla0hpZ2'
    'gSHAoJd2Vla0Nsb3NlGDcgASgBUgl3ZWVrQ2xvc2USHgoKbW9udGhDbG9zZRg4IAEoAVIKbW9u'
    'dGhDbG9zZRIcCgl5ZWFyQ2xvc2UYOSABKAFSCXllYXJDbG9zZRIWCgZwZXJpb2QYOiABKAlSBn'
    'BlcmlvZBIsChFzaGlmdGVkTmV0UHJvY2VlZBg7IAEoAVIRc2hpZnRlZE5ldFByb2NlZWQSGAoH'
    'YXNrU2l6ZRg8IAEoA1IHYXNrU2l6ZRIYCgdiaWRTaXplGD0gASgDUgdiaWRTaXplEhgKB2VxUH'
    'JpY2UYPiABKAFSB2VxUHJpY2USHgoKZXFRdWFudGl0eRg/IAEoAVIKZXFRdWFudGl0eRI2ChZl'
    'cVJlbWFpbmluZ0JpZFF1YW50aXR5GEAgASgBUhZlcVJlbWFpbmluZ0JpZFF1YW50aXR5EjYKFm'
    'VxUmVtYWluaW5nQXNrUXVhbnRpdHkYQSABKAFSFmVxUmVtYWluaW5nQXNrUXVhbnRpdHkSJAoN'
    'cHJldlllYXJDbG9zZRhCIAEoAVINcHJldlllYXJDbG9zZRIcCglkaXJlY3Rpb24YQyABKAVSCW'
    'RpcmVjdGlvbhIkCg13ZWVrUHJpY2VNZWFuGEQgASgBUg13ZWVrUHJpY2VNZWFuEiYKDm1vbnRo'
    'UHJpY2VNZWFuGEUgASgBUg5tb250aFByaWNlTWVhbhIkCg15ZWFyUHJpY2VNZWFuGEYgASgBUg'
    '15ZWFyUHJpY2VNZWFuEhgKB2JldGExMDAYRyABKAFSB2JldGExMDASKAoPY2FzaE5ldERpdmlk'
    'ZW5kGEggASgBUg9jYXNoTmV0RGl2aWRlbmQSJAoNZGl2aWRlbmRZaWVsZBhJIAEoAVINZGl2aW'
    'RlbmRZaWVsZBIgCgtzdG9ja1N0YXR1cxhKIAEoBVILc3RvY2tTdGF0dXMSMwoTaW5jcmVtZW50'
    'YWxRdWFudGl0eRhLIAEoAToBMFITaW5jcmVtZW50YWxRdWFudGl0eRJTCg1wdWJsaXNoUmVhc2'
    '9uGEwgASgOMiUubWVzc2FnZXMuU3ltYm9sTWVzc2FnZS5QdWJsaXNoUmVhc29uOgZVUERBVEVS'
    'DXB1Ymxpc2hSZWFzb24SIAoLeHUwMzBXZWlnaHQYTSABKAFSC3h1MDMwV2VpZ2h0EiAKC3h1MD'
    'UwV2VpZ2h0GE4gASgBUgt4dTA1MFdlaWdodBIgCgt4dTEwMFdlaWdodBhPIAEoAVILeHUxMDBX'
    'ZWlnaHQSGAoHbmV0RGVidBhQIAEoAVIHbmV0RGVidBIkCg1zaGlmdGVkRWJpdGRhGFEgASgBUg'
    '1zaGlmdGVkRWJpdGRhIigKDVB1Ymxpc2hSZWFzb24SCgoGVVBEQVRFEAASCwoHUkVGUkVTSBAB');

