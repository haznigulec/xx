import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';

Container generalButtonPadding({
  Widget? child,
  required BuildContext context,
  double? leftPadding,
  double? rightPadding,
  double? bottomPadding,
  double? viewPadddingOfBottom,
}) {
  return Container(
    color: context.pColorScheme.backgroundColor,
    padding: EdgeInsets.only(
      left: leftPadding ?? Grid.m,
      right: rightPadding ?? Grid.m,
      bottom: (viewPadddingOfBottom ?? MediaQuery.paddingOf(context).bottom) + (bottomPadding ?? Grid.m + Grid.xs),
    ),
    child: child,
  );
}
