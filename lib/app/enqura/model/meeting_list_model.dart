class MeetingListModel {
  final String identityNumber;
  final String phone;
  final DateTime meetingDateTime;
  final DateTime created;

  MeetingListModel({
    required this.identityNumber,
    required this.phone,
    required this.meetingDateTime,
    required this.created,
  });

  factory MeetingListModel.fromJson(Map<String, dynamic> json) {
    return MeetingListModel(
      identityNumber: json['identityNumber'] ?? '',
      phone: json['phone'] ?? '',
      meetingDateTime: DateTime.parse(json['meetingDateTime']),
      created: DateTime.parse(json['created']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'identityNumber': identityNumber,
      'phone': phone,
      'meetingDateTime': meetingDateTime.toIso8601String(),
      'created': created.toIso8601String(),
    };
  }
}
