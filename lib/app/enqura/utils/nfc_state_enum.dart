enum NfcStateEnum {
  suitable,
  closed,
  not,
}

extension NfcStateExtension on NfcStateEnum {
  /// Enum'u string olarak döndürür (örnek: 'CLOSED')
  String get value => toString().split('.').last;

  /// String'den enum'a dönüştürür (örnek: 'suitable' → NfcState.SUITABLE)
  static NfcStateEnum fromString(String str) {
    return NfcStateEnum.values.firstWhere(
      (e) => e.value.toUpperCase() == str.toUpperCase(),
      orElse: () => NfcStateEnum.not, // varsayılan olarak 'NOT'
    );
  }
}
