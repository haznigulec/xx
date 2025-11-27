import 'package:piapiri_v2/app/assets/model/us_capra_summary_model.dart';
import 'package:piapiri_v2/app/orders/model/american_order_type_enum.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_event.dart';
import 'package:piapiri_v2/core/model/order_action_type_enum.dart';

abstract class CreateUsOrdersEvent extends PEvent {}

class GetTradeLimitEvent extends CreateUsOrdersEvent {
  final Function(double)? callback;

  GetTradeLimitEvent({
    this.callback,
  });
}

class GetPositionListEvent extends CreateUsOrdersEvent {
  final Function(List<UsOverallSubItem>)? callback;

  GetPositionListEvent({
    this.callback,
  });
}


class CreateOrderEvent extends CreateUsOrdersEvent {
  final String symbolName;
  final String? quantity;
  final double? amount;
  final double? limitPrice;
  final double? stopPrice;
  final double? equityPrice;
  final OrderActionTypeEnum orderActionType;
  final AmericanOrderTypeEnum orderType;
  final bool extendedHours;
  final Function(bool isSuccess, String? message)? callback;

  CreateOrderEvent({
    required this.symbolName,
    required this.quantity,
    required this.amount,
    required this.limitPrice,
    required this.stopPrice,
    required this.equityPrice,
    required this.orderActionType,
    required this.orderType,
    required this.extendedHours,
    this.callback,
  });
}

class DeleteOrderEvent extends CreateUsOrdersEvent {
  final String id;
  final Function(bool isSuccess, String? message)? callback;

  DeleteOrderEvent({
    required this.id,
    this.callback,
  });
}

class GetComissionEvent extends CreateUsOrdersEvent {

  GetComissionEvent();
}

