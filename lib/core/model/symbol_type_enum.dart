enum SymbolTypeEnum {
  all(16, 'ALL'),
  eqList(2, 'EQ_LIST'), // Hisse / Varant
  viopList(5, 'VIOP_LIST'), // VIOP
  mfList(16, 'MF_LIST'), // Fon
  wrList(4, 'WR_LIST'),
  fincList(12, 'FINC_LIST'), // Eurobond
  americanStockExchangeList(999, 'AMERICAN_STOCK_EXCHANGES'), // Amerikan Borsası
  ipo(999, 'IPOLIST');

  final int value;
  final String backendValue;

  const SymbolTypeEnum(
    this.value,
    this.backendValue,
  );
}
