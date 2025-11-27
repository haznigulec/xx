class GetFinancialFounderListModel {
  int? id;
  String? code;
  String? name;
  int? totalFunds;
  double? totalPeopleInFunds;
  double? totalPortfolioSize;

  GetFinancialFounderListModel({
    this.id,
    this.code,
    this.name,
    this.totalFunds,
    this.totalPeopleInFunds,
    this.totalPortfolioSize,
  });

  factory GetFinancialFounderListModel.fromJson(Map<String, dynamic> json) => GetFinancialFounderListModel(
        id: json['id'] ?? 0,
        code: json['code'] ?? '',
        name: json['name'] ?? '',
        totalFunds: json['totalFunds'] ?? 0,
        totalPeopleInFunds: json['totalPeopleInFunds'] ?? 0.0,
        totalPortfolioSize: json['totalPortfolioSize'] ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'name': name,
        'totalFunds': totalFunds,
        'totalPeopleInFunds': totalPeopleInFunds,
        'totalPortfolioSize': totalPortfolioSize,
      };
  GetFinancialFounderListModel copyWith({
    int? id,
    String? code,
    String? name,
    int? totalFunds,
    double? totalPeopleInFunds,
    double? totalPortfolioSize,
  }) {
    return GetFinancialFounderListModel(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      totalFunds: totalFunds ?? this.totalFunds,
      totalPeopleInFunds: totalPeopleInFunds ?? this.totalPeopleInFunds,
      totalPortfolioSize: totalPortfolioSize ?? this.totalPortfolioSize,
    );
  }
}
