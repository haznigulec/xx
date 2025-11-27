import 'package:flutter/services.dart';

class IbanFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var inputText = "TR${newValue.text}";

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var bufferString = StringBuffer();
    if (inputText.length == 1 || inputText.length == 2) {
      inputText = "TR";
    }
    for (int i = 0; i < inputText.length; i++) {
      bufferString.write(inputText[i]);
      var nonZeroIndexValue = i + 1;
      if (nonZeroIndexValue % 4 == 0 && nonZeroIndexValue != inputText.length) {
        bufferString.write(' ');
      }
    }

    var string = bufferString.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(
        offset: string.length,
      ),
    );
  }
}
