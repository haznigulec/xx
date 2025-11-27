import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';

class StoryViewProgressBarWidget extends StatelessWidget {
  final AnimationController animController;
  final int position;
  final int currentIndex;

  const StoryViewProgressBarWidget({
    super.key,
    required this.animController,
    required this.position,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animController,
      builder: (context, child) {
        double value;
        if (position < currentIndex) {
          value = 1.0;
        } else if (position == currentIndex) {
          value = animController.value;
        } else {
          value = 0.0;
        }

        return LinearProgressIndicator(
          value: value,
          minHeight: Grid.xxs,
          backgroundColor: context.pColorScheme.textQuaternary,
          valueColor: AlwaysStoppedAnimation<Color>(
            context.pColorScheme.primary,
          ),
        );
      },
    );
  }
}
