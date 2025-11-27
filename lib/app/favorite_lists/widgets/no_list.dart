import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/favorite_lists/favorite_list_utils.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/utils/localization_utils.dart';

class NoList extends StatelessWidget {
  const NoList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: Grid.m,
        children: [
          SvgPicture.asset(
            ImagesPath.telescope_on,
            width: 32,
            height: 32,
            colorFilter: ColorFilter.mode(
              context.pColorScheme.iconPrimary,
              BlendMode.srcIn,
            ),
          ),
          Text(
            L10n.tr('no_favorite_list'),
            style: context.pAppStyle.labelReg14textPrimary,
          ),
          PButtonWithIcon(
            text: L10n.tr('create_favorite_list'),
            sizeType: PButtonSize.small,
            icon: SvgPicture.asset(
              ImagesPath.plus,
              width: Grid.m,
              colorFilter: ColorFilter.mode(
                context.pColorScheme.lightHigh,
                BlendMode.srcIn,
              ),
            ),
            onPressed: () => FavoriteListUtils().createFavoriteList(context),
          ),
        ],
      ),
    );
  }
}
