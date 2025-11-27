import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';

class ShimmerFundList extends StatelessWidget {
  final int itemCount;
  const ShimmerFundList({
    super.key,
    this.itemCount = 5,
  });

  @override
  Widget build(BuildContext context) {
    Color floatingColor = context.pColorScheme.lightHigh;

    return ListView.separated(
      itemCount: itemCount,
      shrinkWrap: true,
      separatorBuilder: (context, index) => const PDivider(
        padding: EdgeInsets.symmetric(
          vertical: 8.0,
        ),
      ),
      itemBuilder: (context, index) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            spacing: Grid.xs,
            children: [
              Container(
                width: 40,
                height: 40,
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
                    width: 80,
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
                    width: 100,
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
              )
            ],
          ),
          Container(
            width: 80,
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
      ),
    );
  }
}
