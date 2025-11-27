import 'package:flutter/services.dart';

//telefon numarası girdiğimiz alanlarda numarayı formatlaması için kullanılmaktadır.
//(5555555555 -> 555 555 55 55)
class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text.replaceAll(RegExp(r'\D'), ''); // Sadece rakamları al
    if (text.length > 10) {
      text = text.substring(0, 10); // Maksimum 10 karakter al
    }

    String formattedText = _formatPhoneNumber(text);

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }

  String _formatPhoneNumber(String text) {
    if (text.length <= 3) {
      return text;
    } else if (text.length <= 6) {
      return '${text.substring(0, 3)} ${text.substring(3)}';
    } else if (text.length <= 8) {
      return '${text.substring(0, 3)} ${text.substring(3, 6)} ${text.substring(6)}';
    } else {
      return '${text.substring(0, 3)} ${text.substring(3, 6)} ${text.substring(6, 8)} ${text.substring(8)}';
    }
  }
}
