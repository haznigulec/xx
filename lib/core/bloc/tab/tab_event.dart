import 'package:piapiri_v2/app/markets/model/market_menu.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_event.dart';

abstract class TabEvent extends PEvent {
  const TabEvent();
}

class TabChangedEvent extends TabEvent {
  final int tabIndex;
  final int? ordersTabIndex;
  final MarketMenu? marketMenu;
  final int? marketMenuTabIndex;
  final int? portfolioTabIndex;

  const TabChangedEvent({
    required this.tabIndex,
    this.ordersTabIndex,
    this.marketMenu,
    this.marketMenuTabIndex,
    this.portfolioTabIndex,
  });
}

class TabClearEvent extends TabEvent {}

class TabSetInnerTabEvent extends TabEvent {
  final String innerTabName;
  const TabSetInnerTabEvent({
    required this.innerTabName,
  });
}

class TabResetInnerTabEvent extends TabEvent {}
