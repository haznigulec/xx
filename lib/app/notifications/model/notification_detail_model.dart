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
    symbolTags = json['symbolTags'].cast<String>();
    content = json['content'];
    contentId = json['contentId'].toString();
    externalLink = json['externalLink'];
    fileUrl = json['fileUrl'];
  }
}
