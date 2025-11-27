class FundVolumeHistoryModel {
  String fundCode;
  double numberOfShares;
  double numberOfPeople;
  double portfolioSize;
  DateTime date;

  FundVolumeHistoryModel({
    required this.fundCode,
    required this.numberOfShares,
    required this.numberOfPeople,
    required this.portfolioSize,
    required this.date,
  });

  factory FundVolumeHistoryModel.fromJson(Map<String, dynamic> json) => FundVolumeHistoryModel(
        fundCode: json['fundCode'] ?? '',
        numberOfShares: json['numberOfShares'] ?? 0.0,
        numberOfPeople: json['numberOfPeople'] ?? 0.0,
        portfolioSize: json['portfolioSize']?.toDouble() ?? 0.0,
        date: DateTime.parse(json['date']),
      );

  Map<String, dynamic> toJson() => {
        'fundCode': fundCode,
        'numberOfShares': numberOfShares,
        'numberOfPeople': numberOfPeople,
        'portfolioSize': portfolioSize,
        'date': date.toIso8601String(),
      };
}
