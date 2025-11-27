import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class TradingHourRowWidget extends StatelessWidget {
  final String iconPath;
  final String text;
  final bool canTrade;

  const TradingHourRowWidget({
    required this.iconPath,
    required this.text,
    required this.canTrade,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          iconPath,
          width: Grid.m,
        ),
        const SizedBox(
          width: Grid.s,
        ),
        Text(
          '$text • ${canTrade ? L10n.tr('us_market_active') : L10n.tr('us_market_inactive')}',
          style: context.pAppStyle.labelMed14textSecondary,
        ),
      ],
    );
  }
}
