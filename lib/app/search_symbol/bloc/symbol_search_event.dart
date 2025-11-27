import 'package:piapiri_v2/core/bloc/bloc/bloc_event.dart';
import 'package:piapiri_v2/core/model/position_model.dart';
import 'package:piapiri_v2/core/model/symbol_model.dart';
import 'package:piapiri_v2/app/search_symbol/enum/symbol_search_filter_enum.dart';
import 'package:piapiri_v2/core/model/transaction_type_enum.dart';

abstract class SymbolSearchEventEvent extends PEvent {}

class SearchSymbolEvent extends SymbolSearchEventEvent {
  final String symbolName;
  final String exchangeCode;
  final String? underlying;
  final String? maturity;
  final TransactionTypeEnum? transactionType;
  final List<String> filterDbKeys;

  final Function(List<SymbolModel> result) callback;

  SearchSymbolEvent({
    required this.symbolName,
    required this.exchangeCode,
    required this.underlying,
    required this.maturity,
    required this.transactionType,
    required this.filterDbKeys,
    required this.callback,
  });
}
class SearchFundEvent extends SymbolSearchEventEvent {
  final String foundercode;
  final String searchKey;
  final Function(List<SymbolModel>) callBack;

  SearchFundEvent({
    required this.foundercode,
    required this.searchKey,
    required this.callBack,
  });
}

class GetOldSearchesEvent extends SymbolSearchEventEvent {
  final List<String> filterDbKeys;
  final Function(List<SymbolModel> result)? callback;

  GetOldSearchesEvent({
    required this.filterDbKeys,
    this.callback,
  });
}

class SetOldSearchesEvent extends SymbolSearchEventEvent {
  final SymbolModel symbolModel;

  SetOldSearchesEvent({
    required this.symbolModel,
  });
}

class RemoveOldSearchesEvent extends SymbolSearchEventEvent {
  final SymbolModel symbolModel;

  RemoveOldSearchesEvent({
    required this.symbolModel,
  });
}

class RemoveExpiredOldSearchesEvent extends SymbolSearchEventEvent {
  final List<SymbolModel> expiredSymbols;

  RemoveExpiredOldSearchesEvent({
    required this.expiredSymbols,
  });
}

class GetExchangeListEvent extends SymbolSearchEventEvent {
  final Function(List<Map<String, dynamic>> result) callback;

  GetExchangeListEvent({
    required this.callback,
  });
}

class GetUnderlyingListEvent extends SymbolSearchEventEvent {
  final SymbolSearchFilterEnum filter;
  final String? maturity;
  final Function(
    List<String> futureUnderlyingList
  )? callback;

  GetUnderlyingListEvent({
    required this.filter,
    required this.maturity,
    this.callback,
  });
}

class GetMaturityListEvent extends SymbolSearchEventEvent {
  final SymbolSearchFilterEnum filter;
  final String? underlying;
  final Function(List<String> maturityDate)? callback;

  GetMaturityListEvent({
    required this.filter,
    required this.underlying,
    this.callback,
  });
}

class GetSymbolSortEvent extends SymbolSearchEventEvent {}

class GetPostitionListEvent extends SymbolSearchEventEvent {
  final String accountId;
  final Function(List<PositionModel> positionList)? callback;

  GetPostitionListEvent({
    required this.accountId,
    this.callback,
  });
}
