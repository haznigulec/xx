import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/ink_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

enum PIconButtonType { outlined, standard, fill }

enum PIconButtonSize { xxl, xl, l, m, s }

enum PButtonVariant { brand, success, error, warning, ghost, secondary, filled, textPrimary }

enum PButtonSize {
  xsmall,
  small,
  medium,
  large,
}

class PButtonTypeProperties {
  final Color textColor, backgroundColor, foregroundColor;

  PButtonTypeProperties({
    required this.textColor,
    required this.backgroundColor,
    required this.foregroundColor,
  });
}

final _sizeProperties = [
  // 6
  Grid.xs + Grid.xxs,
  //14
  Grid.m - Grid.xxs,
  //16
  Grid.m,
  //24
  Grid.l,
];

Map<PButtonVariant, PButtonTypeProperties>? _typeProperties;

Map<PButtonVariant, PButtonTypeProperties> getTypeProperties(BuildContext context) {
  _typeProperties ??= <PButtonVariant, PButtonTypeProperties>{
    PButtonVariant.brand: PButtonTypeProperties(
      textColor: context.pColorScheme.primary,
      backgroundColor: context.pColorScheme.primary,
      foregroundColor: context.pColorScheme.lightHigh,
    ),
    PButtonVariant.success: PButtonTypeProperties(
      textColor: context.pColorScheme.success,
      backgroundColor: context.pColorScheme.success,
      foregroundColor: context.pColorScheme.lightHigh,
    ),
    PButtonVariant.error: PButtonTypeProperties(
      textColor: context.pColorScheme.critical,
      backgroundColor: context.pColorScheme.critical,
      foregroundColor: context.pColorScheme.lightHigh,
    ),
    PButtonVariant.warning: PButtonTypeProperties(
      textColor: context.pColorScheme.warning,
      backgroundColor: context.pColorScheme.warning,
      foregroundColor: context.pColorScheme.darkHigh,
    ),
    PButtonVariant.ghost: PButtonTypeProperties(
      textColor: context.pColorScheme.textSecondary,
      backgroundColor: context.pColorScheme.stroke,
      foregroundColor: context.pColorScheme.textSecondary,
    ),
    PButtonVariant.secondary: PButtonTypeProperties(
      textColor: context.pColorScheme.primary,
      backgroundColor: context.pColorScheme.secondary,
      foregroundColor: context.pColorScheme.primary,
    ),
    PButtonVariant.textPrimary: PButtonTypeProperties(
      textColor: context.pColorScheme.textPrimary,
      backgroundColor: context.pColorScheme.stroke,
      foregroundColor: context.pColorScheme.textSecondary,
    ),
    PButtonVariant.filled: PButtonTypeProperties(
      textColor: context.pColorScheme.card.shade50,
      backgroundColor: context.pColorScheme.primary,
      foregroundColor: context.pColorScheme.lightHigh,
    ),
  };
  return _typeProperties!;
}

abstract class PNewButtonBase extends StatelessWidget {
  final PButtonSize size;
  final Alignment? contentAlignment;
  final Color? backgroundColor;
  final PButtonVariant variant;

  const PNewButtonBase({
    super.key,
    required this.variant,
    required this.size,
    this.contentAlignment,
    this.backgroundColor,
  });

  ButtonStyle _pElevatedButtonStyle(BuildContext context) {
    final properties = getTypeProperties(context)[variant]!;
    return ButtonStyle(
      alignment: contentAlignment,
      elevation: WidgetStateProperty.all(0.0),
      overlayColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
        if (states.contains(WidgetState.hovered)) {
          return context.pColorScheme.lightHigh.withValues(alpha: 0.08);
        }
        if (states.contains(WidgetState.pressed)) {
          return context.pColorScheme.lightHigh.withValues(alpha: 0.32);
        }
        return null;
      }),
      backgroundColor: WidgetStateProperty.resolveWith<Color>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return properties.backgroundColor.withValues(alpha: .4);
          }
          return properties.backgroundColor;
        },
      ),
      foregroundColor: WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return properties.foregroundColor.withValues(alpha: .4);
          }
          return properties.foregroundColor;
        },
      ),
      tapTargetSize: MaterialTapTargetSize.padded,
      visualDensity: size == PButtonSize.small ? VisualDensity.compact : VisualDensity.standard,
      padding: _getPadding(),
    );
  }

  ButtonStyle _pOutlinedButtonStyle(
    BuildContext context, {
    Color? backgroundColor,
    bool hasStroke = true,
  }) {
    final properties = getTypeProperties(context)[variant]!;
    return ButtonStyle(
      alignment: contentAlignment,
      padding: _getPadding(),

      backgroundColor: backgroundColor == null
          ? null
          : WidgetStateProperty.resolveWith<Color>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.disabled)) {
                  return properties.backgroundColor.withValues(alpha: .5);
                }
                return backgroundColor;
              },
            ),
      tapTargetSize: MaterialTapTargetSize.padded,
      visualDensity: VisualDensity.compact,
      elevation: WidgetStateProperty.all(0.0), //
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            Grid.l,
          ),
        ),
      ),

      overlayColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
        if (states.contains(WidgetState.hovered)) {
          return properties.backgroundColor.withValues(alpha: 0.04);
        }
        if (states.contains(WidgetState.pressed)) {
          return properties.backgroundColor.withValues(alpha: 0.30);
        }
        return null;
      }),
      side: WidgetStateProperty.resolveWith<BorderSide>(
        (Set<WidgetState> states) {
          final sideColor = hasStroke ? properties.backgroundColor : context.pColorScheme.transparent;
          if (states.contains(WidgetState.disabled)) {
            return BorderSide(
              color: sideColor,
            );
          }
          if (states.contains(WidgetState.pressed)) {
            return BorderSide(
              color: properties.backgroundColor,
            );
          }
          return BorderSide(
            color: sideColor,
          );
        },
      ),
      foregroundColor: WidgetStateProperty.resolveWith<Color>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return properties.textColor.withValues(alpha: .4);
          }
          return properties.textColor;
        },
      ),
    );
  }

  ButtonStyle? _pTextButtonStyle(BuildContext context) {
    final properties = getTypeProperties(context)[variant]!;
    return ButtonStyle(
      alignment: contentAlignment,
      overlayColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
        if (states.contains(WidgetState.hovered)) {
          return properties.backgroundColor.withValues(alpha: 0.04);
        }
        if (states.contains(WidgetState.pressed)) {
          return properties.backgroundColor.withValues(alpha: 0.30);
        }
        return null;
      }),
      foregroundColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return properties.textColor.withValues(alpha: .4);
        }
        return properties.textColor;
      }),
      padding: _getPadding(),
      tapTargetSize: MaterialTapTargetSize.padded,
      visualDensity: VisualDensity.standard,
    );
  }

  WidgetStateProperty<EdgeInsetsGeometry> _getPadding() {
    return WidgetStateProperty.resolveWith<EdgeInsetsGeometry>((Set<WidgetState> states) {
      if (size == PButtonSize.large) {
        return const EdgeInsets.all(Grid.m);
      } else if (size == PButtonSize.medium) {
        return const EdgeInsets.symmetric(
          horizontal: Grid.m,
          vertical: Grid.s + Grid.xs / 2,
        );
      } else if (size == PButtonSize.small) {
        return const EdgeInsets.symmetric(
          horizontal: Grid.m,
          vertical: Grid.s,
        );
      }

      return const EdgeInsets.symmetric(
        horizontal: Grid.s + Grid.xs,
      );
    });
  }
}

class PButton extends PNewButtonBase {
  final bool fillParentWidth;
  final String text;
  final PButtonSize sizeType;
  final VoidCallback? onPressed;
  final bool loading;
  late final double textSize;
  late final PButtonTypeProperties typeProperties;
  final String? iconPath;
  final Color? iconColor;

  PButton({
    super.key,
    required this.text,
    this.onPressed,
    this.fillParentWidth = false,
    this.loading = false,
    this.sizeType = PButtonSize.medium,
    super.variant = PButtonVariant.brand,
    this.iconPath,
    this.iconColor,
  }) : super(
          size: sizeType,
        ) {
    textSize = _sizeProperties[size.index];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 64),
      width: fillParentWidth ? double.infinity : null,
      child: ElevatedButton(
        style: _pElevatedButtonStyle(context),
        onPressed: onPressed,
        child: loading
            ? const _ButtonLoadingAnimation()
            : FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      maxLines: 1,
                      text,
                      style: context.pAppStyle.interMediumBase.copyWith(
                        fontSize: textSize,
                        color: onPressed == null ? context.pColorScheme.lightHigh : null,
                        height: 1,
                      ),
                    ),
                    if (iconPath != null) ...[
                      const SizedBox(
                        width: Grid.xs,
                      ),
                      SvgPicture.asset(
                        height: 18,
                        width: 18,
                        iconPath!,
                        
                        colorFilter: ColorFilter.mode(
                          iconColor ?? context.pColorScheme.primary,
                          BlendMode.srcIn,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
      ),
    );
  }
}

class POutlinedButton extends PNewButtonBase {
  final bool fillParentWidth;
  final String text;
  final PButtonSize sizeType;
  final VoidCallback? onPressed;
  final bool loading;
  late final PButtonTypeProperties typeProperties;
  late final double textSize;
  final String? iconPath;
  final Color? iconColor;

  POutlinedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.fillParentWidth = false,
    this.loading = false,
    this.sizeType = PButtonSize.medium,
    super.variant = PButtonVariant.brand,
    this.iconPath,
    this.iconColor,
  }) : super(
          size: sizeType,
        ) {
    textSize = _sizeProperties[size.index];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: fillParentWidth ? double.infinity : null,
      height: 52,
      constraints: const BoxConstraints(
        minWidth: 64,
      ),
      child: OutlinedButton(
        onPressed: onPressed,
        style: _pOutlinedButtonStyle(context),
        child: loading
            ? _ButtonLoadingAnimation(
                color: typeProperties.textColor,
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text,
                    style: context.pAppStyle.interMediumBase.copyWith(
                      fontSize: textSize,
                      height: 1,
                    ),
                  ),
                  if (iconPath != null) ...[
                    const SizedBox(
                      width: Grid.xs,
                    ),
                    SvgPicture.asset(
                      height: 18,
                      width: 18,
                      iconPath!,
                      
                      colorFilter: ColorFilter.mode(
                        iconColor ?? context.pColorScheme.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ],
                ],
              ),
      ),
    );
  }
}

class PTextButton extends PNewButtonBase {
  final bool fillParentWidth;
  final String text;
  final PButtonSize sizeType;
  final VoidCallback? onPressed;
  final bool loading;
  late final PButtonTypeProperties typeProperties;
  late final double textSize;

  PTextButton({
    super.key,
    required this.text,
    this.onPressed,
    this.fillParentWidth = false,
    this.loading = false,
    this.sizeType = PButtonSize.medium,
    super.variant = PButtonVariant.brand,
  }) : super(
          size: sizeType,
        ) {
    textSize = _sizeProperties[size.index];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: fillParentWidth ? double.infinity : null,
      constraints: const BoxConstraints(minWidth: 64),
      child: TextButton(
        onPressed: onPressed,
        style: _pTextButtonStyle(context),
        child: loading
            ? _ButtonLoadingAnimation(
                color: typeProperties.textColor,
              )
            : Text(
                text,
                style: context.pAppStyle.interMediumBase..copyWith(fontSize: textSize),
              ),
      ),
    );
  }
}

class PButtonWithIcon extends PNewButtonBase {
  final bool fillParentWidth;
  final String text;
  final Widget icon;
  final PButtonSize sizeType;
  final VoidCallback? onPressed;
  late final PButtonTypeProperties typeProperties;
  late final double textSize;
  final bool loading;
  final TextAlign textAlignment;
  final IconAlignment iconAlignment;
  final double? height;

  PButtonWithIcon({
    super.key,
    required this.text,
    this.onPressed,
    this.fillParentWidth = false,
    required this.icon,
    this.sizeType = PButtonSize.medium,
    super.variant = PButtonVariant.brand,
    this.loading = false,
    this.textAlignment = TextAlign.center,
    super.contentAlignment,
    this.iconAlignment = IconAlignment.start,
    this.height,
  }) : super(
          size: sizeType,
        ) {
    textSize = _sizeProperties[size.index];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: fillParentWidth ? double.infinity : null,
      height: height ?? 33,
      constraints: const BoxConstraints(minWidth: 64),
      child: ElevatedButton.icon(
        iconAlignment: iconAlignment,
        label: loading
            ? const Padding(
                padding: EdgeInsetsDirectional.only(end: 8.0),
                child: _ButtonLoadingAnimation(),
              )
            : Text(
                text,
                style: context.pAppStyle.interMediumBase
                  ..copyWith(
                    fontSize: textSize,
                  ),
                textAlign: textAlignment,
              ),
        icon: loading ? const SizedBox.shrink() : icon,
        onPressed: onPressed,
        style: _pElevatedButtonStyle(context),
      ),
    );
  }
}

class PTextButtonWithIcon extends PNewButtonBase {
  final bool fillParentWidth;
  final String text;
  final Widget icon;
  final PButtonSize sizeType;
  final VoidCallback? onPressed;
  late final PButtonTypeProperties typeProperties;
  late final double textSize;
  final bool loading;
  final TextAlign textAlignment;
  final IconAlignment iconAlignment;
  final EdgeInsetsGeometry? padding;

  PTextButtonWithIcon({
    super.key,
    required this.text,
    this.onPressed,
    this.fillParentWidth = false,
    required this.icon,
    this.sizeType = PButtonSize.medium,
    super.variant = PButtonVariant.brand,
    this.loading = false,
    this.textAlignment = TextAlign.center,
    super.contentAlignment,
    this.iconAlignment = IconAlignment.start,
    this.padding,
  }) : super(
          size: sizeType,
        ) {
    textSize = _sizeProperties[size.index];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: fillParentWidth ? double.infinity : null,
      constraints: const BoxConstraints(minWidth: 64),
      child: TextButton.icon(
        icon: loading ? const SizedBox.shrink() : icon,
        style: padding != null
            ? _pTextButtonStyle(context)?.copyWith(
                padding: WidgetStateProperty.resolveWith<EdgeInsetsGeometry>((Set<WidgetState> states) {
                  return padding!;
                }),
              )
            : _pTextButtonStyle(context),
        label: loading
            ? Padding(
                padding: const EdgeInsetsDirectional.only(end: 8.0),
                child: _ButtonLoadingAnimation(
                  color: typeProperties.textColor,
                ),
              )
            : Text(
                text,
                style: context.pAppStyle.interMediumBase.copyWith(fontSize: textSize),
                textAlign: textAlignment,
              ),
        onPressed: onPressed,
        iconAlignment: iconAlignment,
      ),
    );
  }
}

class PIconButton extends StatelessWidget {
  final PIconButtonType type;
  final PIconButtonSize sizeType;
  final IconData? icon;
  final String? svgPath;
  final Color? color;
  final Color? iconColor;
  final VoidCallback? onPressed;
  final List<double> sizes = [32, 24, 20, 16, 12];
  final List<double> sizeBasedPadding = [14, 12, 10, 8, 6];
  final bool loading;

  PIconButton({
    super.key,
    required this.type,
    this.sizeType = PIconButtonSize.m,
    this.icon,
    this.svgPath,
    this.color,
    this.iconColor,
    this.onPressed,
    this.loading = false,
  }) : assert(icon != null || svgPath != null);

  @override
  Widget build(BuildContext context) {
    return InkWrapper(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(Grid.xxs),
        child: loading
            ? _ButtonLoadingAnimation(color: color ?? context.pColorScheme.primary)
            : icon != null
                ? Icon(
                    icon,
                    size: sizes[sizeType.index],
                    color: iconColor ?? context.pColorScheme.iconPrimary,
                  )
                : SvgPicture.asset(
                    svgPath!,
                    width: sizes[sizeType.index],
                    height: sizes[sizeType.index],
                    colorFilter: ColorFilter.mode(
                      iconColor ?? context.pColorScheme.iconPrimary,
                      BlendMode.srcIn,
                    ),
                  ),
      ),
    );
  }
}

class _ButtonLoadingAnimation extends StatelessWidget {
  final Color? color;
  const _ButtonLoadingAnimation({this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Grid.l,
      width: Grid.l,
      child: CircularProgressIndicator(
        strokeWidth: 3,
        valueColor: AlwaysStoppedAnimation<Color>(color ?? context.pColorScheme.lightHigh),
      ),
    );
  }
}

