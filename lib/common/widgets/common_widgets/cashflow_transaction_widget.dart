import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class CashflowTransactionWidget extends StatelessWidget {
  final bool isUs;
  final String? cashText;
  final String? limitText;
  final double? cashValue;
  final double limitValue;
  const CashflowTransactionWidget({
    super.key,
    this.isUs = false,
    this.cashText,
    this.limitText,
    this.cashValue,
    required this.limitValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: context.pColorScheme.card,
        borderRadius: BorderRadius.circular(
          Grid.m,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (cashValue != null) ...[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  cashText ?? '${L10n.tr('cash_balance')}:',
                  maxLines: 1,
                  style: context.pAppStyle.labelReg14textSecondary,
                ),
                Text(
                  '${isUs ? CurrencyEnum.dollar.symbol : CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(cashValue!)}',
                  maxLines: 1,
                  style: context.pAppStyle.labelMed14textPrimary,
                ),
              ],
            ),
            Container(
              height: 15,
              width: 1,
              color: context.pColorScheme.textTeritary,
            ),
          ],
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                limitText ?? '${L10n.tr('islem_limiti')}:',
                maxLines: 1,
                style: context.pAppStyle.labelReg14textSecondary,
              ),
              Text(
                '${isUs ? CurrencyEnum.dollar.symbol : CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(limitValue)}',
                maxLines: 1,
                style: context.pAppStyle.labelMed14textPrimary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
