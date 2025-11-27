enum TimeoutEnum {
  fiveM(5, '5minutes'),
  fifteenM(15, '15minutes'),
  thirtyM(30, '30minutes'),
  oneH(60, '1hour'),
  twoH(120, '2hours'),
  threeH(180, '3hours'),
  fourH(240, '4hours');

  final int value;
  final String localizationKey;
  const TimeoutEnum(this.value, this.localizationKey);
}
