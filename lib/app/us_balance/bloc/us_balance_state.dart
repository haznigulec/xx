import 'package:piapiri_v2/app/us_balance/model/us_balance_transfer_model.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';

class UsBalanceState extends PState {
  final double? cashAmount;
  final UsBalanceTransferModel? balanceTransferModel;

  const UsBalanceState({
    super.type = PageState.initial,
    super.error,
    this.cashAmount,
    this.balanceTransferModel,
  });

  @override
  PState copyWith({
    PageState? type,
    PBlocError? error,
    double? cashAmount,
    UsBalanceTransferModel? balanceTransferModel,
  }) {
    return UsBalanceState(
      type: type ?? this.type,
      error: error ?? this.error,
      cashAmount: cashAmount ?? this.cashAmount,
      balanceTransferModel: balanceTransferModel ?? this.balanceTransferModel,
    );
  }

  @override
  List<Object?> get props => [
        type,
        error,
        cashAmount,
        balanceTransferModel,
      ];
}
