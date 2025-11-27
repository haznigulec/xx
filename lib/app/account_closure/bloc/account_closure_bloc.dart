import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:piapiri_v2/app/account_closure/bloc/account_closure_event.dart';
import 'package:piapiri_v2/app/account_closure/bloc/account_closure_state.dart';
import 'package:piapiri_v2/app/account_closure/repository/account_closure_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class AccountClosureBloc extends PBloc<AccountClosureState> {
  final AccountClosureRepository _accountClosureRepository;

  AccountClosureBloc({
    required AccountClosureRepository accountClosureRepository,
  })  : _accountClosureRepository = accountClosureRepository,
        super(initialState: const AccountClosureState()) {
    on<ClosureEvent>(_onAccountClosure);
    on<GetAccountClosureStatusEvent>(_onGetAccountClosureStatus);
    on<SetAccountClosureStatus>(_onSetAccountClosureStatus);
  }

  FutureOr<void> _onAccountClosure(
    ClosureEvent event,
    Emitter<AccountClosureState> emit,
  ) async {
    ApiResponse response = await _accountClosureRepository.accountClosure(
      customerId: event.customerId,
    );

    if (response.success) {
      event.onSuccess();
    } else {
      event.onFailed();
    }
  }

  FutureOr<void> _onGetAccountClosureStatus(
    GetAccountClosureStatusEvent event,
    Emitter<AccountClosureState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    ApiResponse response = await _accountClosureRepository.getAccountClosureStatus();
    if (response.success) {
      emit(
        state.copyWith(
          type: PageState.success,
          accountClosureStatus: response.data['accountClosureStatus'] == true,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: L10n.tr(
              response.error?.message ?? '',
            ),
            errorCode: '01ACB001',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onSetAccountClosureStatus(
    SetAccountClosureStatus event,
    Emitter<AccountClosureState> emit,
  ) {
    emit(
      state.copyWith(
        accountClosureStatus: true,
      ),
    );
  }
}
