import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';

class DividendExpandedWidget extends StatelessWidget {
  final String title;
  final bool isExpanded;
  final VoidCallback onTap;
  const DividendExpandedWidget({
    super.key,
    required this.isExpanded,
    required this.onTap,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: context.pColorScheme.transparent,
      highlightColor: context.pColorScheme.transparent,
      onTap: onTap,
      child: Row(
        children: [
          Text(
            title,
            style: context.pAppStyle.labelMed16textPrimary,
          ),
          const SizedBox(
            width: Grid.xs,
          ),
          SvgPicture.asset(
            isExpanded ? ImagesPath.chevron_up : ImagesPath.chevron_down,
            width: Grid.s + Grid.xs,
            colorFilter: ColorFilter.mode(
              context.pColorScheme.textPrimary,
              BlendMode.srcIn,
            ),
          ),
        ],
      ),
    );
  }
}
