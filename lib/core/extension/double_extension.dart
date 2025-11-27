extension PPDoubleExtensions on double? {
  bool get isNullOrZero => this == null || this == 0;

  bool get isNotNullAndLessThanZero => this != null && this! <= 0;
}
