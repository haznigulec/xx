import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

enum PCustomOutlinedButtonTypes {
  large,
  mediumPrimary,
  mediumSecondary,
  smallPrimary,
  smallSecondary,
}

class PCustomOutlinedButtonWithIcon extends StatelessWidget {
  const PCustomOutlinedButtonWithIcon({
    super.key,
    required this.onPressed,
    this.text,
    this.selectedWidget,
    this.iconSource,
    this.icon,
    this.foregroundColorApllyBorder = true,
    this.foregroundColor,
    this.disabledForegroundColor,
    this.backgroundColor,
    this.fillParentWidth = false,
    this.iconAlignment = IconAlignment.end,
    this.textStyle,
    this.tapTargetSize,
    this.buttonType = PCustomOutlinedButtonTypes.smallPrimary,
  });

  final Function()? onPressed;
  final String? text;
  final Widget? selectedWidget;
  final String? iconSource;
  final Widget? icon;
  final bool foregroundColorApllyBorder;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final Color? disabledForegroundColor;
  final bool fillParentWidth;
  final IconAlignment iconAlignment;
  final TextStyle? textStyle;
  final MaterialTapTargetSize? tapTargetSize;
  final PCustomOutlinedButtonTypes buttonType;

  @override
  Widget build(BuildContext context) {
    ButtonStyle? buttonStyle;
    Color iconColor;
    double iconSize;

    switch (buttonType) {
      case PCustomOutlinedButtonTypes.large:
        buttonStyle = buttonStyle ?? context.pAppStyle.oulinedLargePrimaryStyle;
        iconColor = foregroundColor ?? context.pColorScheme.primary;
        iconSize = Grid.m + Grid.xxs;
        break;
      case PCustomOutlinedButtonTypes.mediumPrimary:
        buttonStyle = buttonStyle ?? context.pAppStyle.oulinedMediumPrimaryStyle;
        iconColor = foregroundColor ?? context.pColorScheme.textPrimary;
        iconSize = Grid.m + (Grid.xxs / 2);
        break;
      case PCustomOutlinedButtonTypes.mediumSecondary:
        buttonStyle = buttonStyle ?? context.pAppStyle.oulinedMediumSecondaryStyle;
        iconColor = foregroundColor ?? context.pColorScheme.primary;
        iconSize = Grid.m + (Grid.xxs / 2);
        break;
      case PCustomOutlinedButtonTypes.smallPrimary:
        buttonStyle = buttonStyle ?? context.pAppStyle.oulinedSmallPrimaryStyle;
        iconColor = foregroundColor ?? context.pColorScheme.textSecondary;
        iconSize = Grid.m - (Grid.xxs / 2);
        break;
      case PCustomOutlinedButtonTypes.smallSecondary:
        buttonStyle = buttonStyle ?? context.pAppStyle.oulinedSmallSecondaryStyle;
        iconColor = context.pColorScheme.textPrimary;
        iconSize = Grid.m - (Grid.xxs / 2);
        break;
    }

    if (foregroundColor != null) {
      buttonStyle = buttonStyle.copyWith(
        foregroundColor: WidgetStatePropertyAll(foregroundColor),
        side: foregroundColorApllyBorder
            ? WidgetStatePropertyAll(
                BorderSide(color: foregroundColor!),
              )
            : buttonStyle.side,
      );
    }

    if (disabledForegroundColor != null) {
      buttonStyle.copyWith(
        side: foregroundColorApllyBorder
            ? WidgetStatePropertyAll(
                BorderSide(color: disabledForegroundColor!),
              )
            : buttonStyle.side,
      );
    }

    if (backgroundColor != null) {
      buttonStyle = buttonStyle.copyWith(
        backgroundColor: WidgetStatePropertyAll(backgroundColor),
        side: foregroundColorApllyBorder
            ? buttonStyle.side
            : WidgetStatePropertyAll(
                BorderSide(color: backgroundColor!),
              ),
      );
    }

    if (tapTargetSize != null) {
      buttonStyle = buttonStyle.copyWith(
        tapTargetSize: tapTargetSize,
      );
    }

    if (textStyle != null) {
      buttonStyle = buttonStyle.copyWith(
        textStyle: WidgetStatePropertyAll(textStyle),
      );
    }

    return OutlinedButton(
      onPressed: onPressed,
      style: buttonStyle,
      child: Row(
        spacing: Grid.xs,
        mainAxisSize: fillParentWidth ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (iconAlignment == IconAlignment.end) ...[
            selectedWidget ??
                Flexible(
                  child: Text(
                    text ?? '',
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
          ],
          if (icon != null) ...{
            icon!
          } else if (iconSource != null) ...[
            SvgPicture.asset(
              iconSource!,
              colorFilter: ColorFilter.mode(
                iconColor,
                BlendMode.srcIn,
              ),
              width: iconSize,
              height: iconSize,
            ),
          ],
          if (iconAlignment == IconAlignment.start) ...[
            selectedWidget ??
                Flexible(
                  child: Text(
                    text ?? '',
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
          ],
        ],
      ),
    );
  }
}

class PCustomPrimaryTextButton extends StatelessWidget {
  const PCustomPrimaryTextButton({
    required this.text,
    this.icon,
    this.iconSource,
    this.iconAlignment = IconAlignment.start,
    this.margin = EdgeInsets.zero,
    this.iconSpacing = Grid.xs,
    required this.onPressed,
    this.style,
    this.mainAxisAlignment = MainAxisAlignment.start,
    super.key,
  });
  final String text;
  final Widget? icon;
  final String? iconSource;
  final IconAlignment iconAlignment;
  final EdgeInsets margin;
  final double iconSpacing;
  final TextStyle? style;
  final Function()? onPressed;
  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        margin: margin,
        color: context.pColorScheme.transparent,
        child: Row(
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (iconAlignment == IconAlignment.end) ...[
              Text(
                text,
                style: style ?? context.pAppStyle.labelReg16primary,
              ),
              SizedBox(
                width: iconSpacing,
              ),
            ],
            if (icon != null) ...{
              icon!
            } else if (iconSource != null) ...[
              SvgPicture.asset(
                iconSource!,
                colorFilter: ColorFilter.mode(
                  style?.color ?? context.pColorScheme.primary,
                  BlendMode.srcIn,
                ),
                width: Grid.m,
                height: Grid.m,
              ),
            ],
            if (iconAlignment == IconAlignment.start) ...[
              if (icon != null) ...[
                SizedBox(
                  width: iconSpacing,
                ),
              ],
              Text(
                text,
                style: style ?? context.pAppStyle.labelReg16primary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
