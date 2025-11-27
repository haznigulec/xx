class AgreementsModel {
  final String? periodId;
  final String? periodStartDate;
  final String? periodEndDate;
  final String? noticeStartDate;
  final String? noticeEndDate;

  AgreementsModel({
    required this.periodId,
    required this.periodStartDate,
    required this.periodEndDate,
    required this.noticeStartDate,
    required this.noticeEndDate,
  });

  factory AgreementsModel.fromJson(Map<String, dynamic> json) {
    return AgreementsModel(
      periodId: json['periodId'],
      periodStartDate: json['periodStartDate'],
      periodEndDate: json['periodEndDate'],
      noticeStartDate: json['noticeStartDate'],
      noticeEndDate: json['noticeEndDate'],
    );
  }
}
