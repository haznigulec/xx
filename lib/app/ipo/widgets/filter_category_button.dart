import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';

class FilterCategoryButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final bool hasSelectedFilter;
  final Function() onTap;
  final bool hasDivider;

  const FilterCategoryButton({
    super.key,
    required this.title,
    required this.isSelected,
    this.hasSelectedFilter = false,
    required this.onTap,
    this.hasDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 30,
            child: Row(
              children: [
                AnimatedContainer(
                  width: 5,
                  height: isSelected
                      ? 30.0
                      : hasSelectedFilter
                          ? 5.0
                          : 0.0,
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: context.pColorScheme.primary,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(
                        Grid.m,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: Grid.s,
                ),
                Expanded(
                  child: Text(
                    title,
                    style: isSelected ? context.pAppStyle.labelMed16primary : context.pAppStyle.labelReg16textPrimary,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          ),
          if (hasDivider) ...[
            const Padding(
              padding: EdgeInsets.symmetric(
                vertical: Grid.m,
              ),
              child: PDivider(),
            ),
          ] else ...[
            const SizedBox(
              height: Grid.m,
            )
          ]
        ],
      ),
    );
  }
}
