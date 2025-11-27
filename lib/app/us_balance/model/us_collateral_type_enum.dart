enum UsCollateralTypeEnum {
  depositingCollateral(0), // Bakiye Yatırma
  collateralWithdrawal(1); // Bakiye Çekme

  const UsCollateralTypeEnum(this.value);
  final int value;
}
