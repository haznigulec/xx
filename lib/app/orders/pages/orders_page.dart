import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/tab_controller/model/tab_bar_item.dart';
import 'package:piapiri_v2/common/widgets/tab_controller/tab_controllers/p_main_tab_controller.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_state.dart';
import 'package:piapiri_v2/app/orders/widgets/orders_list.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/create_account_widget.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/tab/tab_bloc.dart';
import 'package:piapiri_v2/core/bloc/tab/tab_event.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/order_status_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class OrdersPage extends StatefulWidget {
  const OrdersPage({
    super.key,
  });

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> with TickerProviderStateMixin {
  late final AuthBloc _authBloc;
  late final int _initialTabIndex;

  @override
  void initState() {
    _authBloc = getIt<AuthBloc>();

    if (getIt<TabBloc>().state.ordersTabIndex != null) {
      _initialTabIndex = getIt<TabBloc>().state.ordersTabIndex!;
      getIt<TabBloc>().add(TabClearEvent());
    } else {
      _initialTabIndex = 0;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PBlocBuilder<AuthBloc, AuthState>(
        bloc: _authBloc,
        builder: (context, state) {
          if (!state.isLoggedIn) {
            return Center(
              child: CreateAccountWidget(
                memberMessage: L10n.tr('create_account_orders'),
                loginMessage: L10n.tr('login_warning_orders'),
                onLogin: () => router.push(
                  AuthRoute(
                    activeIndex: 1,
                  ),
                ),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: PMainTabController(
                  initialIndex: _initialTabIndex,
                  scrollable: true,
                  tabs: [
                    PTabItem(
                      title: L10n.tr('waiting'),
                      page: const OrdersList(
                        key: ValueKey(OrderStatusEnum.pending),
                        orderStatus: OrderStatusEnum.pending,
                        ordersSettings: [],
                        isActive: true,
                        duration: 3000,
                        sortKey: 'orders_waiting_is_ascending',
                      ),
                    ),
                    PTabItem(
                      title: L10n.tr('completed'),
                      page: const OrdersList(
                        key: ValueKey(OrderStatusEnum.filled),
                        orderStatus: OrderStatusEnum.filled,
                        ordersSettings: [],
                        isActive: false,
                        duration: 3000,
                        sortKey: 'orders_completed_is_ascending',
                      ),
                    ),
                    PTabItem(
                      title: L10n.tr('deleted'),
                      page: const OrdersList(
                        key: ValueKey(OrderStatusEnum.canceled),
                        orderStatus: OrderStatusEnum.canceled,
                        ordersSettings: [],
                        isActive: false,
                        duration: 0,
                        sortKey: 'orders_canceled_is_ascending',
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
