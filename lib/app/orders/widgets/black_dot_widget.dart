import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';

class BlackDotWidget extends StatelessWidget {
  const BlackDotWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Grid.xs,
      ),
      child: Container(
        width: 3,
        height: 3,
        decoration: BoxDecoration(
          color: context.pColorScheme.textPrimary,
          borderRadius: const BorderRadius.all(
            Radius.circular(
              Grid.m,
            ),
          ),
        ),
      ),
    );
  }
}
