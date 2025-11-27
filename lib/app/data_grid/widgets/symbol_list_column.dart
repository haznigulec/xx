import 'package:auto_size_text/auto_size_text.dart';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

class SymbolListColumn extends StatelessWidget {
  final List<String> columns;
  final bool columnsSpacingIsEqual;
  final bool sortEnabled;
  final bool showTopDivider;
  final Widget? columnIcon;
  final Function() onTapSort;
  final EdgeInsets extraPadding;
  const SymbolListColumn({
    super.key,
    required this.columns,
    required this.columnsSpacingIsEqual,
    required this.sortEnabled,
    required this.showTopDivider,
    this.columnIcon,
    required this.onTapSort,
    this.extraPadding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showTopDivider)
          PDivider(
            padding: extraPadding,
          ),
        Container(
          padding: EdgeInsets.only(
            top: Grid.s + Grid.xs + extraPadding.top,
            bottom: Grid.s + Grid.xs + extraPadding.bottom,
            left: extraPadding.left,
            right: extraPadding.right,
          ),
          child: !columnsSpacingIsEqual
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * .45,
                      child: Row(
                        children: [
                          Text(
                            columns[0],
                            style: context.pAppStyle.labelMed12textSecondary,
                          ),
                          if (sortEnabled || columnIcon != null) ...[
                            const SizedBox(
                              width: Grid.xs,
                            ),
                            columnIcon ??
                                InkWell(
                                  onTap: onTapSort,
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
                          ],
                        ],
                      ),
                    ),
                    if (columns.length > 1)
                      Expanded(
                        child: AutoSizeText(
                          columns[1],
                          maxLines: 1,
                          style: context.pAppStyle.labelMed12textSecondary,
                          textAlign: TextAlign.end,
                          minFontSize: 9,
                        ),
                      ),
                    if (columns.length > 2) ...[
                      const Spacer(),
                      Text(
                        columns[2],
                        style: context.pAppStyle.labelMed12textSecondary,
                        textAlign: TextAlign.end,
                      )
                    ]
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          Text(
                            columns[0],
                            style: context.pAppStyle.labelMed12textSecondary,
                            textAlign: TextAlign.start,
                          ),
                          if (sortEnabled || columnIcon != null) ...[
                            const SizedBox(
                              width: Grid.xs,
                            ),
                            columnIcon ??
                                InkWell(
                                  onTap: onTapSort,
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
                          ],
                        ],
                      ),
                    ),
                    if (columns.length > 1)
                      Expanded(
                        child: AutoSizeText(
                          columns[1],
                          minFontSize: Grid.s,
                          textAlign: columns.length == 2 ? TextAlign.end : TextAlign.center,
                          style: context.pAppStyle.labelMed12textSecondary,
                        ),
                      ),
                    if (columns.length > 2) ...[
                      Expanded(
                        child: AutoSizeText(
                          columns[2],
                          minFontSize: Grid.s,
                          textAlign: TextAlign.end,
                          style: context.pAppStyle.labelMed12textSecondary,
                        ),
                      )
                    ]
                  ],
                ),
        ),
        PDivider(
          padding: extraPadding,
        ),
      ],
    );
  }
}
