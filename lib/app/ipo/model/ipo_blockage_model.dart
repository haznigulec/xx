class IpoBlockageModel {
  String? token;
  List<FinancialInstrument>? financialInstrument;

  IpoBlockageModel({this.token, this.financialInstrument});

  factory IpoBlockageModel.fromJson(Map<String, dynamic> json) {
    return IpoBlockageModel(
      token: json['token'],
      financialInstrument: json['financialInstrument']
          .map<FinancialInstrument>(
            (dynamic element) => FinancialInstrument.fromJson(element),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    if (financialInstrument != null) {
      data['financialInstrument'] = financialInstrument!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FinancialInstrument {
  String? typeCode;
  String? finInstName;
  double? demandAmount;
  double? rationalDemandAmount;
  double? price;
  double? balance;
  double? rationalAmount;
  String? founderCode;

  FinancialInstrument({
    this.typeCode,
    this.finInstName,
    this.demandAmount,
    this.rationalDemandAmount,
    this.price,
    this.balance,
    this.rationalAmount,
    this.founderCode,
  });

  FinancialInstrument.fromJson(Map<String, dynamic> json) {
    typeCode = json['typeCode'];
    finInstName = json['finInstName'];
    demandAmount = double.parse(json['demandAmount'].toString());
    rationalDemandAmount = double.parse(json['rationalDemandAmount'].toString());
    price = json['price'];
    balance = double.parse(json['balance'].toString());
    rationalAmount = json['rationalAmount'];
    founderCode = json['founderCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['typeCode'] = typeCode;
    data['finInstName'] = finInstName;
    data['demandAmount'] = demandAmount;
    data['rationalDemandAmount'] = rationalDemandAmount;
    data['price'] = price;
    data['balance'] = balance;
    data['rationalAmount'] = rationalAmount;
    return data;
  }
}
