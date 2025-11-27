import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

class SettingsTile extends StatelessWidget {
  final String title;
  final String? imagesPath;
  final Function() onTap;
  const SettingsTile({
    super.key,
    required this.title,
    this.imagesPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Grid.s + Grid.xxs),
      child: SizedBox(
        height: 20,
        child: InkWell(
          splashColor: context.pColorScheme.transparent,
          highlightColor: context.pColorScheme.transparent,
          onTap: () => onTap(),
          child: Row(
            children: [
              Text(
                title,
                style: context.pAppStyle.labelReg16textPrimary,
              ),
              const Spacer(),
              SvgPicture.asset(
                imagesPath ?? ImagesPath.chevron_right,
                width: 17,
                height: 17,
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
