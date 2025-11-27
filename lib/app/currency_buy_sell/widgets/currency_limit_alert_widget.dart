import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/utils/localization_utils.dart';

class CurrencyLimitAlertWidget extends StatelessWidget {
  final bool showLowerAlert;
  final double lowerLimit;
  final double upperLimit;
  final String currencySymbol;
  const CurrencyLimitAlertWidget({
    super.key,
    required this.showLowerAlert,
    required this.lowerLimit,
    required this.upperLimit,
    required this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: Grid.s,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: Grid.xs + Grid.xxs,
          ),
          child: Text(
            showLowerAlert
                ? L10n.tr(
                    'minimum_currency_buy_sell_alert',
                    args: [
                      '$currencySymbol${MoneyUtils().readableMoney(lowerLimit)}',
                    ],
                  )
                : L10n.tr(
                    'maximum_currency_buy_sell_alert',
                    args: [
                      '$currencySymbol${MoneyUtils().readableMoney(upperLimit)}',
                    ],
                  ),
            style: context.pAppStyle.interRegularBase.copyWith(
              fontSize: Grid.s + Grid.xs,
              color: context.pColorScheme.critical,
            ),
          ),
        ),
      ],
    );
  }
}
