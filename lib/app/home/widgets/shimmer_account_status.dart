import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';

class ShimmerAccountStatus extends StatelessWidget {
  const ShimmerAccountStatus({super.key});

  @override
  Widget build(BuildContext context) {
    Color floatingColor = context.pColorScheme.lightHigh;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: Grid.xxs,
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
        Row(
          spacing: Grid.s,
          children: [
            Container(
              width: 140,
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
            SvgPicture.asset(
              ImagesPath.eye_on,
              colorFilter: ColorFilter.mode(
                floatingColor,
                BlendMode.srcIn,
              ),
              height: Grid.m,
            ),
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
      ],
    );
  }
}
