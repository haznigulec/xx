enum ParityEnum {
  freeMarketRates('SERBEST', ['I']),
  parities('FOREX', ['A']),
  freeMarketGold('SERBEST', ['D']),
  preciousMetals('FOREX', ['P', 'D']),
  tcmbRates('TCMB', ['A', 'B']);

  final String exchangeCode;
  final List<String> marketCode;
  const ParityEnum(
    this.exchangeCode,
    this.marketCode,
  );
}
