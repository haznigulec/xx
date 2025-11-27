extension IntegerExtensions on int {
  String ordinal() {
    // TODO(sita): translate
    if (this == 12) {
      return 'th';
    }

    switch (this % 10) {
      case 1:
        return '${this}st';
      case 2:
        return '${this}nd';
      case 3:
        return '${this}rd';
      default:
        return '${this}th';
    }
  }
}
