import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/model/filter_category_model.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';

class EquityState extends PState {
  final FilterCategoryItemModel selectedList;
  final List<MarketListModel> symbolList;

  const EquityState({
    super.type = PageState.initial,
    super.error,
    this.selectedList = const FilterCategoryItemModel(
      localization: 'BIST 30',
      value: 'XU030',
      type: '1',
    ),
    this.symbolList = const [],
  });

  @override
  EquityState copyWith({
    PageState? type,
    PBlocError? error,
    FilterCategoryItemModel? selectedList,
    List<MarketListModel>? symbolList,
  }) {
    return EquityState(
      type: type ?? this.type,
      error: error ?? this.error,
      selectedList: selectedList ?? this.selectedList,
      symbolList: symbolList ?? this.symbolList,
    );
  }

  @override
  List<Object?> get props => [
        type,
        error,
        selectedList,
        symbolList,
      ];
}
