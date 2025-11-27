import 'package:piapiri_v2/common/widgets/tab_controller/model/tab_bar_item.dart';
import 'package:piapiri_v2/common/widgets/tab_controller/tab_controllers/p_main_tab_controller.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/app/ipo/pages/ipo_active_page.dart';
import 'package:piapiri_v2/app/ipo/pages/ipo_future_page.dart';
import 'package:piapiri_v2/app/ipo/pages/ipo_past_page.dart';
import 'package:piapiri_v2/app/markets/model/market_menu.dart';
import 'package:piapiri_v2/common/utils/utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/create_account_widget.dart';
import 'package:piapiri_v2/core/config/analytics/analytics.dart';
import 'package:piapiri_v2/core/config/analytics/analytics_events.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/insider_event_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class IpoPage extends StatefulWidget {
  const IpoPage({super.key});

  @override
  State<IpoPage> createState() => _IpoPageState();
}

class _IpoPageState extends State<IpoPage> {
  @override
  Widget build(BuildContext context) {
    Utils.setListPageEvent(pageName: 'IpoPage');
    getIt<Analytics>().track(
      AnalyticsEvents.listingPageView,
      taxonomy: [
        InsiderEventEnum.controlPanel.value,
        InsiderEventEnum.marketsPage.value,
        InsiderEventEnum.ipoTab.value,
      ],
    );

    return Scaffold(
      body: !getIt<AuthBloc>().state.isLoggedIn
          ? Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Grid.m,
              ),
              child: CreateAccountWidget(
                memberMessage: L10n.tr('create_account_ipo_alert'),
                loginMessage: L10n.tr('login_ipo_alert'),
                onLogin: () => router.push(
                  AuthRoute(
                    activeIndex: 2,
                    marketMenu: MarketMenu.ipo,
                  ),
                ),
              ),
            )
          : SafeArea(
              child: Column(
              children: [
                Expanded(
                  child: PMainTabController(
                    scrollable: false,
                    tabs: [
                      PTabItem(
                        title: L10n.tr('active'),
                        page: const IpoActivePage(),
                      ),
                      PTabItem(
                        title: L10n.tr('future'),
                        page: const IpoFuturePage(),
                      ),
                      PTabItem(
                        title: L10n.tr('past'),
                        page: const IpoPastPage(),
                      ),
                    ],
                  ),
                ),
              ],
            )),
    );
  }
}
