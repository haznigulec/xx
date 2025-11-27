enum UsMarketMovers {
  gainers('gainers', 'usEquityStats.high', 'high.show_all_symbols', 'us_equity.gainers.all'),
  losers('losers', 'usEquityStats.low', 'low.show_all_symbols', 'us_equity.losers.all');

  final String value;
  final String localizationKey;
  final String localizationShowAllKey;
  final String localizationListingTitleKey;

  const UsMarketMovers(
    this.value,
    this.localizationKey,
    this.localizationShowAllKey,
    this.localizationListingTitleKey,
  );
}
