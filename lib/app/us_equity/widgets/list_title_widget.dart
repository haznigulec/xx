import 'package:flutter_svg/flutter_svg.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/utils/localization_utils.dart';

class ListTitleWidget extends StatelessWidget {
  final String leadingTitle;
  final String trailingTitle;
  final bool? hasTopDivider;
  final Function() openSorting;
  const ListTitleWidget({
    super.key,
    required this.leadingTitle,
    required this.trailingTitle,
    required this.openSorting,
    this.hasTopDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (hasTopDivider!) ...[
          const Divider(),
          const SizedBox(
            height: Grid.s + Grid.xs,
          ),
        ],
        Row(
          children: [
            Text(
              L10n.tr(leadingTitle),
              style: context.pAppStyle.labelMed12textSecondary,
            ),
            const SizedBox(
              width: Grid.xs,
            ),
            InkWell(
              onTap: () => openSorting(),
              child: SvgPicture.asset(
                ImagesPath.arrows_down_up,
                height: 14,
                width: 14,
                colorFilter: ColorFilter.mode(
                  context.pColorScheme.textSecondary,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const Spacer(),
            Text(
              L10n.tr(trailingTitle),
              style: context.pAppStyle.labelMed12textSecondary,
            ),
          ],
        ),
        const SizedBox(
          height: Grid.s + Grid.xs,
        ),
        const Divider(),
      ],
    );
  }
}
