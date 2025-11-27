import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/model/position_model.dart';
import 'package:piapiri_v2/core/model/symbol_model.dart';

class SymbolSearchState extends PState {
  final List<SymbolModel> searchResults;
  final List<SymbolModel> oldSearches;
  final List<Map<String, dynamic>> exchangeList;
  final List<PositionModel> positionList;
  final List<String> underlyingList;
  final List<String> maturityList;
  final Map<String, dynamic> symbolSort;
  final String sortingQuery;
  final String showForeignAfter;

  const SymbolSearchState({
    super.type = PageState.initial,
    super.error,
    this.searchResults = const [],
    this.oldSearches = const [],
    this.exchangeList = const [],
    this.positionList = const [],
    this.underlyingList = const [],
    this.maturityList = const [],
    this.symbolSort = const {},
    this.sortingQuery = '',
    this.showForeignAfter = '',
  });

  @override
  SymbolSearchState copyWith({
    PageState? type,
    PBlocError? error,
    List<SymbolModel>? searchResults,
    List<SymbolModel>? oldSearches,
    List<Map<String, dynamic>>? exchangeList,
    List<PositionModel>? positionList,
    List<String>? underlyingList,
    List<String>? maturityList,
    Map<String, dynamic>? symbolSort,
    String? sortingQuery,
    String? showForeignAfter,
  }) {
    return SymbolSearchState(
      type: type ?? this.type,
      error: error ?? this.error,
      searchResults: searchResults ?? this.searchResults,
      oldSearches: oldSearches ?? this.oldSearches,
      exchangeList: exchangeList ?? this.exchangeList,
      positionList: positionList ?? this.positionList,
      underlyingList: underlyingList ?? this.underlyingList,
      maturityList: maturityList ?? this.maturityList,
      symbolSort: symbolSort ?? this.symbolSort,
      sortingQuery: sortingQuery ?? this.sortingQuery,
      showForeignAfter: showForeignAfter ?? this.showForeignAfter,
    );
  }

  @override
  List<Object?> get props => [
        type,
        error,
        searchResults,
        oldSearches,
        exchangeList,
        positionList,
        underlyingList,
        maturityList,
        symbolSort,
        sortingQuery,
        showForeignAfter,
      ];
}
