import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';

class ShimmerTransactionHistory extends StatelessWidget {
  const ShimmerTransactionHistory({super.key});

  @override
  Widget build(BuildContext context) {
    Color floatingColor = context.pColorScheme.lightHigh;

    return Column(
      spacing: Grid.s,
      children: [
        Row(
          spacing: Grid.xs,
          children: [
            Container(
              width: 70,
              height: 20,
              decoration: BoxDecoration(
                color: floatingColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(
                    Grid.m,
                  ),
                ),
              ),
            ),
            Container(
              width: 70,
              height: 20,
              decoration: BoxDecoration(
                color: floatingColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(
                    Grid.m,
                  ),
                ),
              ),
            ),
            Container(
              width: 70,
              height: 20,
              decoration: BoxDecoration(
                color: floatingColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(
                    Grid.m,
                  ),
                ),
              ),
            ),
            const Spacer(),
            SvgPicture.asset(
              ImagesPath.search,
              width: 23,
              height: 23,
              colorFilter: ColorFilter.mode(floatingColor, BlendMode.srcIn),
            )
          ],
        ),
        const SizedBox(
          height: Grid.s,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
        const PDivider(),
        ListView.separated(
          itemCount: 3,
          shrinkWrap: true,
          separatorBuilder: (context, index) => const PDivider(
            padding: EdgeInsets.symmetric(
              vertical: Grid.m,
            ),
          ),
          itemBuilder: (context, index) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
                    width: 40,
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
                    width: 60,
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
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
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
                    width: 40,
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
                    width: 60,
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
            ],
          ),
        )
      ],
    );
  }
}
