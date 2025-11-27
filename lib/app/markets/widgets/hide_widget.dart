import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class HideWidget extends StatelessWidget {
  final VoidCallback onTap;
  const HideWidget({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 22,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: Grid.xs,
            horizontal: Grid.s + Grid.xxs,
          ),
          decoration: BoxDecoration(
            color: context.pColorScheme.backgroundColor,
            borderRadius: BorderRadius.circular(
              Grid.m,
            ),
            border: Border.all(
              color: context.pColorScheme.stroke,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Text(
                L10n.tr('hide'),
                style: context.pAppStyle.labelMed12textPrimary,
              ),
              const SizedBox(
                width: Grid.xs,
              ),
              SvgPicture.asset(
                ImagesPath.chevron_up,
                width: Grid.s + Grid.xs,
                colorFilter: ColorFilter.mode(
                  context.pColorScheme.textPrimary,
                  BlendMode.srcIn,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
