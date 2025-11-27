import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

class CustomProgressBar extends StatelessWidget {
  final double value;
  final String progressText;
  final String? title;

  const CustomProgressBar({
    super.key,
    required this.value,
    required this.progressText,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(Grid.s),
          child: Container(
            width: MediaQuery.sizeOf(context).width,
            height: Grid.s,
            decoration: BoxDecoration(
              color: context.pColorScheme.line,
              borderRadius: BorderRadius.circular(
                Grid.s,
              ),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: value,
              child: Container(
                decoration: BoxDecoration(
                  color: context.pColorScheme.primary,
                  borderRadius: BorderRadius.circular(
                    Grid.s,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: Grid.s),
        Text(
          progressText,
          style: context.pAppStyle.labelMed14primary,
        ),
        const SizedBox(height: Grid.l / 2),
        if (title != null) ...[
          Text(
            title ?? '',
            style: context.pAppStyle.labelMed18primary,
          ),
        ],
      ],
    );
  }
}
