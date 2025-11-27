import 'package:flutter/services.dart';
import 'package:piapiri_v2/core/bloc/language/bloc/language_bloc.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';

class AppInputFormatters {
  static TextInputFormatter decimalFormatter({
    required int maxDigitAfterSeparator,
  }) {
    String separatorChar = getIt<LanguageBloc>().state.languageCode == 'tr' ? ',' : '.';
    return _CompositeDecimalFormatter(
      maxDigitAfterSeparator: maxDigitAfterSeparator,
      separatorChar: separatorChar,
    );
  }
}

class _CompositeDecimalFormatter extends TextInputFormatter {
  final int maxDigitAfterSeparator;
  final String separatorChar;

  _CompositeDecimalFormatter({
    required this.maxDigitAfterSeparator,
    required this.separatorChar,
  });

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = newValue.text;
    final oldText = oldValue.text;
    final diffIndex = _findDiffIndex(oldText, newText);
    int separatorCount = separatorChar.allMatches(newText).length;

    if (newText.length < oldText.length) {
      if (diffIndex != null && (oldText[diffIndex] == '.' || oldText[diffIndex] == ',')) {
        // Sildiği karakter . veya , ise
        final restoredText = oldText;
        final newTextList = restoredText.split('');
        if (diffIndex > 0) {
          newTextList.removeAt(diffIndex - 1); // Bir solundakini sil
        }
        String result = newTextList.join();
        final newCursor = diffIndex - 1 >= 0 ? diffIndex - 1 : 0;
        if (result.endsWith(',') || result.endsWith('.')) {
          // Eğer sonuç son karakter olarak , veya . içeriyorsa, bu karakteri kaldır
          result = result.substring(0, result.length - 1);
        }
        return TextEditingValue(
          text: result,
          selection: TextSelection.collapsed(offset: newCursor),
        );
      }
    }

    // String middleSeparator = separatorChar == ',' ? '.' : ',';
    // if (oldValue.text.split(middleSeparator).length != newValue.text.split(middleSeparator).length) {
    //   return oldValue;
    // }

    // 🔒 Yalnızca rakam ve separator karakterlerine izin ver
    final allowedCharsRegExp = RegExp(r'^[0-9.,]*$');
    if (!allowedCharsRegExp.hasMatch(newText)) {
      return oldValue;
    }

    bool isDouble = maxDigitAfterSeparator > 0;

    // 🔄 Kullanıcının girdiği karakteri normalize et (nokta <-> virgül)
    if (newText.length > oldText.length) {
      if (diffIndex != null && diffIndex < newText.length) {
        final insertedChar = newText[diffIndex];
        if (((separatorChar == ',' && insertedChar == '.') || (separatorChar == '.' && insertedChar == ',')) &&
            isDouble) {
          String replacedText = newText.replaceRange(diffIndex, diffIndex + 1, separatorChar);
          // Eğer separatorChar null ise ve yeni metin virgül içeriyorsa, eski değeri döndür
          if (separatorChar.allMatches(replacedText).length > 1) {
            return oldValue;
          }
          return TextEditingValue(
            text: replacedText,
            selection: TextSelection.collapsed(offset: diffIndex + 1),
          );
        }
      }
    }


    // Eğer separatorChar null ise ve yeni metin virgül içeriyorsa, eski değeri döndür
    if (!isDouble && newText.contains(separatorChar)) {
      return oldValue;
    }

    // Eğer yeni metin boşsa ve separator girilmisse, eski değeri döndür
    if (newValue.text == '.' || newValue.text == ',') {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
        composing: TextRange.empty,
      );
    }

    // Sadece bir adet separator olabilir
    if (separatorCount > 1) {
      return oldValue;
    }
    // Ondalık basamak kontrolü
    if (isDouble && newText.contains(separatorChar)) {
      final parts = newText.split(separatorChar);
      if (parts.length > 1 && parts[1].length > maxDigitAfterSeparator) {
        return oldValue;
      }
    }

    return newValue;
  }
  int? _findDiffIndex(String oldText, String newText) {
    final minLength = oldText.length < newText.length ? oldText.length : newText.length;

    for (int i = 0; i < minLength; i++) {
      if (oldText[i] != newText[i]) {
        return i;
      }
    }

    if (oldText.length != newText.length) {
      return minLength;
    }

    return null;
  }
}
