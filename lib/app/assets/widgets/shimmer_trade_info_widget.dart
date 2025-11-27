import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerTradeInfoWidget extends StatelessWidget {
  const ShimmerTradeInfoWidget({super.key});

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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            spacing: Grid.xs,
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
          Row(
            children: [
              Container(
                width: 100,
                height: 20,
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
        ],
      ),
    );
  }
}
