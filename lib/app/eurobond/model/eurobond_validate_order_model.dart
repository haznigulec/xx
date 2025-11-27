class EuroBondValidateOrderModel {
  String? token;
  String? finInstId;
  String? side;
  double? requestedAmount;
  double? nominalUnit;
  double? total;
  Bond? bond;

  EuroBondValidateOrderModel({
    this.token,
    this.finInstId,
    this.side,
    this.requestedAmount,
    this.nominalUnit,
    this.total,
    this.bond,
  });

  EuroBondValidateOrderModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    finInstId = json['finInstId'];
    side = json['side'];
    requestedAmount = json['requestedAmount'];
    nominalUnit = json['nominalUnit'];
    total = json['total'];
    bond = json['bond'] != null ? Bond.fromJson(json['bond']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['token'] = token;
    data['finInstId'] = finInstId;
    data['side'] = side;
    data['requestedAmount'] = requestedAmount;
    data['nominalUnit'] = nominalUnit;
    data['total'] = total;
    if (bond != null) {
      data['bond'] = bond!.toJson();
    }
    return data;
  }
}

class Bond {
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

  Bond({
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

  factory Bond.fromJson(Map<String, dynamic> json) {
    return Bond(
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
