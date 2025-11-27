import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

class AdvencedOrderTile extends StatelessWidget {
  final String title;
  final String? subTitle;
  final bool isSelected;
  final bool isEnabled;
  final Function(bool isSelected) onTap;
  const AdvencedOrderTile({
    super.key,
    required this.title,
    this.subTitle,
    required this.isSelected,
    required this.onTap,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: Grid.m,
      ),
      child: InkWell(
        child: Row(
          children: [
            SvgPicture.asset(
              isSelected ? ImagesPath.pencil : ImagesPath.plus,
              height: 18,
              width: 18,
              colorFilter: ColorFilter.mode(
                isEnabled ? context.pColorScheme.primary : context.pColorScheme.iconSecondary,
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
                const SizedBox(
                  height: Grid.xs,
                ),
                if (subTitle != null)
                  SizedBox(
                    width: MediaQuery.of(context).size.width - (Grid.m * 4),
                    child: Text(
                      subTitle!,
                      style: context.pAppStyle.labelReg12textSecondary,
                    ),
                  ),
              ],
            ),
          ],
        ),
        onTap: () => isEnabled ? onTap(!isSelected) : null,
      ),
    );
  }
}
