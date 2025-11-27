enum LanguageEnum {
  turkish('tr', 'TR', 'turkish'),
  english('en', 'US', 'english');

  final String value;
  final String countryCode;
  final String localizationKey;
  const LanguageEnum(this.value, this.countryCode, this.localizationKey);
}
