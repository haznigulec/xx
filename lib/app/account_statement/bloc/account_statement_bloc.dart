import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piapiri_v2/app/account_statement/bloc/account_statement_event.dart';
import 'package:piapiri_v2/app/account_statement/bloc/account_statement_state.dart';
import 'package:piapiri_v2/app/account_statement/model/account_transaction_model.dart';
import 'package:piapiri_v2/app/account_statement/repository/account_statement_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';

class AccountStatementBloc extends PBloc<AccountStatementState> {
  final AccountStatementRepository _accountStatementRepository;

  AccountStatementBloc({required AccountStatementRepository accountStatementRepository})
      : _accountStatementRepository = accountStatementRepository,
        super(initialState: const AccountStatementState()) {
    on<GetAccountTransactionsEvent>(_onGetAccountTransactions);
    on<SendCustomerStatementEvent>(_onSendCustomerStatement);
  }

  FutureOr<void> _onGetAccountTransactions(
    GetAccountTransactionsEvent event,
    Emitter<AccountStatementState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    ApiResponse response = await _accountStatementRepository.getAccountTransactions(
      selectedAccount: event.selectedAccount,
      transactionType: event.transactionType,
      startDate: event.startDate,
      endDate: event.endDate,
    );

    if (response.success) {
      List<AccountSummaryModel> accountSummaryList = response.data['accountTransactions']
          .map<AccountSummaryModel>(
            (element) => AccountSummaryModel.fromJson(element),
          )
          .toList();

      accountSummaryList.sort((a, b) {
        final dateA = DateTime.parse(a.valueDateString);
        final dateB = DateTime.parse(b.valueDateString);
        return dateB.compareTo(dateA); // en yeni tarih önce üstte listelemek için.
      });

      emit(
        state.copyWith(
          type: PageState.success,
          accountSummaryList: accountSummaryList,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '01ACC001',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onSendCustomerStatement(
    SendCustomerStatementEvent event,
    Emitter<AccountStatementState> emit,
  ) async {
    ApiResponse response = await _accountStatementRepository.sendCustomerStatement(
      accountId: event.accountId,
      transactionType: event.transactionType,
      startDate: event.startDate,
      endDate: event.endDate,
    );

    if (response.success) {
      event.onSuccess(
        response.data['email'] ?? '',
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '01ACC002',
          ),
        ),
      );
    }
  }
}
