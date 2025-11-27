import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerFundFounderWidget extends StatelessWidget {
  const ShimmerFundFounderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Color floatingColor = context.pColorScheme.lightHigh;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: Grid.m,
      ),
      child: Shimmer.fromColors(
        baseColor: context.pColorScheme.textSecondary.withValues(
          alpha: 0.3,
        ),
        highlightColor: context.pColorScheme.textSecondary.withValues(
          alpha: 0.1,
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(
            horizontal: Grid.m,
          ),
          child: Row(
            spacing: Grid.s,
            children: [
              ...List.generate(
                6,
                (_) => Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: floatingColor,
                    borderRadius: BorderRadius.circular(Grid.s),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
