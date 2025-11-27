import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/utils/localization_utils.dart';

class ContactButton extends StatelessWidget {
  final VoidCallback onTap;
  final String iconPath;
  final String text;

  const ContactButton({
    super.key,
    required this.onTap,
    required this.iconPath,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: context.pColorScheme.transparent,
      highlightColor: context.pColorScheme.transparent,
      focusColor: context.pColorScheme.transparent,
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            iconPath,
            width: 20,
            fit: BoxFit.contain,
            colorFilter: ColorFilter.mode(
              context.pColorScheme.primary,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(
            width: Grid.s,
          ),
          Text(
            L10n.tr(text),
            style: context.pAppStyle.labelMed16primary,
          ),
        ],
      ),
    );
  }
}
