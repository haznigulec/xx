class IpoTradeLimitModel {
  TradeLimitCalculationDetails? tradeLimitCalculationDetails;
  double? tradeLimit;
  double? realLimit;
  String? token;

  IpoTradeLimitModel({
    this.tradeLimitCalculationDetails,
    this.tradeLimit,
    this.realLimit,
    this.token,
  });

  factory IpoTradeLimitModel.fromJson(Map<String, dynamic> json) {
    return IpoTradeLimitModel(
      tradeLimitCalculationDetails: json['tradeLimitCalculationDetails'] != null
          ? TradeLimitCalculationDetails.fromJson(
              json['tradeLimitCalculationDetails'],
            )
          : null,
      tradeLimit: json['tradeLimit'],
      realLimit: double.parse(json['realLimit'].toString()),
      token: json['token'],
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (tradeLimitCalculationDetails != null) {
      data['tradeLimitCalculationDetails'] = tradeLimitCalculationDetails!.toJson();
    }
    data['tradeLimit'] = tradeLimit;
    data['realLimit'] = realLimit;
    data['token'] = token;
    return data;
  }
}

class TradeLimitCalculationDetails {
  final double cBBALANCE;

  TradeLimitCalculationDetails({
    this.cBBALANCE = 0,
  });

  factory TradeLimitCalculationDetails.fromJson(Map<String, dynamic> json) {
    return TradeLimitCalculationDetails(
      cBBALANCE: json['CBBALANCE'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CBBALANCE'] = cBBALANCE;
    return data;
  }
}
