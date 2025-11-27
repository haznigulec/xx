import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/assets/model/us_capra_summary_model.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';

import 'package:piapiri_v2/core/utils/localization_utils.dart';

import '../../../common/utils/utils.dart';

class AssetUsCollateralBottomSheetTopWidget extends StatelessWidget {
  final UsOverallItemModel portfolioSummary;
  final bool isVisible;

  const AssetUsCollateralBottomSheetTopWidget({
    super.key,
    required this.portfolioSummary,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              L10n.tr('american_stock_exchanges_${portfolioSummary.instrumentCategory ?? ''}'),
              style: context.pAppStyle.labelReg14textPrimary,
            ),
            // Text(
            //   '${L10n.tr('portfolio_allocation')} %${MoneyUtils().readableMoney(
            //     portfolioSummary.ratio ?? 0,
            //   )}',
            //   style: const PTypography.title(
            //     fontSize: Grid.s + Grid.xxs,
            //     color: context.pColorScheme.textSecondary,
            //   ),
            // ),
            Text(
              L10n.tr('portfolio_ratio'),
              style: context.pAppStyle.labelMed12textSecondary,
            )
          ],
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              !isVisible
                  ? '${CurrencyEnum.dollar.symbol}**'
                  : '${CurrencyEnum.dollar.symbol}${MoneyUtils().readableMoney(portfolioSummary.totalAmount!)}',
              style: context.pAppStyle.labelMed14textPrimary,
            ),
            if (portfolioSummary.totalPotentialProfitLoss != null && portfolioSummary.totalPotentialProfitLoss != 0)
              Padding(
                padding: const EdgeInsets.only(
                  right: Grid.m,
                ),
                child: Row(
                  children: [
                    Utils().profitLossPercentWidget(
                      context: context,
                      performance: portfolioSummary.totalPotentialProfitLoss! /
                          (portfolioSummary.totalAmount! - portfolioSummary.totalPotentialProfitLoss!) *
                          100,
                      fontSize: Grid.l / 2,
                      isVisible: true,
                    ),
                    Text(
                        ' (${CurrencyEnum.dollar.symbol}${MoneyUtils().readableMoney(portfolioSummary.totalPotentialProfitLoss!)})',
                        style: context.pAppStyle.interMediumBase.copyWith(
                          color: portfolioSummary.totalPotentialProfitLoss! == 0
                              ? context.pColorScheme.textPrimary
                              : portfolioSummary.totalPotentialProfitLoss! > 0
                                  ? context.pColorScheme.success
                                  : context.pColorScheme.critical,
                          fontSize: Grid.s + Grid.xs,
                        )),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}
