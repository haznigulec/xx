enum OrderTypeEnum {
  market('MKT', 'market_order', 'market_order_description'),
  limit('LOT', 'limit_order', 'limit_order_description'),
  marketToLimit('MTL', 'market_to_limit_order', 'market_to_limit_order_description'),
  reserve('LOT', 'reserved_order', 'reserved_order_description');

  const OrderTypeEnum(this.value, this.localizationKey, this.descLocalizationKey);
  final String value;
  final String localizationKey;
  final String descLocalizationKey;
}

OrderTypeEnum settingsToOrderTypeEnum(String settingsValue) {
  switch (settingsValue) {
    case '2':
      return OrderTypeEnum.marketToLimit;
    case '3':
      return OrderTypeEnum.market;
    case '4':
      return OrderTypeEnum.reserve;
    case '1':
      return OrderTypeEnum.limit;
    default:
      return OrderTypeEnum.limit;
  }
}

int enumToConditionalType(OrderTypeEnum value) {
  switch (value) {
    case OrderTypeEnum.marketToLimit:
      return 6;
    case OrderTypeEnum.market:
      return 5;
    case OrderTypeEnum.limit:
      return 0;
    default:
      return 0;
  }
}

String enumToTransactionTypeId(OrderTypeEnum value) {
  switch (value) {
    case OrderTypeEnum.marketToLimit:
      return '0000-000011-ETT';
    case OrderTypeEnum.market:
      return '0000-000010-ETT';
    case OrderTypeEnum.limit:
      return '0000-000001-ETT';
    case OrderTypeEnum.reserve:
      return '0000-000012-ETT';
  }
}

enum OptionOrderTypeEnum {
  limit('LOT', '2', 'limit_order', 'limit_order_description'),
  marketToLimit('MTL', '1', 'market_to_limit_order', 'market_to_limit_order_description');

  const OptionOrderTypeEnum(
    this.value,
    this.matriksValue,
    this.localizationKey,
    this.descriptionKey,
  );
  final String value;
  final String matriksValue;
  final String localizationKey;
  final String descriptionKey;
}

OptionOrderTypeEnum settingsToOptionOrderTypeEnum(String settingsValue) {
  switch (settingsValue) {
    case 'K':
      return OptionOrderTypeEnum.marketToLimit;
    case '2':
      return OptionOrderTypeEnum.limit;
    default:
      return OptionOrderTypeEnum.marketToLimit;
  }
}

String optionenumToConditionalType(OptionOrderTypeEnum value) {
  switch (value) {
    case OptionOrderTypeEnum.marketToLimit:
      return 'K';
    case OptionOrderTypeEnum.limit:
      return '2';
  }
}
