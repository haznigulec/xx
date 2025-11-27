import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/bloc/tab/tab_event.dart';
import 'package:piapiri_v2/core/bloc/tab/tab_state.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';

class TabBloc extends PBloc<TabState> {
  TabBloc() : super(initialState: const TabState()) {
    on<TabChangedEvent>(_onSetTabIndex);
    on<TabClearEvent>(_onClearEvent);
    on<TabSetInnerTabEvent>(_onSetInnerTabName);
    on<TabResetInnerTabEvent>(_onResetInnerTabName);
  }

  List<PageRouteInfo> tabRoutes = [
    const HomeRoute(),
    const OrdersRoute(),
    MarketsRoute(),
    PortfolioRoute(),
  ];

  FutureOr<void> _onSetTabIndex(
    TabChangedEvent event,
    Emitter<TabState> emit,
  ) {
    try {
      PageRouteInfo actualTab = tabRoutes[state.selectedTabIndex];
      PageRouteInfo newTab = tabRoutes[event.tabIndex];
      router.popAndPushTabBarRouteName(actualTab.routeName, newTab.routeName);
      emit(
        state.copyWith(
          selectedTabIndex: event.tabIndex,
          ordersTabIndex: newTab is OrdersRoute && event.ordersTabIndex != null ? event.ordersTabIndex : null,
          marketMenu: newTab is MarketsRoute && event.marketMenu != null ? event.marketMenu : null,
          marketMenuTabIndex:
              newTab is MarketsRoute && event.marketMenuTabIndex != null ? event.marketMenuTabIndex : null,
          portfolioTabIndex:
              newTab is PortfolioRoute && event.portfolioTabIndex != null ? event.portfolioTabIndex : null,
        ),
      );
    } catch (e) {
      talker.critical(
        e.toString(),
        'MethodName: _onSetTabIndex',
      );
    }
  }

  FutureOr<void> _onClearEvent(
    TabClearEvent event,
    Emitter<TabState> emit,
  ) {
    emit(
      state.copyWith(
        marketMenu: null,
        marketMenuTabIndex: null,
        portfolioTabIndex: null,
      ),
    );
  }

  FutureOr<void> _onSetInnerTabName(
    TabSetInnerTabEvent event,
    Emitter<TabState> emit,
  ) {
    try {
      emit(
        state.copyWith(
          innerTabName: event.innerTabName,
          type: PageState.willChange,
        ),
      );
    } catch (e) {
      talker.critical(
        e.toString(),
        'MethodName: _onSetInnerTabName',
      );
    }
  }

  FutureOr<void> _onResetInnerTabName(
    TabResetInnerTabEvent event,
    Emitter<TabState> emit,
  ) {
    try {
      emit(
        state.copyWith(
          innerTabName: '',
          type: PageState.success,
        ),
      );
    } catch (e) {
      talker.critical(
        e.toString(),
        'MethodName: _onResetInnerTabName',
      );
    }
  }
}
