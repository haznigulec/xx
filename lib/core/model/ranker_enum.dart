enum RankerEnum {
  equity('stats', 'tl'),
  warrant('statsWarrant', 'usd'),
  future('statsFuture', 'eur');

  final String symbol;
  final String shortName;
  const RankerEnum(
    this.symbol,
    this.shortName,
  );
}
