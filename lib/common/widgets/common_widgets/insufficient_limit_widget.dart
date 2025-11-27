import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/utils/localization_utils.dart';

class InsufficientLimitWidget extends StatelessWidget {
  final String? text;
  final Function()? onTap;
  const InsufficientLimitWidget({
    super.key,
    this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ??
          () => router.push(
                DepositMoneyAccountRoute(),
              ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text ?? L10n.tr('deposit_money_direction'),
            style: context.pAppStyle.labelMed14primary,
          ),
          const SizedBox(
            width: Grid.xs,
          ),
          SvgPicture.asset(
            height: 15,
            width: 15,
            ImagesPath.arrow_up_right,
            colorFilter: ColorFilter.mode(
              context.pColorScheme.primary,
              BlendMode.srcIn,
            ),
          )
        ],
      ),
    );
  }
}
