import 'list_item.dart';
import '../selection_control/checkbox.dart';
import '../selection_control/radio_button.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';

class PCheckboxListItem extends PBaseListItem {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final Widget? trailing;
  final Widget? leading;
  final Widget? titleIcon;
  final String title;
  final String? subtitle;
  final bool allowOverflow;
  final bool disabled;
  final Color? color;
  final bool _isTrailingCheckBox;
  final Widget? trailingWidget;
  final Size leadingWidgetSize;
  final CrossAxisAlignment? crossAxisAlignment;
  final double? leadingWidth;

  const PCheckboxListItem({
    super.key,
    required this.value,
    required this.onChanged,
    this.trailing,
    this.titleIcon,
    required this.title,
    this.subtitle,
    this.allowOverflow = false,
    this.disabled = false,
    this.color,
    this.trailingWidget,
    this.leadingWidgetSize = const Size(40, 40),
    this.crossAxisAlignment,
    this.leadingWidth = Grid.s,
  })  : leading = null,
        _isTrailingCheckBox = false;

  const PCheckboxListItem.trailingCheckBox({
    super.key,
    required this.value,
    required this.onChanged,
    this.leading,
    this.titleIcon,
    required this.title,
    this.subtitle,
    this.allowOverflow = false,
    this.disabled = false,
    this.color,
    this.trailingWidget,
    this.leadingWidgetSize = const Size(40, 40),
    this.crossAxisAlignment,
    this.leadingWidth = Grid.s,
  })  : trailing = null,
        _isTrailingCheckBox = true;

  @override
  Widget build(BuildContext context) {
    final titleColor = color ?? context.pColorScheme.darkHigh;

    return MergeSemantics(
      child: PListItem(
        leading: _isTrailingCheckBox
            ? leading
            : PCheckbox(
                value: value,
                onChanged: !disabled ? onChanged : null,
              ),
        leadingWidth: leadingWidth,
        title: title,
        subtitle: subtitle,
        titleColor: titleColor,
        allowOverflow: allowOverflow,
        onTap: !disabled ? () => onChanged(!value) : null,
        trailing: _isTrailingCheckBox
            ? PCheckbox(
                value: value,
                onChanged: !disabled ? onChanged : null,
              )
            : trailing,
        trailingWidget: trailingWidget,
        disabled: disabled,
        titleIcon: titleIcon,
        leadingWidgetSize: leadingWidgetSize,
        crossAxisAlignment: crossAxisAlignment,
      ),
    );
  }
}

class PRadioButtonListItem<T> extends PBaseListItem {
  final T value;
  final T groupValue;
  final ValueChanged<T?> onChanged;
  final Widget? trailing;
  final Widget? leading;
  final Widget? titleIcon;
  final String title;
  final String? subtitle;
  final bool disabled;
  final Color? color;
  final bool _isTrailingRadio;
  final bool allowOverflow;
  final Widget? trailingWidget;
  final TextStyle? titleStyle;

  const PRadioButtonListItem({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.trailing,
    this.titleIcon,
    required this.title,
    this.subtitle,
    this.disabled = false,
    this.color,
    this.allowOverflow = false,
    this.trailingWidget,
    this.titleStyle,
  })  : leading = null,
        _isTrailingRadio = false;

  const PRadioButtonListItem.trailingRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.leading,
    this.titleIcon,
    required this.title,
    this.subtitle,
    this.disabled = false,
    this.color,
    this.allowOverflow = false,
    this.trailingWidget,
    this.titleStyle,
  })  : trailing = null,
        _isTrailingRadio = true;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: PListItem(
        leading: _isTrailingRadio
            ? leading
            : PRadioButton<T>(
                value: value,
                groupValue: groupValue,
                onChanged: !disabled ? onChanged : null,
              ),
        title: title,
        subtitle: subtitle,
        titleColor: color,
        onTap: !disabled ? () => onChanged(value) : null,
        trailing: _isTrailingRadio
            ? PRadioButton<T>(
                value: value,
                groupValue: groupValue,
                onChanged: !disabled ? onChanged : null,
              )
            : trailing,
        allowOverflow: allowOverflow,
        disabled: disabled,
        titleIcon: titleIcon,
        trailingWidget: trailingWidget,
        titleStyle: titleStyle,
      ),
    );
  }
}
