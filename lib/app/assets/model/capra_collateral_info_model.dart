class CapraCollateralInfoModel {
  final String? currency;
  final double? cash;
  final double? cashWithdrawable;
  final double? equity;
  final double? lastEquity;
  final double? positionMarketValue;
  final double? buyingPower;

  CapraCollateralInfoModel({
    this.currency,
    this.cash,
    this.cashWithdrawable,
    this.equity,
    this.lastEquity,
    this.positionMarketValue,
    this.buyingPower,
  });

  factory CapraCollateralInfoModel.fromJson(Map<String, dynamic> json) {
    return CapraCollateralInfoModel(
      currency: json['currency'],
      cash: double.parse(json['cash'].toString().replaceAll(',', '')),
      cashWithdrawable: double.parse(json['cash_withdrawable'].toString().replaceAll(',', '')),
      equity: double.parse(json['equity'].toString().replaceAll(',', '')),
      lastEquity: double.parse(json['last_equity'].toString().replaceAll(',', '')),
      positionMarketValue: double.parse(json['position_market_value'].toString().replaceAll(',', '')),
      buyingPower: double.parse(json['buying_power'].toString().replaceAll(',', '')),
    );
  }
}
