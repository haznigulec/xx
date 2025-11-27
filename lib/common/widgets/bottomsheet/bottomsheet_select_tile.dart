import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';

class BottomsheetSelectTile extends StatelessWidget {
  final String title;
  final String? subTitle;
  final Widget? subTitleWidget;
  final dynamic value;
  final bool isSelected;
  final Widget? prefix;
  final Function(String title, dynamic value) onTap;
  final Widget? trailingWidget;
  final EdgeInsetsGeometry? padding;
  const BottomsheetSelectTile({
    super.key,
    required this.title,
    this.subTitle,
    this.subTitleWidget,
    this.value,
    required this.isSelected,
    this.prefix,
    required this.onTap,
    this.trailingWidget,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(title, value),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: Grid.m,
        ),
        child: Row(
          children: [
            Container(
              height: 30,
              width: 5,
              decoration: BoxDecoration(
                color: isSelected ? context.pColorScheme.primary : Colors.transparent,
                borderRadius: const BorderRadius.all(
                  Radius.circular(30),
                ),
              ),
            ),
            if (prefix != null) ...[
              const SizedBox(
                width: Grid.s,
              ),
              prefix!,
            ],
            const SizedBox(
              width: Grid.s,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    style: isSelected ? context.pAppStyle.labelMed16primary : context.pAppStyle.labelReg16textPrimary,
                  ),
                  if (subTitleWidget != null) subTitleWidget!,
                  if (subTitle != null)
                    Text(
                      subTitle!,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: context.pAppStyle.labelReg12textSecondary,
                    ),
                ],
              ),
            ),
            if (trailingWidget != null) trailingWidget!,
          ],
        ),
      ),
    );
  }
}
