enum CurrencyEnum {
  turkishLira('₺', 'tl'),
  dollar('\$', 'usd'),
  euro('€', 'eur'),
  pound('£', 'gbp'),
  japaneseYen('¥', 'jpy'),
  other('', '');

  final String symbol;
  final String shortName;
  const CurrencyEnum(
    this.symbol,
    this.shortName,
  );
}
