enum AlarmValidityEnum {
  alarmDaily(1),
  alarmWeekly(7),
  alarmMonthly(30),
  // alarmTwoMonths(60),
  alarmThreeMonths(90);

  const AlarmValidityEnum(
    this.value,
  );

  final int value;
}
