class ModelPortfolioDetailInfoModel {
  int id;
  String title;
  String detail;
  String targetGroup;
  String iconFile;
  DateTime startDate;
  DateTime endDate;
  bool isActive;
  bool isModelPortfolio;
  int status;

  ModelPortfolioDetailInfoModel({
    required this.id,
    required this.title,
    required this.detail,
    required this.targetGroup,
    required this.iconFile,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    required this.isModelPortfolio,
    required this.status,
  });

  factory ModelPortfolioDetailInfoModel.fromJson(Map<String, dynamic> json) => ModelPortfolioDetailInfoModel(
        id: json['id'],
        title: json['title'],
        detail: json['detail'],
        targetGroup: json['targetGroup'],
        iconFile: json['iconFile'],
        startDate: DateTime.parse(json['startDate']),
        endDate: DateTime.parse(json['endDate']),
        isActive: json['isActive'],
        isModelPortfolio: json['isModelPortfolio'],
        status: json['status'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'detail': detail,
        'targetGroup': targetGroup,
        'iconFile': iconFile,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'isActive': isActive,
        'isModelPortfolio': isModelPortfolio,
        'status': status,
      };
}
