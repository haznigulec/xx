import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';

class ShimmerOrdersListWidget extends StatelessWidget {
  final int itemCount;
  const ShimmerOrdersListWidget({
    super.key,
    this.itemCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    Color floatingColor = context.pColorScheme.lightHigh;

    return ListView.separated(
      itemCount: itemCount,
      shrinkWrap: true,
      separatorBuilder: (context, index) => const Padding(
        padding: EdgeInsets.symmetric(
          vertical: Grid.m,
        ),
        child: PDivider(),
      ),
      itemBuilder: (context, index) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: Grid.s,
        children: [
          Row(
            spacing: Grid.s,
            children: [
              ClipOval(
                child: Container(
                  width: 28,
                  height: 28,
                  color: floatingColor,
                ),
              ),
              Column(
                spacing: Grid.xs,
                children: [
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
              ),
            ],
          ),
          Row(
            spacing: Grid.s,
            children: [
              Column(
                spacing: Grid.xs,
                children: [
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
              ),
              SvgPicture.asset(
                ImagesPath.chevron_right,
                width: 15,
                height: 15,
                colorFilter: ColorFilter.mode(
                  context.pColorScheme.textPrimary,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
