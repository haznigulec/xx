enum SymbolSearchFilterEnum {
  all(0, 'all', null),
  equity(2, 'bist_equity', ['EQUITY', 'RIGHT']),
  warrant(4, 'varant', ['WARRANT', 'CERTIFICATE', 'COMMODITY']),
  future(5, 'futures', ['FUTURE']),
  option(6, 'options_market', ['OPTION']),
  foreign(998, 'foreign', ['FOREIGN']),
  fund(999, 'funds', ['FUND']),
  parity(7, 'currency_parity', ['PARITY']),
  preciousMetals(11, 'precious_metals', ['PRECIOUSMETALS']),
  crypto(10, 'crypto', ['CRYPTO']),
  etf(8, 'etf', ['ETF']),
  endeks(3, 'indices', ['INDEX']);

  final int value;
  final String localization;
  final List<String>? dbKeys;

  const SymbolSearchFilterEnum(this.value, this.localization, this.dbKeys);
}
