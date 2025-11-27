enum TransactionHistoryTypeEnum {
  all('', 'all_transactions', ''),
  buying('CREDIT', 'alis', 'buy'),
  selling('DEBIT', 'satis', 'sell');

  const TransactionHistoryTypeEnum(
    this.value,
    this.localizationKey,
    this.abroadValue,
  );
  final String value;
  final String localizationKey;
  final String abroadValue;
}
