enum MessageTypeEnum {
  noNfc,
  nfcClosed,
  osIsInsufficient,
  cameraIsInsufficient,
  lowConnection,
  none,
}

extension MessageTypeExtension on MessageTypeEnum {
  /// Enum'u string olarak döndürür ('NO_NFC', 'LOW_CONNECTION' vs.)
  String get value => toString().split('.').last;

  /// String'den enum'a çevirir (örn. 'NO_NFC' → MessageType.NO_NFC)
  static MessageTypeEnum fromString(String str) {
    return MessageTypeEnum.values.firstWhere(
      (e) => e.value.toUpperCase() == str.toUpperCase(),
      orElse: () => MessageTypeEnum.none,
    );
  }
}
