import 'package:flutter/material.dart';

extension ColorExtensions on Color {
  // Darken the provided color by mixing it with the Black color.
  // Value must be decimals between 0 and 1
  // If [value] = 0, return the same color, if value = 1 return black
  Color darken([double value = 0.1]) {
    return Color.lerp(this, Colors.black, value)!;
  }

  // Lighten the provided color by mixing it with the White color.
  // Value must be decimals between 0 and 1
  // If [value] = 0, return the same color, if value = 1 return white
  Color lighten([double value = 0.1]) {
    return Color.lerp(this, Colors.black, value)!;
  }

  static Color fromHexString(String hexString) {
    var hex = '';
    if (hexString.length == 6 || hexString.length == 7) {
      hex += 'ff';
    }
    hex += hexString.replaceFirst('#', '');
    return Color(int.parse(hex, radix: 16));
  }
}
