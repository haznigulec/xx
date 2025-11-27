import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Shimmerize extends StatelessWidget {
  final Widget child;
  final bool enabled;
  const Shimmerize({
    super.key,
    required this.child,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled) {
      return child;
    }

    return Shimmer.fromColors(
      baseColor: context.pColorScheme.textSecondary.withValues(
        alpha: 0.3,
      ),
      highlightColor: context.pColorScheme.textSecondary.withValues(
        alpha: 0.1,
      ),
      enabled: true,
      child: Skeletonizer(
        child: child,
      ),
    );
  }
}
