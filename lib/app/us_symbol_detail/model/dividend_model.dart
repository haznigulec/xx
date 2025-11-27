class DividendModel {
  List<CashDividendsList>? cashDividends;

  DividendModel({
    this.cashDividends,
  });

  factory DividendModel.fromJson(Map<String, dynamic> json) {
    return DividendModel(
      cashDividends: json['cashDividends'] == null
          ? []
          : List<CashDividendsList>.from(
              json['cashDividends'].map(
                (x) => CashDividendsList.fromJson(x),
              ),
            ),
    );
  }
}

class CashDividendsList {
  String? symbol;
  double? rate;
  bool? isForeign;
  bool? isSpecial;
  String? processDate;
  String? executionDate;
  String? recordDate;
  String? payableDate;
  dynamic dueBillOffDate;
  dynamic dueBillOnDate;

  CashDividendsList({
    this.symbol,
    this.rate,
    this.isForeign,
    this.isSpecial,
    this.processDate,
    this.executionDate,
    this.recordDate,
    this.payableDate,
    this.dueBillOffDate,
    this.dueBillOnDate,
  });

  factory CashDividendsList.fromJson(Map<String, dynamic> json) {
    return CashDividendsList(
      symbol: json['symbol'],
      rate: json['rate'],
      isForeign: json['isForeign'],
      isSpecial: json['isSpecial'],
      processDate: json['processDate'],
      executionDate: json['executionDate'],
      recordDate: json['recordDate'],
      payableDate: json['payableDate'],
      dueBillOffDate: json['dueBillOffDate'],
      dueBillOnDate: json['dueBillOnDate'],
    );
  }
}
