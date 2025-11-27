import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/diff_percentage.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/model/us_market_status_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class UsMarketPriceInfo extends StatelessWidget {
  final UsMarketStatus usMarketStatus;
  final String price;
  final double percentage;
  final String? preAfterPrice;
  final double? preAfterPercentage;

  const UsMarketPriceInfo({
    super.key,
    required this.usMarketStatus,
    required this.price,
    required this.percentage,
    this.preAfterPrice,
    this.preAfterPercentage,
  });

  @override
  Widget build(BuildContext context) {
    if (usMarketStatus == UsMarketStatus.preMarket || usMarketStatus == UsMarketStatus.afterMarket) {
      return Padding(
        padding: const EdgeInsets.only(
          top: Grid.s,
        ),
        child: Row(
          children: [
            Column(
              children: [
                Text(
                  L10n.tr('market_price_difference'),
                  style: context.pAppStyle.labelMed12textSecondary,
                ),
                Row(
                  children: [
                    Text(
                      '\$$price',
                      style: context.pAppStyle.labelMed14textPrimary,
                    ),
                    const SizedBox(
                      width: Grid.xs,
                    ),
                    DiffPercentage(
                      percentage: percentage,
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            if (preAfterPrice != null && preAfterPercentage != null)
              Column(
                children: [
                  Text(
                    usMarketStatus == UsMarketStatus.preMarket
                        ? L10n.tr('pre_market_price_diff')
                        : L10n.tr('after_market_price_diff'),
                    style: context.pAppStyle.labelMed12textSecondary,
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        usMarketStatus.iconPath,
                        width: 15,
                        height: 15,
                      ),
                      const SizedBox(
                        width: Grid.xxs,
                      ),
                      Text(
                        '\$$preAfterPrice',
                        style: context.pAppStyle.labelMed14textPrimary,
                      ),
                      const SizedBox(
                        width: Grid.xs,
                      ),
                      DiffPercentage(
                        percentage: preAfterPercentage!,
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(
          top: Grid.s,
        ),
        child: Row(
          children: [
            Text(
              L10n.tr('market_price'),
              style: context.pAppStyle.labelMed12textSecondary,
            ),
            if (usMarketStatus == UsMarketStatus.closed) ...[
              const SizedBox(
                width: Grid.xxs,
              ),
              SvgPicture.asset(
                usMarketStatus.iconPath,
                width: 15,
                height: 15,
              ),
            ],
            const SizedBox(
              width: Grid.xs,
            ),
            Text(
              '\$$price',
              style: context.pAppStyle.labelMed12textPrimary,
            ),
            const Spacer(),
            Text(
              L10n.tr('lists_difference2'),
              style: context.pAppStyle.labelMed12textSecondary,
            ),
            const SizedBox(
              width: Grid.xs,
            ),
            DiffPercentage(
              percentage: percentage,
            ),
          ],
        ),
      );
    }
  }
}
