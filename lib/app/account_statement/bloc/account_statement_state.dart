import 'package:piapiri_v2/app/account_statement/model/account_transaction_model.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';

class AccountStatementState extends PState {
  final List<AccountSummaryModel> accountSummaryList;
  const AccountStatementState({
    super.type = PageState.initial,
    super.error,
    this.accountSummaryList = const [],
  });

  @override
  AccountStatementState copyWith({
    PageState? type,
    PBlocError? error,
    List<AccountSummaryModel>? accountSummaryList,
  }) {
    return AccountStatementState(
      type: type ?? this.type,
      error: error ?? this.error,
      accountSummaryList: accountSummaryList ?? this.accountSummaryList,
    );
  }

  @override
  List<Object?> get props => [
        type,
        error,
        accountSummaryList,
      ];
}
