import '../lozenge/lozenge.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:p_core/keys/keys.dart';

abstract class PBaseListItem extends StatelessWidget {
  const PBaseListItem({super.key});
}

class PListItem extends PBaseListItem {
  final Widget? leading;
  final Widget? trailing;
  final String title;
  final TextStyle? titleStyle;
  final Widget? titleIcon;
  final String? subtitle;
  final TextStyle? subtitleStyle;
  final String? trailingText;
  final Widget? trailingWidget;
  final Color? titleColor;
  final Color? backgroundColor;
  final Decoration? decoration;
  final bool allowOverflow;
  final bool disabled;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry subtitlePadding;
  final EdgeInsetsGeometry? padding;
  final TextDirection? textDirection;
  final Size leadingWidgetSize;
  final double leadingLargeWidgetSize;
  final double trailingWidgetSize;
  final double trailingSmallWidgetSize;
  final double? minHeight;
  final CrossAxisAlignment? crossAxisAlignment;
  final double? leadingWidth;

  const PListItem({
    super.key,
    this.leading,
    required this.title,
    this.titleStyle,
    this.titleIcon,
    this.subtitle,
    this.subtitleStyle,
    this.trailingText,
    this.trailingWidget,
    this.titleColor,
    this.backgroundColor,
    this.decoration,
    this.trailing,
    this.allowOverflow = false,
    this.disabled = false,
    this.onTap,
    this.subtitlePadding = EdgeInsets.zero,
    this.padding,
    this.textDirection,
    this.leadingWidgetSize = const Size(20, 20),
    this.leadingLargeWidgetSize = 64,
    this.trailingWidgetSize = 24,
    this.trailingSmallWidgetSize = 20,
    this.minHeight,
    this.crossAxisAlignment,
    this.leadingWidth = Grid.s,
  });

  @override
  Widget build(BuildContext context) {
    final bool singleLine = subtitle == null;
    return Opacity(
      opacity: disabled ? 0.38 : 1.0,
      child: Material(
        color: backgroundColor ?? context.pColorScheme.backgroundColor,
        child: InkWell(
          key: const Key(GeneralKeys.listItemKey),
          onTap: !disabled ? onTap : null,
          child: Container(
            decoration: decoration,
            color: context.pColorScheme.transparent,
            alignment: Alignment.centerLeft,
            constraints: BoxConstraints(
              minHeight:
                  minHeight ?? (singleLine ? Dimension.singleLineListItemHeight : Dimension.doubleLineListItemHeight),
            ),
            padding: padding ?? EdgeInsets.zero,
            child: Row(
              crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
              children: <Widget>[
                if (leading != null) ...[
                  SizedBox(
                    width: leadingWidth,
                  ),
                  SizedBox(
                    height: leadingWidgetSize.height,
                    width: leadingWidgetSize.width,
                    child: leading,
                  ),
                  const SizedBox(
                    width: Grid.xs,
                  ),
                ],
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          constraints: singleLine
                              ? null
                              : const BoxConstraints(
                                  minHeight: 40,
                                ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: singleLine ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text.rich(
                                TextSpan(
                                  children: <InlineSpan>[
                                    TextSpan(
                                      text: title,
                                      style: titleStyle ?? context.pAppStyle.labelReg14textPrimary,
                                    ),
                                    if (titleIcon != null)
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional.only(
                                            start: Grid.xs,
                                          ),
                                          child: titleIcon,
                                        ),
                                      ),
                                  ],
                                ),
                                maxLines: allowOverflow ? 30 : 1,
                                overflow: TextOverflow.ellipsis,
                                strutStyle: StrutStyle.fromTextStyle(
                                  context.pAppStyle.interRegularBase.copyWith(fontSize: Grid.m + Grid.xxs),
                                ),
                              ),
                              const SizedBox(
                                height: Grid.xxs,
                              ),
                              if (!singleLine)
                                Padding(
                                  padding: subtitlePadding,
                                  child: Text(
                                    subtitle!,
                                    maxLines: allowOverflow ? 10 : 1,
                                    style: subtitleStyle ?? context.pAppStyle.labelReg16darkMedium,
                                    strutStyle: StrutStyle.fromTextStyle(
                                      context.pAppStyle.interRegularBase.copyWith(
                                        fontSize: Grid.m,
                                      ),
                                      leading: 0.4,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      if (trailingText != null)
                        Text(
                          trailingText!,
                          style: context.pAppStyle.interRegularBase.copyWith(
                            fontSize: Grid.m + Grid.xxs,
                            color: titleColor ?? context.pColorScheme.lightHigh,
                          ),
                        ),
                      if (trailingWidget != null) trailingWidget!,
                      if (trailing != null)
                        Padding(
                          padding: const EdgeInsetsDirectional.only(start: Grid.m),
                          child: SizedBox(
                            height: trailingWidgetSize,
                            width: trailingWidgetSize,
                            child: Center(
                              child: trailing,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PDetailedListItem extends PBaseListItem {
  final Widget? leading;
  final String title;
  final String firstSubtitle;
  final String secondSubtitle;
  final double? subtitleSpacing;
  final Widget? trailing;
  final Widget? bottomRow;
  final bool disabled;
  final VoidCallback? onTap;
  final TextStyle? titleStyle;
  final TextStyle? firstSubtitleStyle;
  final TextStyle? secondSubtitleStyle;
  final double leadingWidgetSize;
  final double leadingLargeWidgetSize;
  final double trailingWidgetSize;
  final double trailingSmallWidgetSize;
  final Decoration? decoration;

  /// Specifying custom style for texts may cause exceeding the specified height of the body.
  /// The [bodyHeight] can be specified for these cases in order to prevent overflows.
  final double? bodyHeight;

  const PDetailedListItem({
    super.key,
    this.leading,
    required this.title,
    required this.firstSubtitle,
    required this.secondSubtitle,
    this.subtitleSpacing,
    this.trailing,
    this.bottomRow,
    this.disabled = false,
    this.onTap,
    this.titleStyle,
    this.firstSubtitleStyle,
    this.secondSubtitleStyle,
    this.bodyHeight,
    this.leadingWidgetSize = 40,
    this.leadingLargeWidgetSize = 64,
    this.trailingWidgetSize = 24,
    this.trailingSmallWidgetSize = 20,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: disabled ? 0.38 : 1.0,
      child: Material(
        color: context.pColorScheme.lightHigh,
        child: InkWell(
          onTap: !disabled ? onTap : null,
          child: Container(
            padding: const EdgeInsets.all(Grid.m),
            decoration: decoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (leading != null)
                      Padding(
                        padding: const EdgeInsetsDirectional.only(end: Grid.m),
                        child: SizedBox(
                          height: leadingLargeWidgetSize,
                          width: leadingLargeWidgetSize,
                          child: Center(
                            child: leading,
                          ),
                        ),
                      ),
                    Expanded(
                      child: SizedBox(
                        height: bodyHeight ?? 66,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Text.rich(
                              TextSpan(
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: title,
                                    style: titleStyle ??
                                        context.pAppStyle.interRegularBase.copyWith(
                                          fontSize: Grid.m + Grid.xxs,
                                          color: context.pColorScheme.darkHigh,
                                        ),
                                  ),
                                ],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              strutStyle: StrutStyle.fromTextStyle(
                                context.pAppStyle.interRegularBase.copyWith(fontSize: Grid.m + Grid.xxs),
                                leading: 0.4,
                              ),
                            ),
                            Text(
                              firstSubtitle,
                              maxLines: 1,
                              style: firstSubtitleStyle ?? context.pAppStyle.labelReg16darkMedium,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (subtitleSpacing != null) SizedBox(height: subtitleSpacing),
                            Text(
                              secondSubtitle,
                              maxLines: 1,
                              style: secondSubtitleStyle ?? context.pAppStyle.labelReg16darkMedium,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (trailing != null)
                      Padding(
                        padding: const EdgeInsetsDirectional.only(start: Grid.m),
                        child: trailing,
                      ),
                  ],
                ),
                if (bottomRow != null) ...<Widget>[
                  const SizedBox(height: Grid.s),
                  bottomRow!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PFacilityListItem extends PBaseListItem {
  final Widget? leading;
  final String title;
  final String firstSubtitle;
  final String secondSubtitle;
  final double? rating;
  final int? ratingCount;
  final bool showRating;
  final bool showNewTag;
  final bool onlineBookingAvailable;
  final bool disabled;
  final VoidCallback? onTap;
  final double leadingWidgetSize;
  final double leadingLargeWidgetSize;
  final double trailingWidgetSize;
  final double trailingSmallWidgetSize;

  const PFacilityListItem({
    super.key,
    this.leading,
    required this.title,
    required this.firstSubtitle,
    required this.secondSubtitle,
    this.rating,
    this.ratingCount,
    this.showRating = false,
    this.showNewTag = false,
    this.onlineBookingAvailable = false,
    this.disabled = false,
    this.onTap,
    this.leadingWidgetSize = 40,
    this.leadingLargeWidgetSize = 64,
    this.trailingWidgetSize = 24,
    this.trailingSmallWidgetSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    final double finalRating = rating ?? 0;
    return PDetailedListItem(
      leading: leading,
      title: title,
      firstSubtitle: firstSubtitle,
      secondSubtitle: secondSubtitle,
      onTap: !disabled ? onTap : null,
      bottomRow: showRating || onlineBookingAvailable
          ? Row(
              mainAxisAlignment: showRating ? MainAxisAlignment.spaceBetween : MainAxisAlignment.end,
              children: <Widget>[
                if (showRating)
                  Row(
                    children: <Widget>[
                      SizedBox(width: leadingLargeWidgetSize + Grid.m),
                      Text(
                        finalRating > 0 ? '$finalRating' : '',
                        style: context.pAppStyle.labelReg14iconPrimary,
                      ),
                      if (finalRating > 0) const SizedBox(width: Grid.s),
                      ...List<Icon>.generate(
                        5,
                        (int index) => Icon(
                          Icons.star,
                          color: index + 1 <= finalRating.floor()
                              ? context.pColorScheme.warning
                              : context.pColorScheme.iconPrimary.shade200,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
              ],
            )
          : null,
      disabled: disabled,
    );
  }
}

class PTimesheetListItem extends PBaseListItem {
  final String title;
  final String firstSubtitle;
  final String secondSubtitle;
  final bool billable;
  final bool disabled;
  final VoidCallback? onTap;

  const PTimesheetListItem({
    super.key,
    required this.title,
    required this.firstSubtitle,
    required this.secondSubtitle,
    this.billable = false,
    this.disabled = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return PDetailedListItem(
      title: title,
      firstSubtitle: firstSubtitle,
      secondSubtitle: secondSubtitle,
      trailing: PLozenge.withColor(
        text: '${billable ? '' : 'NOT '}BILLABLE',
        backgroundColor: billable ? context.pColorScheme.success.shade100 : context.pColorScheme.iconPrimary.shade200,
      ),
      onTap: !disabled ? onTap : null,
      disabled: disabled,
    );
  }
}
