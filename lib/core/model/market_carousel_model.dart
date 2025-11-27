import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/symbol_soruce_enum.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';

class MarketCarouselModel {
  final String code;
  final SymbolTypes symbolType;
  final SymbolSourceEnum symbolSource;
  final CurrencyEnum currencyType;

  MarketCarouselModel({
    required this.code,
    required this.symbolType,
    required this.symbolSource,
    required this.currencyType,
  });

  factory MarketCarouselModel.fromJson(Map<String, dynamic> json) {
    SymbolTypes symbolType = SymbolTypes.values.firstWhere(
      (element) => element.dbKey == json['Type'],
      orElse: () => SymbolTypes.equity,
    );

    SymbolSourceEnum symbolSource = SymbolSourceEnum.values.firstWhere(
      (element) => element.symbolTypes.contains(symbolType),
      orElse: () => SymbolSourceEnum.matriks,
    );
    CurrencyEnum currencyType = CurrencyEnum.values.firstWhere(
      (e) => e.shortName == json['CurrencyType'],
      orElse: () => CurrencyEnum.turkishLira,
    );
    return MarketCarouselModel(
      code: json['Code'],
      symbolType: symbolType,
      symbolSource: symbolSource,
      currencyType: currencyType,
    );
  }
}
