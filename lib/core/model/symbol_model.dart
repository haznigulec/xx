import 'package:equatable/equatable.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';

class SymbolModel extends Equatable {
  final String id;
  final String name;
  final String typeCode;
  final String exchangeCode;
  final String logo;
  final String marketId;
  final String exchangeId;
  final String sectorId;
  final String marketDesc;
  final String description;
  final String isinCode;
  final String underlyingId;
  final String parentsString;
  final String marketCode;
  final String swapType;
  final String actionType;
  final String fundCode;
  final String fundTitle;
  final String fundFounderCode;
  final String fundTefasStatus;
  final String underlyingName;
  final String issuer;
  final String maturityDate;

  const SymbolModel({
    this.id = '',
    this.name = '',
    this.typeCode = '',
    this.exchangeCode = '',
    this.logo = '',
    this.marketId = '',
    this.exchangeId = '',
    this.sectorId = '',
    this.marketDesc = '',
    this.description = '',
    this.isinCode = '',
    this.underlyingId = '',
    this.parentsString = '',
    this.marketCode = '',
    this.swapType = '',
    this.actionType = '',
    this.fundCode = '',
    this.fundTitle = '',
    this.fundFounderCode = '',
    this.fundTefasStatus = '',
    this.underlyingName = '',
    this.issuer = '',
    this.maturityDate = '',
  });

  factory SymbolModel.fromMap(dynamic map) => SymbolModel(
        id: map['Id'] ?? '',
        name: map['Name'] ?? '',
        typeCode: map['TypeCode'].toString(),
        exchangeCode: map['ExchangeCode'] ?? '',
        logo: map['Logo'] ?? '',
        marketId: map['MarketId'] ?? '',
        exchangeId: map['ExchangeId'] ?? '',
        sectorId: map['SectorId'] ?? '',
        marketDesc: map['MarketDesc'] ?? '',
        description: map['Description'] ?? '',
        isinCode: map['IsinCode'] ?? '',
        underlyingId: map['UnderlyingId'].toString(),
        parentsString: map['ParentsString'] ?? '',
        marketCode: map['MarketCode'] ?? '',
        swapType: map['SwapType'] ?? '',
        actionType: map['ActionType'] ?? '',
        fundCode: map['Code'] ?? '',
        fundTitle: map['Title'] ?? '',
        fundFounderCode: map['FounderCode'] ?? '',
        fundTefasStatus: map['TefasStatus'].toString(),
        underlyingName: map['UnderlyingName'] ?? '',
        issuer: map['Issuer'] ?? '',
        maturityDate: map['MaturityDate'] ?? '',
      );

  factory SymbolModel.fromUsMap(dynamic map) => SymbolModel(
        name: map['ticker'] ?? '',
        description: map['name'] ?? '',
        typeCode: 'FOREIGN',
      );

  factory SymbolModel.fromMarketListModel(MarketListModel symbol) {
    return SymbolModel(
      id: symbol.symbolId.toString(),
      name: symbol.symbolCode,
      typeCode: symbol.type.toString(),
      logo: '',
      marketId: symbol.marketCode,
      exchangeId: '',
      sectorId: '',
      marketDesc: symbol.marketCode,
      description: symbol.description,
      isinCode: symbol.symbolCode,
      underlyingId: symbol.underlying,
      parentsString: '',
      marketCode: symbol.marketCode,
      swapType: symbol.swapType,
      actionType: symbol.actionType,
      fundCode: '',
      fundTitle: '',
      fundFounderCode: '',
      fundTefasStatus: '',
      underlyingName: symbol.underlying,
      issuer: symbol.issuer,
    );
  }

  MarketListModel toMarketListModel() {
    return MarketListModel(
      symbolId: int.parse(id.isEmpty ? '0' : id),
      symbolCode: name,
      type: stringToSymbolType(typeCode).name,
      marketCode: marketId,
      underlying: underlyingName,
      swapType: swapType,
      actionType: actionType,
      updateDate: '',
      issuer: issuer,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'Name': name,
      'TypeCode': typeCode,
      'ExchangeCode': exchangeCode,
      'MarketCode': marketCode,
      'MarketDesc': marketDesc,
      'Description': description,
      'Code': fundCode,
      'Title': fundTitle,
      'FounderCode': fundFounderCode,
      'TefasStatus': fundTefasStatus,
      'UnderlyingName': underlyingName,
      'Issuer': issuer,
    };
  }

  SymbolModel setName(String newName) {
    return SymbolModel(
      id: id,
      name: newName,
      typeCode: typeCode,
      exchangeCode: exchangeCode,
      logo: logo,
      marketId: marketId,
      exchangeId: exchangeId,
      sectorId: sectorId,
      marketDesc: marketDesc,
      description: description,
      isinCode: isinCode,
      underlyingId: underlyingId,
      parentsString: parentsString,
      marketCode: marketCode,
      swapType: swapType,
      actionType: actionType,
      fundCode: fundCode,
      fundTitle: fundTitle,
      fundFounderCode: fundFounderCode,
      fundTefasStatus: fundTefasStatus,
      underlyingName: underlyingName,
      issuer: issuer,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        typeCode,
        exchangeCode,
        logo,
        marketId,
        exchangeId,
        sectorId,
        marketDesc,
        description,
        isinCode,
        underlyingId,
        parentsString,
        marketCode,
        swapType,
        actionType,
        fundCode,
        fundTitle,
        fundFounderCode,
        fundTefasStatus,
        underlyingName,
        issuer,
        maturityDate,
      ];
}
