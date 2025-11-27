class FundApplicationCategoryListModel {
  int code;
  String name;
  int count;

  FundApplicationCategoryListModel({
    required this.code,
    required this.name,
    this.count = 0,
  });

  factory FundApplicationCategoryListModel.fromJson(Map<String, dynamic> json) => FundApplicationCategoryListModel(
        code: json['applicationCategoryId'] ?? 0,
        name: json['applicaitonCategoryName'] ?? '',
        count: json['count'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'code': code,
        'count': count,
      };
}
