enum ViopSessionEnum {
  normal(1, 1, 'viop_session_normal', 'viop_session_normal_description'),
  evening(2, 2, 'viop_session_evening', 'viop_session_evening_description'),
  normalEvening(1, 2, 'viop_session_normal_evening', 'viop_session_normal_evening_description');

  final int initialMarketSessionSel;
  final int endingMarketSessionSel;
  final String localizationKey;
  final String descriptionKey;
  const ViopSessionEnum(
    this.initialMarketSessionSel,
    this.endingMarketSessionSel,
    this.localizationKey,
    this.descriptionKey,
  );
}
