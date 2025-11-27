import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/utils/localization_utils.dart';

class TransferButtons extends StatelessWidget {
  const TransferButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Grid.xxl - Grid.xs,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          PButtonWithIcon(
            text: L10n.tr('transfer'),
            icon: SvgPicture.asset(
              ImagesPath.arrow_up,
              colorFilter: ColorFilter.mode(
                context.pColorScheme.lightHigh,
                BlendMode.srcIn,
              ),
              width: 17,
              height: 17,
            ),
            onPressed: () {
              // router.push(
              //   PortfolioTabMoneyTransferRoute(
              //     initialIndex: initialIndex,
              //   ),
              // );
            },
          ),
          const SizedBox(
            width: Grid.s,
          ),
          PButtonWithIcon(
            text: L10n.tr('withdraw'),
            variant: PButtonVariant.secondary,
            icon: SvgPicture.asset(
              ImagesPath.arrow_down,
              colorFilter: ColorFilter.mode(
                context.pColorScheme.primary,
                BlendMode.srcIn,
              ),
              width: 17,
              height: 17,
            ),
            onPressed: () {
              // router.push(
              //   PortfolioTabMoneyTransferRoute(
              //     initialIndex: initialIndex,
              //   ),
              // );
            },
          ),
          const SizedBox(
            width: Grid.s,
          ),
          PButtonWithIcon(
            text: L10n.tr('currency_exchange'),
            variant: PButtonVariant.secondary,
            icon: SvgPicture.asset(
              ImagesPath.arrows_right_left,
              colorFilter: ColorFilter.mode(
                context.pColorScheme.primary,
                BlendMode.srcIn,
              ),
              width: 17,
              height: 17,
            ),
            onPressed: () {
              // router.push(
              //   PortfolioTabMoneyTransferRoute(
              //     initialIndex: initialIndex,
              //   ),
              // );
            },
          ),
        ],
      ),
    );
  }
}
