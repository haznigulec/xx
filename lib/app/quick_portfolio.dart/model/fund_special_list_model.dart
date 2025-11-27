class FundSpecialListModel {
  String code;
  String title;
  double performance1M;
  double price;
  String institutionCode;

  FundSpecialListModel({
    required this.code,
    required this.title,
    required this.performance1M,
    required this.price,
    required this.institutionCode,
  });

  factory FundSpecialListModel.fromJson(Map<String, dynamic> json) => FundSpecialListModel(
        code: json['code'] ?? '',
        title: json['title'] ?? '',
        performance1M: json['performance1M'] ?? 0,
        price: json['price'] ?? 0,
        institutionCode: json['institutionCode'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'code': code,
        'title': title,
        'performance1M': performance1M,
        'price': price,
        'institutionCode': institutionCode,
      };
}
