import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/currency_buy_sell/widgets/currency_rate_widget.dart';
import 'package:piapiri_v2/app/search_symbol/widgets/order_approvement_buttons.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class CurrencyBuySellConfirmationWidget extends StatelessWidget {
  final CurrencyEnum currencyType;
  final double currencyRate;
  final String currencyAmount;
  final String tlAmount;
  final VoidCallback? onApprove;
  final bool isBuy;

  const CurrencyBuySellConfirmationWidget({
    super.key,
    required this.currencyType,
    required this.currencyRate,
    required this.currencyAmount,
    required this.tlAmount,
    this.onApprove,
    required this.isBuy,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CurrencyRateWidget(
          currencyType: currencyType,
          currencyRate: currencyRate,
          titleWidget: Text(
            L10n.tr('exchange_rate_price'),
            style: context.pAppStyle.labelMed16textPrimary,
          ),
        ),
        const SizedBox(
          height: Grid.s,
        ),
        Text(
          '${L10n.tr('toplam_tutar')}: $currencyAmount ≈ ${isBuy ? '₺$tlAmount' : tlAmount}',
          style: context.pAppStyle.labelMed16primary,
        ),
        if (isBuy) ...[
          Text(
              L10n.tr(
                'usd_kgv_approvement_description',
                args: [
                  ((double.parse(L10n.tr('usd_kgv')) * 100).toString().replaceAll('.', ',')),
                  MoneyUtils().readableMoney(
                    (double.parse(L10n.tr('usd_kgv')) * MoneyUtils().fromReadableMoney(tlAmount)),
                  )
                ],
              ),
              style: context.pAppStyle.labelMed14textSecondary),
          const SizedBox(
            height: Grid.s,
          ),
        ],
        Text(
          L10n.tr('do_you_want_continue_your_transaction'),
          style: context.pAppStyle.labelReg16textPrimary,
        ),
        const SizedBox(
          height: Grid.l,
        ),
        OrderApprovementButtons(
          onPressedApprove: onApprove,
        ),
      ],
    );
  }
}
