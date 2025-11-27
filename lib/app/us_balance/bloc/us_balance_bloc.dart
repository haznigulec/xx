import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piapiri_v2/app/us_balance/bloc/us_balance_event.dart';
import 'package:piapiri_v2/app/us_balance/bloc/us_balance_state.dart';
import 'package:piapiri_v2/app/us_balance/model/us_balance_transfer_model.dart';
import 'package:piapiri_v2/app/us_balance/repository/us_balance_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class UsBalanceBloc extends PBloc<UsBalanceState> {
  final UsBalanceRepository _usBalanceRepository;

  UsBalanceBloc({
    required UsBalanceRepository usBalanceRepository,
  })  : _usBalanceRepository = usBalanceRepository,
        super(initialState: const UsBalanceState()) {
    on<GetInstantCashAmountUsBalanceEvent>(_onGetInstantCashAmount);
    on<BalanceTransferEvent>(_onBalanceTransfer);
  }

  FutureOr<void> _onGetInstantCashAmount(
    GetInstantCashAmountUsBalanceEvent event,
    Emitter emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _usBalanceRepository.getInstantCashAmount(
      accountId: event.accountId,
    );

    if (response.success) {
      emit(state.copyWith(
        type: PageState.success,
        cashAmount: double.parse(
          response.data['amount'].toString(),
        ),
      ));
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: L10n.tr('us_balance.${response.error?.message ?? ''}'),
            errorCode: '01USB001',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onBalanceTransfer(
    BalanceTransferEvent event,
    Emitter emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _usBalanceRepository.balanceTransfer(
      accountId: event.accountId,
      amount: event.amount,
      collateralType: event.collateralType,
    );

    if (response.success) {
      UsBalanceTransferModel balanceTransferModel = UsBalanceTransferModel.fromJson(response.data);

      emit(
        state.copyWith(
          type: PageState.success,
          balanceTransferModel: balanceTransferModel,
        ),
      );

      event.onSuccess?.call(balanceTransferModel);
    } else {
      event.onFailed?.call();
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: L10n.tr('us_balance.${response.error?.message ?? ''}'),
            errorCode: '01USB002',
          ),
        ),
      );
    }
  }
}
