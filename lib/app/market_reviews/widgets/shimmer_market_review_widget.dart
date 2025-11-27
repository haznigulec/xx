import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerMarketReviewWidget extends StatelessWidget {
  const ShimmerMarketReviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Color floatingColor = context.pColorScheme.lightHigh;

    return Shimmer.fromColors(
      baseColor: context.pColorScheme.textSecondary.withValues(
        alpha: 0.3,
      ),
      highlightColor: context.pColorScheme.textSecondary.withValues(
        alpha: 0.1,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Grid.m,
        ),
        child: Row(
          spacing: Grid.m,
          children: [
            Container(
              width: 30,
              height: 30,
              color: floatingColor,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: Grid.s,
              children: [
                Container(
                  width: 60,
                  height: 20,
                  color: floatingColor,
                ),
                Container(
                  width: 250,
                  height: 30,
                  color: floatingColor,
                ),
                Row(
                  spacing: Grid.s,
                  children: [
                    Container(
                      width: 60,
                      height: 15,
                      decoration: BoxDecoration(
                        color: floatingColor,
                        border: Border.all(
                          color: context.pColorScheme.stroke.shade200,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(
                            Grid.m,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 60,
                      height: 15,
                      decoration: BoxDecoration(
                        color: floatingColor,
                        border: Border.all(
                          color: context.pColorScheme.stroke.shade200,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(
                            Grid.m,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
