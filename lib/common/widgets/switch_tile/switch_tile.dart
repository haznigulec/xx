import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';

import 'switch.dart';
import 'package:flutter/material.dart';

class PSwitchRow extends StatelessWidget {
  final bool value;
  final String text;
  final double? height;
  final double? width;
  final double? rowBetweenPadding;
  final TextStyle? textStyle;

  final ValueChanged<bool>? onChanged;

  const PSwitchRow({
    super.key,
    required this.value,
    required this.text,
    this.height,
    this.width,
    this.onChanged,
    this.rowBetweenPadding,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: InkWell(
        onTap: () {
          onChanged!(!value);
        },
        child: SizedBox(
          height: Grid.m + Grid.xs,
          child: Row(
            children: <Widget>[
              Center(
                widthFactor: 1,
                child: Text(
                  text,
                  style: textStyle ?? context.pAppStyle.labelReg16textPrimary,
                ),
              ),
              if (rowBetweenPadding == null) const Spacer() else SizedBox(width: rowBetweenPadding),
              PSwitch(
                value: value,
                height: height,
                width: width,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
