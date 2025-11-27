import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';

class ShimmerCryptoWidget extends StatelessWidget {
  const ShimmerCryptoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Color floatingColor = context.pColorScheme.lightHigh;

    return Padding(
      padding: const EdgeInsets.all(
        Grid.m,
      ),
      child: ListView.separated(
          itemCount: 3,
          shrinkWrap: true,
          separatorBuilder: (context, index) => const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: Grid.m,
                ),
                child: Divider(),
              ),
          itemBuilder: (context, index) {
            return Row(
              spacing: Grid.s,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  spacing: Grid.xs,
                  children: [
                    ClipOval(
                      child: Container(
                        width: 30,
                        height: 30,
                        color: floatingColor,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: Grid.xs,
                      children: [
                        Container(
                          width: 30,
                          height: 15,
                          color: floatingColor,
                        ),
                        Container(
                          width: 60,
                          height: 15,
                          color: floatingColor,
                        ),
                      ],
                    )
                  ],
                ),
                Container(
                  width: 50,
                  height: 20,
                  color: floatingColor,
                ),
                Container(
                  width: 50,
                  height: 20,
                  color: floatingColor,
                ),
              ],
            );
          }),
    );
  }
}
