import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension StringExtensions on String {
  Future<void> copyToClipboard() {
    if (const String.fromEnvironment('env') == 'test') {
      return Future.value();
    }
    return Clipboard.setData(ClipboardData(text: this));
  }

  String turkishToLatin() {
    return replaceAll('ç', 'c')
        .replaceAll('Ç', 'C')
        .replaceAll('ğ', 'g')
        .replaceAll('Ğ', 'G')
        .replaceAll('ı', 'i')
        .replaceAll('İ', 'I')
        .replaceAll('ö', 'o')
        .replaceAll('Ö', 'O')
        .replaceAll('ş', 's')
        .replaceAll('Ş', 'S')
        .replaceAll('ü', 'u')
        .replaceAll('Ü', 'U');
  }
}

extension StringExtensionNullOrEmpty on String? {
  bool get isNullOrBlank => this == null || this!.trim().isEmpty;

  bool get isNotNullOrEmpty => this != null && this!.isNotEmpty;

  bool get isNotNullOrBlank => this != null && this!.trim().isNotEmpty;

  String? get asNullIfBlank => isNullOrBlank ? null : this;
}

extension TextSizeExtension on String {
  double calculateTextWidth({
    required TextStyle textStyle,
  }) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: this,
        style: TextStyle(
          fontSize: textStyle.fontSize,
          fontFamily: textStyle.fontFamily,
          fontWeight: textStyle.fontWeight,
          fontFeatures: textStyle.fontFeatures,
        ),
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    return textPainter.width;
  }
}

extension NegativePercentageAndPriceFormatter on String {
  String formatNegativePriceAndPercentage() {
    if (startsWith('%-')) {
      return '-%${substring(2)}';
    }

    if (contains('₺-')) {
      return replaceFirst('₺-', '-₺');
    }

    if (contains('\$-')) {
      return replaceFirst('\$-', '-\$');
    }

    return this;
  }
}
