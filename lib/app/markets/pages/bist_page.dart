import 'package:piapiri_v2/common/widgets/exchange_overlay/widgets/show_case_view.dart';
import 'package:piapiri_v2/common/widgets/tab_controller/model/tab_bar_item.dart';
import 'package:piapiri_v2/common/widgets/tab_controller/tab_controllers/p_main_tab_controller.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/advices/bloc/advices_bloc.dart';
import 'package:piapiri_v2/app/advices/bloc/advices_event.dart';
import 'package:piapiri_v2/app/advices/enum/market_type_enum.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/app/equity/widgets/equity_front_page.dart';
import 'package:piapiri_v2/app/market_reviews/bloc/reports_bloc.dart';
import 'package:piapiri_v2/app/market_reviews/bloc/reports_event.dart';
import 'package:piapiri_v2/app/markets/model/market_menu.dart';
import 'package:piapiri_v2/app/markets/pages/bist_analysis_page.dart';
import 'package:piapiri_v2/app/markets/pages/markets_video_page.dart';
import 'package:piapiri_v2/app/markets/pages/viop_front_page.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/bloc/quick_portfolio_bloc.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/bloc/quick_portfolio_event.dart';
import 'package:piapiri_v2/app/warrant/widgets/warrant_front_page.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/delayed_info_widget.dart';
import 'package:piapiri_v2/core/config/app_info.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class BistPage extends StatefulWidget {
  final int? tabIndex;
  final List<ShowCaseViewModel> bistShowCaseKeys;
  const BistPage({
    this.tabIndex,
    required this.bistShowCaseKeys,
    super.key,
  });

  @override
  State<BistPage> createState() => _BistPageState();
}

int _selectedTabIndex = 0;

class _BistPageState extends State<BistPage> {
  _fetchAnalysisData() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (getIt<AuthBloc>().state.isLoggedIn) {
          getIt<AdvicesBloc>().add(
            GetAdvicesEvent(
              fetchRoboSignals: true,
              mainGroup: MarketTypeEnum.marketBist.value,
            ),
          );
          getIt<ReportsBloc>().add(
            GetReportsEvent(
              deviceId: getIt<AppInfo>().deviceId,
              mainGroup: MarketTypeEnum.marketBist.value,
            ),
          );
          final QuickPortfolioBloc quickPortfolioBloc =
              getIt<QuickPortfolioBloc>();
          quickPortfolioBloc.add(
            GetPreparedPortfolioEvent(
              portfolioKey: 'robotik_sepet',
              callback: (portfolioModel) {
                for (var item in portfolioModel) {
                  quickPortfolioBloc.add(
                    GetRoboticBasketsEvent(
                      portfolioId: item.id ?? 0,
                    ),
                  );
                }
              },
            ),
          );
          quickPortfolioBloc.add(
            GetModelPortfolioEvent(),
          );
        }
      },
    );
  }

  @override
  void initState() {
    if (widget.tabIndex == 3) {
      _fetchAnalysisData();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<PTabItem> tabs = [
      PTabItem(
        title: L10n.tr('equity'),
        page: EquityFrontPage(
          bistShowCaseKeys: widget.bistShowCaseKeys,
        ),
      ),
      PTabItem(
        title: L10n.tr('viop'),
        page: const ViopFrontPage(),
      ),
      PTabItem(
        title: L10n.tr('warrant'),
        page: const WarrantFrontPage(),
      ),
      PTabItem(
        title: L10n.tr('analysis'),
        showCase: widget.bistShowCaseKeys.last,
        page: const BistAnalysisPage(),
      ),
      if (getIt<ReportsBloc>().state.bistVideoReportList.isNotEmpty)
        PTabItem(
          title: L10n.tr('video'),
          page: const MarketsVideoPage(
            marketType: MarketTypeEnum.marketBist,
          ),
        ),
    ];
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_selectedTabIndex != 3)
              DelayedInfoWidget(
                delayedSymbols: _selectedTabIndex == 0
                    ? [SymbolTypes.equity.matriks]
                    : _selectedTabIndex == 1
                        ? [
                            SymbolTypes.future.matriks,
                            SymbolTypes.option.matriks
                          ]
                        : [SymbolTypes.warrant.matriks],
                activeIndex: 2,
                marketMenu: MarketMenu.istanbulStockExchange,
              ),
            Expanded(
              child: PMainTabController(
                scrollable: false,
                initialIndex: widget.tabIndex ?? 0,
                tabs: tabs,
                onTabChange: (selectedTabIndex) {
                  setState(() {
                    _selectedTabIndex = selectedTabIndex;
                  });
                  if (_selectedTabIndex == 3) {
                    _fetchAnalysisData();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
