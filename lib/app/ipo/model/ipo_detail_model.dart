class IpoDetailModel {
  int? id;
  List<IpoAttachments>? ipoAttachments;
  List<IpoLinks>? ipoLinks;
  String? companyName;
  String? companyLogo;
  String? symbol;
  String? companyWebsite;
  String? startDate;
  String? endDate;
  double? startPrice;
  double? endPrice;
  String? distributionType;
  int? sharesToDistribute;
  String? brokerageFirm;
  String? freeFloatingShares;
  String? freeFloatingShareRate;
  String? market;
  String? bistFirstTransactionDate;
  int? ipoStatus;
  String? companyDetailInfo;
  String? ipoTypeCapitalIncrease;
  String? ipoTypeStockholderSale;
  String? ipoTypeReference;
  String? ipoSaleType;
  String? ipoSaleTypeReference;
  String? ipoFundUsingInfo;
  String? ipoFundUsingInfoReference;
  String? allotments;
  String? allotmentsReference;
  String? sharesDistributed;
  String? sharesDistributedReference;
  String? financialTablePeriod1;
  String? financialTableRevenues1;
  String? financialTableGrossProfit1;
  String? financialTablePeriod2;
  String? financialTableRevenues2;
  String? financialTableGrossProfit2;
  String? financialTablePeriod3;
  String? financialTableRevenues3;
  String? financialTableGrossProfit3;
  String? financialTableReference;
  String? priceStability;
  String? priceStabilityReference;
  String? shareKeepingPromises;
  String? shareKeepingPromisesReference;
  String? publicityRate;
  String? publicityRateReference;
  String? discount;
  String? discountReference;
  String? size;
  String? sizeReference;
  String? summaryFootnotes;
  int? ipoResultDomesticIndividualPerson;
  int? ipoResultDomesticIndividualLot;
  int? ipoResultDomesticIndividualRate;
  int? ipoResultDomesticCorporatePerson;
  int? ipoResultDomesticCorporateLot;
  int? ipoResultDomesticCorporateRate;
  int? ipoResultGroupEmployeesPerson;
  int? ipoResultGroupEmployeesLot;
  int? ipoResultGroupEmployeesRate;
  int? ipoResultAbroadCorporatePerson;
  int? ipoResultAbroadCorporateLot;
  int? ipoResultAbroadCorporateRate;
  String? ipoResultFootnotes;
  String ipoId;
  String ipoDemandId;
  bool isDemanded;
  int ipoDemandExtId;
  double unitsDemanded;
  String equity;
  String detail;
  String accountExtId;

  IpoDetailModel({
    this.id,
    this.ipoAttachments,
    this.ipoLinks,
    this.companyName,
    this.companyLogo,
    this.symbol,
    this.companyWebsite,
    this.startDate,
    this.endDate,
    this.startPrice,
    this.endPrice,
    this.distributionType,
    this.sharesToDistribute,
    this.brokerageFirm,
    this.freeFloatingShares,
    this.freeFloatingShareRate,
    this.market,
    this.bistFirstTransactionDate,
    this.ipoStatus,
    this.companyDetailInfo,
    this.ipoTypeCapitalIncrease,
    this.ipoTypeStockholderSale,
    this.ipoTypeReference,
    this.ipoSaleType,
    this.ipoSaleTypeReference,
    this.ipoFundUsingInfo,
    this.ipoFundUsingInfoReference,
    this.allotments,
    this.allotmentsReference,
    this.sharesDistributed,
    this.sharesDistributedReference,
    this.financialTablePeriod1,
    this.financialTableRevenues1,
    this.financialTableGrossProfit1,
    this.financialTablePeriod2,
    this.financialTableRevenues2,
    this.financialTableGrossProfit2,
    this.financialTablePeriod3,
    this.financialTableRevenues3,
    this.financialTableGrossProfit3,
    this.financialTableReference,
    this.priceStability,
    this.priceStabilityReference,
    this.shareKeepingPromises,
    this.shareKeepingPromisesReference,
    this.publicityRate,
    this.publicityRateReference,
    this.discount,
    this.discountReference,
    this.size,
    this.sizeReference,
    this.summaryFootnotes,
    this.ipoResultDomesticIndividualPerson,
    this.ipoResultDomesticIndividualLot,
    this.ipoResultDomesticIndividualRate,
    this.ipoResultDomesticCorporatePerson,
    this.ipoResultDomesticCorporateLot,
    this.ipoResultDomesticCorporateRate,
    this.ipoResultGroupEmployeesPerson,
    this.ipoResultGroupEmployeesLot,
    this.ipoResultGroupEmployeesRate,
    this.ipoResultAbroadCorporatePerson,
    this.ipoResultAbroadCorporateLot,
    this.ipoResultAbroadCorporateRate,
    this.ipoResultFootnotes,
    this.ipoId = '',
    this.ipoDemandId = '',
    this.isDemanded = false,
    this.ipoDemandExtId = 0,
    this.unitsDemanded = 0.0,
    this.equity = '',
    this.detail = '',
    this.accountExtId = '',
  });

  factory IpoDetailModel.fromJson(Map json) {
    return IpoDetailModel(
      id: json['id'],
      ipoAttachments: (json['ipoAttachments'] as List<dynamic>?)?.map((e) => IpoAttachments.fromJson(e)).toList(),
      ipoLinks: (json['ipoLinks'] as List<dynamic>?)?.map((e) => IpoLinks.fromJson(e)).toList(),
      companyName: json['companyName'],
      companyLogo: json['companyLogo'],
      symbol: json['symbol'],
      companyWebsite: json['companyWebsite'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      startPrice: json['startPrice'],
      endPrice: json['endPrice'],
      distributionType: json['distributionType'],
      sharesToDistribute: json['sharesToDistribute'],
      brokerageFirm: json['brokerageFirm'],
      freeFloatingShares: json['freeFloatingShares'],
      freeFloatingShareRate: json['freeFloatingShareRate'],
      market: json['market'],
      bistFirstTransactionDate: json['bistFirstTransactionDate'],
      ipoStatus: json['ipoStatus'],
      companyDetailInfo: json['companyDetailInfo'],
      ipoTypeCapitalIncrease: json['ipoTypeCapitalIncrease'],
      ipoTypeStockholderSale: json['ipoTypeStockholderSale'],
      ipoTypeReference: json['ipoTypeReference'],
      ipoSaleType: json['ipoSaleType'],
      ipoSaleTypeReference: json['ipoSaleTypeReference'],
      ipoFundUsingInfo: json['ipoFundUsingInfo'],
      ipoFundUsingInfoReference: json['ipoFundUsingInfoReference'],
      allotments: json['allotments'],
      allotmentsReference: json['allotmentsReference'],
      sharesDistributed: json['sharesDistributed'],
      sharesDistributedReference: json['sharesDistributedReference'],
      financialTablePeriod1: json['financialTablePeriod1'],
      financialTableRevenues1: json['financialTableRevenues1'],
      financialTableGrossProfit1: json['financialTableGrossProfit1'],
      financialTablePeriod2: json['financialTablePeriod2'],
      financialTableRevenues2: json['financialTableRevenues2'],
      financialTableGrossProfit2: json['financialTableGrossProfit2'],
      financialTablePeriod3: json['financialTablePeriod3'],
      financialTableRevenues3: json['financialTableRevenues3'],
      financialTableGrossProfit3: json['financialTableGrossProfit3'],
      financialTableReference: json['financialTableReference'],
      priceStability: json['priceStability'],
      priceStabilityReference: json['priceStabilityReference'],
      shareKeepingPromises: json['shareKeepingPromises'],
      shareKeepingPromisesReference: json['shareKeepingPromisesReference'],
      publicityRate: json['publicityRate'],
      publicityRateReference: json['publicityRateReference'],
      discount: json['discount'],
      discountReference: json['discountReference'],
      size: json['size'],
      sizeReference: json['sizeReference'],
      summaryFootnotes: json['summaryFootnotes'],
      ipoResultDomesticIndividualPerson: json['ipoResultDomesticIndividualPerson'],
      ipoResultDomesticIndividualLot: json['ipoResultDomesticIndividualLot'],
      ipoResultDomesticIndividualRate: json['ipoResultDomesticIndividualRate'],
      ipoResultDomesticCorporatePerson: json['ipoResultDomesticCorporatePerson'],
      ipoResultDomesticCorporateLot: json['ipoResultDomesticCorporateLot'],
      ipoResultDomesticCorporateRate: json['ipoResultDomesticCorporateRate'],
      ipoResultGroupEmployeesPerson: json['ipoResultGroupEmployeesPerson'],
      ipoResultGroupEmployeesLot: json['ipoResultGroupEmployeesLot'],
      ipoResultGroupEmployeesRate: json['ipoResultGroupEmployeesRate'],
      ipoResultAbroadCorporatePerson: json['ipoResultAbroadCorporatePerson'],
      ipoResultAbroadCorporateLot: json['ipoResultAbroadCorporateLot'],
      ipoResultAbroadCorporateRate: json['ipoResultAbroadCorporateRate'],
      ipoResultFootnotes: json['ipoResultFootnotes'],
    );
  }
}

class IpoAttachments {
  int? ipoId;
  int? parentIpoAttachmentId;
  String? title;
  String? url;
  List<dynamic>? children;

  IpoAttachments({
    this.ipoId,
    this.parentIpoAttachmentId,
    this.title,
    this.url,
    this.children,
  });

  IpoAttachments.fromJson(Map<String, dynamic> json) {
    ipoId = json['ipoId'];
    parentIpoAttachmentId = json['parentIpoAttachmentId'];
    title = json['title'];
    url = json['url'];
    children = json['children'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ipoId'] = ipoId;
    data['parentIpoAttachmentId'] = parentIpoAttachmentId;
    data['title'] = title;
    data['url'] = url;
    data['children'] = children;
    return data;
  }
}

class IpoLinks {
  int? ipoId;
  String? title;
  String? description;
  String? url;

  IpoLinks({this.ipoId, this.title, this.description, this.url});

  IpoLinks.fromJson(Map<String, dynamic> json) {
    ipoId = json['ipoId'];
    title = json['title'];
    description = json['description'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ipoId'] = ipoId;
    data['title'] = title;
    data['description'] = description;
    data['url'] = url;
    return data;
  }
}
