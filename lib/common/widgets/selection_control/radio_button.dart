import '../lozenge/lozenge.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';

class PRadioButton<T> extends StatelessWidget {
  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;

  const PRadioButton({
    super.key,
    required this.value,
    this.groupValue,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Radio<T>(
      value: value,
      groupValue: groupValue,
      toggleable: true,
      onChanged: onChanged,
    );
  }
}

class PRadioButtonText<T> extends StatelessWidget {
  final String text;
  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;

  const PRadioButtonText({
    super.key,
    required this.text,
    required this.value,
    this.groupValue,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onChanged != null ? () => onChanged!(value) : null,
      child: Row(
        children: <Widget>[
          PRadioButton<T>(
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
          ),
          Text(
            text,
            style: context.pAppStyle.interRegularBase.copyWith(
              fontSize: Grid.m + Grid.xxs,
            ),
          ),
        ],
      ),
    );
  }
}

class PRadioButtonRow<T> extends StatelessWidget {
  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final String? text;
  final bool removeCheckboxPadding;
  final Widget? child;

  const PRadioButtonRow({
    super.key,
    required this.value,
    this.groupValue,
    this.onChanged,
    this.removeCheckboxPadding = false,
    this.text,
    this.child,
  }) : assert(child != null || text != null);

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: InkWell(
        splashColor: context.pColorScheme.transparent,
        highlightColor: context.pColorScheme.transparent,
        onTap: onChanged != null
            ? () {
                onChanged!(value);
              }
            : null,
        child: Row(
          children: <Widget>[
            const SizedBox(width: Grid.xs),
            SizedBox(
              width: removeCheckboxPadding ? 24 : null,
              child: PRadioButton<T>(
                value: value,
                groupValue: groupValue,
                onChanged: onChanged,
              ),
            ),
            Flexible(
              child: Container(
                constraints: const BoxConstraints(minHeight: Grid.xxl),
                padding: EdgeInsetsDirectional.only(
                  start: removeCheckboxPadding ? Grid.s : Grid.xs,
                  end: Grid.m,
                  top: Grid.s,
                  bottom: Grid.s,
                ),
                child: child ??
                    Center(
                      widthFactor: 1,
                      child: Text(
                        text!,
                        style: context.pAppStyle.interRegularBase.copyWith(
                          fontSize: Grid.m - Grid.xxs,
                          color: onChanged != null ? context.pColorScheme.textPrimary : context.pColorScheme.darkLow,
                        ),
                      ),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PStatusBadgeRadioButtonRow<T> extends StatelessWidget {
  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final String text;
  final Color? color;

  const PStatusBadgeRadioButtonRow({
    super.key,
    required this.value,
    this.groupValue,
    this.onChanged,
    required this.text,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: InkWell(
        onTap: onChanged != null
            ? () {
                onChanged!(value);
              }
            : null,
        child: Row(
          children: <Widget>[
            const SizedBox(width: Grid.xs),
            PRadioButton<T>(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
            ),
            Flexible(
              child: Container(
                constraints: const BoxConstraints(minHeight: Grid.xxl),
                padding: const EdgeInsetsDirectional.only(
                  start: Grid.xs,
                  end: Grid.m,
                  top: Grid.s,
                  bottom: Grid.s,
                ),
                child: Center(
                  widthFactor: 1,
                  child: PLozenge.withColor(
                    text: text,
                    backgroundColor: color ?? context.pColorScheme.transparent,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
