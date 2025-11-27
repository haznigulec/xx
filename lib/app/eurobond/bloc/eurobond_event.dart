import 'package:piapiri_v2/app/eurobond/model/eurobond_list_model.dart';
import 'package:piapiri_v2/app/eurobond/model/eurobond_validate_order_model.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_event.dart';
import 'package:piapiri_v2/core/model/assets_model.dart';

abstract class EuroBondEvent extends PEvent {}

class GetBondListEvent extends EuroBondEvent {
  final String finInstId;
  final Function(EuroBondListModel)? onSuccess;

  GetBondListEvent({
    required this.finInstId,
    this.onSuccess,
  });
}

class GetBondsAssetsEvent extends EuroBondEvent {
  final String finInstId;
  final String accountId;
  final Function(OverallSubItemModel?)? onSuccess;

  GetBondsAssetsEvent({
    required this.accountId,
    required this.finInstId,
    this.onSuccess,
  });
}

class ValidateOrderEvent extends EuroBondEvent {
  final String accountId;
  final String finInstId;
  final String side;
  final double amount;
  final Function(EuroBondValidateOrderModel)? onSuccess;
  final Function(String errorMessage)? onError;

  ValidateOrderEvent({
    required this.accountId,
    required this.finInstId,
    required this.side,
    required this.amount,
    required this.onSuccess,
    required this.onError,
  });
}

class AddOrderEvent extends EuroBondEvent {
  final String accountId;
  final String finInstName;
  final String side;
  final double amount;
  final double rate;
  final double nominal;
  final double unitPrice;
  final Function(String)? onSuccess;
  final Function(String errorMessage)? onError;

  AddOrderEvent({
    required this.accountId,
    required this.finInstName,
    required this.side,
    required this.amount,
    required this.rate,
    required this.nominal,
    required this.unitPrice,
    required this.onSuccess,
    required this.onError,
  });
}

class DeleteOrderEvent extends EuroBondEvent {
  final String accountId;
  final String transactionId;
  final Function(bool, String)? completedCallBack;

  DeleteOrderEvent({
    required this.accountId,
    required this.transactionId,
    this.completedCallBack,
  });
}

class GetBondLimitEvent extends EuroBondEvent {
  final String accountId;
  final String finInstName;
  final String side;

  GetBondLimitEvent({
    required this.accountId,
    required this.finInstName,
    required this.side,
  });
}

class GetDescriptionEvent extends EuroBondEvent {
  GetDescriptionEvent();
}

class GetTradeLimitEvent extends EuroBondEvent {
  final Function(double cashLimit)? callback;
  GetTradeLimitEvent({
    this.callback,
  });
}
