// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

class PotentialProfitLossModel extends Equatable {
  List<CreditInfoList>? creditInfoList;
  List<OverallItemGroups>? overallItemGroups;
  double? totalPotentialProfitLoss;
  double? tradeLimit;
  double? totalTlOverAll;
  double? totalUsdOverAll;
  bool? noCreditAndShortFall;
  String? token;

  PotentialProfitLossModel({
    this.creditInfoList,
    this.overallItemGroups,
    this.totalPotentialProfitLoss,
    this.tradeLimit,
    this.totalTlOverAll,
    this.totalUsdOverAll,
    this.noCreditAndShortFall,
    this.token,
  });

  PotentialProfitLossModel.fromJson(Map<String, dynamic> json) {
    if (json['creditInfoList'] != null) {
      creditInfoList = json['creditInfoList']
          .map<CreditInfoList>(
            (e) => CreditInfoList.fromJson(e),
          )
          .toList();
    }
    if (json['overallItemGroups'] != null) {
      overallItemGroups = json['overallItemGroups']
          .map<OverallItemGroups>(
            (e) => OverallItemGroups.fromJson(e),
          )
          .toList();
    }
    totalPotentialProfitLoss =
        json['totalPotentialProfitLoss'] != null ? double.parse(json['totalPotentialProfitLoss'].toString()) : 0.0;
    tradeLimit = json['tradeLimit'] != null ? double.parse(json['tradeLimit'].toString()) : 0.0;
    totalTlOverAll = json['totalTlOverAll'] != null ? double.parse(json['totalTlOverAll'].toString()) : 0.0;
    totalUsdOverAll = json['totalUsdOverAll'] != null ? double.parse(json['totalUsdOverAll'].toString()) : 0.0;
    noCreditAndShortFall = json['noCreditAndShortFall'];
    token = json['token'];
  }

  @override
  List<Object?> get props => [
        creditInfoList,
        overallItemGroups,
        totalPotentialProfitLoss,
        tradeLimit,
        totalTlOverAll,
        totalUsdOverAll,
        noCreditAndShortFall,
        token,
      ];
}

class CreditInfoList {
  num? creditLimit;
  num? usedCredit;
  num? remainingCredit;
  num? availableCollateral;
  num? shortFallAmountLimit;
  num? riskCapitalRate;

  CreditInfoList({
    this.creditLimit,
    this.usedCredit,
    this.remainingCredit,
    this.availableCollateral,
    this.shortFallAmountLimit,
    this.riskCapitalRate,
  });

  CreditInfoList.fromJson(Map<String, dynamic> json) {
    creditLimit = json['creditLimit'];
    usedCredit = json['usedCredit'];
    remainingCredit = json['remainingCredit'];
    availableCollateral = json['availableCollateral'];
    shortFallAmountLimit = json['shortFallAmountLimit'];
    riskCapitalRate = json['riskCapitalRate'];
  }
}

class OverallItemGroups extends Equatable {
  String? instrumentCategory;
  double? totalAmount;
  double? ratio;
  double? totalPotentialProfitLoss;
  List<OverallItems>? overallItems;

  OverallItemGroups({
    this.instrumentCategory,
    this.totalAmount,
    this.ratio,
    this.totalPotentialProfitLoss,
    this.overallItems,
  });

  OverallItemGroups.fromJson(Map<String, dynamic> json) {
    instrumentCategory = json['instrumentCategory'] ?? '';
    totalAmount = json['totalAmount'];
    ratio = json['ratio'];
    totalPotentialProfitLoss = double.parse(
      json['totalPotentialProfitLoss'].toString(),
    );
    if (json['overallItems'] != null) {
      overallItems = json['overallItems']
          .map<OverallItems>(
            (e) => OverallItems.fromJson(e),
          )
          .toList();
    }
  }

  @override
  List<Object?> get props => [
        instrumentCategory,
        totalAmount,
        ratio,
        totalPotentialProfitLoss,
        overallItems,
      ];
}

class OverallItems extends Equatable {
  String? symbol;
  num? amount;
  num? price;
  num? qty;
  num? cost;
  num? exchangeValue;
  num? profitLossPercent;
  num? potentialProfitLoss;
  num? totalStock;
  String? financialInstrumentType;
  String? transTypeOrder;
  String? financialInstrumentCode;
  String? financialInstrumentId;
  String? category;
  String? underlying;

  OverallItems({
    this.symbol,
    this.amount,
    this.price,
    this.qty,
    this.cost,
    this.exchangeValue,
    this.profitLossPercent,
    this.potentialProfitLoss,
    this.totalStock,
    this.financialInstrumentType,
    this.transTypeOrder,
    this.financialInstrumentCode,
    this.financialInstrumentId,
    this.category,
    this.underlying,
  });

  OverallItems.fromJson(Map<String, dynamic> json) {
    symbol = json['symbol'];
    amount = json['amount'];
    price = json['price'];
    qty = json['qty'];
    cost = json['cost'];
    exchangeValue = json['exchangeValue'];
    profitLossPercent = json['profitLossPercent'];
    potentialProfitLoss = json['potentialProfitLoss'];
    totalStock = json['totalStock'];
    financialInstrumentType = json['financialInstrumentType'];
    transTypeOrder = json['transTypeOrder'];
    financialInstrumentCode = json['financialInstrumentCode'];
    financialInstrumentId = json['financialInstrumentId'];
    category = json['category'];
    underlying = json['underlying'];
  }

  OverallItems copyWith({
    String? symbol,
    num? amount,
    num? price,
    num? qty,
    num? cost,
    num? exchangeValue,
    num? profitLossPercent,
    num? potentialProfitLoss,
    num? totalStock,
    String? financialInstrumentType,
    String? transTypeOrder,
    String? financialInstrumentCode,
    String? financialInstrumentId,
    String? category,
    String? underlying,
  }) {
    return OverallItems(
      symbol: symbol ?? this.symbol,
      amount: amount ?? this.amount,
      price: price ?? this.price,
      qty: qty ?? this.qty,
      cost: cost ?? this.cost,
      exchangeValue: exchangeValue ?? this.exchangeValue,
      profitLossPercent: profitLossPercent ?? this.profitLossPercent,
      potentialProfitLoss: potentialProfitLoss ?? this.potentialProfitLoss,
      totalStock: totalStock ?? this.totalStock,
      financialInstrumentType: financialInstrumentType ?? this.financialInstrumentType,
      transTypeOrder: transTypeOrder ?? this.transTypeOrder,
      financialInstrumentCode: financialInstrumentCode ?? this.financialInstrumentCode,
      financialInstrumentId: financialInstrumentId ?? this.financialInstrumentId,
      category: category ?? this.category,
      underlying: underlying ?? this.underlying,
    );
  }

  @override
  List<Object?> get props => [
        symbol,
        amount,
        price,
        qty,
        cost,
        exchangeValue,
        profitLossPercent,
        potentialProfitLoss,
        totalStock,
        financialInstrumentType,
        transTypeOrder,
        financialInstrumentCode,
        financialInstrumentId,
        category,
        underlying,
      ];
}
