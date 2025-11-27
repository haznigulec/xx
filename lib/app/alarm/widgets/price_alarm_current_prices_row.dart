import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class PriceAlarmCurrentPricesRow extends StatelessWidget {
  final double buyPrice;
  final double sellPrice;
  final double lastPrice;
  final double percentage;
  final String currencySymbol;

  const PriceAlarmCurrentPricesRow({
    super.key,
    required this.buyPrice,
    required this.sellPrice,
    required this.lastPrice,
    required this.percentage,
    required this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 35,
      children: [
        Column(
          children: [
            Text(
              L10n.tr('purchase_price'),
              style: context.pAppStyle.labelMed12textSecondary,
            ),
            Text(
              '$currencySymbol${MoneyUtils().readableMoney(buyPrice)}',
              textAlign: TextAlign.center,
              style: context.pAppStyle.labelMed14textPrimary,
            )
          ],
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                L10n.tr('sale_price'),
                textAlign: TextAlign.center,
                style: context.pAppStyle.labelMed12textSecondary,
              ),
              Text(
                '$currencySymbol${MoneyUtils().readableMoney(sellPrice)}',
                textAlign: TextAlign.center,
                style: context.pAppStyle.labelMed14textPrimary,
              )
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                L10n.tr('son_fiyat'),
                style: context.pAppStyle.labelMed12textSecondary,
              ),
              Text(
                '$currencySymbol${MoneyUtils().readableMoney(lastPrice)}',
                textAlign: TextAlign.center,
                style: context.pAppStyle.labelMed14textPrimary,
              )
            ],
          ),
        ),
        Column(
          children: [
            Text(
              L10n.tr('equity_bist_difference2'),
              style: context.pAppStyle.labelMed12textSecondary,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SvgPicture.asset(
                  percentage > 0 ? ImagesPath.trending_up : ImagesPath.trending_down,
                  width: Grid.m,
                  height: Grid.m,
                  colorFilter: ColorFilter.mode(
                    percentage > 0 ? context.pColorScheme.success : context.pColorScheme.critical,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(
                  width: Grid.xxs,
                ),
                Text(
                  '${percentage < 0 ? '-' : ''}%${MoneyUtils().readableMoney(percentage).replaceAll('-', '')}',
                  textAlign: TextAlign.center,
                  style: context.pAppStyle.labelMed14textPrimary.copyWith(
                    color: percentage > 0 ? context.pColorScheme.success : context.pColorScheme.critical,
                  ),
                ),
              ],
            )
          ],
        ),
      ],
    );
  }
}
