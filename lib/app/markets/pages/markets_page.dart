import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/exchange_overlay/model/market_overlay_model.dart';
import 'package:piapiri_v2/common/widgets/exchange_overlay/widgets/market_overlay.dart';
import 'package:piapiri_v2/common/widgets/exchange_overlay/widgets/show_case_view.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/app/crypto/page/crypto_page.dart';
import 'package:piapiri_v2/app/eurobond/pages/eurobond_page.dart';
import 'package:piapiri_v2/app/favorite_lists/bloc/favorite_list_bloc.dart';
import 'package:piapiri_v2/app/favorite_lists/favorite_list_utils.dart';
import 'package:piapiri_v2/app/favorite_lists/pages/favorite_list_page.dart';
import 'package:piapiri_v2/app/favorite_lists/widgets/list_options.dart';
import 'package:piapiri_v2/app/fund/pages/fund_investment_page.dart';
import 'package:piapiri_v2/app/ipo/pages/ipo_page.dart';
import 'package:piapiri_v2/app/markets/market_menu_constants.dart';
import 'package:piapiri_v2/app/markets/model/market_menu.dart';
import 'package:piapiri_v2/app/markets/pages/bist_page.dart';
import 'package:piapiri_v2/app/markets/pages/journal_page.dart';
import 'package:piapiri_v2/app/markets/pages/us_front_page.dart';
import 'package:piapiri_v2/app/parity/pages/parity_exchange_page.dart';
import 'package:piapiri_v2/app/search_symbol/symbol_search_utils.dart';
import 'package:piapiri_v2/common/utils/constant.dart';
import 'package:piapiri_v2/common/utils/show_case_utils.dart';
import 'package:piapiri_v2/common/widgets/appbars/markets_app_bar.dart';
import 'package:piapiri_v2/core/bloc/tab/tab_bloc.dart';
import 'package:piapiri_v2/core/bloc/tab/tab_event.dart';
import 'package:piapiri_v2/core/config/analytics/analytics.dart';
import 'package:piapiri_v2/core/config/analytics/analytics_events.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/insider_event_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:showcaseview/showcaseview.dart';

@RoutePage()
class MarketsPage extends StatefulWidget {
  final Function(bool isOverlayVisible)? onOverlayVisibilityChanged;

  const MarketsPage({
    super.key,
    this.onOverlayVisibilityChanged,
  });

  @override
  State<MarketsPage> createState() => _MarketsPageState();
}

class _MarketsPageState extends State<MarketsPage> {
  late FavoriteListBloc _favoriteListBloc;
  late AuthBloc _authBloc;
  late TabBloc _tabBloc;

  bool _isOverlayVisible = false;
  int _selectedMenuIndex = 0;
  int _selectedTabIndex = 0;
  late bool _isActiveMarketShowCase;
  late final List<ShowCaseViewModel> _marketShowCaseKeys;
  late final List<ShowCaseViewModel> _bistShowCaseKeys;

  @override
  initState() {
    _tabBloc = getIt<TabBloc>();
    _authBloc = getIt<AuthBloc>();
    _favoriteListBloc = getIt<FavoriteListBloc>();
    _setInitializeIndex();
    _isActiveMarketShowCase =
        ShowCaseUtils.onCheckShowCaseEvent(ShowCaseEnum.marketsCase) && _authBloc.state.isLoggedIn;
    _marketShowCaseKeys = [
      ShowCaseViewModel(
        globalKey: GlobalKey(),
        title: L10n.tr('piyasalar'),
        description: L10n.tr('piyasalar_sc_desc'),
        stepText: '1/3',
        buttonText: L10n.tr('sc_next'),
      ),
      ShowCaseViewModel(
        globalKey: GlobalKey(),
        title: L10n.tr('american_stock_exchanges'),
        description: L10n.tr('american_stock_exchanges_sc_desc'),
        stepText: '2/3',
        buttonText: L10n.tr('sc_next'),
      ),
      ShowCaseViewModel(
        globalKey: GlobalKey(),
        title: L10n.tr('journal'),
        description: L10n.tr('journal_sc_desc'),
        stepText: '3/3',
        buttonText: L10n.tr('sc_completed'),
      ),
    ];
    _bistShowCaseKeys = [
      ShowCaseViewModel(
        globalKey: GlobalKey(),
        title: L10n.tr('bist_higlight_sc_title'),
        description: L10n.tr('bist_higlight_sc_desc'),
        stepText: '1/3',
        buttonText: L10n.tr('sc_next'),
      ),
      ShowCaseViewModel(
        globalKey: GlobalKey(),
        title: L10n.tr('bist_showall_sc_title'),
        description: L10n.tr('bist_showall_sc_desc'),
        stepText: '2/3',
        buttonText: L10n.tr('sc_next'),
      ),
      ShowCaseViewModel(
        globalKey: GlobalKey(),
        title: L10n.tr('bist_analysis_sc_title'),
        description: L10n.tr('bist_analysis_sc_desc'),
        stepText: '3/3',
        buttonText: L10n.tr('sc_completed'),
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MarketsAppBar(
        backgroundColor: _isOverlayVisible ? Colors.black.withValues(alpha: 0.5) : null,
        titleWidget: MarketOverlay(
          isActiveShowCase: _isActiveMarketShowCase,
          marketShowCaseKeys: _marketShowCaseKeys,
          initialIndex: _selectedMenuIndex,
          list: [
            TopMarketOverlayModel(
              label: L10n.tr('istanbul_stock_xchange'),
              index: MarketMenu.istanbulStockExchange.value,
              assetPath: ImagesPath.bist,
            ),
            TopMarketOverlayModel(
              label: L10n.tr('american_stock_exchanges'),
              index: MarketMenu.americanStockExchanges.value,
              assetPath: ImagesPath.yurt_disi,
            ),
            TopMarketOverlayModel(
              label: L10n.tr('investment_fund'),
              index: MarketMenu.investmentFund.value,
              assetPath: ImagesPath.fon,
            ),
            TopMarketOverlayModel(
              label: L10n.tr('halka_arz'),
              index: MarketMenu.ipo.value,
              assetPath: ImagesPath.halka_arz,
            ),
            TopMarketOverlayModel(
              label: L10n.tr('eurobond'),
              index: MarketMenu.eurobond.value,
              assetPath: ImagesPath.eurobond,
            ),
            TopMarketOverlayModel(
              label: L10n.tr('currency_parity'),
              index: MarketMenu.currencyParity.value,
              assetPath: ImagesPath.kur,
            ),
            TopMarketOverlayModel(
              label: L10n.tr('crypto'),
              index: MarketMenu.crypto.value,
              assetPath: ImagesPath.kripto,
            ),
            BottomMarketOverlayModel(
              label: L10n.tr('my_favorites'),
              index: MarketMenu.favorites.value,
              assetPath: ImagesPath.favorites,
            ),
            BottomMarketOverlayModel(
              label: L10n.tr('journal'),
              index: MarketMenu.journal.value,
              assetPath: ImagesPath.gundem,
            ),
          ],
          onSelected: (index) {
            setState(
              () {
                _selectedMenuIndex = index;
                selectedMenuIndex.value = index;
                if (_selectedMenuIndex == 3) {
                  getIt<Analytics>().track(
                    AnalyticsEvents.halkaArzSubTabClick,
                    taxonomy: [
                      InsiderEventEnum.controlPanel.value,
                      InsiderEventEnum.marketsPage.value,
                      InsiderEventEnum.ipoTab.value,
                    ],
                  );
                }
              },
            );
          },
          onOverlayVisibilityChanged: (bool isOverlayVisible) {
            widget.onOverlayVisibilityChanged?.call(isOverlayVisible);

            setState(() {
              _isOverlayVisible = isOverlayVisible;
            });

            if (!isOverlayVisible && _isActiveMarketShowCase) {
              _isActiveMarketShowCase = false;
              ShowCaseUtils.onAddShowCaseEvent(ShowCaseEnum.marketsCase);
            }

            if (!isOverlayVisible &&
                _selectedMenuIndex == MarketMenu.istanbulStockExchange.value &&
                _selectedTabIndex == 0) {
              bool isActiveBistCase =
                  ShowCaseUtils.onCheckShowCaseEvent(ShowCaseEnum.bistCase) && _authBloc.state.isLoggedIn;
              if (isActiveBistCase) {
                ShowCaseUtils.onAddShowCaseEvent(ShowCaseEnum.bistCase);
                ShowcaseView.get().startShowCase([
                  ..._bistShowCaseKeys.map((e) => e.globalKey),
                ]);
              }
            }
          },
        ),
        actionsWidget: _actionDecider(),
      ),
      body: Stack(
        children: [
          _decidePage(_resetTabIndex()),
          if (_isOverlayVisible)
            Positioned.fill(
              child: GestureDetector(
                child: Container(
                  color: Colors.black.withValues(alpha: 0.5), // Background Color
                ),
                onTap: () {},
              ),
            ),
        ],
      ),
    );
  }

  _setInitializeIndex() {
    if (dashboardInitialMarketMenu != null) {
      _selectedMenuIndex = dashboardInitialMarketMenu!.value;
      if (dashboardInitialMarketMenuIndex != null) {
        _selectedTabIndex = dashboardInitialMarketMenuIndex!;
      }
      dashboardInitialMarketMenu = null;
      dashboardInitialMarketMenuIndex = null;
    } else if (_tabBloc.state.marketMenu != null) {
      _selectedMenuIndex = _tabBloc.state.marketMenu!.value;
      if (_tabBloc.state.marketMenuTabIndex != null) {
        _selectedTabIndex = _tabBloc.state.marketMenuTabIndex!;
      }
      _tabBloc.add(TabClearEvent());
    } else {
      _selectedMenuIndex = selectedMenuIndex.value;
    }
    selectedMenuIndex.value = _selectedMenuIndex;
  }

  Widget _decidePage(int tabIndex) {
    switch (_selectedMenuIndex) {
      case 0:
        return BistPage(
          tabIndex: tabIndex,
          bistShowCaseKeys: _bistShowCaseKeys,
        );
      case 1:
        return UsFrontPage(
          tabIndex: tabIndex,
        );
      case 2:
        return FundInvestmentPage(
          tabIndex: tabIndex,
        );
      case 3:
        return const IpoPage();
      case 4:
        return const EuroBondPage();
      case 5:
        return const ParityExchangePage();
      case 6:
        return const CryptoPage();
      case 7:
        return const FavoriteListPage();
      case 8:
        return const JournalPage();
      default:
        return const Text("data");
    }
  }

  List<Widget> _actionDecider() {
    switch (_selectedMenuIndex) {
      case 7:
        return _favoriteListBloc.state.watchList.isEmpty
            ? []
            : [
                PIconButton(
                  type: PIconButtonType.outlined,
                  svgPath: ImagesPath.plus,
                  sizeType: PIconButtonSize.xl,
                  onPressed: () => FavoriteListUtils().updateFavoriteList(
                    context,
                    _favoriteListBloc.state.selectedList?.favoriteListItems ?? [],
                  ),
                ),
                const ListOptions(),
              ];
      case 8:
        return [];
      default:
        return [
          PIconButton(
            type: PIconButtonType.standard,
            svgPath: ImagesPath.alarm,
            sizeType: PIconButtonSize.xl,
            onPressed: () {
              router.push(
                MyAlarmsRoute(),
              );
            },
          ),
          PIconButton(
            type: PIconButtonType.outlined,
            svgPath: ImagesPath.search,
            sizeType: PIconButtonSize.xl,
            onPressed: () => SymbolSearchUtils.goSymbolDetail(),
          ),
        ];
    }
  }

  int _resetTabIndex() {
    int currentTabIndex = _selectedTabIndex;
    setState(() {
      _selectedTabIndex = 0;
    });
    return currentTabIndex;
  }
}
