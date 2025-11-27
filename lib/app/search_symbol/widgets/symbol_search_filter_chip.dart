import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

class SymbolSearchFilterChip extends StatelessWidget {
  final String text;
  final bool isSelected;
  final void Function() onTap;
  const SymbolSearchFilterChip({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Grid.m - Grid.xs,
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? context.pColorScheme.secondary : context.pColorScheme.backgroundColor,
          borderRadius: BorderRadius.circular(Grid.m),
          border: Border.all(
            color: isSelected ? context.pColorScheme.secondary : context.pColorScheme.stroke,
            width: 1,
          ),
        ),
        child: Text(
          text,
          style: isSelected ? context.pAppStyle.labelMed14primary : context.pAppStyle.labelReg14textPrimary,
        ),
      ),
    );
  }
}
