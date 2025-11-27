import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/common/widgets/tab_controller/model/tab_bar_item.dart';
import 'package:piapiri_v2/common/widgets/tab_controller/tab_controllers/p_main_tab_controller.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/alarm/bloc/alarm_bloc.dart';
import 'package:piapiri_v2/app/alarm/bloc/alarm_event.dart';
import 'package:piapiri_v2/app/alarm/bloc/alarm_state.dart';
import 'package:piapiri_v2/app/alarm/page/news_alarms.dart';
import 'package:piapiri_v2/app/alarm/page/price_alarms.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/create_account_widget.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class MyAlarmsPage extends StatefulWidget {
  final String? symbol;
  const MyAlarmsPage({
    super.key,
    this.symbol,
  });

  @override
  State<MyAlarmsPage> createState() => _MyAlarmsPageState();
}

class _MyAlarmsPageState extends State<MyAlarmsPage> {
  late final AlarmBloc _alarmBloc;
  late AuthBloc _authBloc;

  @override
  void initState() {
    _authBloc = getIt<AuthBloc>();
    _alarmBloc = getIt<AlarmBloc>();
    if (_authBloc.state.isLoggedIn) {
      _alarmBloc.add(
        GetAlarmsEvent(),
      );
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PInnerAppBar(
        title: L10n.tr('alarmlarim'),
        
      ),
      body: !_authBloc.state.isLoggedIn
          ? CreateAccountWidget(
              memberMessage: L10n.tr('create_account_alarm_alert'),
              loginMessage: L10n.tr('login_alarm_alert'),
              onLogin: () => router.push(
                AuthRoute(
                  afterLoginAction: () async {
                    router.push(
                      MyAlarmsRoute(
                        symbol: widget.symbol,
                      ),
                    );
                  },
                ),
              ),
            )
          : PBlocBuilder<AlarmBloc, AlarmState>(
              bloc: _alarmBloc,
              builder: (context, state) {
                return PMainTabController(
                  tabs: [
                    PTabItem(
                      title: L10n.tr('fiyat_alarmi'),
                      page: PriceAlarms(
                        priceAlarms: state.priceAlarms,
                      ),
                    ),
                    PTabItem(
                      title: L10n.tr('haber_alarmi'),
                      page: NewsAlarms(
                        newsAlarms: state.newsAlarms,
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
