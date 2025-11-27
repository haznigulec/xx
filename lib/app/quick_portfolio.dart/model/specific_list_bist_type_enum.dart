enum BistType {
  equityBist('equity_bist'),
  viopBist('viop_bist'),
  warrantBist('warrant_bist'),
  fundBist('market_investment_funds'),
  home('homepage'),
  us('us');

  final String type;

  const BistType(this.type);
}

enum SpecialListSymbolTypeEnum {
  warrant('varant'),
  equity('hisse'),
  fund('fon'),
  foreign('ab'),
  viop('viop');

  final String type;
  const SpecialListSymbolTypeEnum(
    this.type,
  );
}
