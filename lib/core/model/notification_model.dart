import 'package:html/parser.dart';

class NotificationCategoryModel {
  final bool isSelected;
  final String key;
  final String title;
  final int count;
  final int categoryId;

  NotificationCategoryModel({
    required this.isSelected,
    required this.key,
    required this.title,
    required this.count,
    required this.categoryId,
  });

  factory NotificationCategoryModel.fromJson(Map<String, dynamic> json) {
    return NotificationCategoryModel(
      isSelected: json['isSelected'],
      key: json['key'],
      title: json['title'],
      count: json['count'],
      categoryId: json['categoryId'],
    );
  }
}

class NotificationModel {
  final List<int> notificationId;
  final String createdDay;
  final String title;
  bool isRead;
  final String createdTime;
  final String? subTitle;
  final String? notificationActionType;
  final String? notificationActionParams;
  final String? fileUrl;
  final String? externalLink;
  final List<dynamic> tags;

  NotificationModel({
    required this.notificationId,
    required this.createdDay,
    required this.title,
    required this.isRead,
    required this.createdTime,
    required this.subTitle,
    required this.notificationActionType,
    required this.notificationActionParams,
    this.fileUrl,
    this.externalLink,
    required this.tags,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      notificationId: json['notificationId'].cast<int>(),
      createdDay: json['createdDay'],
      title: parse(json['title']).body!.text,
      isRead: json['isRead'],
      createdTime: json['createdTime'],
      subTitle: parse(json['subTitle']).body!.text,
      notificationActionType: json['notificationActionType'],
      notificationActionParams: json['notificationActionParams'],
      fileUrl: json['fileUrl'],
      externalLink: json['externalLink'],
      tags: json['tags'] ?? [],
    );
  }
}

class NotificationDetail {
  List<String>? symbolTags;
  String? content;
  String? contentId;
  String? externalLink;
  String? fileUrl;

  NotificationDetail({
    this.symbolTags,
    this.content,
    this.contentId,
    this.externalLink,
    this.fileUrl,
  });

  NotificationDetail copyWith({
    List<String>? symbolTags,
    String? content,
    String? contentId,
    String? externalLink,
    String? fileUrl,
  }) {
    return NotificationDetail(
      symbolTags: symbolTags ?? this.symbolTags,
      content: content ?? this.content,
      contentId: contentId ?? this.contentId,
      externalLink: externalLink ?? this.externalLink,
      fileUrl: fileUrl ?? this.fileUrl,
    );
  }

  NotificationDetail.fromJson(Map<String, dynamic> json) {
    symbolTags = json['symbolTags']?.cast<String>();
    content = json['content'] ?? '';
    contentId = json['contentId']?.toString();
    externalLink = json['externalLink'] ?? '';
    fileUrl = json['fileUrl'] ?? '';
  }
}
