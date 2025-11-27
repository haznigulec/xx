import 'package:piapiri_v2/core/model/currency_enum.dart';

class AccountModel {
  final String accountId;
  final bool isDefault;
  final CurrencyEnum currency;

  AccountModel({
    required this.accountId,
    this.isDefault = false,
    this.currency = CurrencyEnum.turkishLira,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      accountId: json['accountExtId'],
      isDefault: json['defaultAccount'],
      currency: json['currencyType'] == 'TRY'
          ? CurrencyEnum.turkishLira
          : json['currencyType'] == 'USD'
              ? CurrencyEnum.dollar
              : json['currencyType'] == 'EUR'
                  ? CurrencyEnum.euro
                  : json['currencyType'] == 'GBP'
                      ? CurrencyEnum.pound
                      : json['currencyType'] == 'JPY'
                          ? CurrencyEnum.japaneseYen
                          : CurrencyEnum.other,
    );
  }
}
