import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';

class ShimmerSpecificListWidget extends StatelessWidget {
  const ShimmerSpecificListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Color floatingColor = context.pColorScheme.lightHigh;

    return Padding(
      padding: const EdgeInsets.only(
        bottom: Grid.s,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: Grid.s,
        children: [
          Container(
            width: 150,
            height: 22,
            margin: const EdgeInsets.only(
              left: Grid.m,
            ),
            decoration: BoxDecoration(
              color: floatingColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(
                  Grid.s,
                ),
              ),
            ),
          ),
          ListView.separated(
            itemCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => const Padding(
              padding: EdgeInsets.symmetric(
                vertical: Grid.m,
              ),
              child: Divider(),
            ),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(
                  left: Grid.m,
                  right: Grid.m,
                ),
                child: Row(
                  spacing: Grid.s,
                  children: [
                    Container(
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: Grid.xs,
                      children: [
                        Container(
                          width: 90,
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
                          width: 120,
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
                        Row(
                          spacing: Grid.xs,
                          children: [
                            Container(
                              width: 70,
                              height: 20,
                              decoration: BoxDecoration(
                                color: floatingColor,
                                borderRadius: BorderRadius.circular(
                                  Grid.s,
                                ),
                              ),
                            ),
                            Container(
                              width: 70,
                              height: 20,
                              decoration: BoxDecoration(
                                color: floatingColor,
                                borderRadius: BorderRadius.circular(
                                  Grid.s,
                                ),
                              ),
                            ),
                            Container(
                              width: 70,
                              height: 20,
                              decoration: BoxDecoration(
                                color: floatingColor,
                                borderRadius: BorderRadius.circular(
                                  Grid.s,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
