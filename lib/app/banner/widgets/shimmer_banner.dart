import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';

class ShimmerBanner extends StatelessWidget {
  const ShimmerBanner({super.key});

  @override
  Widget build(BuildContext context) {
    Color floatingColor = context.pColorScheme.lightHigh;

    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: 80,
      decoration: BoxDecoration(
        color: floatingColor,
        borderRadius: BorderRadius.circular(
          Grid.m,
        ),
      ),
    );
  }
}
