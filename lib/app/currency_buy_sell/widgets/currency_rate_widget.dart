import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class CurrencyRateWidget extends StatelessWidget {
  final CurrencyEnum currencyType;
  final double currencyRate;
  final Widget? titleWidget;
  const CurrencyRateWidget({
    super.key,
    required this.currencyType,
    required this.currencyRate,
    this.titleWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        titleWidget ??
            InkWell(
              splashColor: context.pColorScheme.transparent,
              highlightColor: context.pColorScheme.transparent,
              onTap: () => PBottomSheet.showError(
                context,
                content: L10n.tr('exchange_rates_can_change_info'),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    ImagesPath.alert_circle,
                    width: 15,
                    height: 15,
                    colorFilter: ColorFilter.mode(
                      context.pColorScheme.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(
                    width: Grid.s,
                  ),
                  Text(
                    L10n.tr('exchange_rate'),
                    textAlign: TextAlign.left,
                    style: context.pAppStyle.labelReg14textPrimary,
                  ),
                ],
              ),
            ),
        const SizedBox(
          width: Grid.s,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: Grid.s,
          ),
          child: Text(
            '${currencyType.symbol}1 = ₺${MoneyUtils().readableMoney(
              currencyRate,
              pattern: '#,##0.00000',
            )}',
            style: context.pAppStyle.labelMed18textPrimary,
          ),
        ),
      ],
    );
  }
}
