import 'package:piapiri_v2/common/widgets/common_widgets/insufficient_limit_widget.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/fund_order_action.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class FundTransactionLimitWidget extends StatelessWidget {
  final FundOrderActionEnum action;
  final double estimatedAmount;
  final int estimatedUnit;
  final bool showQuantity;
  final double maxBuyableAmount;

  const FundTransactionLimitWidget({
    super.key,
    required this.action,
    required this.estimatedAmount,
    required this.estimatedUnit,
    required this.showQuantity,
    required this.maxBuyableAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              showQuantity ? L10n.tr('estimated_number_shares') : L10n.tr('estimated_amount'),
              style: context.pAppStyle.labelReg16textPrimary,
            ),
            const SizedBox(
              width: Grid.s,
            ),
            Text(
              showQuantity
                  ? MoneyUtils().readableMoney(estimatedUnit, pattern: '#,##0')
                  : '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(estimatedAmount)}',
              style: context.pAppStyle.interMediumBase.copyWith(
                color: errorText() != null ? context.pColorScheme.critical : context.pColorScheme.textPrimary,
                fontSize: Grid.m + Grid.xxs,
              ),
            ),
          ],
        ),
        if (errorText() != null) ...[
          Text(
            errorText()!,
            style: context.pAppStyle.interRegularBase.copyWith(
              fontSize: Grid.s + Grid.xs,
              color: context.pColorScheme.critical,
            ),
          ),
        ],

        if (action == FundOrderActionEnum.buy && estimatedAmount > maxBuyableAmount) ...[
          const SizedBox(
            height: Grid.s,
          ),
          InsufficientLimitWidget(
            text: L10n.tr('deposit_tl_continue'),
            onTap: () {
              router.push(DepositMoneyAccountRoute());
            },
          ),
        ],

        /// yetersiz limitte bakiye yuklemeye godneridgimiz widget
      ],
    );
  }

  String? errorText() {
    if (!showQuantity && action == FundOrderActionEnum.buy && estimatedAmount > maxBuyableAmount) {
      return L10n.tr('insufficient_transaction_limit');
    }
    return null;
  }
}
