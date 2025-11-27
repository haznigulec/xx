class FundComparionModel {
  String? code;
  String? title;
  double? value;
  String? institutionCode;

  FundComparionModel({
    required this.code,
    required this.title,
    required this.value,
    required this.institutionCode,
  });

  factory FundComparionModel.fromProfit(Map<String, dynamic> json) {
    return FundComparionModel(
      code: json['code'],
      title: json['title'],
      value: double.parse((json['profit'] ?? 0).toString()),
      institutionCode: json['institutionCode'],
    );
  }

  factory FundComparionModel.fromManagement(Map<String, dynamic> json) {
    return FundComparionModel(
      code: json['code'],
      title: json['title'],
      value: double.parse((json['managementFee'] ?? 0).toString()),
      institutionCode: json['institutionCode'],
    );
  }

  factory FundComparionModel.fromPortfolio(Map<String, dynamic> json) {
    return FundComparionModel(
      code: json['code'],
      title: json['title'],
      value: double.parse((json['portfolioSize'] ?? 0).toString()),
      institutionCode: json['institutionCode'],
    );
  }
}
