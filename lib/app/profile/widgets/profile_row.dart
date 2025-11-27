import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

class ProfileRow extends StatelessWidget {
  final String iconName;
  final String title;
  final Color? titleColor;
  final VoidCallback onTap;
  const ProfileRow({
    super.key,
    required this.iconName,
    required this.title,
    this.titleColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: InkWell(
        splashColor: context.pColorScheme.transparent,
        highlightColor: context.pColorScheme.transparent,
        onTap: onTap,
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.pColorScheme.card,
              ),
              child: SvgPicture.asset(
                iconName,
                height: 18,
                width: 18,
                colorFilter: ColorFilter.mode(
                  context.pColorScheme.primary,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(
              width: Grid.s,
            ),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.start,
                style: context.pAppStyle.labelReg16textPrimary.copyWith(
                  color: titleColor ?? context.pColorScheme.textPrimary,
                ),
              ),
            ),
            const SizedBox(
              width: Grid.s,
            ),
            SvgPicture.asset(
              ImagesPath.chevron_right,
              width: Grid.m,
              height: Grid.m,
              colorFilter: ColorFilter.mode(
                context.pColorScheme.textPrimary,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
