enum ConditionEnum {
  greatherThen(2, 'greater_or_equal'),
  dollar(3, 'less_or_equal');

  final int value;
  final String localizationKey;
  const ConditionEnum(this.value, this.localizationKey);
}
