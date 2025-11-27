import 'package:flutter/material.dart';

class PColorScheme extends ThemeExtension<PColorScheme> {
  MaterialColor primary;
  Color secondary;
  MaterialColor card;
  MaterialColor line;
  MaterialColor stroke;
  MaterialColor textPrimary;
  MaterialColor textSecondary;
  MaterialColor textQuaternary;
  MaterialColor textTeritary;
  MaterialColor iconPrimary;
  MaterialColor iconSecondary;
  MaterialColor critical;
  MaterialColor warning;
  MaterialColor success;
  List<Color> assetColors;
  List<Color> performanceChartColors;
  Color backgroundColor;
  Color darkHigh;
  Color darkMedium;
  Color darkLow;
  Color lightHigh;
  Color lightMedium;
  Color lightLow;
  Color shadow;
  Color unselectedItemColor;
  Color risky;
  Color transparent;

  PColorScheme({
    required this.primary,
    required this.secondary,
    required this.card,
    required this.line,
    required this.stroke,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTeritary,
    required this.textQuaternary,
    required this.iconPrimary,
    required this.iconSecondary,
    required this.critical,
    required this.warning,
    required this.success,
    required this.assetColors,
    required this.performanceChartColors,
    required this.backgroundColor,
    required this.darkHigh,
    required this.darkMedium,
    required this.darkLow,
    required this.lightHigh,
    required this.lightMedium,
    required this.lightLow,
    required this.shadow,
    required this.unselectedItemColor,
    required this.risky,
    required this.transparent,
  });

  @override
  ThemeExtension<PColorScheme> copyWith() {
    return this;
  }

  @override
  ThemeExtension<PColorScheme> lerp(covariant ThemeExtension<PColorScheme>? other, double t) {
    return this;
  }
}
