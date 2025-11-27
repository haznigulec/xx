enum MarketMenu {
  istanbulStockExchange(0),
  americanStockExchanges(1),
  investmentFund(2),
  ipo(3),
  eurobond(4),
  currencyParity(5),
  crypto(6),
  favorites(7),
  journal(8);

  const MarketMenu(this.value);
  final int value;
}
