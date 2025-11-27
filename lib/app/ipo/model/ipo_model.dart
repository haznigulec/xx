
import 'package:equatable/equatable.dart';

class IpoModel extends Equatable {
  final int id;
  final List<IpoAttachments>? ipoAttachments;
  final List<IpoLinks>? ipoLinks;
  final List<IpoDemandModel>? ipoDemandeds;
  final String? companyName;
  final String? companyLogo;
  final String? symbol;
  final String? companyWebsite;
  final String? startDate;
  final String? endDate;
  final double? startPrice;
  final double? endPrice;
  final String? distributionType;
  final int? sharesToDistribute;
  final String? brokerageFirm;
  final String? freeFloatingShares;
  final String? freeFloatingShareRate;
  final String? market;
  final String? bistFirstTransactionDate;
  final int? ipoStatus;
  final String? companyDetailInfo;
  final String? ipoTypeCapitalIncrease;
  final String? ipoTypeStockholderSale;
  final String? ipoTypeReference;
  final String? ipoSaleType;
  final String? ipoSaleTypeReference;
  final String? ipoFundUsingInfo;
  final String? ipoFundUsingInfoReference;
  final String? allotments;
  final String? allotmentsReference;
  final String? sharesDistributed;
  final String? sharesDistributedReference;
  final String? financialTablePeriod1;
  final String? financialTableRevenues1;
  final String? financialTableGrossProfit1;
  final String? financialTablePeriod2;
  final String? financialTableRevenues2;
  final String? financialTableGrossProfit2;
  final String? financialTablePeriod3;
  final String? financialTableRevenues3;
  final String? financialTableGrossProfit3;
  final String? financialTableReference;
  final String? priceStability;
  final String? priceStabilityReference;
  final String? shareKeepingPromises;
  final String? shareKeepingPromisesReference;
  final String? publicityRate;
  final String? publicityRateReference;
  final String? discount;
  final String? discountReference;
  final String? size;
  final String? sizeReference;
  final String? summaryFootnotes;
  final int? ipoResultDomesticIndividualPerson;
  final int? ipoResultDomesticIndividualLot;
  final int? ipoResultDomesticIndividualRate;
  final int? ipoResultDomesticCorporatePerson;
  final int? ipoResultDomesticCorporateLot;
  final int? ipoResultDomesticCorporateRate;
  final int? ipoResultGroupEmployeesPerson;
  final int? ipoResultGroupEmployeesLot;
  final int? ipoResultGroupEmployeesRate;
  final int? ipoResultAbroadCorporatePerson;
  final int? ipoResultAbroadCorporateLot;
  final int? ipoResultAbroadCorporateRate;
  final String? ipoResultFootnotes;
  final String ipoId;
  final String ipoDemandId;
  final bool isDemanded;
  final int ipoDemandExtId;
  final double unitsDemanded;
  final String equity;
  final String detail;
  final String accountExtId;

  const IpoModel({
    this.ipoAttachments,
    this.ipoLinks,
    this.ipoDemandeds,
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
    required this.id,
  });

  factory IpoModel.fromJson(Map<String, dynamic> json) {
    return IpoModel(
      ipoAttachments: json['ipoAttachments']
          ?.map<IpoAttachments>(
            (dynamic element) => IpoAttachments.fromJson(element),
          )
          .toList(),
      ipoLinks: json['ipoLinks']
          ?.map<IpoLinks>(
            (dynamic element) => IpoLinks.fromJson(element),
          )
          .toList(),
      ipoDemandeds: json['ipoDemanded']
          ?.map<IpoDemandModel>(
            (dynamic element) => IpoDemandModel.fromJson(element),
          )
          .toList(),
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
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (ipoAttachments != null) {
      data['ipoAttachments'] = ipoAttachments!.map((v) => v.toJson()).toList();
    }
    if (ipoLinks != null) {
      data['ipoLinks'] = ipoLinks!.map((v) => v.toJson()).toList();
    }
    data['companyName'] = companyName;
    data['companyLogo'] = companyLogo;
    data['symbol'] = symbol;
    data['companyWebsite'] = companyWebsite;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['startPrice'] = startPrice;
    data['endPrice'] = endPrice;
    data['distributionType'] = distributionType;
    data['sharesToDistribute'] = sharesToDistribute;
    data['brokerageFirm'] = brokerageFirm;
    data['freeFloatingShares'] = freeFloatingShares;
    data['freeFloatingShareRate'] = freeFloatingShareRate;
    data['market'] = market;
    data['bistFirstTransactionDate'] = bistFirstTransactionDate;
    data['ipoStatus'] = ipoStatus;
    data['companyDetailInfo'] = companyDetailInfo;
    data['ipoTypeCapitalIncrease'] = ipoTypeCapitalIncrease;
    data['ipoTypeStockholderSale'] = ipoTypeStockholderSale;
    data['ipoTypeReference'] = ipoTypeReference;
    data['ipoSaleType'] = ipoSaleType;
    data['ipoSaleTypeReference'] = ipoSaleTypeReference;
    data['ipoFundUsingInfo'] = ipoFundUsingInfo;
    data['ipoFundUsingInfoReference'] = ipoFundUsingInfoReference;
    data['allotments'] = allotments;
    data['allotmentsReference'] = allotmentsReference;
    data['sharesDistributed'] = sharesDistributed;
    data['sharesDistributedReference'] = sharesDistributedReference;
    data['financialTablePeriod1'] = financialTablePeriod1;
    data['financialTableRevenues1'] = financialTableRevenues1;
    data['financialTableGrossProfit1'] = financialTableGrossProfit1;
    data['financialTablePeriod2'] = financialTablePeriod2;
    data['financialTableRevenues2'] = financialTableRevenues2;
    data['financialTableGrossProfit2'] = financialTableGrossProfit2;
    data['financialTablePeriod3'] = financialTablePeriod3;
    data['financialTableRevenues3'] = financialTableRevenues3;
    data['financialTableGrossProfit3'] = financialTableGrossProfit3;
    data['financialTableReference'] = financialTableReference;
    data['priceStability'] = priceStability;
    data['priceStabilityReference'] = priceStabilityReference;
    data['shareKeepingPromises'] = shareKeepingPromises;
    data['shareKeepingPromisesReference'] = shareKeepingPromisesReference;
    data['publicityRate'] = publicityRate;
    data['publicityRateReference'] = publicityRateReference;
    data['discount'] = discount;
    data['discountReference'] = discountReference;
    data['size'] = size;
    data['sizeReference'] = sizeReference;
    data['summaryFootnotes'] = summaryFootnotes;
    data['ipoResultDomesticIndividualPerson'] = ipoResultDomesticIndividualPerson;
    data['ipoResultDomesticIndividualLot'] = ipoResultDomesticIndividualLot;
    data['ipoResultDomesticIndividualRate'] = ipoResultDomesticIndividualRate;
    data['ipoResultDomesticCorporatePerson'] = ipoResultDomesticCorporatePerson;
    data['ipoResultDomesticCorporateLot'] = ipoResultDomesticCorporateLot;
    data['ipoResultDomesticCorporateRate'] = ipoResultDomesticCorporateRate;
    data['ipoResultGroupEmployeesPerson'] = ipoResultGroupEmployeesPerson;
    data['ipoResultGroupEmployeesLot'] = ipoResultGroupEmployeesLot;
    data['ipoResultGroupEmployeesRate'] = ipoResultGroupEmployeesRate;
    data['ipoResultAbroadCorporatePerson'] = ipoResultAbroadCorporatePerson;
    data['ipoResultAbroadCorporateLot'] = ipoResultAbroadCorporateLot;
    data['ipoResultAbroadCorporateRate'] = ipoResultAbroadCorporateRate;
    data['ipoResultFootnotes'] = ipoResultFootnotes;
    data['id'] = id;

    return data;
  }

  IpoModel setDemandInfo(
    String ipoId,
    String demandId,
    bool isDemanded,
    int ipoDemandExtId,
    double unitsDemanded,
    String equity,
    String detail,
    String accountExtId,
  ) {
    return IpoModel(
      ipoAttachments: ipoAttachments,
      ipoLinks: ipoLinks,
      companyName: companyName,
      companyLogo: companyLogo,
      symbol: symbol,
      companyWebsite: companyWebsite,
      startDate: startDate,
      endDate: endDate,
      startPrice: startPrice,
      endPrice: endPrice,
      distributionType: distributionType,
      sharesToDistribute: sharesToDistribute,
      brokerageFirm: brokerageFirm,
      freeFloatingShares: freeFloatingShares,
      freeFloatingShareRate: freeFloatingShareRate,
      market: market,
      bistFirstTransactionDate: bistFirstTransactionDate,
      ipoStatus: ipoStatus,
      companyDetailInfo: companyDetailInfo,
      ipoTypeCapitalIncrease: ipoTypeCapitalIncrease,
      ipoTypeStockholderSale: ipoTypeStockholderSale,
      ipoTypeReference: ipoTypeReference,
      ipoSaleType: ipoSaleType,
      ipoSaleTypeReference: ipoSaleTypeReference,
      ipoFundUsingInfo: ipoFundUsingInfo,
      ipoFundUsingInfoReference: ipoFundUsingInfoReference,
      allotments: allotments,
      allotmentsReference: allotmentsReference,
      sharesDistributed: sharesDistributed,
      sharesDistributedReference: sharesDistributedReference,
      financialTablePeriod1: financialTablePeriod1,
      financialTableRevenues1: financialTableRevenues1,
      financialTableGrossProfit1: financialTableGrossProfit1,
      financialTablePeriod2: financialTablePeriod2,
      financialTableRevenues2: financialTableRevenues2,
      financialTableGrossProfit2: financialTableGrossProfit2,
      financialTablePeriod3: financialTablePeriod3,
      financialTableRevenues3: financialTableRevenues3,
      financialTableGrossProfit3: financialTableGrossProfit3,
      financialTableReference: financialTableReference,
      priceStability: priceStability,
      priceStabilityReference: priceStabilityReference,
      shareKeepingPromises: shareKeepingPromises,
      shareKeepingPromisesReference: shareKeepingPromisesReference,
      publicityRate: publicityRate,
      publicityRateReference: publicityRateReference,
      discount: discount,
      discountReference: discountReference,
      size: size,
      sizeReference: sizeReference,
      summaryFootnotes: summaryFootnotes,
      ipoResultDomesticIndividualPerson: ipoResultDomesticIndividualPerson,
      ipoResultDomesticIndividualLot: ipoResultDomesticIndividualLot,
      ipoResultDomesticIndividualRate: ipoResultDomesticIndividualRate,
      ipoResultDomesticCorporatePerson: ipoResultDomesticCorporatePerson,
      ipoResultDomesticCorporateLot: ipoResultDomesticCorporateLot,
      ipoResultDomesticCorporateRate: ipoResultDomesticCorporateRate,
      ipoResultGroupEmployeesPerson: ipoResultGroupEmployeesPerson,
      ipoResultGroupEmployeesLot: ipoResultGroupEmployeesLot,
      ipoResultGroupEmployeesRate: ipoResultGroupEmployeesRate,
      ipoResultAbroadCorporatePerson: ipoResultAbroadCorporatePerson,
      ipoResultAbroadCorporateLot: ipoResultAbroadCorporateLot,
      ipoResultAbroadCorporateRate: ipoResultAbroadCorporateRate,
      ipoResultFootnotes: ipoResultFootnotes,
      id: id,
      ipoId: ipoId,
      ipoDemandId: demandId,
      isDemanded: isDemanded,
      ipoDemandExtId: ipoDemandExtId,
      unitsDemanded: unitsDemanded,
      equity: equity,
      detail: detail,
      accountExtId: accountExtId,
    );
  }

  @override
  List<Object?> get props => [
        ipoAttachments,
        ipoLinks,
        companyName,
        companyLogo,
        symbol,
        companyWebsite,
        startDate,
        endDate,
        startPrice,
        endPrice,
        distributionType,
        sharesToDistribute,
        brokerageFirm,
        freeFloatingShares,
        freeFloatingShareRate,
        market,
        bistFirstTransactionDate,
        ipoStatus,
        companyDetailInfo,
        ipoTypeCapitalIncrease,
        ipoTypeStockholderSale,
        ipoTypeReference,
        ipoSaleType,
        ipoSaleTypeReference,
        ipoFundUsingInfo,
        ipoFundUsingInfoReference,
        allotments,
        allotmentsReference,
        sharesDistributed,
        sharesDistributedReference,
        financialTablePeriod1,
        financialTableRevenues1,
        financialTableGrossProfit1,
        financialTablePeriod2,
        financialTableRevenues2,
        financialTableGrossProfit2,
        financialTablePeriod3,
        financialTableRevenues3,
        financialTableGrossProfit3,
        financialTableReference,
        priceStability,
        priceStabilityReference,
        shareKeepingPromises,
        shareKeepingPromisesReference,
        publicityRate,
        publicityRateReference,
        discount,
        discountReference,
        size,
        sizeReference,
        summaryFootnotes,
        ipoResultDomesticIndividualPerson,
        ipoResultDomesticIndividualLot,
        ipoResultDomesticIndividualRate,
        ipoResultDomesticCorporatePerson,
        ipoResultDomesticCorporateLot,
        ipoResultDomesticCorporateRate,
        ipoResultGroupEmployeesPerson,
        ipoResultGroupEmployeesLot,
        ipoResultGroupEmployeesRate,
        ipoResultAbroadCorporatePerson,
        ipoResultAbroadCorporateLot,
        ipoResultAbroadCorporateRate,
        ipoResultFootnotes,
        id,
        ipoId,
        ipoDemandId,
        isDemanded,
        ipoDemandExtId,
        unitsDemanded,
        equity,
        detail,
        accountExtId,
      ];
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

class IpoDemandModel {
  String? ipoDemandId;
  double? amountDemanded;
  String? description;
  String? distributionDate;
  String? ipoId;
  String? name;
  double? offerPrice;
  String? sellEndDate;
  double? unitsDemanded;
  String? accountExtId;
  double? amountRealized;
  bool? canEdit;
  String? demandDate;
  String? detail;
  String? equity;
  int? ipoDemandExtId;
  double? minimumDemand;
  double? priceRealized;
  double? unitsRealized;

  IpoDemandModel({
    this.ipoDemandId,
    this.amountDemanded,
    this.description,
    this.distributionDate,
    this.ipoId,
    this.name,
    this.offerPrice,
    this.sellEndDate,
    this.unitsDemanded,
    this.accountExtId,
    this.amountRealized,
    this.canEdit,
    this.demandDate,
    this.detail,
    this.equity,
    this.ipoDemandExtId,
    this.minimumDemand,
    this.priceRealized,
    this.unitsRealized,
  });

  IpoDemandModel.fromJson(Map<String, dynamic> json) {
    ipoDemandId = json['ipoDemandId'];
    amountDemanded = double.parse(json['amountDemanded'].toString());
    description = json['description'];
    distributionDate = json['distributionDate'];
    ipoId = json['ipoId'];
    name = json['name'];
    offerPrice = double.parse(json['offerPrice'].toString());
    sellEndDate = json['sellEndDate'];
    unitsDemanded = double.parse(json['unitsDemanded'].toString());
    accountExtId = json['accountExtId'];
    amountRealized = double.parse(json['amountRealized'].toString());
    canEdit = json['canEdit'];
    demandDate = json['demandDate'];
    detail = json['detail'];
    equity = json['equity'];
    ipoDemandExtId = json['ipoDemandExtId'];
    minimumDemand = double.parse(json['minimumDemand'].toString());
    priceRealized = double.parse(json['priceRealized'].toString());
    unitsRealized = double.parse(json['unitsRealized'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amountDemanded'] = amountDemanded;
    data['description'] = description;
    data['distributionDate'] = distributionDate;
    data['ipoId'] = ipoId;
    data['name'] = name;
    data['offerPrice'] = offerPrice;
    data['sellEndDate'] = sellEndDate;
    data['unitsDemanded'] = unitsDemanded;
    data['accountExtId'] = accountExtId;
    data['amountRealized'] = amountRealized;
    data['canEdit'] = canEdit;
    data['demandDate'] = demandDate;
    data['detail'] = detail;
    data['equity'] = equity;
    data['ipoDemandExtId'] = ipoDemandExtId;
    data['minimumDemand'] = minimumDemand;
    data['priceRealized'] = priceRealized;
    data['unitsRealized'] = unitsRealized;
    return data;
  }
}
