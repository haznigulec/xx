import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';

class TableTitleWidget extends StatelessWidget {
  final String primaryColumnTitle;
  final String? secondaryColumnTitle;
  final String tertiaryColumnTitle;
  final Function()? onTap;
  final Function()? onTertiaryTextTap;
  final Function()? onTertiaryIconTap;
  final bool? hasSorting;
  final bool? hasTertiarySorting;
  final bool showTopDivider;

  const TableTitleWidget({
    super.key,
    required this.primaryColumnTitle,
    this.secondaryColumnTitle,
    required this.tertiaryColumnTitle,
    this.onTap,
    this.onTertiaryTextTap,
    this.onTertiaryIconTap,
    this.hasSorting = false,
    this.hasTertiarySorting = false,
    this.showTopDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showTopDivider) const PDivider(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: Grid.s + Grid.xs),
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: Row(
                  children: [
                    Text(
                      primaryColumnTitle,
                      style: context.pAppStyle.labelMed12textSecondary,
                    ),
                    const SizedBox(
                      width: Grid.s,
                    ),
                    if (hasSorting!)
                      InkWell(
                        splashColor: context.pColorScheme.transparent,
                        highlightColor: context.pColorScheme.transparent,
                        onTap: onTap,
                        child: SvgPicture.asset(
                          ImagesPath.arrows_down_up,
                          width: 14,
                        ),
                      )
                  ],
                ),
              ),
              if (secondaryColumnTitle != null)
                Expanded(
                  flex: 3,
                  child: Text(
                    '$secondaryColumnTitle ',
                    textAlign: TextAlign.center,
                    style: context.pAppStyle.labelMed12textSecondary,
                  ),
                ),
              Expanded(
                flex: 3,
                child: (hasTertiarySorting ?? false)
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: onTertiaryTextTap,
                            child: Text(
                              tertiaryColumnTitle,
                              textAlign: TextAlign.right,
                              style: context.pAppStyle.labelMed12textSecondary,
                            ),
                          ),
                          const SizedBox(
                            width: Grid.s,
                          ),
                          InkWell(
                            onTap: onTertiaryIconTap,
                            child: SvgPicture.asset(
                              ImagesPath.arrows_down_up,
                              width: 14,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        tertiaryColumnTitle,
                        textAlign: TextAlign.right,
                        style: context.pAppStyle.labelMed12textSecondary,
                      ),
              ),
            ],
          ),
        ),
        const PDivider(),
      ],
    );
  }
}
