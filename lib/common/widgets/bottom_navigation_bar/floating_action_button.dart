
import 'package:piapiri_v2/common/widgets/exchange_overlay/widgets/darken_backgorund.dart';
import 'package:piapiri_v2/common/widgets/exchange_overlay/widgets/show_case_view.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

class PFloatingAction extends StatelessWidget {
  final void Function()? onPressed;
  final bool? isOverlayVisible;
  final ShowCaseViewModel? showCase;
  const PFloatingAction({
    super.key,
    this.onPressed,
    this.isOverlayVisible,
    this.showCase,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: showCase != null
          ? ShowCaseView(
              showCase: showCase!,
              targetRadius: BorderRadius.circular(
                Grid.xxl,
              ),
              tooltipBorderRadius: const BorderRadius.only(
                topLeft: Radius.circular(Grid.m),
                topRight: Radius.circular(Grid.m),
                bottomLeft: Radius.circular(Grid.m),
                bottomRight: Radius.circular(Grid.xs),
              ),
              targetPadding: const EdgeInsets.all(
                Grid.s,
              ),
              tooltipPosition: TooltipPosition.top,
              child: DarkenBackgorund(
                isDarken: isOverlayVisible ?? false,
                borderRadius: 100,
                child: SizedBox(
                  height: 68,
                  width: 68,
                  child: FloatingActionButton(
                    backgroundColor: context.pColorScheme.primary,
                    shape: const CircleBorder(),
                    onPressed: onPressed,
                    child: Image.asset(
                      ImagesPath.piapiriCombinedShape,
                      height: 23,
                      width: 28,
                      color: context.pColorScheme.lightHigh,
                    ),
                  ),
                ),
              ),
            )
          : DarkenBackgorund(
              isDarken: isOverlayVisible ?? false,
              borderRadius: 100,
              child: SizedBox(
                height: 68,
                width: 68,
                child: FloatingActionButton(
                  backgroundColor: context.pColorScheme.primary,
                  shape: const CircleBorder(),
                  onPressed: onPressed,
                  child: Image.asset(
                    ImagesPath.piapiriCombinedShape,
                    height: 23,
                    width: 28,
                    color: context.pColorScheme.lightHigh,
                  ),
                ),
              ),
            ),
    );
  }
}
