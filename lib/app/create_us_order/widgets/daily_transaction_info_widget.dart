import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class DailyTransactionInfoWidget extends StatelessWidget {
  const DailyTransactionInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Grid.m),
      child: Column(
        children: [
          SvgPicture.asset(
            ImagesPath.info,
            height: 52,
            width: 52,
            colorFilter: ColorFilter.mode(
              context.pColorScheme.primary,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(
            height: Grid.m,
          ),
          Text(
            L10n.tr(
              'what_is_daily_transaction',
            ),
            style: context.pAppStyle.labelMed16textPrimary,
          ),
          const SizedBox(
            height: Grid.m,
          ),
          Text(
            L10n.tr(
              'daily_transaction_limit_desc',
            ),
            style: context.pAppStyle.labelReg14textPrimary,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: Grid.m,
          ),
          Text(
            L10n.tr(
              'daily_transaction_limit_desc2',
            ),
            style: context.pAppStyle.labelReg14textPrimary,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
