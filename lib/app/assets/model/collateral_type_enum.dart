enum CollateralTypeEnum {
  depositingCollateral('Overall'),
  collateralWithdrawal('Custody');

  final String value;
  const CollateralTypeEnum(this.value);
}
