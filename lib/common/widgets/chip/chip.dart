import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_svg_image/cached_network_svg_image.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:p_core/utils/string_utils.dart';

enum ChipSize {
  large,
  medium,
  small,
}

class _ChipProperties {
  final EdgeInsetsDirectional padding;
  final TextStyle textStyle;
  final Color selectedColor, disabledColor;
  final double prefixIconRadius;

  _ChipProperties({
    required this.padding,
    required this.textStyle,
    required this.selectedColor,
    required this.prefixIconRadius,
    required this.disabledColor,
  });
}

Map<ChipSize, _ChipProperties> _getChipProperties(BuildContext context) {
  return <ChipSize, _ChipProperties>{
    ChipSize.large: _ChipProperties(
      padding: const EdgeInsetsDirectional.fromSTEB(
        Grid.s + Grid.xs / 2,
        Grid.xs,
        Grid.s + Grid.xs / 2,
        Grid.xs,
      ),
      textStyle: context.pAppStyle.interRegularBase.copyWith(
        fontSize: Grid.m + Grid.xxs,
        color: context.pColorScheme.textPrimary,
      ),
      selectedColor: context.pColorScheme.backgroundColor,
      prefixIconRadius: Grid.m + Grid.xs,
      disabledColor: context.pColorScheme.iconPrimary,
    ),
    ChipSize.medium: _ChipProperties(
      padding: const EdgeInsetsDirectional.fromSTEB(
        Grid.s + Grid.xs / 2,
        Grid.xs,
        Grid.s + Grid.xs / 2,
        Grid.xs,
      ),
      textStyle: context.pAppStyle.interMediumBase.copyWith(
        fontSize: Grid.m,
        color: context.pColorScheme.textPrimary,
      ),
      selectedColor: context.pColorScheme.backgroundColor,
      prefixIconRadius: Grid.s + Grid.xs,
      disabledColor: context.pColorScheme.iconPrimary,
    ),
    ChipSize.small: _ChipProperties(
      padding: const EdgeInsetsDirectional.fromSTEB(Grid.s, Grid.xs, Grid.s, Grid.xs),
      textStyle: context.pAppStyle.interMediumBase.copyWith(
        fontSize: Grid.m - Grid.xxs,
        color: context.pColorScheme.textPrimary,
      ),
      selectedColor: context.pColorScheme.backgroundColor,
      prefixIconRadius: Grid.s + Grid.xs,
      disabledColor: context.pColorScheme.iconPrimary,
    ),
  };
}

class PChipList extends StatelessWidget {
  final List<Widget> children;

  const PChipList({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: Grid.s,
      runSpacing: Grid.xs,
      children: children,
    );
  }
}

class PInputChip extends StatelessWidget {
  final String label;
  final Function(bool)? onSelected;
  final bool selected, enabled;
  final ChipSize chipSize;
  final bool showDeleteIcon;

  const PInputChip({
    super.key,
    required this.label,
    required this.chipSize,
    this.onSelected,
    this.selected = false,
    this.enabled = true,
    this.showDeleteIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final chipProperties = _getChipProperties(context)[chipSize]!;
    return InputChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            StringUtils.titleCase(label) ?? '',
            style: chipProperties.textStyle,
          ),
          if (selected && showDeleteIcon) ...<Widget>[
            const SizedBox(
              width: Grid.xs + Grid.xxs,
            ),
            Icon(
              Icons.close,
              color: context.pColorScheme.darkHigh,
              size: Grid.m,
            ),
          ],
        ],
      ),
      selected: enabled && selected,
      onSelected: onSelected,
      showCheckmark: false,
      padding: chipProperties.padding,
      isEnabled: enabled,
      selectedColor: chipProperties.selectedColor,
      visualDensity:
          const VisualDensity(vertical: VisualDensity.minimumDensity, horizontal: VisualDensity.minimumDensity),
      backgroundColor: chipProperties.selectedColor,
      disabledColor: chipProperties.disabledColor,
      labelPadding: EdgeInsets.zero,
      side: BorderSide(color: (enabled && selected) ? context.pColorScheme.darkHigh : chipProperties.selectedColor),
    );
  }
}

class PInputWithIconChip extends StatelessWidget {
  final String label;
  final Function(bool)? onSelected;
  final bool selected, enabled;
  final ChipSize chipSize;
  final IconData iconData;
  final Color? iconColor;
  final bool showDeleteIcon;
  final Color? selectedColor;
  final Color? borderColor;

  const PInputWithIconChip({
    super.key,
    required this.label,
    required this.chipSize,
    required this.iconData,
    this.onSelected,
    this.selected = false,
    this.enabled = true,
    this.iconColor,
    this.showDeleteIcon = true,
    this.selectedColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final chipProperties = _getChipProperties(context)[chipSize]!;
    return InputChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            iconData,
            size: chipProperties.prefixIconRadius,
            color: iconColor ?? context.pColorScheme.darkHigh,
          ),
          const SizedBox(
            width: Grid.xs + Grid.xxs,
          ),
          Text(
            StringUtils.titleCase(label) ?? '',
            style: chipProperties.textStyle,
          ),
          if (selected && showDeleteIcon) ...<Widget>[
            const SizedBox(
              width: Grid.xs + Grid.xxs,
            ),
            Icon(
              Icons.close,
              color: context.pColorScheme.darkHigh,
              size: Grid.m,
            ),
          ],
        ],
      ),
      selected: enabled && selected,
      onSelected: onSelected,
      showCheckmark: false,
      padding: chipProperties.padding,
      isEnabled: enabled,
      selectedColor: selectedColor ?? chipProperties.selectedColor,
      visualDensity:
          const VisualDensity(vertical: VisualDensity.minimumDensity, horizontal: VisualDensity.minimumDensity),
      backgroundColor: chipProperties.selectedColor,
      disabledColor: chipProperties.disabledColor,
      labelPadding: EdgeInsets.zero,
      side: BorderSide(
        color: (enabled && selected) ? context.pColorScheme.primary : chipProperties.selectedColor,
      ),
    );
  }
}

class PFilterChip extends StatelessWidget {
  final String label;
  final Function(bool)? onSelected;
  final bool selected, enabled;
  final ChipSize chipSize;

  const PFilterChip({
    super.key,
    required this.label,
    required this.chipSize,
    this.onSelected,
    this.selected = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final chipProperties = _getChipProperties(context)[chipSize]!;
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (selected) ...<Widget>[
            Icon(
              Icons.check,
              color: context.pColorScheme.darkHigh,
              size: chipProperties.prefixIconRadius,
            ),
            const SizedBox(
              width: Grid.xs + Grid.xxs,
            ),
          ],
          Text(
            StringUtils.titleCase(label) ?? '',
            style: chipProperties.textStyle,
          ),
        ],
      ),
      selected: enabled && selected,
      onSelected: onSelected,
      showCheckmark: false,
      padding: chipProperties.padding,
      selectedColor: context.pColorScheme.primary.shade100,
      visualDensity:
          const VisualDensity(vertical: VisualDensity.minimumDensity, horizontal: VisualDensity.minimumDensity),
      backgroundColor: chipProperties.selectedColor,
      disabledColor: chipProperties.disabledColor,
      labelPadding: EdgeInsets.zero,
      side: BorderSide(color: (enabled && selected) ? context.pColorScheme.primary : chipProperties.selectedColor),
    );
  }
}

class PChoiceChip extends StatelessWidget {
  final String label;
  final Function(bool)? onSelected;
  final bool selected, enabled;
  final ChipSize chipSize;
  final bool useTitleCase;
  final Color? selectedColor;
  final Color? disabledColor;
  final Color? backgroundColor;
  final BorderSide? borderSide;
  final TextStyle? labelStyle;
  final EdgeInsets? padding;
  final bool? showCheckmark;
  final double? radius;
  final String? svgPath;
  final double svgSize;

  const PChoiceChip({
    super.key,
    required this.label,
    required this.chipSize,
    this.onSelected,
    this.selected = false,
    this.enabled = true,
    this.useTitleCase = true,
    this.selectedColor,
    this.borderSide,
    this.backgroundColor,
    this.disabledColor,
    this.labelStyle,
    this.padding,
    this.showCheckmark = false,
    this.radius,
    this.svgPath,
    this.svgSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    final chipProperties = _getChipProperties(context)[chipSize]!;
    return ChoiceChip(
      label: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (svgPath != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(Grid.s),
                child: CachedNetworkSVGImage(
                  svgPath!,
                  width: svgSize,
                  height: svgSize,
                  fit: BoxFit.cover,
                  errorWidget: Icon(
                    Icons.error,
                    size: svgSize,
                  ),
                ),
              ),
              const SizedBox(
                width: Grid.xs + Grid.xxs,
              ),
            ],
            Text(
              useTitleCase ? StringUtils.titleCase(label) ?? '' : label,
              style: labelStyle ??
                  (selected ? context.pAppStyle.labelMed16primary : context.pAppStyle.labelReg16textPrimary),
            ),
          ],
        ),
      ),
      selected: enabled && selected,
      onSelected: onSelected,
      padding: padding ?? chipProperties.padding,
      selectedColor: selectedColor ?? context.pColorScheme.secondary,
      visualDensity: VisualDensity.comfortable,
      backgroundColor: backgroundColor ?? chipProperties.selectedColor,
      disabledColor: disabledColor ?? chipProperties.disabledColor,
      labelPadding: EdgeInsets.zero,
      showCheckmark: showCheckmark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius ?? Grid.m),
        side: borderSide ??
            BorderSide(
              color: selected ? Colors.transparent : context.pColorScheme.iconPrimary.withValues(alpha: .15),
            ),
      ),
    );
  }
}

class PAvatarChip extends StatelessWidget {
  final String label;
  final Function(bool)? onSelected;
  final bool selected, enabled;
  final ChipSize chipSize;
  final ImageProvider<Object> avatar;
  final bool showDeleteIcon;

  const PAvatarChip({
    super.key,
    required this.label,
    required this.chipSize,
    required this.avatar,
    this.onSelected,
    this.selected = false,
    this.enabled = true,
    this.showDeleteIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final chipProperties = _getChipProperties(context)[chipSize]!;
    return InputChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: chipProperties.prefixIconRadius / 2,
            backgroundColor: context.pColorScheme.lightHigh,
            backgroundImage: avatar,
          ),
          const SizedBox(
            width: Grid.xs + Grid.xxs,
          ),
          Text(
            StringUtils.titleCase(label) ?? '',
            style: chipProperties.textStyle,
          ),
          if (selected && showDeleteIcon) ...<Widget>[
            const SizedBox(
              width: Grid.xs + Grid.xxs,
            ),
            Icon(
              Icons.close,
              color: context.pColorScheme.darkHigh,
              size: Grid.m,
            ),
          ],
        ],
      ),
      selected: enabled && selected,
      onSelected: onSelected,
      showCheckmark: false,
      padding: chipProperties.padding,
      isEnabled: enabled,
      selectedColor: chipProperties.selectedColor,
      visualDensity:
          const VisualDensity(vertical: VisualDensity.minimumDensity, horizontal: VisualDensity.minimumDensity),
      backgroundColor: chipProperties.selectedColor,
      disabledColor: chipProperties.disabledColor,
      labelPadding: EdgeInsets.zero,
      side: BorderSide(color: (enabled && selected) ? context.pColorScheme.darkHigh : chipProperties.selectedColor),
    );
  }
}

class PSymbolChip extends StatelessWidget {
  final String label;
  final Function()? onPressed;
  final ChipSize chipSize;
  final String svgPath;
  final bool showDeleteIcon;
  final bool isForeign;

  const PSymbolChip({
    super.key,
    required this.label,
    required this.chipSize,
    required this.svgPath,
    this.onPressed,
    this.showDeleteIcon = true,
    this.isForeign = false,
  });

  @override
  Widget build(BuildContext context) {
    final chipProperties = _getChipProperties(context)[chipSize]!;
    const double size = Grid.m - Grid.xs;

    return Padding(
      padding: const EdgeInsets.only(
        right: Grid.s,
      ),
      child: ActionChip(
        onPressed: onPressed,
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(
                Grid.s,
              ),
              child: isForeign
                  ? CachedNetworkImage(
                      imageUrl: 'https://piapiri-test.b-cdn.net/icons/symbols/us/$label.png',
                      width: size,
                      height: size,
                      placeholder: (_, __) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, _, __) {
                        // burası design_system olduğu için capital_fallback kullanılmadı.
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(34),
                            color: Colors.white,
                          ),
                          child: Center(
                            child: Text(
                              label.isEmpty ? '-' : label.characters.first,
                              style: context.pAppStyle.interMediumBase.copyWith(
                                fontSize: Grid.s + Grid.xs,
                                color: context.pColorScheme.darkLow,
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : CachedNetworkSVGImage(
                      svgPath,
                      width: size,
                      height: size,
                      fit: BoxFit.cover,
                      errorWidget: const Icon(
                        Icons.error,
                        size: size,
                      ),
                    ),
            ),
            const SizedBox(
              width: Grid.xs + Grid.xxs,
            ),
            Text(
              label,
              style: chipProperties.textStyle,
            ),
          ],
        ),
        padding: chipProperties.padding,
        visualDensity: const VisualDensity(
          vertical: VisualDensity.minimumDensity,
          horizontal: VisualDensity.minimumDensity,
        ),
        backgroundColor: chipProperties.selectedColor,
        disabledColor: chipProperties.disabledColor,
        labelPadding: EdgeInsets.zero,
        side: BorderSide(
          color: context.pColorScheme.stroke,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Grid.m),
        ),
      ),
    );
  }
}

class PDropdownChip extends StatelessWidget {
  final String label;
  final Function()? onPressed;
  final ChipSize chipSize;
  final String svgPath;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? textColor;
  final bool showDeleteIcon;
  final IconAlignment iconAlignment;

  const PDropdownChip({
    super.key,
    required this.label,
    required this.chipSize,
    required this.svgPath,
    this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.textColor,
    this.showDeleteIcon = true,
    this.iconAlignment = IconAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    final chipProperties = _getChipProperties(context)[chipSize]!;
    const double size = Grid.m - Grid.xs;
    return ActionChip(
      onPressed: onPressed,
      color: WidgetStateProperty.all(backgroundColor ?? context.pColorScheme.primary),
      label: Row(
        textDirection: iconAlignment == IconAlignment.start ? TextDirection.ltr : TextDirection.rtl,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(Grid.s),
            child: SvgPicture.asset(
              svgPath,
              width: size,
              height: size,
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                iconColor ?? context.pColorScheme.darkHigh,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(
            width: Grid.xs + Grid.xxs,
          ),
          Text(
            label,
            style: chipProperties.textStyle.copyWith(
              color: textColor ?? context.pColorScheme.primary,
            ),
          ),
        ],
      ),
      padding: chipProperties.padding,
      visualDensity: const VisualDensity(
        vertical: VisualDensity.minimumDensity,
        horizontal: VisualDensity.minimumDensity,
      ),
      backgroundColor: chipProperties.selectedColor,
      disabledColor: chipProperties.disabledColor,
      labelPadding: EdgeInsets.zero,
      side: BorderSide(
        color: context.pColorScheme.stroke,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Grid.m),
      ),
    );
  }
}
