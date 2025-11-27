import 'dart:ui';

import 'package:piapiri_v2/app/ipo/model/ipo_active_info_model.dart';
import 'package:piapiri_v2/app/ipo/model/ipo_model.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_event.dart';

abstract class IpoEvent extends PEvent {}

class GetActiveListEvent extends IpoEvent {
  final bool forceFetch;
  final int pageNumber;
  final Function()? callback;

  GetActiveListEvent({
    this.forceFetch = false,
    required this.pageNumber,
    this.callback,
  });
}

class GetFutureListEvent extends IpoEvent {
  final bool forceFetch;
  final int pageNumber;
  final Function()? callback;

  GetFutureListEvent({
    this.forceFetch = false,
    required this.pageNumber,
    this.callback,
  });
}

class GetPastListEvent extends IpoEvent {
  final bool forceFetch;
  final Function()? callback;

  GetPastListEvent({
    this.forceFetch = false,
    this.callback,
  });
}

class GetIpoDetailsByIdEvent extends IpoEvent {
  final int ipoId;
  final Function(IpoModel)? callback;

  GetIpoDetailsByIdEvent({
    required this.ipoId,
    this.callback,
  });
}

class SetStateSuccessEvent extends IpoEvent {
  SetStateSuccessEvent();
}

class GetActiveDemandsEvent extends IpoEvent {}

class GetTradeLimitEvent extends IpoEvent {
  final String customerId;
  final String accountId;

  GetTradeLimitEvent({
    required this.customerId,
    required this.accountId,
  });
}

class GetCashBalanceEvent extends IpoEvent {
  final String customerId;
  final String accountId;
  final String typeName;

  GetCashBalanceEvent({
    required this.customerId,
    required this.accountId,
    required this.typeName,
  });
}

class GetActiveInfoEvent extends IpoEvent {
  final String customerId;
  final String accountId;
  final Function(String, IpoActiveInfoModel) callback;

  GetActiveInfoEvent({
    required this.customerId,
    required this.accountId,
    required this.callback,
  });
}

class GetJustActiveInfoEvent extends IpoEvent {
  final String accountId;
  final Function(IpoActiveInfoModel) callback;

  GetJustActiveInfoEvent({
    required this.accountId,
    required this.callback,
  });
}

class GetCustomerInfoEvent extends IpoEvent {
  final String customerId;
  final String accountId;

  GetCustomerInfoEvent({
    required this.customerId,
    required this.accountId,
  });
}

class GetBlockageEvent extends IpoEvent {
  final String customerId;
  final String accountId;
  final String ipoId;
  final int paymentType;
  final Function(bool)? isEmpty;

  GetBlockageEvent({
    required this.customerId,
    required this.accountId,
    required this.ipoId,
    required this.paymentType,
    this.isEmpty,
  });
}

class DemandAddEvent extends IpoEvent {
  final String customerId;
  final String accountId;
  final int functionName;
  final String demandDate;
  final String ipoId;
  final int unitsDemanded;
  final int paymentType;
  final String transactionType;
  final String investorTypeId;
  final String demandGatheringType;
  final double totalAmount;
  final List<Map<String, dynamic>> itemsToBlock;
  final VoidCallback callback;
  final double offerPrice;
  final int minUnits;
  final String customFields;

  DemandAddEvent({
    required this.customerId,
    required this.accountId,
    required this.functionName,
    required this.demandDate,
    required this.ipoId,
    required this.unitsDemanded,
    required this.paymentType,
    required this.transactionType,
    required this.investorTypeId,
    required this.demandGatheringType,
    required this.totalAmount,
    required this.itemsToBlock,
    required this.callback,
    required this.offerPrice,
    required this.minUnits,
    required this.customFields,
  });
}

class DemandDeleteEvent extends IpoEvent {
  final String customerId;
  final String accountId;
  final int functionName;
  final String demandDate;
  final String ipoId;
  final String demandId;
  final VoidCallback callback;

  DemandDeleteEvent({
    required this.customerId,
    required this.accountId,
    required this.functionName,
    required this.demandDate,
    required this.ipoId,
    required this.demandId,
    required this.callback,
  });
}

class DemandUpdateEvent extends IpoEvent {
  final String customerId;
  final String accountId;
  final int functionName;
  final String demandDate;
  final String ipoId;
  final String demandId;
  final double unitsDemanded;
  final double offerPrice;
  final bool checkLimit;
  final String demandGatheringType;
  final String demandType;
  final VoidCallback callback;
  final int? paymentTypeId;
  final List<Map<String, dynamic>>? itemsToBlock;

  DemandUpdateEvent({
    required this.customerId,
    required this.accountId,
    required this.functionName,
    required this.demandDate,
    required this.ipoId,
    required this.demandId,
    required this.unitsDemanded,
    required this.callback,
    required this.offerPrice,
    required this.checkLimit,
    required this.demandGatheringType,
    required this.demandType,
    this.paymentTypeId,
    this.itemsToBlock,
  });
}

class IpoListResetPageNumber extends IpoEvent {}

class GetIpoDetailsBySymbol extends IpoEvent {
  final String ipoSymbol;

  GetIpoDetailsBySymbol({
    required this.ipoSymbol,
  });
}

class GetIpoDetailsForSearch extends IpoEvent {
  final String ipoSymbol;
  final int pageNumber;

  GetIpoDetailsForSearch({
    required this.ipoSymbol,
    required this.pageNumber,
  });
}

class NewOrderHEEvent extends IpoEvent {
  final String symbolName;
  final String quantity;
  final String orderActionType;
  final String orderType;
  final String orderValidity;
  final String account;
  final String price;
  final String orderCompletionType;

  final VoidCallback callback;

  NewOrderHEEvent({
    required this.symbolName,
    required this.quantity,
    required this.orderActionType,
    required this.orderType,
    required this.orderValidity,
    required this.account,
    required this.price,
    required this.orderCompletionType,
    required this.callback,
  });
}

class GetSymbolNameIsExistEvent extends IpoEvent {
  final String symbolName;
  final Function(String)? callback;

  GetSymbolNameIsExistEvent({
    required this.symbolName,
    this.callback,
  });
}
