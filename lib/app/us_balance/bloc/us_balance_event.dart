import 'package:piapiri_v2/app/us_balance/model/us_balance_transfer_model.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_event.dart';

abstract class UsBalanceEvent extends PEvent {}

class GetInstantCashAmountUsBalanceEvent extends UsBalanceEvent {
  final String accountId;

  GetInstantCashAmountUsBalanceEvent({
    required this.accountId,
  });
}

class BalanceTransferEvent extends UsBalanceEvent {
  final String accountId;
  final String amount;
  final int collateralType;
  final Function(UsBalanceTransferModel)? onSuccess;
  final Function()? onFailed;

  BalanceTransferEvent({
    required this.accountId,
    required this.amount,
    required this.collateralType,
    this.onSuccess,
    this.onFailed,
  });
}
