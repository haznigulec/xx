import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

class OrderUsDetailRowWidget extends StatelessWidget {
  final String title;
  final String value;
  final Color? valueColor;
  final Widget? widget;
  const OrderUsDetailRowWidget({
    super.key,
    required this.title,
    required this.value,
    this.valueColor,
    this.widget,
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
              style: context.pAppStyle.labelReg14textSecondary,
            ),
            widget ??
                Text(
                  value,
                  style: context.pAppStyle.interMediumBase.copyWith(
                    fontSize: Grid.m - Grid.xxs,
                    color: valueColor ?? context.pColorScheme.textPrimary,
                  ),
                ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(
            vertical: Grid.s + Grid.xs,
          ),
          child: PDivider(),
        ),
      ],
    );
  }
}
