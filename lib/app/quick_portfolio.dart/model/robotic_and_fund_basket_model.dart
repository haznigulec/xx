class RoboticAndFundBasketModel {
  final int? id;
  final String key;
  final String header;
  final String description;
  final String suitable;
  final String iconFile;
  final String whoIsItSuitableFor;
  final String? funds;
  RoboticAndFundBasketModel({
    this.id,
    required this.key,
    required this.header,
    required this.description,
    required this.suitable,
    required this.iconFile,
    required this.whoIsItSuitableFor,
    this.funds,
  });

  factory RoboticAndFundBasketModel.fromJson(Map<String, dynamic> json) {
    return RoboticAndFundBasketModel(
      id: json['portfolio_id'] ?? 0,
      key: json['key'],
      header: json['header'],
      description: json['description'],
      suitable: json['suitable'] ?? '',
      iconFile: json['iconFile'] ?? '',
      whoIsItSuitableFor: json['whoIsItSuitableFor'] ?? '',
      funds: json['funds'] ?? json['symbols'] ?? '',
    );
  }
}
