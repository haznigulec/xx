import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class DecimalInputFormatter extends TextInputFormatter {
  final int decimalRange;

  DecimalInputFormatter({required this.decimalRange});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text;
    final String locale = Intl.defaultLocale ?? 'tr';
    final String separator = locale == 'tr' ? '.' : ',';

    text = text.replaceAll(separator, ''); // Tüm noktaları kaldır (binlik ayracı gibi düşünüyoruz)

    // Eğer boşsa, herhangi bir değişiklik yapma.
    if (text.isEmpty) {
      return newValue;
    }

    // Regex: Sayının nokta veya virgülden sonra belirli bir hane sayısını aşmamasını sağlar.
    final regex = RegExp(r'^[0-9]*(\.|,)?[0-9]{0,' + decimalRange.toString() + r'}$');

    // Yeni metin regex'e uyuyorsa değişikliği uygula, aksi takdirde eski değeri döndür.
    if (regex.hasMatch(text)) {
      return newValue;
    } else {
      return oldValue;
    }
  }
}
