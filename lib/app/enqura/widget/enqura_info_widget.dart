import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class EnquraInfoWidget extends StatelessWidget {
  final Widget? imageWidget;
  final bool imageFormatIsSvg;
  final String? imagePath;
  final double imageSize;
  final Color? imageColor;
  final String? title;
  final String? subTitle;
  final TextStyle? titleStyle;
  final TextStyle? subTitleStyle;

  const EnquraInfoWidget({
    super.key,
    this.imageWidget,
    this.imageFormatIsSvg = true,
    this.imagePath,
    this.imageSize = Grid.xl + Grid.xl,
    this.imageColor,
    this.title,
    this.subTitle,
    this.titleStyle,
    this.subTitleStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: Grid.m,
      children: [
        if (imageWidget != null)
          imageWidget!
        else if (imagePath != null)
          imageFormatIsSvg
              ? SvgPicture.asset(
                  imagePath!,
                  height: imageSize,
                  width: imageSize,
                  colorFilter: imageColor == null
                      ? null
                      : ColorFilter.mode(
                          imageColor!,
                          BlendMode.srcIn,
                        ),
                )
              : Image.asset(
                  imagePath!,
                  height: imageSize,
                  width: imageSize,
                  color: imageColor,
                ),
        if (title?.isNotEmpty == true) ...[
          Text(
            title!,
            textAlign: TextAlign.center,
            style: titleStyle ?? context.pAppStyle.labelMed20textPrimary,
          ),
        ],
        if (subTitle?.isNotEmpty == true) ...[
          Text(
            subTitle!,
            textAlign: TextAlign.center,
            style: subTitleStyle ?? context.pAppStyle.labelReg16textPrimary,
          ),
        ],
      ],
    );
  }
}
