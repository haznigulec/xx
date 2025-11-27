class MarketMoversModel {
  String? symbol;
  double? change;
  double? changePercent;
  int? updated;

  MarketMoversModel({
    this.symbol,
    this.change,
    this.changePercent,
    this.updated,
  });

  MarketMoversModel.fromJson(Map<String, dynamic> json) {
    symbol = json['ticker'] ?? '';
    change = json['todaysChange']?.toDouble();
    changePercent = json['todaysChangePerc']?.toDouble();
    updated = json['updated'];
  }
}
