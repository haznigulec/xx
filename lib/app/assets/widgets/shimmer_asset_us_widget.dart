import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerAssetUsWidget extends StatelessWidget {
  const ShimmerAssetUsWidget({
    super.key,
  });

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
      child: Column(
        spacing: Grid.s,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 100,
                height: 20,
                color: floatingColor,
              ),
              Container(
                width: 100,
                height: 20,
                color: floatingColor,
              ),
            ],
          ),
          Container(
            width: double.infinity,
            height: 32,
            decoration: BoxDecoration(
              color: floatingColor,
              borderRadius: BorderRadius.circular(
                Grid.s,
              ),
            ),
          ), // Grafik için placeholder
          SizedBox(
            height: 62,
            child: Row(
              children: [
                Container(
                  height: 30,
                  width: 5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
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
                      height: 15,
                      color: floatingColor,
                    ),
                    Container(
                      width: 50,
                      height: 10,
                      color: floatingColor,
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  width: 70,
                  height: 15,
                  color: floatingColor,
                ),
                SvgPicture.asset(
                  ImagesPath.chevron_down,
                  colorFilter: ColorFilter.mode(
                    floatingColor,
                    BlendMode.srcIn,
                  ),
                  height: Grid.m,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
