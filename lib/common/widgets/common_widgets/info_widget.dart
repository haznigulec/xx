import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';

class PInfoWidget extends StatelessWidget {
  final String infoText;
  final TextStyle? infoTextStyle;
  final bool isAlignCenter;
  final String? iconPath;
  final Color? textColor;
  final CrossAxisAlignment crossAxisAlignment;
  final Widget? textWidget;
  final bool leadingIcon;
  final MaterialColor? iconColor;

  const PInfoWidget({
    super.key,
    required this.infoText,
    this.infoTextStyle,
    this.isAlignCenter = false,
    this.iconPath,
    this.textColor,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.textWidget,
    this.leadingIcon = true,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: crossAxisAlignment,
      spacing: Grid.xs,
      children: [
        if (leadingIcon) _iconWidget(context),
        textWidget ??
            Expanded(
              child: Text(
                infoText,
                textAlign: isAlignCenter ? TextAlign.center : TextAlign.left,
                style: infoTextStyle ??
                    context.pAppStyle.labelReg14textPrimary.copyWith(
                      color: textColor ?? context.pColorScheme.textPrimary,
                    ),
              ),
            ),
        if (!leadingIcon) _iconWidget(context),
      ],
    );
  }

  Widget _iconWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: Grid.xxs,
      ),
      child: SvgPicture.asset(
        iconPath ?? ImagesPath.alert_circle,
        width: Grid.m,
        height: Grid.m,
        colorFilter: ColorFilter.mode(
          iconColor ?? context.pColorScheme.primary,
          BlendMode.srcIn,
        ),
      ),
    );
  }

}
