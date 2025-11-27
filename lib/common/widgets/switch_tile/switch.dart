import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:flutter/material.dart';

class PSwitch extends StatelessWidget {
  final bool value;
  final Function(bool)? onChanged;
  final double? height;
  final double? width;
  const PSwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final double switchWidth = width ?? 37.5;
    final double switchHeight = height ?? 20;
    return GestureDetector(
      onTap: onChanged == null
          ? null
          : () {
              onChanged!(!value);
            },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: switchWidth,
        height: switchHeight,
        padding: const EdgeInsets.symmetric(horizontal: 1.25),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: value ? context.pColorScheme.primary : context.pColorScheme.stroke,
        ),
        child: AnimatedAlign(
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          duration: const Duration(milliseconds: 200),
          child: Container(
            width: switchHeight - 2.5,
            height: switchHeight - 2.5,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: value ? context.pColorScheme.card : context.pColorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}
