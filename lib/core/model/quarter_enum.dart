enum SortingEnum {
  first('first_quarter', '03'),
  second('second_quarter', '06'),
  third('third_quarter', '09'),
  fourth('fourth_quarter', '12');

  final String localization;
  final String value;
  const SortingEnum(
    this.value,
    this.localization,
  );
}
