extension DecimalExtension on num {
  String removeTrailingZeroDecimal() {
    final numberString = toString();
    if (!numberString.contains('.')) {
      return numberString;
    }
    final regex = RegExp(r'([.]*0)(?!.*\d)');
    return toString().replaceAll(regex, '');
  }
}
