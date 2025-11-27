import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

class TradeInfoTile extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback onTap;

  const TradeInfoTile({
    super.key,
    required this.title,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: context.pColorScheme.transparent,
      highlightColor: context.pColorScheme.transparent,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: Grid.s,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: context.pAppStyle.labelReg14textSecondary,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value.isNotEmpty ? value : '',
                  textAlign: TextAlign.end,
                  style: context.pAppStyle.labelMed14textPrimary,
                ),
                const SizedBox(width: Grid.s),
                SvgPicture.asset(
                  ImagesPath.chevron_down,
                  height: Grid.m,
                  colorFilter: ColorFilter.mode(
                    context.pColorScheme.textPrimary,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
