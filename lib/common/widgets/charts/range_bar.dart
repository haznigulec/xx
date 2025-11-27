import 'package:flutter/material.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

class RangeBar extends StatelessWidget {
  final double value;
  final double minValue;
  final double maxValue;
  final double height;

  const RangeBar({
    super.key,
    required this.value,
    required this.minValue,
    required this.maxValue,
    this.height = 10,
  });

  @override
  Widget build(BuildContext context) {
    final double range = (maxValue - minValue).abs() < 0.0001 ? 100 : (maxValue - minValue);
    final double zeroPosition = (0 - minValue) / range;
    final double valuePosition = (value - minValue) / range;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double totalWidth = constraints.maxWidth;
        final double zeroX = zeroPosition.clamp(0.0, 1.0) * totalWidth;
        final double valueX = valuePosition.clamp(0.0, 1.0) * totalWidth;

        final bool isPositive = value >= 0;
        final double width = (valueX - zeroX).abs();

        return Stack(
          children: [
            // Gri arka plan
            Container(
              width: totalWidth,
              height: height,
              decoration: BoxDecoration(
                color: context.pColorScheme.card,
                borderRadius: BorderRadius.circular(Grid.xs),
              ),
            ),
            // Değer barı
            Positioned(
              left: isPositive ? zeroX : valueX,
              child: Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  color: isPositive ? context.pColorScheme.success : context.pColorScheme.critical,
                  borderRadius: BorderRadius.circular(Grid.xs),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
