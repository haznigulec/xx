enum FundOrderActionEnum {
  buy('B', 'al'),
  sell('S', 'sat');

  const FundOrderActionEnum(
    this.value,
    this.localizationKey,
  );
  final String value;
  final String localizationKey;

}

enum FundOrderBaseTypeEnum {
  unit('Unit'),
  amount('Amount');

  const FundOrderBaseTypeEnum(this.value);
  final String value;
}
