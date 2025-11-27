import 'package:equatable/equatable.dart';
import 'package:p_core/extensions/date_time_extensions.dart';

class AssetModel extends Equatable {
  final double tradeLimit;
  final double totalTlOverall;
  final double totalUsdOverall;
  final bool noCreditAndShortFall;
  final List<CreditInfoModel> creditInfo;
  final List<OverallItemModel> overallItemGroups;
  final bool ipoStatus;

  const AssetModel({
    required this.tradeLimit,
    required this.totalTlOverall,
    required this.totalUsdOverall,
    required this.noCreditAndShortFall,
    required this.creditInfo,
    required this.overallItemGroups,
    this.ipoStatus = false,
  });

  factory AssetModel.fromJson(dynamic json) {
    return AssetModel(
      tradeLimit: double.parse(json['tradeLimit'].toString()),
      totalTlOverall: double.parse(json['totalTlOverAll'].toString()),
      totalUsdOverall: double.parse(json['totalUsdOverAll'].toString()),
      noCreditAndShortFall: json['noCreditAndShortFall'],
      creditInfo: json['creditInfoList']
          .map<CreditInfoModel>(
            (dynamic element) => CreditInfoModel.fromJson(element),
          )
          .toList(),
      overallItemGroups: json['overallItemGroups']
          .map<OverallItemModel>(
            (dynamic element) => OverallItemModel.fromJson(element),
          )
          .toList(),
      ipoStatus: json['ipoStatus'] ?? false,
    );
  }

  @override
  List<Object?> get props => [
        tradeLimit,
        totalTlOverall,
        totalUsdOverall,
        noCreditAndShortFall,
        creditInfo,
        overallItemGroups,
        ipoStatus,
      ];
}

class CreditLimitInfoLimit {
  final double creditLimit;
  final double usedCredit;
  final double remainingCredit;

  CreditLimitInfoLimit({
    required this.creditLimit,
    required this.usedCredit,
    required this.remainingCredit,
  });

  factory CreditLimitInfoLimit.fromJson(dynamic json) {
    return CreditLimitInfoLimit(
      creditLimit: json['creditLimit'],
      usedCredit: json['usedCredit'],
      remainingCredit: json['remainingCredit'],
    );
  }
}

class CollateralInfoLimit {
  final double availableCollateral;
  final double shortFallAmountLimit;

  CollateralInfoLimit({
    required this.availableCollateral,
    required this.shortFallAmountLimit,
  });

  factory CollateralInfoLimit.fromJson(dynamic json) {
    return CollateralInfoLimit(
      availableCollateral: json['availableCollateral'],
      shortFallAmountLimit: json['shortFallAmountLimit'],
    );
  }
}

class RiskCapitalInfoLimit {
  final double riskCapitalRate;
  final double? riskCapitalRateT1;
  final double? riskCapitalRateT2;

  RiskCapitalInfoLimit({
    required this.riskCapitalRate,
    this.riskCapitalRateT1,
    this.riskCapitalRateT2,
  });

  factory RiskCapitalInfoLimit.fromJson(dynamic json) {
    return RiskCapitalInfoLimit(
      riskCapitalRate: json['riskCapitalRate'],
      riskCapitalRateT1: json['riskCapitalRateT1'],
      riskCapitalRateT2: json['riskCapitalRateT2'],
    );
  }
}

class CreditInfoModel {
  final CreditLimitInfoLimit creditLimitInfo;
  final CollateralInfoLimit collateralInfo;
  final RiskCapitalInfoLimit riskCapitalInfo;

  CreditInfoModel({
    required this.creditLimitInfo,
    required this.collateralInfo,
    required this.riskCapitalInfo,
  });

  factory CreditInfoModel.fromJson(dynamic json) {
    return CreditInfoModel(
      creditLimitInfo: CreditLimitInfoLimit.fromJson(json),
      collateralInfo: CollateralInfoLimit.fromJson(json),
      riskCapitalInfo: RiskCapitalInfoLimit.fromJson(json),
    );
  }
}

class OverallItemModel {
  final String instrumentCategory;
  final double totalAmount;
  final double ratio;
  final List<OverallSubItemModel> overallSubItems;
  final double totalPotentialProfitLoss;

  OverallItemModel({
    required this.instrumentCategory,
    required this.totalAmount,
    required this.ratio,
    required this.overallSubItems,
    required this.totalPotentialProfitLoss,
  });

  factory OverallItemModel.fromJson(dynamic json) {
    return OverallItemModel(
      instrumentCategory: json['instrumentCategory'],
      totalAmount: json['totalAmount'],
      ratio: json['ratio'],
      overallSubItems: json['overallItems']
          .map<OverallSubItemModel>(
            (dynamic element) => OverallSubItemModel.fromJson(element),
          )
          .toList(),
      totalPotentialProfitLoss: double.parse(json['totalPotentialProfitLoss'].toString()),
    );
  }
}

class OverallSubItemModel {
  final String symbol;
  final double amount;
  final double price;
  final double qty;
  final double cost;
  final double exchangeValue;
  final double profitLossPercent;
  final double potentialProfitLoss;
  final double totalStock;
  final String financialInstrumentType;
  final String transTypeOrder;
  final String? financialInstrumentCode;
  final String? financialInstrumentId;
  final String category;
  final String underlying;
  final num multiplier;
  final String maturity;
  final double instantPotentialProfitLoss;

  OverallSubItemModel({
    required this.symbol,
    required this.amount,
    required this.price,
    required this.qty,
    required this.cost,
    required this.exchangeValue,
    required this.profitLossPercent,
    required this.potentialProfitLoss,
    required this.totalStock,
    required this.financialInstrumentType,
    required this.transTypeOrder,
    this.financialInstrumentCode,
    this.financialInstrumentId,
    required this.category,
    this.underlying = '',
    this.multiplier = 1,
    this.maturity = '',
    this.instantPotentialProfitLoss = 0.0,
  });

  factory OverallSubItemModel.fromJson(dynamic json) {
    return OverallSubItemModel(
      symbol: json['symbol'],
      amount: double.parse(json['amount'].toString()),
      price: double.parse(json['price'].toString()),
      qty: json['qty'],
      cost: json['cost'],
      exchangeValue: double.parse(json['exchangeValue'].toString()),
      profitLossPercent: double.parse(json['profitLossPercent'].toString()),
      potentialProfitLoss: double.parse(json['potentialProfitLoss'].toString()),
      totalStock: double.parse(json['totalStock'].toString()),
      financialInstrumentType: json['financialInstrumentType'] ?? '',
      transTypeOrder: json['transTypeOrder'] ?? '',
      financialInstrumentCode: json['financialInstrumentCode'],
      financialInstrumentId: json['financialInstrumentId'],
      category: json['category'],
      underlying: json['underlying'] ?? '',
      multiplier: json['multiplier'] ?? 1,
      instantPotentialProfitLoss: double.parse(json['instantPotentialProfitLoss'].toString()),
      maturity: json['maturity'] ??
          DateTime.now()
              .add(
                const Duration(
                  days: 1,
                ),
              )
              .formatToJson(),
    );
  }
}

class CustomerBankAccountModel {
  final String accountId;
  final String accountExtId;
  final String bankName;
  final String branchName;
  final String bankAccountNo;
  // final int cityCode;
  final String cityName;
  final String createdBy;
  final int isDefault;
  final String customerId;
  final String customerName;
  // final int institutionId;
  final String branchId;
  final String cusAccStatus;
  final String isClosed;
  final String name;
  final String receiverName;
  final String customerExtId;
  final String bankAccId;
  final String ibanNo;
  final String fatherName;
  final String defaultAccountId;

  CustomerBankAccountModel({
    required this.accountId,
    required this.accountExtId,
    required this.bankName,
    required this.branchName,
    required this.bankAccountNo,
    // required this.cityCode,
    required this.cityName,
    required this.createdBy,
    required this.isDefault,
    required this.customerId,
    required this.customerName,
    // required this.institutionId,
    required this.branchId,
    required this.cusAccStatus,
    required this.isClosed,
    required this.name,
    required this.receiverName,
    required this.customerExtId,
    required this.bankAccId,
    required this.ibanNo,
    required this.fatherName,
    required this.defaultAccountId,
  });

  factory CustomerBankAccountModel.fromJson(dynamic json) {
    return CustomerBankAccountModel(
      accountId: json['accountId'] ?? '',
      accountExtId: json['accountExtId'] ?? '',
      bankName: json['bankName'] ?? '',
      branchName: json['branchName'] ?? '',
      bankAccountNo: json['bankAccountNo'] ?? '',
      // cityCode: json['cityCode'] ?? 0,
      cityName: json['cityName'] ?? '',
      createdBy: json['createdBy'] ?? '',
      isDefault: json['isDefault'] ?? 0,
      customerId: json['customerId'] ?? '',
      customerName: json['customerName'] ?? '',
      // institutionId: json['institutionId'] ?? 0,
      branchId: json['branchId'] ?? '',
      cusAccStatus: json['cusAccStatus'] ?? '',
      isClosed: json['isClosed'] ?? '',
      name: json['name'] ?? '',
      receiverName: json['receiverName'] ?? '',
      customerExtId: json['customerExtId'] ?? '',
      bankAccId: json['bankAccId'] ?? '',
      ibanNo: json['ibanNo'] ?? '',
      fatherName: json['fatherName'] ?? '',
      defaultAccountId: json['defaultAccountId'] ?? '',
    );
  }
}

class EftInfoModel {
  final double eftLowerLimit;
  final double eftUpperLimit;
  final String eftStartTime;
  final String eftEndTime;
  final String eftDate;
  final String usdEftStartTime;
  final String usdEftEndTime;

  EftInfoModel({
    required this.eftLowerLimit,
    required this.eftUpperLimit,
    required this.eftStartTime,
    required this.eftEndTime,
    required this.eftDate,
    required this.usdEftStartTime,
    required this.usdEftEndTime,
  });

  factory EftInfoModel.fromJson(dynamic json) {
    return EftInfoModel(
      eftLowerLimit: json['eftLowerLimit'],
      eftUpperLimit: json['eftUpperLimit'],
      eftStartTime: json['eftStartTime'],
      eftEndTime: json['eftEndTime'],
      eftDate: json['eftDate'],
      usdEftStartTime: json['usdEftStartTime'],
      usdEftEndTime: json['usdEftEndTime'],
    );
  }
}

class CashFlowModel {
  final String valueDate;
  final int equityValue;
  final double cashValue;

  CashFlowModel({
    required this.valueDate,
    required this.equityValue,
    required this.cashValue,
  });

  factory CashFlowModel.fromJson(dynamic json) {
    return CashFlowModel(
      valueDate: json['valueDate'],
      equityValue: json['equityValue'],
      cashValue: json['cashValue'],
    );
  }
}
