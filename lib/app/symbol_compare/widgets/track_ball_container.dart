import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';

class TrackBallContainer extends StatelessWidget {
  final Color borderColor;
  final Color backgroundColor;
  final Widget child;
  const TrackBallContainer({
    super.key,
    required this.borderColor,
    required this.backgroundColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 175,
      padding: const EdgeInsets.symmetric(
        vertical: Grid.xs,
        horizontal: Grid.s,
      ),
      margin: const EdgeInsets.symmetric(vertical: 1),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(
          color: borderColor,
        ),
        borderRadius: BorderRadius.circular(Grid.s),
      ),
      child: child,
    );
  }
}
