class CollateralInfoModel {
  bool? resultMessage;
  CollateralInfo? collateralInfo;

  CollateralInfoModel({
    required this.resultMessage,
    required this.collateralInfo,
  });

  factory CollateralInfoModel.fromJson(Map<String, dynamic> json) {
    return CollateralInfoModel(
      resultMessage: json['resultMessage'],
      collateralInfo: json['collateralInfo'] != null
          ? CollateralInfo.fromJson(
              json['collateralInfo'],
            )
          : null,
    );
  }
}

class CollateralInfo {
  double? sumScanValue;
  double? sumSpreadValue;
  double? shortOptionMinimumMargin;
  double? scanRisk;
  double? netOptionValue;
  double? pendingPremiumPayments;
  double? collateralRate;
  double? maintainCollateral;
  double? beginningCollateral;
  double? requiredCollateral;
  double? collateralInExchange;
  double? collateralInInstitution;
  double? totalCollateralInInstitution;
  double? totalCollateralInExchange;
  double? exchangeNonCashCollateral;
  double? institutionNonCashCollateral;
  // double? deliveryCharge;
  // String? description;
  double? instantProfitLoss;
  // double? instantProfitLossValue1;
  // bool? hasInstantProfitLossValue1;
  double? freeColl;
  double? freeCashColl;
  double? usableColl;
  double? riskLevel;
  double? custodyMarginCallAmount;
  double? prevMarginCallAmount;
  double? instantMarginCallAmount;
  double? cashColl;

  CollateralInfo({
    required this.sumScanValue,
    required this.sumSpreadValue,
    required this.shortOptionMinimumMargin,
    required this.scanRisk,
    required this.netOptionValue,
    required this.pendingPremiumPayments,
    required this.collateralRate,
    required this.maintainCollateral,
    required this.beginningCollateral,
    required this.requiredCollateral,
    required this.collateralInExchange,
    required this.collateralInInstitution,
    required this.totalCollateralInInstitution,
    required this.totalCollateralInExchange,
    required this.exchangeNonCashCollateral,
    required this.institutionNonCashCollateral,
    // required this.deliveryCharge,
    // required this.description,
    required this.instantProfitLoss,
    // required this.instantProfitLossValue1,
    // required this.hasInstantProfitLossValue1,
    required this.freeColl,
    required this.freeCashColl,
    required this.usableColl,
    required this.riskLevel,
    required this.custodyMarginCallAmount,
    required this.prevMarginCallAmount,
    required this.instantMarginCallAmount,
    required this.cashColl,
  });

  factory CollateralInfo.fromJson(Map<String, dynamic> json) {
    return CollateralInfo(
      sumScanValue: json['sumScanValue'],
      sumSpreadValue: json['sumSpreadValue'],
      shortOptionMinimumMargin: json['shortOptionMinimumMargin'],
      scanRisk: json['scanRisk'],
      netOptionValue: json['netOptionValue'],
      pendingPremiumPayments: json['pendingPremiumPayments'],
      collateralRate: json['collateralRate'],
      maintainCollateral: json['maintainCollateral'],
      beginningCollateral: json['beginningCollateral'],
      requiredCollateral: json['requiredCollateral'],
      collateralInExchange: json['collateralInExchange'],
      collateralInInstitution: json['collateralInInstitution'],
      totalCollateralInInstitution: json['totalCollateralInInstitution'],
      totalCollateralInExchange: json['totalCollateralInExchange'],
      exchangeNonCashCollateral: json['exchangeNonCashCollateral'],
      institutionNonCashCollateral: json['institutionNonCashCollateral'],
      // deliveryCharge: json['deliveryCharge'],
      // description: json['description'],
      instantProfitLoss: json['instantProfitLoss'],
      // instantProfitLossValue1: json['instantProfitLossValue1'],
      // hasInstantProfitLossValue1: json['hasInstantProfitLossValue1'],
      freeColl: json['freeColl'],
      freeCashColl: json['freeCashColl'],
      usableColl: json['usableColl'],
      riskLevel: json['riskLevel'],
      custodyMarginCallAmount: json['custodyMarginCallAmount'],
      prevMarginCallAmount: json['prevMarginCallAmount'],
      instantMarginCallAmount: json['instantMarginCallAmount'],
      cashColl: json['cashColl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sumScanValue': sumScanValue,
      'sumSpreadValue': sumSpreadValue,
      'shortOptionMinimumMargin': shortOptionMinimumMargin,
      'scanRisk': scanRisk,
      'netOptionValue': netOptionValue,
      'pendingPremiumPayments': pendingPremiumPayments,
      'collateralRate': collateralRate,
      'maintainCollateral': maintainCollateral,
      'beginningCollateral': beginningCollateral,
      'requiredCollateral': requiredCollateral,
      'collateralInExchange': collateralInExchange,
      'collateralInInstitution': collateralInInstitution,
      'totalCollateralInInstitution': totalCollateralInInstitution,
      'totalCollateralInExchange': totalCollateralInExchange,
      'exchangeNonCashCollateral': exchangeNonCashCollateral,
      'institutionNonCashCollateral': institutionNonCashCollateral,
      // 'deliveryCharge': deliveryCharge,
      // 'description': description,
      'instantProfitLoss': instantProfitLoss,
      // 'instantProfitLossValue1': instantProfitLossValue1,
      // 'hasInstantProfitLossValue1': hasInstantProfitLossValue1,
      'freeColl': freeColl,
      'freeCashColl': freeCashColl,
      'usableColl': usableColl,
      'riskLevel': riskLevel,
      'custodyMarginCallAmount': custodyMarginCallAmount,
      'prevMarginCallAmount': prevMarginCallAmount,
      'instantMarginCallAmount': instantMarginCallAmount,
      'cashColl': cashColl,
    };
  }
}
