import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerUsBalanceWidget extends StatelessWidget {
  const ShimmerUsBalanceWidget({super.key});

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
        padding: const EdgeInsets.all(
          Grid.m,
        ),
        child: Column(
          spacing: Grid.s,
          children: [
            Container(
              width: MediaQuery.sizeOf(context).width,
              height: 30,
              decoration: BoxDecoration(
                color: floatingColor,
                borderRadius: BorderRadius.circular(Grid.m),
              ),
            ),
            const SizedBox(
              height: Grid.m,
            ),
            Container(
              width: MediaQuery.sizeOf(context).width,
              height: 40,
              decoration: BoxDecoration(
                color: floatingColor,
                borderRadius: BorderRadius.circular(Grid.m),
              ),
            ),
            Container(
              width: MediaQuery.sizeOf(context).width,
              height: 40,
              decoration: BoxDecoration(
                color: floatingColor,
                borderRadius: BorderRadius.circular(Grid.m),
              ),
            ),
            const SizedBox(
              height: Grid.m,
            ),
            Container(
              width: 150,
              height: 20,
              color: floatingColor,
            ),
            Container(
              width: 100,
              height: 20,
              color: floatingColor,
            ),
            const Spacer(),
            Container(
              width: MediaQuery.sizeOf(context).width,
              height: 40,
              decoration: BoxDecoration(
                color: floatingColor,
                borderRadius: BorderRadius.circular(Grid.m),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
