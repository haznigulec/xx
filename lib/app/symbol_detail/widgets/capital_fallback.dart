import 'package:flutter/material.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

class CapitalFallback extends StatelessWidget {
  final String symbolName;
  final double size;
  const CapitalFallback({super.key, required this.symbolName, this.size = 14});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(34),
        color: Colors.white,
      ),
      child: Center(
        child: Text(
          symbolName.isEmpty ? '-' : symbolName.characters.first,
          style: TextStyle(
            color: context.pColorScheme.darkLow,
            fontSize: size * 0.8,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
