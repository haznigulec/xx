import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/utils/localization_utils.dart';

class SymbolSearchFakeField extends StatelessWidget {
  final Function() onTap;
  final String? hintText;
  final double? width;
  const SymbolSearchFakeField({
    super.key,
    this.width,
    required this.onTap,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => onTap(),
      child: Container(
        height: 43,
        width: width ?? MediaQuery.of(context).size.width - Grid.m * 2,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: Grid.m),
        decoration: BoxDecoration(
          color: context.pColorScheme.stroke,
          borderRadius: BorderRadius.circular(Grid.l),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              ImagesPath.search,
              width: 17,
              height: 17,
              colorFilter: ColorFilter.mode(
                context.pColorScheme.textSecondary,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: Grid.xs),
            Container(
              height: 19,
              width: 2,
              margin: const EdgeInsets.only(right: Grid.xxs / 2),
              decoration: BoxDecoration(
                color: context.pColorScheme.primary,
                borderRadius: BorderRadius.circular(Grid.xxs),
              ),
            ),
            Text(
              hintText ?? L10n.tr('symbol_search'),
              style: context.pAppStyle.labelReg16textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
