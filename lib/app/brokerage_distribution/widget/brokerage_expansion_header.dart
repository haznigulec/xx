import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

class BrokerageExpansionHeader extends StatelessWidget {
  final String agent;
  final String ratio;
  final String quantity;
  final Color color;
  final bool isExpanded;
  const BrokerageExpansionHeader({
    super.key,
    required this.agent,
    required this.ratio,
    required this.quantity,
    required this.color,
    required this.isExpanded,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Grid.s + Grid.xs),
      child: SizedBox(
        height: 38,
        child: Row(
          children: [
            Container(
              height: 30,
              width: 5,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(Grid.m),
              ),
            ),
            const SizedBox(
              width: Grid.s,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  agent,
                  style: context.pAppStyle.labelReg14textPrimary,
                ),
                const SizedBox(
                  height: Grid.xxs / 2,
                ),
                Text(
                  ratio,
                  style: context.pAppStyle.labelMed12textSecondary,
                ),
              ],
            ),
            const Spacer(),
            Text(
              quantity,
              style: context.pAppStyle.labelMed14textPrimary,
            ),
            const SizedBox(
              width: Grid.xs,
            ),
            SvgPicture.asset(
              isExpanded ? ImagesPath.chevron_up : ImagesPath.chevron_down,
              height: 12,
              width: 12,
              colorFilter: ColorFilter.mode(
                context.pColorScheme.textPrimary,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
