enum CryptoEnum {
  btcTurk('A', ''),
  binance('B', '_BIN'),
  bitmex('C', '_BMEX');

  final String marketCode;
  final String suffix;
  const CryptoEnum(this.marketCode, this.suffix);
}
