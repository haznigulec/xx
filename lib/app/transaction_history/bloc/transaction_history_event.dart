import 'package:piapiri_v2/app/transaction_history/model/transaction_history_filter_model.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_event.dart';

abstract class TransactionHistoryEvent extends PEvent {}

class GetTransactionHistoryEvent extends TransactionHistoryEvent {
  final Function(Map<String, dynamic>)? callback;

  GetTransactionHistoryEvent({
    this.callback,
  });
}

class SetTransactionHistoryFilter extends TransactionHistoryEvent {
  final TransactionHistoryFilterModel transactionHistoryFilter;
  final bool? fetchTransactionHistory;

  SetTransactionHistoryFilter({
    required this.transactionHistoryFilter,
    this.fetchTransactionHistory = true,
  });
}

class GetCapraTransactionHistoryEvent extends TransactionHistoryEvent {
  final String side;
  final String symbol;
  final String until;
  final String after;

  GetCapraTransactionHistoryEvent({
    required this.side,
    required this.symbol,
    required this.until,
    required this.after,
  });
}
