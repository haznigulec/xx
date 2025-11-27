import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

class ShowCaseViewModel {
  final GlobalKey globalKey;
  final String title;
  final String description;
  String stepText;
  final String buttonText;

  ShowCaseViewModel({
    required this.globalKey,
    required this.title,
    required this.description,
    required this.stepText,
    required this.buttonText,
  });
}

class ShowCaseView extends StatelessWidget {
  const ShowCaseView({
    required this.child,
    required this.showCase,
    this.targetPadding = EdgeInsets.zero,
    this.targetRadius = BorderRadius.zero,
    this.tooltipBorderRadius,
    this.tooltipPosition = TooltipPosition.bottom,
    super.key,
  });

  final Widget child;
  final ShowCaseViewModel showCase;
  final EdgeInsets targetPadding;
  final BorderRadius targetRadius;
  final BorderRadius? tooltipBorderRadius;
  final TooltipPosition tooltipPosition;

  @override
  Widget build(BuildContext context) {
    return Showcase(
      tooltipBackgroundColor: context.pColorScheme.backgroundColor,
      key: showCase.globalKey,
      toolTipMargin: Grid.xl,
      title: showCase.title,
      titleTextStyle: context.pAppStyle.labelMed16textPrimary,
      titleTextAlign: TextAlign.center,
      description: showCase.description,
      descTextStyle: context.pAppStyle.labelReg14textSecondary,
      descriptionTextAlign: TextAlign.center,
      tooltipPadding: const EdgeInsets.symmetric(
        horizontal: Grid.m,
        vertical: Grid.m + Grid.xs,
      ),
      tooltipBorderRadius: tooltipBorderRadius ??
          BorderRadius.circular(
            Grid.m,
          ),
      descriptionPadding: const EdgeInsets.only(
        top: Grid.s,
        bottom: Grid.xs,
      ),
      tooltipPosition: tooltipPosition,
      tooltipActions: [
        TooltipActionButton(
          padding: EdgeInsets.zero,
          type: TooltipDefaultActionType.next,
          name: showCase.stepText,
          backgroundColor: context.pColorScheme.backgroundColor,
          textStyle: context.pAppStyle.labelReg14iconPrimary,
        ),
        TooltipActionButton(
          padding: EdgeInsets.zero,
          backgroundColor: context.pColorScheme.backgroundColor,
          textStyle: context.pAppStyle.labelReg14primary,
          name: showCase.buttonText,
          type: TooltipDefaultActionType.next,
        ),
      ],
      targetPadding: targetPadding,
      targetShapeBorder: RoundedRectangleBorder(
        side: BorderSide(color: context.pColorScheme.stroke),
      ),
      targetBorderRadius: targetRadius,
      child: child,
    );
  }
}
