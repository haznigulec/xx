import 'dart:core';

import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';

class DemandDetailRow extends StatelessWidget {
  final String title;
  final String value;
  final TextStyle? textStyle;
  final bool hasDivider;
  const DemandDetailRow({
    super.key,
    required this.title,
    required this.value,
    this.textStyle,
    this.hasDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: Grid.xs,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: Grid.s,
            children: [
              Text(
                title,
                textAlign: TextAlign.left,
                style: context.pAppStyle.labelReg14textSecondary,
              ),
              Expanded(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  style: textStyle ?? context.pAppStyle.labelMed14textPrimary,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: Grid.s + Grid.xs,
          ),
          child: hasDivider ? const PDivider() : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
