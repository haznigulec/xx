import 'package:flutter/material.dart';

class DarkenBackgorund extends StatelessWidget {
  final bool isDarken;
  final double? borderRadius;
  final Widget child;
  const DarkenBackgorund({
    super.key,
    required this.isDarken,
    this.borderRadius,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isDarken)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                borderRadius: borderRadius != null ? BorderRadius.circular(borderRadius!) : null,
              ),
            ),
          ),
      ],
    );
  }
}
