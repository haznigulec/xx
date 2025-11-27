class GetTicketMessagesModel {
  DateTime? created;
  String? content;
  int? operatorId;
  List? attachments;

  GetTicketMessagesModel({
    this.created,
    this.content,
    this.operatorId,
    this.attachments,
  });

  factory GetTicketMessagesModel.fromJson(Map<String, dynamic> json) => GetTicketMessagesModel(
        created: DateTime.parse(json['created']),
        content: json['content'],
        operatorId: json['operatorId'],
        attachments: json['attachments'],
      );
}
