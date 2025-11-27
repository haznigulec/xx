import 'package:piapiri_v2/app/search_symbol/enum/symbol_search_filter_enum.dart';
import 'package:piapiri_v2/core/model/symbol_type_enum.dart';

enum SymbolTypes {
  equity(2, 'S', 'EQUITY', '', SymbolSearchFilterEnum.equity),
  indexType(3, 'I', 'INDEX', '', SymbolSearchFilterEnum.endeks),
  warrant(4, 'V', 'WARRANT', '', SymbolSearchFilterEnum.warrant),
  future(5, 'F', 'FUTURE', 'futures', SymbolSearchFilterEnum.future),
  option(6, 'O', 'OPTION', 'options_market', SymbolSearchFilterEnum.option),
  parity(7, 'X', 'PARITY', '', SymbolSearchFilterEnum.parity),
  etf(8, 'M', 'ETF', '', SymbolSearchFilterEnum.etf),
  right(9, 'R', 'RIGHT', '', SymbolSearchFilterEnum.equity),
  crypto(10, 'K', 'CRYPTO', '', SymbolSearchFilterEnum.crypto),
  commodity(11, 'E', 'COMMODITY', '', SymbolSearchFilterEnum.warrant),
  bond(12, 'B', 'BOND', '', null),
  libor(13, 'Z', 'LIBOR', '', null),
  certificate(17, 'C', 'CERTIFICATE', 'certificate', SymbolSearchFilterEnum.warrant),
  fund(999, 'FUND', 'FUND', '', SymbolSearchFilterEnum.fund),
  undefined(16, 'UNDEFIED', 'UNDEFINED', '', null),
  foreign(998, 'foreign', 'FOREIGN', '', SymbolSearchFilterEnum.foreign),
  bankIcon(9999, 'BANK', 'BANK', '', null),
  fundFounder(8888, 'FUND_FOUNDER', 'FUND_FOUNDER', '', null),
  marketMaker(7777, 'MARKET_MAKER', 'MARKET_MAKER', '', null);

  final int value;
  final String matriks;
  final String dbKey;
  final String localization;
  final SymbolSearchFilterEnum? filter;

  const SymbolTypes(this.value, this.matriks, this.dbKey, this.localization, this.filter);
}

SymbolTypes stringToSymbolType(String value) {
  String lowerValue = value.toLowerCase();
  switch (lowerValue) {
    case 'equity':
    case 'hisse':
      return SymbolTypes.equity;
    case 'endeks':
    case 'index':
      return SymbolTypes.indexType;
    case 'warrant':
    case 'varant':
      return SymbolTypes.warrant;
    case 'viop':
    case 'future':
      return SymbolTypes.future;
    case 'fund':
    case 'fon':
      return SymbolTypes.fund;
    case 'option':
    case 'opsiyon':
      return SymbolTypes.option;
    case 'parite':
    case 'parity':
      return SymbolTypes.parity;
    case 'etf':
      return SymbolTypes.etf;
    case 'right':
      return SymbolTypes.right;
    case 'kripto':
    case 'crypto':
      return SymbolTypes.crypto;
    case 'emtia':
    case 'commodity':
      return SymbolTypes.commodity;
    case 'bono':
    case 'sgmk':
    case 'bond':
      return SymbolTypes.bond;
    case 'libor':
      return SymbolTypes.libor;
    case 'certificate':
      return SymbolTypes.certificate;
    case 'ab':
    case 'foreign':
      return SymbolTypes.foreign;
    default:
      return SymbolTypes.equity;
  }
}

//SymbolIcon widget için kullanılıyor.
(String, String) symbolTypeToCdnHandleWithExtension(SymbolTypes symbolType) {
  switch (symbolType) {
    case SymbolTypes.equity:
    case SymbolTypes.warrant:
    case SymbolTypes.certificate:
    case SymbolTypes.future:
    case SymbolTypes.option:
      return ('symbols/eq', 'svg');
    case SymbolTypes.bond:
      return ('symbols/finc', 'svg');
    case SymbolTypes.parity:
      return ('symbols/fx', 'svg');
    case SymbolTypes.crypto:
      return ('symbols/crypto', 'svg');
    case SymbolTypes.commodity:
      return ('symbols/comm', 'svg');
    case SymbolTypes.fund:
    case SymbolTypes.fundFounder:
      return ('institutions/fundFounder', 'png');
    case SymbolTypes.marketMaker:
      return ('institutions/marketmaker', 'svg');
    case SymbolTypes.foreign:
      return ('symbols/us', 'png');
    case SymbolTypes.bankIcon:
      return ('bankicons', 'svg');
    // bunlar kesin değil genel çokluğa göre default svg gönderildi
    // svg formatı hata alması halinde png uzantısı SymbolIcon tarafından deneniyor.
    case SymbolTypes.indexType:
    case SymbolTypes.undefined:
    case SymbolTypes.etf:
    case SymbolTypes.libor:
    case SymbolTypes.right:
      return ('symbols/eq', 'svg');
  }
}

String symbolTypeToCdnHandle(SymbolTypes symbolType) {
  switch (symbolType) {
    case SymbolTypes.equity:
    case SymbolTypes.warrant:
    case SymbolTypes.certificate:
    case SymbolTypes.future:
    case SymbolTypes.option:
      return 'symbols/eq';
    case SymbolTypes.bond:
      return 'symbols/finc';
    case SymbolTypes.parity:
      return 'symbols/fx';
    case SymbolTypes.crypto:
      return 'symbols/crypto';
    case SymbolTypes.commodity:
      return 'symbols/comm';
    case SymbolTypes.fund:
    case SymbolTypes.fundFounder:
      return ('institutions/fundFounder');
    case SymbolTypes.marketMaker:
      return ('institutions/marketmaker');
    case SymbolTypes.foreign:
      return 'symbols/us';
    case SymbolTypes.bankIcon:
      return 'bankicons';
    default:
      return 'symbols/eq';
  }
}

SymbolTypes symbolTypeEnumToType(SymbolTypeEnum symbolType) {
  switch (symbolType) {
    case SymbolTypeEnum.eqList:
    case SymbolTypeEnum.viopList:
    case SymbolTypeEnum.wrList:
      return SymbolTypes.equity;
    case SymbolTypeEnum.mfList:
      return SymbolTypes.fund;
    case SymbolTypeEnum.fincList:
      return SymbolTypes.bond;
    case SymbolTypeEnum.americanStockExchangeList:
      return SymbolTypes.foreign;
    default:
      return SymbolTypes.equity;
  }
}
