import 'package:equatable/equatable.dart';
import 'package:piapiri_v2/app/app_settings/bloc/app_settings_bloc.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';

class FundModel extends Equatable {
  final String code;
  final double price;
  final double? performance1D;
  final double numberOfShares;
  final double portfolioSize;
  final String fundTitleType;
  final double numberOfPeople;
  final double marketShare;
  final double rank;
  final int categoryCount;
  final String institutionCode;
  final String? institutionName;
  final double performance1W;
  final double performance1M;
  final double performance3M;
  final double performance6M;
  final double performanceNewYear;
  final double performance1Y;
  final double performance3Y;
  final double performance5Y;
  final int? riskLevel;
  final String subType;

  const FundModel({
    required this.code,
    required this.price,
    required this.performance1D,
    required this.numberOfShares,
    required this.portfolioSize,
    required this.fundTitleType,
    required this.numberOfPeople,
    required this.marketShare,
    required this.rank,
    required this.categoryCount,
    this.institutionCode = 'UNP',
    this.institutionName,
    required this.riskLevel,
    required this.performance1W,
    required this.performance1M,
    required this.performance3M,
    required this.performance6M,
    required this.performanceNewYear,
    required this.performance1Y,
    required this.performance3Y,
    required this.performance5Y,
    required this.subType,
  });

  factory FundModel.fromJson(Map<String, dynamic> json) {
    return FundModel(
      code: json['code'] ?? json['fundCode'],
      price: json['price'] ?? 0,
      performance1D: json['performance1D'],
      numberOfShares: json['numberOfShares'] ?? 0,
      portfolioSize: json['portfolioSize'] ?? 0,
      fundTitleType: json['fundTitleType'] ?? '',
      numberOfPeople: json['numberOfPeople'] ?? 0,
      marketShare: json['marketShare'] ?? 0,
      rank: json['rank'] ?? 0,
      categoryCount: json['categoryCount'] ?? 0,
      institutionCode: json['institutionCode'] ?? 'UNP',
      institutionName: (json['institutionName'] ?? json['founder'])
          ?.toString()
          .replaceAll(RegExp(r'YÖNET[İI]M[İI]\s(?:A\.Ş\.?|ANONİM ŞİRKETİ|ANONİM SIRKETI)', caseSensitive: false), ''),
      riskLevel: json["riskLevel"] ?? 0,
      performance1W: json["performance1W"]?.toDouble() ?? 0.0,
      performance1M: json["performance1M"]?.toDouble() ?? 0.0,
      performance3M: json["performance3M"]?.toDouble() ?? 0.0,
      performance6M: json["performance6M"]?.toDouble() ?? 0.0,
      performanceNewYear: json["performanceNewYear"]?.toDouble() ?? 0.0,
      performance1Y: json["performance1Y"]?.toDouble() ?? 0.0,
      performance3Y: json["performance3Y"]?.toDouble() ?? 0.0,
      performance5Y: json["performance5Y"]?.toDouble() ?? 0.0,
      subType: json['subType'] ?? '',
    );
  }

  @override
  List<Object?> get props => [
        code,
        price,
        performance1D,
        numberOfShares,
        portfolioSize,
        fundTitleType,
        numberOfPeople,
        marketShare,
        rank,
        categoryCount,
        institutionCode,
        institutionName,
        riskLevel,
        performance1W,
        performance1M,
        performance3M,
        performance6M,
        performanceNewYear,
        performance1Y,
        performance3Y,
        performance5Y,
        subType,
      ];
}

class FundFilterModel extends Equatable {
  final String institution;
  final String institutionName;
  final String fundType;
  final String fundTypeName;
  final String tefasType;
  final String tefasTypeName;
  final String subType;
  final String subTypeName;
  final String fundTitle;
  final String fundTitleName;
  final String applicationCategory;
  final int? themeId;

  const FundFilterModel({
    this.institution = 'UNP',
    this.institutionName = 'ÜNLÜ PORTFÖY',
    this.fundType = 'ALL',
    this.fundTypeName = 'Tümü',
    this.tefasType = 'ALL',
    this.tefasTypeName = 'Tümü',
    this.subType = 'ALL',
    this.subTypeName = 'Tümü',
    this.fundTitle = 'ALL',
    this.fundTitleName = 'Tümü',
    this.applicationCategory = 'ALL',
    this.themeId,
  });

  FundFilterModel copyWith({
    String? institution,
    String? institutionName,
    String? fundType,
    String? fundTypeName,
    String? tefasType,
    String? tefasTypeName,
    String? subType,
    String? subTypeName,
    String? fundTitle,
    String? fundTitleName,
    String? applicationCategory,
    int? themeId,
  }) {
    return FundFilterModel(
      institution: institution ?? this.institution,
      institutionName: institutionName != null
          ? institutionName.toString().replaceAll(
              RegExp(r'YÖNET[İI]M[İI]\s(?:A\.Ş\.?|ANONİM ŞİRKETİ|ANONİM SIRKETI)', caseSensitive: false), '')
          : this.institutionName,
      fundType: fundType ?? this.fundType,
      fundTypeName: fundTypeName ?? this.fundTypeName,
      tefasType: tefasType ?? this.tefasType,
      tefasTypeName: tefasTypeName ?? this.tefasTypeName,
      subType: subType ?? this.subType,
      subTypeName: subTypeName ?? this.subTypeName,
      fundTitle: fundTitle ?? this.fundTitle,
      fundTitleName: fundTitleName ?? this.fundTitleName,
      applicationCategory: applicationCategory ?? this.applicationCategory,
      themeId: themeId ?? this.themeId,
    );
  }

  @override
  List<Object?> get props => [
        institution,
        institutionName,
        fundType,
        fundTypeName,
        tefasType,
        tefasTypeName,
        subType,
        subTypeName,
        fundTitle,
        fundTitleName,
        applicationCategory,
        themeId,
      ];
}

class FundDetailModel extends Equatable {
  final String code;
  final String title;
  final String isin;
  final String tefasStartTime;
  final String tefasEndTime;
  final int buyMaturity;
  final int sellMaturity;
  final double minBuyAmount;
  final double minSellAmount;
  final double? maxBuyAmount;
  final double? maxSellAmount;
  final int tefasStatus;
  final String founded;
  final double? price;
  final int? riskLevel;
  final double? managementFee;
  final double? performance1D;
  final double performance1W;
  final double performance1M;
  final double performance3M;
  final double performance6M;
  final double performanceNewYear;
  final double performance1Y;
  final double performance3Y;
  final double performance5Y;
  final double numberOfShares;
  final double portfolioSize;
  final String subType;
  final double numberOfPeople;
  final double marketShare;
  final double rank;
  final int categoryCount;
  final String founder;
  final Map<String, dynamic> extra;
  final int unitCoefficient;
  final String institutionCode;
  final int? applicationCategoryCode;
  final String? applicationCategoryName;
  final bool? virtualBranchAllowedBuy;
  final bool? virtualBranchAllowedSell;

  const FundDetailModel({
    required this.code,
    required this.title,
    required this.isin,
    required this.tefasStartTime,
    required this.tefasEndTime,
    this.buyMaturity = 0,
    this.sellMaturity = 0,
    required this.minBuyAmount,
    required this.minSellAmount,
    this.maxBuyAmount,
    this.maxSellAmount,
    required this.tefasStatus,
    required this.founded,
    required this.riskLevel,
    required this.managementFee,
    this.price,
    this.performance1D,
    required this.performance1W,
    required this.performance1M,
    required this.performance3M,
    required this.performance6M,
    required this.performanceNewYear,
    required this.performance1Y,
    required this.performance3Y,
    required this.performance5Y,
    required this.numberOfShares,
    required this.portfolioSize,
    required this.subType,
    required this.numberOfPeople,
    required this.marketShare,
    required this.rank,
    required this.categoryCount,
    required this.founder,
    required this.extra,
    required this.unitCoefficient,
    this.institutionCode = 'UNP',
    required this.applicationCategoryCode,
    required this.applicationCategoryName,
    this.virtualBranchAllowedBuy,
    this.virtualBranchAllowedSell,
  });

  factory FundDetailModel.fromJson(Map<String, dynamic> json) {
    return FundDetailModel(
      code: json['code'] ?? '',
      title: json['title'] ?? '',
      isin: json['isin'] ?? '',
      tefasStartTime: json['tefasTransactionStartTime'] ?? '',
      tefasEndTime: json['tefasTransactionEndTime'] ?? '',
      buyMaturity: json['buyMaturity'] ?? 0,
      sellMaturity: json['sellMaturity'] ?? 0,
      minBuyAmount: json['minBuyAmount'] ?? 0,
      minSellAmount: json['minSellAmount'] ?? 0,
      maxBuyAmount: json['maxBuyAmount'] ?? 0,
      maxSellAmount: json['maxSellAmount'] ?? 0,
      tefasStatus: json['tefasStatus'] ?? 0,
      founded: json['founded'] ?? '',
      riskLevel: json["riskLevel"] ?? 0,
      managementFee: json["managementFee"] ?? 0.0,
      price: json["price"]?.toDouble() ?? 0,
      performance1D: json["performance1D"]?.toDouble() ?? 0.0,
      performance1W: json["performance1W"]?.toDouble() ?? 0.0,
      performance1M: json["performance1M"]?.toDouble() ?? 0.0,
      performance3M: json["performance3M"]?.toDouble() ?? 0.0,
      performance6M: json["performance6M"]?.toDouble() ?? 0.0,
      performanceNewYear: json["performanceNewYear"]?.toDouble() ?? 0.0,
      performance1Y: json["performance1Y"]?.toDouble() ?? 0.0,
      performance3Y: json["performance3Y"]?.toDouble() ?? 0.0,
      performance5Y: json["performance5Y"]?.toDouble() ?? 0.0,
      numberOfShares: json['numberOfShares'] ?? 0,
      portfolioSize: json['portfolioSize'] ?? 0,
      subType: json['subType'] ?? '',
      numberOfPeople: json['numberOfPeople'] ?? 0,
      marketShare: json['marketShare'] ?? 0,
      rank: json['rank'] ?? 0,
      categoryCount: json['categoryCount'] ?? 0,
      founder: json['founder']
          .toString()
          .replaceAll(RegExp(r'YÖNET[İI]M[İI]\s(?:A\.Ş\.?|ANONİM ŞİRKETİ|ANONİM SIRKETI)', caseSensitive: false), ''),
      extra: json['extra'] ?? {},
      unitCoefficient: json['unitCoefficient'] ?? 1,
      institutionCode: json['institutionCode'] ?? 'UNP',
      applicationCategoryCode: json['applicationCategoryId'] ?? '',
      applicationCategoryName: getIt<AppSettingsBloc>().state.generalSettings.language.value == 'tr'
          ? json['applicationCategoryNameTr']
          : json['applicationCategoryNameEng'],
      virtualBranchAllowedBuy: json['virtualBranchAllowedBuy'],
      virtualBranchAllowedSell: json['virtualBranchAllowedSell'],
    );
  }
  @override
  List<Object?> get props => [
        code,
        title,
        isin,
        tefasStartTime,
        tefasEndTime,
        buyMaturity,
        sellMaturity,
        minBuyAmount,
        minSellAmount,
        maxBuyAmount,
        maxSellAmount,
        tefasStatus,
        founded,
        riskLevel,
        managementFee,
        price,
        performance1D,
        performance1W,
        performance1M,
        performance3M,
        performance6M,
        performanceNewYear,
        performance1Y,
        performance3Y,
        performance5Y,
        numberOfShares,
        portfolioSize,
        subType,
        numberOfPeople,
        marketShare,
        rank,
        categoryCount,
        founder,
        extra,
        unitCoefficient,
        institutionCode,
        applicationCategoryCode,
        applicationCategoryName,
        virtualBranchAllowedBuy,
        virtualBranchAllowedSell,
      ];
}
