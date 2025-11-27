enum StatementPreferenceEnum {
  digital('5', 'digital', 'extract_preference_online'),
  email('4', 'email', 'email');

  const StatementPreferenceEnum(
    this.serviceValue,
    this.value,
    this.localizationKey,
  );
  final String serviceValue;
  final String value;
  final String localizationKey;
}
