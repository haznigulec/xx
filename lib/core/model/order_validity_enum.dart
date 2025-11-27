enum OrderValidityEnum {
  daily('0', 'daily'),
  cancelRest('3', 'kalanini_iptal_et'),
  balancer('9', 'dengeleyici'),
  goodTillCancel('1', 'goodTillCancel');

  const OrderValidityEnum(this.value, this.localizationKey);
  final String value;
  final String localizationKey;
}

OrderValidityEnum settingsToOrderValidityEnum(String settingsValue) {
  switch (settingsValue) {
    case '1':
      return OrderValidityEnum.daily;
    case '3':
      return OrderValidityEnum.cancelRest;
    case '6':
      return OrderValidityEnum.balancer;
    case '2':
      return OrderValidityEnum.goodTillCancel;
    default:
      return OrderValidityEnum.daily;
  }
}

enum OptionOrderValidityEnum {
  daily('0', 'daily'),
  validTillCancel('1', 'validTillCancel'),
  cancelRest('3', 'cancelRest'),
  fillOrKill('4', 'fillOrKill'),
  byDate('6', 'byDate');

  const OptionOrderValidityEnum(this.value, this.localizationKey);
  final String value;
  final String localizationKey;
}

OptionOrderValidityEnum settingsToOptionOrderValidityEnum(String settingsValue) {
  switch (settingsValue) {
    case '1':
      return OptionOrderValidityEnum.daily;
    case '2':
      return OptionOrderValidityEnum.validTillCancel;
    case '3':
      return OptionOrderValidityEnum.cancelRest;
    case '4':
      return OptionOrderValidityEnum.fillOrKill;
    case '5':
      return OptionOrderValidityEnum.byDate;
    default:
      return OptionOrderValidityEnum.daily;
  }
}
