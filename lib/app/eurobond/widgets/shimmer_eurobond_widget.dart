import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';

class ShimmerEurobondWidget extends StatelessWidget {
  const ShimmerEurobondWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Color floatingColor = context.pColorScheme.lightHigh;

    return Padding(
      padding: const EdgeInsets.all(
        Grid.s,
      ),
      child: ListView.separated(
        itemCount: 3,
        separatorBuilder: (context, index) => const Padding(
          padding: EdgeInsets.symmetric(
            vertical: Grid.s,
          ),
          child: Divider(),
        ),
        itemBuilder: (context, index) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: Grid.xs,
              children: [
                ClipOval(
                  child: Container(
                    width: 50,
                    height: 50,
                    color: floatingColor,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: Grid.s,
                  children: [
                    Container(
                      width: 100,
                      height: 20,
                      color: floatingColor,
                    ),
                    Container(
                      width: 80,
                      height: 20,
                      color: floatingColor,
                    ),
                  ],
                )
              ],
            ),
            Column(
              spacing: Grid.s,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 100,
                  height: 20,
                  color: floatingColor,
                ),
                Container(
                  width: 80,
                  height: 20,
                  color: floatingColor,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
