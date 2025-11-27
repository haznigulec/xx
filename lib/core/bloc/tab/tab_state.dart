import 'package:piapiri_v2/app/markets/model/market_menu.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';

class TabState extends PState {
  final int selectedTabIndex;
  final String innerTabName;
  final int? ordersTabIndex;
  final MarketMenu? marketMenu;
  final int? marketMenuTabIndex;
  final int? portfolioTabIndex;

  const TabState({
    super.type = PageState.initial,
    super.error,
    this.selectedTabIndex = 0,
    this.innerTabName = '',
    this.ordersTabIndex,
    this.marketMenu,
    this.marketMenuTabIndex,
    this.portfolioTabIndex,
  });

  @override
  TabState copyWith({
    PageState? type,
    PBlocError? error,
    int? selectedTabIndex,
    String? innerTabName,
    MarketMenu? marketMenu,
    int? marketMenuTabIndex,
    int? portfolioTabIndex,
    int? ordersTabIndex,
  }) {
    return TabState(
      type: type ?? this.type,
      error: error ?? this.error,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      innerTabName: innerTabName ?? this.innerTabName,
      ordersTabIndex: ordersTabIndex,
      marketMenu: marketMenu,
      marketMenuTabIndex: marketMenuTabIndex,
      portfolioTabIndex: portfolioTabIndex,
    );
  }

  @override
  List<Object?> get props => [
        type,
        error,
        selectedTabIndex,
        innerTabName,
      ];
}
