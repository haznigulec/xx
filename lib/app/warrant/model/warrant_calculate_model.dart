class WarrantCalculateModel {
  String? symbol;
  String? referenceDate;
  String? maturity;
  double? underlyingValue;
  double? underlyingStep;
  double? volatility;
  double? volatilityStep;
  double? interestRate;
  double? interestRateStep;

  WarrantCalculateModel({
    required this.symbol,
    required this.referenceDate,
    required this.maturity,
    required this.underlyingValue,
    required this.underlyingStep,
    required this.volatility,
    required this.volatilityStep,
    required this.interestRate,
    required this.interestRateStep,
  });

  factory WarrantCalculateModel.fromJson(Map<String, dynamic> json) => WarrantCalculateModel(
        symbol: json['symbol'],
        referenceDate: json['referenceDate'],
        maturity: json['maturity'],
        underlyingValue: json['underlyingValue']?.toDouble(),
        underlyingStep: json['underlyingStep']?.toDouble(),
        volatility: json['volatility']?.toDouble(),
        volatilityStep: json['volatilityStep']?.toDouble(),
        interestRate: json['interestRate']?.toDouble(),
        interestRateStep: json['interestRateStep']?.toDouble(),
      );
}
