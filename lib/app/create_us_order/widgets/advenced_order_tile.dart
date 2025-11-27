import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

class AdvencedOrderTile extends StatelessWidget {
  final String title;
  final String? subTitle;
  final bool isSelected;
  final Function(bool isSelected) onTap;
  const AdvencedOrderTile({
    super.key,
    required this.title,
    this.subTitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: Grid.m,
      ),
      child: InkWell(
        splashColor: context.pColorScheme.transparent,
        highlightColor: context.pColorScheme.transparent,
        child: Row(
          children: [
            SvgPicture.asset(
              isSelected ? ImagesPath.pencil : ImagesPath.plus,
              height: 15,
              width: 15,
              colorFilter: ColorFilter.mode(
                context.pColorScheme.primary,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(
              width: Grid.s,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.pAppStyle.interMediumBase.copyWith(
                    color: isSelected ? context.pColorScheme.primary : context.pColorScheme.textPrimary,
                    fontSize: Grid.m,
                  ),
                ),
                if (subTitle != null)
                  Text(
                    subTitle!,
                    style: context.pAppStyle.interRegularBase.copyWith(
                      color: context.pColorScheme.textSecondary,
                      fontSize: Grid.s + Grid.xs,
                    ),
                  ),
              ],
            ),
          ],
        ),
        onTap: () => onTap(!isSelected),
      ),
    );
  }
}
