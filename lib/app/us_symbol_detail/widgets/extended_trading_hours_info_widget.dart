import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/us_symbol_detail/widgets/trading_hour_row_widget.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/utils/localization_utils.dart';

class ExtendedTradingHoursInfoWidget extends StatelessWidget {
  const ExtendedTradingHoursInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          L10n.tr('transaction_hours_desc1'),
          style: context.pAppStyle.labelReg14textPrimary,
        ),
        const SizedBox(
          height: Grid.m,
        ),
        Text(
          L10n.tr('transaction_hours_desc2'),
          style: context.pAppStyle.labelReg14textPrimary,
        ),
        const SizedBox(
          height: Grid.m,
        ),
        Text(
          L10n.tr('transaction_hours_desc3'),
          style: context.pAppStyle.labelReg14textPrimary,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(
            vertical: Grid.m,
          ),
          child: PDivider(),
        ),
        TradingHourRowWidget(
          iconPath: ImagesPath.yellowCloud,
          text: L10n.tr('pre_market'),
          canTrade: true,
        ),
        const SizedBox(height: Grid.m),
        TradingHourRowWidget(
          iconPath: ImagesPath.sun,
          text: L10n.tr('open_market'),
          canTrade: true,
        ),
        const SizedBox(height: Grid.m),
        TradingHourRowWidget(
          iconPath: ImagesPath.cloud,
          text: L10n.tr('post_market'),
          canTrade: true,
        ),
        const SizedBox(height: Grid.m),
        TradingHourRowWidget(
          iconPath: ImagesPath.moon,
          text: L10n.tr('close_market'),
          canTrade: false,
        ),
        const SizedBox(height: Grid.m),
      ],
    );
  }
}
