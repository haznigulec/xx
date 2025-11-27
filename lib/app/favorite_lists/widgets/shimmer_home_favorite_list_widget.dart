import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';

class ShimmerHomeFavoriteListWidget extends StatelessWidget {
  final int itemCount;
  const ShimmerHomeFavoriteListWidget({
    super.key,
    this.itemCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    Color floatingColor = context.pColorScheme.lightHigh;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Grid.m,
      ),
      child: ListView.separated(
          itemCount: itemCount,
          shrinkWrap: true,
          separatorBuilder: (context, index) => const PDivider(
                padding: EdgeInsets.symmetric(
                  vertical: Grid.s,
                ),
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
                        decoration: BoxDecoration(
                          color: floatingColor,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(
                              Grid.s,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: Grid.xs,
                      children: [
                        Container(
                          width: 30,
                          height: 15,
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
                          width: 60,
                          height: 15,
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
                    )
                  ],
                ),
                Container(
                  width: 50,
                  height: 20,
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
                  width: 50,
                  height: 20,
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
            );
          }),
    );
  }
}
