class FeatureStatus {
  final List<String> enabledFeatures;
  late final bool isAccountEnabled;
  late final bool isExchangeEnabled;
  late final bool isWithdrawEnabled;
  late final bool isDepositEnabled;
  late final bool isBannerEnabled;
  late final bool isFavoriteEnabled;
  late final bool isAgendaEnabled;
  late final bool isBistEnabled;
  late final bool isEquityEnabled;
  late final bool isWarrantEnabled;
  late final bool isViopEnabled;
  late final bool isAnalysisEnabled;
  late final bool isFundsEnabled;
  late final bool isIpoEnabled;
  late final bool isEurobondEnabled;
  late final bool isCurrencyEnabled;
  late final bool isCryptoEnabled;
  late final bool isSectorsEnabled;
  late final bool isHighEnabled;
  late final bool isLowEnabled;
  late final bool isVolumeEnabled;
  late final bool isAdviceEnabled;
  late final bool isModelPortfoliosEnabled;
  late final bool isOrdersEnabled;
  late final bool isMarketEnabled;
  late final bool isPortfolioEnabled;

  FeatureStatus(
    this.enabledFeatures,
  ) {
    isAccountEnabled = isFeatureEnabled(':ACCOUNT:');
    isExchangeEnabled = isFeatureEnabled(':EXCHANGE:');
    isWithdrawEnabled = isFeatureEnabled(':WITHDRAW:');
    isDepositEnabled = isFeatureEnabled(':DEPOSIT:');
    isBannerEnabled = isFeatureEnabled(':BANNER:');
    isFavoriteEnabled = isFeatureEnabled(':FAVORITE:');
    isAgendaEnabled = isFeatureEnabled(':AGENDA:');
    isBistEnabled = isFeatureEnabled(':BIST:');
    isEquityEnabled = isFeatureEnabled(':EQUITY:');
    isWarrantEnabled = isFeatureEnabled(':WARRANT:');
    isViopEnabled = isFeatureEnabled(':VIOP:');
    isAnalysisEnabled = isFeatureEnabled(':ANALYSIS:');
    isFundsEnabled = isFeatureEnabled(':FUNDS:');
    isIpoEnabled = isFeatureEnabled(':IPO:');
    isEurobondEnabled = isFeatureEnabled(':EUROBOND:');
    isCurrencyEnabled = isFeatureEnabled(':CURRENCY:');
    isCryptoEnabled = isFeatureEnabled(':CRYPTO:');
    isSectorsEnabled = isFeatureEnabled(':SECTORS:');
    isHighEnabled = isFeatureEnabled(':HIGH:');
    isLowEnabled = isFeatureEnabled(':LOW:');
    isVolumeEnabled = isFeatureEnabled(':VOLUME:');
    isAdviceEnabled = isFeatureEnabled(':ADVICE:');
    isModelPortfoliosEnabled = isFeatureEnabled(':MODEL_PORTFOLIOS:');
    isOrdersEnabled = isFeatureEnabled(':ORDERS:');
    isMarketEnabled = isFeatureEnabled(':MARKET:');
    isPortfolioEnabled = isFeatureEnabled(':PORTFOLIO:');
  }

  bool isFeatureEnabled(String feature) {
    return enabledFeatures.contains(feature);
  }
}
