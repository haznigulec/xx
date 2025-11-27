import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';

class ShimmerIpoWidget extends StatelessWidget {
  const ShimmerIpoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Color floatingColor = context.pColorScheme.lightHigh;

    return Column(
      spacing: Grid.s,
      children: [
        Row(
          children: [
            ClipOval(
              child: Container(
                height: 38,
                width: 38,
                color: floatingColor,
              ),
            ),
            const SizedBox(
              width: Grid.s,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: Grid.xs,
              children: [
                Container(
                  width: 50,
                  height: 10,
                  decoration: BoxDecoration(
                    color: floatingColor,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(
                        Grid.s,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 80,
                  height: 10,
                  decoration: BoxDecoration(
                    color: floatingColor,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(
                        Grid.s,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              spacing: Grid.xs,
              children: [
                Container(
                  width: 50,
                  height: 10,
                  decoration: BoxDecoration(
                    color: floatingColor,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(
                        Grid.s,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 80,
                  height: 10,
                  decoration: BoxDecoration(
                    color: floatingColor,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(
                        Grid.s,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const PDivider(),
        Row(
          children: [
            ClipOval(
              child: Container(
                height: 38,
                width: 38,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: floatingColor,
                ),
              ),
            ),
            const SizedBox(
              width: Grid.s,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: Grid.xs,
              children: [
                Container(
                  width: 50,
                  height: 10,
                  decoration: BoxDecoration(
                    color: floatingColor,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(
                        Grid.s,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 80,
                  height: 10,
                  decoration: BoxDecoration(
                    color: floatingColor,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(
                        Grid.s,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              spacing: Grid.xs,
              children: [
                Container(
                  width: 50,
                  height: 10,
                  decoration: BoxDecoration(
                    color: floatingColor,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(
                        Grid.s,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 80,
                  height: 10,
                  decoration: BoxDecoration(
                    color: floatingColor,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(
                        Grid.s,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
