import 'package:piapiri_v2/core/bloc/bloc/bloc_event.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/model/transaction_type_enum.dart';

abstract class ViopEvent extends PEvent {}

class ViopInitEvent extends ViopEvent {
  final String? underlyingName;
  final String? subMarketCode;
  final Function(List<MarketListModel>) callback;

  ViopInitEvent({
    this.underlyingName,
    this.subMarketCode,
    required this.callback,
  });
}

class ApplyFiltersEvent extends ViopEvent {
  final SymbolTypes? contractType;
  final String? underlyingName;
  final String? maturityDate;
  final String? subMaketCode;
  final TransactionTypeEnum? transactionType;
  final Function(List<MarketListModel>)? callback;

  ApplyFiltersEvent({
    this.contractType,
    this.underlyingName,
    this.maturityDate,
    this.subMaketCode,
    this.transactionType,
    this.callback,
  });
}

class GetUnderlyingListEvent extends ViopEvent {
  final Function(List<String> futureUnderlyingList)? callback;
  GetUnderlyingListEvent({
    this.callback,
  });
}

class GetMaturityListEvent extends ViopEvent {
  final String? subMarketCode;

  GetMaturityListEvent({
    this.subMarketCode,
  });
}

class OnRemoveSelectedEvent extends ViopEvent {
  final bool removeMaturity;
  final bool removeTransactionType;
  final bool removeContractType;
  final String? subMarketCode;
  final Function(List<MarketListModel>)? callback;

  OnRemoveSelectedEvent({
    this.removeMaturity = false,
    this.removeTransactionType = false,
    this.removeContractType = false,
    this.subMarketCode,
    this.callback,
  });
}

class GetViopListsEvent extends ViopEvent {}

class OnDisposeEvent extends ViopEvent {}
