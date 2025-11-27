import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class FundMarketSessionWidget extends StatelessWidget {
  const FundMarketSessionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Grid.m,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            ImagesPath.sun,
            width: 15,
            height: 15,
          ),
          const SizedBox(width: Grid.xs),
          Expanded(
            child: RichText(
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: context.pAppStyle.labelReg12textSecondary,
                children: [
                  TextSpan(
                    text: L10n.tr('market_session_open'),
                  ),
                  TextSpan(
                    text: ' • ',
                    style: context.pAppStyle.labelMed14textSecondary,
                  ),
                  TextSpan(
                    text: L10n.tr(
                      'market_session_open_trade',
                      args: [L10n.tr('fund')],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
