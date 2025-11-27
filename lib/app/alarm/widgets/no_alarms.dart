import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class NoAlarms extends StatelessWidget {
  final VoidCallback? onPressed;
  final String message;

  const NoAlarms({
    super.key,
    this.onPressed,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              ImagesPath.telescope_off,
              width: 32,
              height: 32,
            ),
            const SizedBox(
              height: Grid.m,
            ),
            Text(
              L10n.tr('no_active_alarm'),
              textAlign: TextAlign.center,
              style: context.pAppStyle.labelMed18textPrimary,
            ),
            const SizedBox(
              height: Grid.m,
            ),
            Text(
              L10n.tr(message),
              textAlign: TextAlign.center,
              style: context.pAppStyle.labelReg14textPrimary,
            ),
            const SizedBox(
              height: Grid.m,
            ),
            PButtonWithIcon(
              text: L10n.tr('alarm_kur'),
              sizeType: PButtonSize.small,
              icon: SvgPicture.asset(
                ImagesPath.plus,
                width: 17,
                height: 17,
                colorFilter: ColorFilter.mode(
                  context.pColorScheme.lightHigh,
                  BlendMode.srcIn,
                ),
              ),
              onPressed: onPressed,
            ),
            const SizedBox(
              height: Grid.l,
            ),
          ],
        ),
      ),
    );
  }
}
