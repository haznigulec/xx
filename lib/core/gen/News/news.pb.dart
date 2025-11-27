// This is a generated file - do not edit.
//
// Generated from News/news.proto.

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

class RelatedNews extends $pb.GeneratedMessage {
  factory RelatedNews({
    $core.String? id,
    $core.String? headline,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (headline != null) result.headline = headline;
    return result;
  }

  RelatedNews._();

  factory RelatedNews.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory RelatedNews.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RelatedNews', package: const $pb.PackageName(_omitMessageNames ? '' : 'messages'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'id')
    ..aQS(2, _omitFieldNames ? '' : 'headline')
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RelatedNews clone() => RelatedNews()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RelatedNews copyWith(void Function(RelatedNews) updates) => super.copyWith((message) => updates(message as RelatedNews)) as RelatedNews;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RelatedNews create() => RelatedNews._();
  @$core.override
  RelatedNews createEmptyInstance() => create();
  static $pb.PbList<RelatedNews> createRepeated() => $pb.PbList<RelatedNews>();
  @$core.pragma('dart2js:noInline')
  static RelatedNews getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RelatedNews>(create);
  static RelatedNews? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get headline => $_getSZ(1);
  @$pb.TagNumber(2)
  set headline($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHeadline() => $_has(1);
  @$pb.TagNumber(2)
  void clearHeadline() => $_clearField(2);
}

class NewsMessage extends $pb.GeneratedMessage {
  factory NewsMessage({
    $core.String? id,
    $core.bool? isFlash,
    $core.bool? deleted,
    $fixnum.Int64? timestamp,
    $core.String? headline,
    $core.String? content,
    $core.Iterable<$core.String>? source,
    $core.Iterable<$core.String>? category,
    $core.Iterable<$core.String>? symbol,
    $core.String? language,
    $core.Iterable<$core.String>? attachment,
    $core.String? dailyNewsNo,
    $core.String? chainId,
    $core.Iterable<RelatedNews>? relatedNews,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (isFlash != null) result.isFlash = isFlash;
    if (deleted != null) result.deleted = deleted;
    if (timestamp != null) result.timestamp = timestamp;
    if (headline != null) result.headline = headline;
    if (content != null) result.content = content;
    if (source != null) result.source.addAll(source);
    if (category != null) result.category.addAll(category);
    if (symbol != null) result.symbol.addAll(symbol);
    if (language != null) result.language = language;
    if (attachment != null) result.attachment.addAll(attachment);
    if (dailyNewsNo != null) result.dailyNewsNo = dailyNewsNo;
    if (chainId != null) result.chainId = chainId;
    if (relatedNews != null) result.relatedNews.addAll(relatedNews);
    return result;
  }

  NewsMessage._();

  factory NewsMessage.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory NewsMessage.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'NewsMessage', package: const $pb.PackageName(_omitMessageNames ? '' : 'messages'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'id')
    ..aOB(2, _omitFieldNames ? '' : 'isFlash', protoName: 'isFlash')
    ..aOB(3, _omitFieldNames ? '' : 'deleted')
    ..aInt64(4, _omitFieldNames ? '' : 'timestamp')
    ..aOS(5, _omitFieldNames ? '' : 'headline')
    ..aOS(6, _omitFieldNames ? '' : 'content')
    ..pPS(7, _omitFieldNames ? '' : 'source')
    ..pPS(8, _omitFieldNames ? '' : 'category')
    ..pPS(9, _omitFieldNames ? '' : 'symbol')
    ..a<$core.String>(10, _omitFieldNames ? '' : 'language', $pb.PbFieldType.OS, defaultOrMaker: 'TR')
    ..pPS(11, _omitFieldNames ? '' : 'attachment')
    ..aOS(12, _omitFieldNames ? '' : 'dailyNewsNo', protoName: 'dailyNewsNo')
    ..aOS(13, _omitFieldNames ? '' : 'chainId', protoName: 'chainId')
    ..pc<RelatedNews>(14, _omitFieldNames ? '' : 'relatedNews', $pb.PbFieldType.PM, protoName: 'relatedNews', subBuilder: RelatedNews.create)
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NewsMessage clone() => NewsMessage()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NewsMessage copyWith(void Function(NewsMessage) updates) => super.copyWith((message) => updates(message as NewsMessage)) as NewsMessage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NewsMessage create() => NewsMessage._();
  @$core.override
  NewsMessage createEmptyInstance() => create();
  static $pb.PbList<NewsMessage> createRepeated() => $pb.PbList<NewsMessage>();
  @$core.pragma('dart2js:noInline')
  static NewsMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<NewsMessage>(create);
  static NewsMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get isFlash => $_getBF(1);
  @$pb.TagNumber(2)
  set isFlash($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIsFlash() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsFlash() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get deleted => $_getBF(2);
  @$pb.TagNumber(3)
  set deleted($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDeleted() => $_has(2);
  @$pb.TagNumber(3)
  void clearDeleted() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get timestamp => $_getI64(3);
  @$pb.TagNumber(4)
  set timestamp($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTimestamp() => $_has(3);
  @$pb.TagNumber(4)
  void clearTimestamp() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get headline => $_getSZ(4);
  @$pb.TagNumber(5)
  set headline($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasHeadline() => $_has(4);
  @$pb.TagNumber(5)
  void clearHeadline() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get content => $_getSZ(5);
  @$pb.TagNumber(6)
  set content($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasContent() => $_has(5);
  @$pb.TagNumber(6)
  void clearContent() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbList<$core.String> get source => $_getList(6);

  @$pb.TagNumber(8)
  $pb.PbList<$core.String> get category => $_getList(7);

  @$pb.TagNumber(9)
  $pb.PbList<$core.String> get symbol => $_getList(8);

  @$pb.TagNumber(10)
  $core.String get language => $_getS(9, 'TR');
  @$pb.TagNumber(10)
  set language($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasLanguage() => $_has(9);
  @$pb.TagNumber(10)
  void clearLanguage() => $_clearField(10);

  @$pb.TagNumber(11)
  $pb.PbList<$core.String> get attachment => $_getList(10);

  @$pb.TagNumber(12)
  $core.String get dailyNewsNo => $_getSZ(11);
  @$pb.TagNumber(12)
  set dailyNewsNo($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasDailyNewsNo() => $_has(11);
  @$pb.TagNumber(12)
  void clearDailyNewsNo() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get chainId => $_getSZ(12);
  @$pb.TagNumber(13)
  set chainId($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasChainId() => $_has(12);
  @$pb.TagNumber(13)
  void clearChainId() => $_clearField(13);

  @$pb.TagNumber(14)
  $pb.PbList<RelatedNews> get relatedNews => $_getList(13);
}


const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
