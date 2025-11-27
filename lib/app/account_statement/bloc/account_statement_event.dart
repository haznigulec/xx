import 'package:piapiri_v2/core/bloc/bloc/bloc_event.dart';

abstract class AccountStatementEvent extends PEvent {}

class GetAccountTransactionsEvent extends AccountStatementEvent {
  final String selectedAccount;
  final int transactionType;
  final String startDate;
  final String endDate;

  GetAccountTransactionsEvent({
    required this.selectedAccount,
    required this.transactionType,
    required this.startDate,
    required this.endDate,
  });
}

class SendCustomerStatementEvent extends AccountStatementEvent {
  final String accountId;
  final int transactionType;
  final String startDate;
  final String endDate;
  final Function(String) onSuccess;

  SendCustomerStatementEvent({
    required this.accountId,
    required this.transactionType,
    required this.startDate,
    required this.endDate,
    required this.onSuccess,
  });
}
