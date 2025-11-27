import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:p_core/keys/navigator_keys.dart';

enum OrderActionTypeEnum {
  buy(
    'CREDIT',
    'al',
    'alis',
  ),
  sell(
    'DEBIT',
    'sat',
    'satis',
  ),
  shortSell(
    'SHORT',
    'aciga_sat',
    'aciga_sat',
  );

  const OrderActionTypeEnum(
    this.value,
    this.localizationKey1,
    this.localizationKey2,
  );
  final String value;
  final String localizationKey1;
  final String localizationKey2;

  Color get color => _getColor();

  Color _getColor() {
    final context = NavigatorKeys.navigatorKey.currentContext!;
    switch (this) {
      case OrderActionTypeEnum.buy:
        return context.pColorScheme.success;
      case OrderActionTypeEnum.sell:
        return context.pColorScheme.critical;
      case OrderActionTypeEnum.shortSell:
        return context.pColorScheme.primary;
    }
  }
}
