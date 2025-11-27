import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class LicenseGiveUpCancelButton extends StatelessWidget {
  final VoidCallback onTap;
  const LicenseGiveUpCancelButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 23,
      child: PCustomOutlinedButtonWithIcon(
        text: L10n.tr('give_up_cancel'),
        icon: Icon(
          Icons.arrow_outward_rounded,
          size: Grid.m,
          color: context.pColorScheme.critical,
        ),
        foregroundColor: context.pColorScheme.critical,
        foregroundColorApllyBorder: false,
        buttonType: PCustomOutlinedButtonTypes.mediumPrimary,
        textStyle: context.pAppStyle.labelMed14textSecondary.copyWith(
          color: context.pColorScheme.critical,
        ),
        onPressed: onTap,
      ),
    );
  }
}
