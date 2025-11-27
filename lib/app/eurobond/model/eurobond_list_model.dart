class EuroBondListModel {
  String? token;
  List<Bonds>? bonds;
  String? transactionStartTime;
  String? transactionEndTime;

  EuroBondListModel({
    this.token,
    this.bonds,
    this.transactionStartTime,
    this.transactionEndTime,
  });

  EuroBondListModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    if (json['bonds'] != null) {
      bonds = <Bonds>[];
      json['bonds'].forEach((v) {
        bonds!.add(Bonds.fromJson(v));
      });
    }
    transactionStartTime = json['transactionStartTime'];
    transactionEndTime = json['transactionEndTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    if (bonds != null) {
      data['bonds'] = bonds!.map((v) => v.toJson()).toList();
    }
    data['transactionStartTime'] = transactionStartTime;
    data['transactionEndTime'] = transactionEndTime;
    return data;
  }
}

class Bonds {
  String? finInstId;
  String? name;
  String? maturityDate;
  String? valueDate;
  String? currencyName;
  double? debitPrice;
  double? debitRate;
  double? debitTransactionLimit;
  double? debitCleanPrice;
  double? creditPrice;
  double? creditRate;
  double? creditTransactionLimit;
  double? creditCleanPrice;
  String? nextCouponDate;
  double? couponRate;
  double? couponFrequency;

  Bonds({
    this.finInstId,
    this.name,
    this.maturityDate,
    this.valueDate,
    this.currencyName,
    this.debitPrice,
    this.debitRate,
    this.debitTransactionLimit,
    this.debitCleanPrice,
    this.creditPrice,
    this.creditRate,
    this.creditTransactionLimit,
    this.creditCleanPrice,
    this.nextCouponDate,
    this.couponRate,
    this.couponFrequency,
  });

  factory Bonds.fromJson(Map<String, dynamic> json) {
    return Bonds(
      finInstId: json['finInstId'],
      name: json['name'],
      maturityDate: json['maturityDate'],
      valueDate: json['valueDate'],
      currencyName: json['currencyName'],
      debitPrice: json['debitPrice'],
      debitRate: json['debitRate'],
      debitTransactionLimit: json['debitTransactionLimit'],
      debitCleanPrice: json['debitCleanPrice'],
      creditPrice: json['creditPrice'],
      creditRate: json['creditRate'],
      creditTransactionLimit: json['creditTransactionLimit'],
      creditCleanPrice: json['creditCleanPrice'],
      nextCouponDate: json['nextCouponDate'],
      couponRate: json['couponRate'],
      couponFrequency: json['couponFrequency'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'finInstId': finInstId,
      'name': name,
      'maturityDate': maturityDate,
      'valueDate': valueDate,
      'currencyName': currencyName,
      'debitPrice': debitPrice,
      'debitRate': debitRate,
      'debitTransactionLimit': debitTransactionLimit,
      'debitCleanPrice': debitCleanPrice,
      'creditPrice': creditPrice,
      'creditRate': creditRate,
      'creditTransactionLimit': creditTransactionLimit,
      'creditCleanPrice': creditCleanPrice,
      'nextCouponDate': nextCouponDate,
      'couponRate': couponRate,
      'couponFrequency': couponFrequency,
    };
  }
}
