import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';

class LicenseInfoRow extends StatelessWidget {
  final String title;
  final String text;
  final Widget? trailingWidget;
  final TextStyle? textStyle;
  const LicenseInfoRow({
    super.key,
    required this.title,
    required this.text,
    this.trailingWidget,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              textAlign: TextAlign.left,
              style: context.pAppStyle.labelReg14textSecondary,
            ),
            Expanded(
              flex: 3,
              child: trailingWidget ??
                  Text(
                    text,
                    textAlign: TextAlign.end,
                    style: textStyle ?? context.pAppStyle.labelMed14textPrimary,
                  ),
            ),
          ],
        ),
        const PDivider(
          padding: EdgeInsets.symmetric(
            vertical: Grid.s + Grid.xs,
          ),
        ),
      ],
    );
  }
}
