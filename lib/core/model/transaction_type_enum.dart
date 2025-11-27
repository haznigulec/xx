enum TransactionTypeEnum {
  all(null, 'all_transaction_preferences'),
  call('C', 'call'),
  put('P', 'put');

  const TransactionTypeEnum(
    this.value,
    this.localizationKey,
  );
  final String? value;
  final String localizationKey;
}
