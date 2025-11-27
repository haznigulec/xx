class SystemParametersModel {
  double? eftLowerLimit;
  double? eftUpperLimit;
  String? eftStartTime;
  String? eftEndTime;
  String? eftDate;
  String? usdEftStartTime;
  String? usdEftEndTime;
  DateTime? fcStartTime;
  DateTime? fcEndTime;
  double? fcUsdBuyOnceMaxLimit;
  double? fcUsdSellOnceMaxLimit;
  double? fcEurBuyOnceMaxLimit;
  double? fcEurSellOnceMaxLimit;
  double? fcGbpBuyOnceMaxLimit;
  double? fcGbpSellOnceMaxLimit;
  double? eftUsdLowerLimit;
  double? eftUsdUpperLimit;
  double? eftEurLowerLimit;
  double? eftEurUpperLimit;
  double? eftGbpLowerLimit;
  double? eftGbpUpperLimit;
  double? fcUsdBuyOnceMinLimit;
  double? fcUsdSellOnceMinLimit;
  double? fcEurBuyOnceMinLimit;
  double? fcEurSellOnceMinLimit;
  double? fcGbpBuyOnceMinLimit;
  double? fcGbpSellOnceMinLimit;
  double? t0CreditInstitutionUpperLimit;
  double? t0CreditInstitutionLowerLimit;

  SystemParametersModel({
    this.eftLowerLimit,
    this.eftUpperLimit,
    this.eftStartTime,
    this.eftEndTime,
    this.eftDate,
    this.usdEftStartTime,
    this.usdEftEndTime,
    this.fcStartTime,
    this.fcEndTime,
    this.fcUsdBuyOnceMaxLimit,
    this.fcUsdSellOnceMaxLimit,
    this.fcEurBuyOnceMaxLimit,
    this.fcEurSellOnceMaxLimit,
    this.fcGbpBuyOnceMaxLimit,
    this.fcGbpSellOnceMaxLimit,
    this.eftUsdLowerLimit,
    this.eftUsdUpperLimit,
    this.eftEurLowerLimit,
    this.eftEurUpperLimit,
    this.eftGbpLowerLimit,
    this.eftGbpUpperLimit,
    this.fcUsdBuyOnceMinLimit,
    this.fcUsdSellOnceMinLimit,
    this.fcEurBuyOnceMinLimit,
    this.fcEurSellOnceMinLimit,
    this.fcGbpBuyOnceMinLimit,
    this.fcGbpSellOnceMinLimit,
    this.t0CreditInstitutionUpperLimit,
    this.t0CreditInstitutionLowerLimit,
  });

  factory SystemParametersModel.fromJson(Map<String, dynamic> json) {
    return SystemParametersModel(
      eftLowerLimit: json['eftLowerLimit'],
      eftUpperLimit: json['eftUpperLimit'],
      eftStartTime: json['eftStartTime'],
      eftEndTime: json['eftEndTime'],
      eftDate: json['eftDate'],
      usdEftStartTime: json['usdEftStartTime'],
      usdEftEndTime: json['usdEftEndTime'],
      fcStartTime: json['fcStartTime'] != null
          ? DateTime.parse(
              json['fcStartTime'],
            )
          : null,
      fcEndTime: json['fcEndTime'] != null
          ? DateTime.parse(
              json['fcEndTime'],
            )
          : null,
      fcUsdBuyOnceMaxLimit: json['fcUsdBuyOnceMaxLimit'],
      fcUsdSellOnceMaxLimit: json['fcUsdSellOnceMaxLimit'],
      fcEurBuyOnceMaxLimit: json['fcEurBuyOnceMaxLimit'],
      fcEurSellOnceMaxLimit: json['fcEurSellOnceMaxLimit'],
      fcGbpBuyOnceMaxLimit: json['fcGbpBuyOnceMaxLimit'],
      fcGbpSellOnceMaxLimit: json['fcGbpSellOnceMaxLimit'],
      eftUsdLowerLimit: json['eftUsdLowerLimit'],
      eftUsdUpperLimit: json['eftUsdUpperLimit'],
      eftEurLowerLimit: json['eftEurLowerLimit'],
      eftEurUpperLimit: json['eftEurUpperLimit'],
      eftGbpLowerLimit: json['eftGbpLowerLimit'],
      eftGbpUpperLimit: json['eftGbpUpperLimit'],
      fcUsdBuyOnceMinLimit: json['fcUsdBuyOnceMinLimit'],
      fcUsdSellOnceMinLimit: json['fcUsdSellOnceMinLimit'],
      fcEurBuyOnceMinLimit: json['fcEurBuyOnceMinLimit'],
      fcEurSellOnceMinLimit: json['fcEurSellOnceMinLimit'],
      fcGbpBuyOnceMinLimit: json['fcGbpBuyOnceMinLimit'],
      fcGbpSellOnceMinLimit: json['fcGbpSellOnceMinLimit'],
      t0CreditInstitutionUpperLimit: json['t0CreditInstitutionUpperLimit'],
      t0CreditInstitutionLowerLimit: json['t0CreditInstitutionLowerLimit'],
    );
  }
}
