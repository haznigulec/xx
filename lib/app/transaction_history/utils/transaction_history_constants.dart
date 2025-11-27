import 'package:piapiri_v2/app/transaction_history/model/transaction_history_main_type_enum.dart';

class TransactionHistoryConstants {
  List<Map<String, dynamic>> transactionTypes = [
    {
      'title': 'all',
      "value": TransactionMainTypeEnum.all,
    },
    {
      'title': 'hisse',
      "value": TransactionMainTypeEnum.equity,
    },
    {
      'title': 'viop',
      "value": TransactionMainTypeEnum.viop,
    },
    {
      'title': 'fund',
      "value": TransactionMainTypeEnum.fund,
    },
    {
      'title': 'eurobond',
      "value": TransactionMainTypeEnum.eurobond,
    },
    {
      'title': 'CASH',
      "value": TransactionMainTypeEnum.cash,
    },
    {
      'title': 'halka_arz',
      "value": TransactionMainTypeEnum.ipo,
    },
  ];
}
