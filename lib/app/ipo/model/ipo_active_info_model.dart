class IpoActiveInfoModel {
  List<DefinitionsList>? definitionsList;
  Null ipoDefinationDetails;
  List<Null>? ipoCustomFieldList;
  List<Null>? ipoDemandCustomFieldList;
  Null ipoDemands;
  List<IpoDetailsList>? ipoDetailsList;
  String? token;

  IpoActiveInfoModel({
    this.definitionsList,
    this.ipoDefinationDetails,
    this.ipoCustomFieldList,
    this.ipoDemandCustomFieldList,
    this.ipoDemands,
    this.ipoDetailsList,
    this.token,
  });

  factory IpoActiveInfoModel.fromJson(Map<String, dynamic> json) {
    return IpoActiveInfoModel(
      definitionsList: json['definitionsList']
          .map<DefinitionsList>(
            (dynamic element) => DefinitionsList.fromJson(element),
          )
          .toList(),
      ipoDetailsList: json['ipoDetailsList']
          .map<IpoDetailsList>(
            (dynamic element) => IpoDetailsList.fromJson(element),
          )
          .toList(),
      token: json['token'],
    );
  }
}

class DefinitionsList {
  String? ipoId;
  String? orgId;
  String? name;
  String? description;
  String? finInstId;
  String? offerType;
  String? reason;
  String? commitment;
  double? units;
  double? amount;
  double? ratio;
  double? oldUnits;
  double? oldRatio;
  double? totalCapital;
  String? sellStartDate;
  String? sellEndDate;
  String? quotationDate;
  String? consortiumFlag;
  String? abroadSell;
  double? abroadLocation;
  double? instutionAllocation;
  String? demandCollectionType;
  double? price;
  double? realizedPrice;
  String? subscription;
  String? ipoAccountId;
  double? interest;
  double? managementCommision;
  double? sellCommision;
  double? commitmentCommision;
  double? abroadCommision;
  String? applyFlag;
  String? distributionFlag;
  String? notes;
  dynamic distributionAccRef;
  String? distributionDate;
  String? resultFlag;
  dynamic leaderCode;
  String? finInstDistributionFlag;
  String? finInstDistributionDate;
  dynamic finInstDistributionAccRef;
  String? preRegStartDate;
  String? preRegEndDate;
  bool? preReg;
  double? bigDemandLimit;
  double? installmentCount;
  double? firstInstRatio;
  String? checkBirthDate;
  String? circularDate;
  String? circularNewspaper;
  double? nominal;
  String? eftAccount;
  String? ccAccount;
  String? collectDefaultInterest;
  String? status;
  // Null created;
  String? createdBy;
  String? lastUpd;
  String? lastUpdBy;
  String? currentIpo;
  String? channelPermissionXml;
  dynamic equityInBookRef;
  String? equityInBookDate;
  String? limitIndividualDemandAmount;
  String? takeInterestFromDelayedPayment;
  dynamic finsInstId1;
  dynamic orgGroupId;
  dynamic name1;
  dynamic description1;
  String? created1;
  dynamic createdBy1;
  String? lastUpd1;
  dynamic lastUpdBy1;
  double? unitNominal;
  dynamic currencyId;
  int? roundingCoefficient;
  dynamic status1;
  dynamic finInstTypeId;
  dynamic instrumentName;
  double? minimumNominal;
  dynamic priceXml;
  double? priceStep;
  String? hasSpread;
  dynamic varPriceCustomer;
  String? multiplyOrDivideBlockageRate;
  double? mfPayRatioForLiquidFunds;
  double? mfPayRatioForFundTypeA;
  double? mfPayRatioForFundTypeB;
  String? ipoType;
  InvestorTypes? investorTypes;
  String? ipoTransactionType;
  String? moneyBackPaymentMethod;
  String? mkReturnType;
  List<PaymentType> paymentType;
  List<PaymentType> highDemandPaymentTypes;
  double? maxBlockedQuantity;
  String? paymentMethod;
  // Null ipoDemandExtId;
  String? demandGatheringType2;
  String? autoDemandMap;
  double? lowerPrice;
  double? maxPrice;
  double? minPrice;
  double? priceCount;
  bool? byInstallments;

  DefinitionsList({
    this.ipoId,
    this.orgId,
    this.name,
    this.description,
    this.finInstId,
    this.offerType,
    this.reason,
    this.commitment,
    this.units,
    this.amount,
    this.ratio,
    this.oldUnits,
    this.oldRatio,
    this.totalCapital,
    this.sellStartDate,
    this.sellEndDate,
    this.quotationDate,
    this.consortiumFlag,
    this.abroadSell,
    this.abroadLocation,
    this.instutionAllocation,
    this.demandCollectionType,
    this.price,
    this.realizedPrice,
    this.subscription,
    this.ipoAccountId,
    this.interest,
    this.managementCommision,
    this.sellCommision,
    this.commitmentCommision,
    this.abroadCommision,
    this.applyFlag,
    this.distributionFlag,
    this.notes,
    this.distributionAccRef,
    this.distributionDate,
    this.resultFlag,
    this.leaderCode,
    this.finInstDistributionFlag,
    this.finInstDistributionDate,
    this.finInstDistributionAccRef,
    this.preRegStartDate,
    this.preRegEndDate,
    this.preReg,
    this.bigDemandLimit,
    this.installmentCount,
    this.firstInstRatio,
    this.checkBirthDate,
    this.circularDate,
    this.circularNewspaper,
    this.nominal,
    this.eftAccount,
    this.ccAccount,
    this.collectDefaultInterest,
    this.status,
    // this.created,
    this.createdBy,
    this.lastUpd,
    this.lastUpdBy,
    this.currentIpo,
    this.channelPermissionXml,
    this.equityInBookRef,
    this.equityInBookDate,
    this.limitIndividualDemandAmount,
    this.takeInterestFromDelayedPayment,
    this.finsInstId1,
    this.orgGroupId,
    this.name1,
    this.description1,
    this.created1,
    this.createdBy1,
    this.lastUpd1,
    this.lastUpdBy1,
    this.unitNominal,
    this.currencyId,
    this.roundingCoefficient,
    this.status1,
    this.finInstTypeId,
    this.instrumentName,
    this.minimumNominal,
    this.priceXml,
    this.priceStep,
    this.hasSpread,
    this.varPriceCustomer,
    this.multiplyOrDivideBlockageRate,
    this.mfPayRatioForLiquidFunds,
    this.mfPayRatioForFundTypeA,
    this.mfPayRatioForFundTypeB,
    this.ipoType,
    this.investorTypes,
    this.ipoTransactionType,
    this.moneyBackPaymentMethod,
    this.mkReturnType,
    this.paymentType = const [],
    this.highDemandPaymentTypes = const [],
    this.maxBlockedQuantity,
    this.paymentMethod,
    // this.ipoDemandExtId,
    this.demandGatheringType2,
    this.autoDemandMap,
    this.lowerPrice,
    this.maxPrice,
    this.minPrice,
    this.priceCount,
    this.byInstallments,
  });

  factory DefinitionsList.fromJson(Map<String, dynamic> json) {
    return DefinitionsList(
      ipoId: json['ipoId'],
      orgId: json['orgId'],
      name: json['name'],
      description: json['description'],
      finInstId: json['finInstId'],
      offerType: json['offerType'],
      reason: json['reason'],
      commitment: json['commitment'],
      units: double.parse(json['units'].toString()),
      amount: double.parse(json['amount'].toString()),
      ratio: double.parse(json['ratio'].toString()),
      oldUnits: double.parse(json['oldUnits'].toString()),
      oldRatio: double.parse(json['oldRatio'].toString()),
      totalCapital: double.parse(json['totalCapital'].toString()),
      sellStartDate: json['sellStartDate'],
      sellEndDate: json['sellEndDate'],
      quotationDate: json['quotationDate'],
      consortiumFlag: json['consortiumFlag'],
      abroadSell: json['abroadSell'],
      abroadLocation: double.parse(json['abroadLocation'].toString()),
      instutionAllocation: double.parse(json['instutionAllocation'].toString()),
      demandCollectionType: json['demandCollectionType'],
      price: double.parse(json['price'].toString()),
      realizedPrice: double.parse(json['realizedPrice'].toString()),
      subscription: json['subscription'],
      ipoAccountId: json['ipoAccountId'],
      interest: double.parse(json['interest'].toString()),
      managementCommision: double.parse(json['managementCommision'].toString()),
      sellCommision: double.parse(json['sellCommision'].toString()),
      commitmentCommision: double.parse(json['commitmentCommision'].toString()),
      abroadCommision: double.parse(json['abroadCommision'].toString()),
      applyFlag: json['applyFlag'],
      distributionFlag: json['distributionFlag'],
      notes: json['notes'],
      distributionAccRef: json['distributionAccRef'],
      distributionDate: json['distributionDate'],
      resultFlag: json['resultFlag'],
      leaderCode: json['leaderCode'],
      finInstDistributionFlag: json['finInstDistributionFlag'],
      finInstDistributionDate: json['finInstDistributionDate'],
      finInstDistributionAccRef: json['finInstDistributionAccRef'],
      preRegStartDate: json['preRegStartDate'],
      preRegEndDate: json['preRegEndDate'],
      preReg: json['preReg'],
      bigDemandLimit: double.parse(json['bigDemandLimit'].toString()),
      installmentCount: double.parse(json['installmentCount'].toString()),
      firstInstRatio: double.parse(json['firstInstRatio'].toString()),
      checkBirthDate: json['checkBirthDate'],
      circularDate: json['circularDate'],
      circularNewspaper: json['circularNewspaper'],
      nominal: double.parse(json['nominal'].toString()),
      eftAccount: json['eftAccount'],
      ccAccount: json['ccAccount'],
      collectDefaultInterest: json['collectDefaultInterest'],
      status: json['status'],
      // created: json['created'],
      createdBy: json['createdBy'],
      lastUpd: json['lastUpd'],
      lastUpdBy: json['lastUpdBy'],
      currentIpo: json['currentIpo'],
      channelPermissionXml: json['channelPermissionXml'],
      equityInBookRef: json['equityInBookRef'],
      equityInBookDate: json['equityInBookDate'],
      limitIndividualDemandAmount: json['limitIndividualDemandAmount'],
      takeInterestFromDelayedPayment: json['takeInterestFromDelayedPayment'],
      finsInstId1: json['finsInstId1'],
      orgGroupId: json['orgGroupId'],
      name1: json['name1'],
      description1: json['description1'],
      created1: json['created1'],
      createdBy1: json['createdBy1'],
      lastUpd1: json['lastUpd1'],
      lastUpdBy1: json['lastUpdBy1'],
      unitNominal: double.parse(json['unitNominal'].toString()),
      currencyId: json['currencyId'],
      roundingCoefficient: json['roundingCoefficient'],
      status1: json['status1'],
      finInstTypeId: json['finInstTypeId'],
      instrumentName: json['instrumentName'],
      minimumNominal: double.parse(json['minimumNominal'].toString()),
      priceXml: json['priceXml'],
      priceStep: double.parse(json['priceStep'].toString()),
      hasSpread: json['hasSpread'],
      varPriceCustomer: json['varPriceCustomer'],
      multiplyOrDivideBlockageRate: json['multiplyOrDivideBlockageRate'],
      mfPayRatioForLiquidFunds: json['mfPayRatioForLiquidFunds'],
      mfPayRatioForFundTypeA: json['mfPayRatioForFundTypeA'],
      mfPayRatioForFundTypeB: json['mfPayRatioForFundTypeB'],
      ipoType: json['ipoType'],
      investorTypes: json['investorTypes'] != null ? InvestorTypes.fromJson(json['investorTypes']) : null,
      ipoTransactionType: json['ipoTransactionType'],
      moneyBackPaymentMethod: json['moneyBackPaymentMethod'],
      mkReturnType: json['mkReturnType'],
      paymentType: json['paymentType'] != null
          ? json['paymentType'].keys.map<PaymentType>((e) => PaymentType.fromJson(e, json['paymentType'][e])).toList()
          : [],
      highDemandPaymentTypes: json['highDemandPaymentTypes'] != null
          ? json['highDemandPaymentTypes']
              .keys
              .map<PaymentType>((e) => PaymentType.fromJson(e, json['highDemandPaymentTypes'][e]))
              .toList()
          : [],
      maxBlockedQuantity: json['maxBlockedQuantity'].toDouble(),
      paymentMethod: json['paymentMethod'],
      // ipoDemandExtId: json['ipoDemandExtId'],
      demandGatheringType2: json['demandGatheringType2'],
      autoDemandMap: json['autoDemandMap'],
      lowerPrice: double.parse(json['lowerPrice'].toString()),
      maxPrice: double.parse(json['maxPrice'].toString()),
      minPrice: double.parse(json['minPrice'].toString()),
      priceCount: double.parse(json['priceCount'].toString()),
      byInstallments: json['byInstallments'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ipoId'] = ipoId;
    data['orgId'] = orgId;
    data['name'] = name;
    data['description'] = description;
    data['finInstId'] = finInstId;
    data['offerType'] = offerType;
    data['reason'] = reason;
    data['commitment'] = commitment;
    data['units'] = units;
    data['amount'] = amount;
    data['ratio'] = ratio;
    data['oldUnits'] = oldUnits;
    data['oldRatio'] = oldRatio;
    data['totalCapital'] = totalCapital;
    data['sellStartDate'] = sellStartDate;
    data['sellEndDate'] = sellEndDate;
    data['quotationDate'] = quotationDate;
    data['consortiumFlag'] = consortiumFlag;
    data['abroadSell'] = abroadSell;
    data['abroadLocation'] = abroadLocation;
    data['instutionAllocation'] = instutionAllocation;
    data['demandCollectionType'] = demandCollectionType;
    data['price'] = price;
    data['realizedPrice'] = realizedPrice;
    data['subscription'] = subscription;
    data['ipoAccountId'] = ipoAccountId;
    data['interest'] = interest;
    data['managementCommision'] = managementCommision;
    data['sellCommision'] = sellCommision;
    data['commitmentCommision'] = commitmentCommision;
    data['abroadCommision'] = abroadCommision;
    data['applyFlag'] = applyFlag;
    data['distributionFlag'] = distributionFlag;
    data['notes'] = notes;
    data['distributionAccRef'] = distributionAccRef;
    data['distributionDate'] = distributionDate;
    data['resultFlag'] = resultFlag;
    data['leaderCode'] = leaderCode;
    data['finInstDistributionFlag'] = finInstDistributionFlag;
    data['finInstDistributionDate'] = finInstDistributionDate;
    data['finInstDistributionAccRef'] = finInstDistributionAccRef;
    data['preRegStartDate'] = preRegStartDate;
    data['preRegEndDate'] = preRegEndDate;
    data['preReg'] = preReg;
    data['bigDemandLimit'] = bigDemandLimit;
    data['installmentCount'] = installmentCount;
    data['firstInstRatio'] = firstInstRatio;
    data['checkBirthDate'] = checkBirthDate;
    data['circularDate'] = circularDate;
    data['circularNewspaper'] = circularNewspaper;
    data['nominal'] = nominal;
    data['eftAccount'] = eftAccount;
    data['ccAccount'] = ccAccount;
    data['collectDefaultInterest'] = collectDefaultInterest;
    data['status'] = status;
    // data['created'] = this.created;
    data['createdBy'] = createdBy;
    data['lastUpd'] = lastUpd;
    data['lastUpdBy'] = lastUpdBy;
    data['currentIpo'] = currentIpo;
    data['channelPermissionXml'] = channelPermissionXml;
    data['equityInBookRef'] = equityInBookRef;
    data['equityInBookDate'] = equityInBookDate;
    data['limitIndividualDemandAmount'] = limitIndividualDemandAmount;
    data['takeInterestFromDelayedPayment'] = takeInterestFromDelayedPayment;
    data['finsInstId1'] = finsInstId1;
    data['orgGroupId'] = orgGroupId;
    data['name1'] = name1;
    data['description1'] = description1;
    data['created1'] = created1;
    data['createdBy1'] = createdBy1;
    data['lastUpd1'] = lastUpd1;
    data['lastUpdBy1'] = lastUpdBy1;
    data['unitNominal'] = unitNominal;
    data['currencyId'] = currencyId;
    data['roundingCoefficient'] = roundingCoefficient;
    data['status1'] = status1;
    data['finInstTypeId'] = finInstTypeId;
    data['instrumentName'] = instrumentName;
    data['minimumNominal'] = minimumNominal;
    data['priceXml'] = priceXml;
    data['priceStep'] = priceStep;
    data['hasSpread'] = hasSpread;
    data['varPriceCustomer'] = varPriceCustomer;
    data['multiplyOrDivideBlockageRate'] = multiplyOrDivideBlockageRate;
    data['mfPayRatioForLiquidFunds'] = mfPayRatioForLiquidFunds;
    data['mfPayRatioForFundTypeA'] = mfPayRatioForFundTypeA;
    data['mfPayRatioForFundTypeB'] = mfPayRatioForFundTypeB;
    data['ipoType'] = ipoType;
    if (investorTypes != null) {
      data['investorTypes'] = investorTypes!.toJson();
    }
    data['ipoTransactionType'] = ipoTransactionType;
    data['moneyBackPaymentMethod'] = moneyBackPaymentMethod;
    data['mkReturnType'] = mkReturnType;
    // if (this.paymentType != null) {
    //   data['paymentType'] = this.paymentType!.toJson();
    // }
    data['paymentMethod'] = paymentMethod;
    // data['ipoDemandExtId'] = this.ipoDemandExtId;
    data['demandGatheringType2'] = demandGatheringType2;
    data['autoDemandMap'] = autoDemandMap;
    data['lowerPrice'] = lowerPrice;
    data['maxPrice'] = maxPrice;
    data['minPrice'] = minPrice;
    data['priceCount'] = priceCount;
    data['byInstallments'] = byInstallments;
    return data;
  }
}

class InvestorTypes {
  String? s0000000002INT;
  String? s0000000003INT;
  String? s0000000009INT;
  String? s000000000DINT;

  InvestorTypes({
    this.s0000000002INT,
    this.s0000000003INT,
    this.s0000000009INT,
    this.s000000000DINT,
  });

  InvestorTypes.fromJson(Map<String, dynamic> json) {
    s0000000002INT = json['0000-000002-INT'];
    s0000000003INT = json['0000-000003-INT'];
    s0000000009INT = json['0000-000009-INT'];
    s000000000DINT = json['0000-00000D-INT'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['0000-000002-INT'] = s0000000002INT;
    data['0000-000003-INT'] = s0000000003INT;
    data['0000-000009-INT'] = s0000000009INT;
    data['0000-00000D-INT'] = s000000000DINT;
    return data;
  }
}

class PaymentType {
  String key;
  String title;

  PaymentType({
    required this.key,
    required this.title,
  });

  PaymentType.fromJson(this.key, String value) : title = value;
}

class IpoDetailsList {
  String? orgId;
  String? ipoId;
  String? name;
  String? description;
  String? finInstId;

  IpoDetailsList({
    this.orgId,
    this.ipoId,
    this.name,
    this.description,
    this.finInstId,
  });

  IpoDetailsList.fromJson(Map<String, dynamic> json) {
    orgId = json['orgId'];
    ipoId = json['ipoId'];
    name = json['name'];
    description = json['description'];
    finInstId = json['finInstId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['orgId'] = orgId;
    data['ipoId'] = ipoId;
    data['name'] = name;
    data['description'] = description;
    data['finInstId'] = finInstId;
    return data;
  }
}
