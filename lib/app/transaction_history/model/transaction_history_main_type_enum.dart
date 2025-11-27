enum TransactionMainTypeEnum {
  all('ALL', 'ALL', true),
  equity('EQ_LIST', 'equityTransactionList', true),
  viop('VIOP_LIST', 'viopTransactionList', true),
  fund('MF_LIST', 'fundTransactionList', false),
  eurobond('FINC_LIST', 'fincTransactionList', true),
  cash('CASH_LIST', 'cashTransactionList', false),
  ipo('IPO_LIST', 'distributedIpoTransactionList', true),
  foreignCurrency('FC_LIST', 'fcTransactionList', false);

  const TransactionMainTypeEnum(
    this.listType,
    this.responseListType,
    this.isType,
  );

  final String listType;
  final String responseListType;
  final bool isType;
}
