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

class WarrantCalculateDetailsModel {
  double? price;
  dynamic instrinsicValue;
  double? premium;
  double? premiumPa;
  double? delta;
  double? gamma;
  double? theta;
  double? vega;
  double? omega;
  double? leverage;
  double? breakEvenPrice;
  double? sensitivity;
  String? riskLevel;
  List<Graph>? graph;

  WarrantCalculateDetailsModel({
    this.price,
    this.instrinsicValue,
    this.premium,
    this.premiumPa,
    this.delta,
    this.gamma,
    this.theta,
    this.vega,
    this.omega,
    this.leverage,
    this.breakEvenPrice,
    this.sensitivity,
    this.riskLevel,
    this.graph,
  });

  factory WarrantCalculateDetailsModel.fromJson(Map<String, dynamic> json) => WarrantCalculateDetailsModel(
        price: json['price']?.toDouble() ?? 0.0,
        instrinsicValue: json['instrinsicValue'] ?? 0,
        premium: json['premium']?.toDouble() ?? 0.0,
        premiumPa: json['premiumPa']?.toDouble() ?? 0.0,
        delta: json['delta']?.toDouble() ?? 0.0,
        gamma: json['gamma']?.toDouble() ?? 0.0,
        theta: json['theta']?.toDouble() ?? 0.0,
        vega: json['vega']?.toDouble() ?? 0.0,
        omega: json['omega']?.toDouble() ?? 0.0,
        leverage: json['leverage']?.toDouble() ?? 0.0,
        breakEvenPrice: json['breakEvenPrice']?.toDouble() ?? 0.0,
        sensitivity: json['sensitivity']?.toDouble() ?? 0.0,
        riskLevel: json['riskLevel'] ?? '',
        graph: List<Graph>.from(json['graph'].map((x) => Graph.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'price': price,
        'instrinsicValue': instrinsicValue,
        'premium': premium,
        'premiumPa': premiumPa,
        'delta': delta,
        'gamma': gamma,
        'theta': theta,
        'vega': vega,
        'omega': omega,
        'leverage': leverage,
        'breakEvenPrice': breakEvenPrice,
        'sensitivity': sensitivity,
        'riskLevel': riskLevel,
        'graph': List<dynamic>.from(graph!.map((x) => x.toJson())),
      };
}

class Graph {
  double? underlyingPrice;
  double? warrantPrice;
  double? delta;
  double? vega;
  double? gamma;
  double? theta;

  Graph({
    this.underlyingPrice,
    this.warrantPrice,
    this.delta,
    this.vega,
    this.gamma,
    this.theta,
  });

  factory Graph.fromJson(Map<String, dynamic> json) => Graph(
        underlyingPrice: json['underlyingPrice']?.toDouble() ?? 0.0,
        warrantPrice: json['warrantPrice']?.toDouble() ?? 0.0,
        delta: json['delta']?.toDouble() ?? 0.0,
        vega: json['vega']?.toDouble() ?? 0.0,
        gamma: json['gamma']?.toDouble() ?? 0.0,
        theta: json['theta']?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        'underlyingPrice': underlyingPrice,
        'warrantPrice': warrantPrice,
        'delta': delta,
        'vega': vega,
        'gamma': gamma,
        'theta': theta,
      };
}
