import 'dart:async';
import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:piapiri_v2/common/widgets/bottom_navigation_bar/floating_action_button.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:p_core/keys/navigator_keys.dart';
import 'package:piapiri_v2/app/advices/enum/market_type_enum.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_event.dart';
import 'package:piapiri_v2/app/market_reviews/bloc/reports_bloc.dart';
import 'package:piapiri_v2/app/market_reviews/bloc/reports_event.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/bloc/quick_portfolio_bloc.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/bloc/quick_portfolio_event.dart';
import 'package:piapiri_v2/common/utils/constant.dart';
import 'package:piapiri_v2/common/utils/local_keys.dart';
import 'package:piapiri_v2/common/utils/show_case_utils.dart';
import 'package:piapiri_v2/common/utils/utils.dart';
import 'package:piapiri_v2/common/widgets/appbars/dashboard_app_bar.dart';
import 'package:piapiri_v2/common/widgets/exchange_overlay/widgets/darken_backgorund.dart';
import 'package:piapiri_v2/common/widgets/exchange_overlay/widgets/show_case_view.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_consumer.dart';
import 'package:piapiri_v2/core/bloc/tab/tab_bloc.dart';
import 'package:piapiri_v2/core/bloc/tab/tab_event.dart';
import 'package:piapiri_v2/core/bloc/tab/tab_state.dart';
import 'package:piapiri_v2/core/config/analytics/analytics.dart';
import 'package:piapiri_v2/core/config/analytics/analytics_events.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/storage/local_storage.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:talker_flutter/talker_flutter.dart';

@RoutePage()
class DashboardPage extends StatefulWidget {
  final bool isFirstLaunch;
  final bool checkBiometric;
  final bool newCustomerWelcomeScreen;

  const DashboardPage({
    super.key,
    this.isFirstLaunch = false,
    this.checkBiometric = false,
    this.newCustomerWelcomeScreen = false,
  });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final GlobalKey scaffoldKey = GlobalKey<ScaffoldState>(debugLabel: 'dashboard');
  late final TabBloc _bloc;
  late final AuthBloc _authBloc;
  late QuickPortfolioBloc _quickPortfolioBloc;

  late final StreamSubscription subscription;
  bool isAlertShown = false;
  bool _isOverlayVisible = false;
  bool _isBiometricAlertShown = false;
  bool _isNewCustomerWelcomeScreenShown = false;
  late final List<ShowCaseViewModel> _portfolioShowCaseKeys;
  TabsRouter? tabsRouter;

  @override
  void initState() {
    _bloc = getIt<TabBloc>();
    _authBloc = getIt<AuthBloc>();
    _quickPortfolioBloc = getIt<QuickPortfolioBloc>();
    _quickPortfolioBloc.add(
      GetSpecificListEvent(
        mainGroup: MarketTypeEnum.home.value,
      ),
    );
    _portfolioShowCaseKeys = [
      ShowCaseViewModel(
        globalKey: GlobalKey(),
        title: L10n.tr('portfolio_sc_dom_title'),
        description: L10n.tr('portfolio_sc_dom_desc'),
        stepText: '1/3',
        buttonText: L10n.tr('sc_next'),
      ),
      ShowCaseViewModel(
        globalKey: GlobalKey(),
        title: L10n.tr('portfolio_sc_abr_title'),
        description: L10n.tr('portfolio_sc_abr_desc'),
        stepText: '2/3',
        buttonText: L10n.tr('sc_next'),
      ),
      ShowCaseViewModel(
        globalKey: GlobalKey(),
        title: L10n.tr('portfolio_sc_buysell_title'),
        description: L10n.tr('portfolio_sc_buysell_desc'),
        stepText: '',
        buttonText: L10n.tr('sc_completed'),
      ),
    ];
    getIt<Analytics>().track(
      AnalyticsEvents.homePageView,
    );
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        getIt<ReportsBloc>().add(GetVideoReportsEvent());

        if (dashboardInitialIndex != null) {
          tabsRouter!.setActiveIndex(dashboardInitialIndex!);
          //listener'ın tetiklenmemesi için sonrasında TabChangedEvent tetiklenmiştir.
          //PBottomNavigationBar selected index doğru gözükmesi için gereklidir.
          _bloc.add(TabChangedEvent(tabIndex: dashboardInitialIndex!));
          dashboardInitialIndex = null;
        } else if (tabsRouter!.activeIndex != _bloc.state.selectedTabIndex) {
          tabsRouter!.setActiveIndex(_bloc.state.selectedTabIndex);
        }

        if (widget.newCustomerWelcomeScreen && !_isNewCustomerWelcomeScreenShown) {
          setState(() => _isNewCustomerWelcomeScreenShown = true);
          router.push(const WelcomePiapiriRoute());
        }

        subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async {
          bool hasConnection = await InternetConnectionChecker().hasConnection;
          if (!hasConnection && !isAlertShown) {
            setState(() => isAlertShown = true);
            Utils().showConnectivityAlert(
              context: NavigatorKeys.navigatorKey.currentContext ?? context,
              action: () => setState(() {
                isAlertShown = false;
                router.maybePop();
              }),
            );
          } else if (hasConnection) {
            setState(() => isAlertShown = false);
          }

          if (widget.checkBiometric && !_isBiometricAlertShown) {
            final shouldShowBiometric = getIt<LocalStorage>().read(LocalKeys.showBiometricLogin) == null;

            if (shouldShowBiometric) {
              setState(() => _isBiometricAlertShown = true);
              await Future.delayed(Duration.zero);
              Utils().showBiometricAlert(NavigatorKeys.navigatorKey.currentContext ?? context);
            }
          }
        });
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TalkerWrapper(
      talker: talker,
      options: const TalkerWrapperOptions(
        enableErrorAlerts: true,
      ),
      child: PBlocConsumer<TabBloc, TabState>(
        bloc: _bloc,
        listenWhen: (previous, current) => previous.selectedTabIndex != current.selectedTabIndex,
        listener: (context, state) {
          tabsRouter?.setActiveIndex(state.selectedTabIndex);
          switch (state.selectedTabIndex) {
            case 0:
              getIt<Analytics>().track(
                AnalyticsEvents.homePageView,
              );
            case 1:
              getIt<Analytics>().track(
                AnalyticsEvents.ordersPageView,
              );
            case 2:
              getIt<Analytics>().track(
                AnalyticsEvents.piyasalarTabClick,
              );
            case 3:
              {
                bool isActivePortfolio =
                    ShowCaseUtils.onCheckShowCaseEvent(ShowCaseEnum.portfolioCase) && _authBloc.state.isLoggedIn;
                if (isActivePortfolio) {
                  setState(() {
                    _portfolioShowCaseKeys.last.stepText = '3/3';
                  });
                }
                getIt<Analytics>().track(
                  AnalyticsEvents.portfolioPageView,
                );
              }

            default:
          }
        },
        builder: (context, state) {
          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (bool didPop, Object? result) {
              if (state.selectedTabIndex == 0) {
                if (getIt<AuthBloc>().state.isLoggedIn) {
                  _showLogoutAlert();
                } else {
                  if (Platform.isAndroid) {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  } else if (Platform.isIOS) {
                    exit(0);
                  }
                }
              }
              _bloc.add(const TabChangedEvent(tabIndex: 0));
            },
            child: AutoTabsRouter(
              key: scaffoldKey,
              lazyLoad: true,
              routes: [
                const HomeRoute(),
                const OrdersRoute(),
                MarketsRoute(
                  onOverlayVisibilityChanged: (isVisible) {
                    setState(() {
                      _isOverlayVisible = isVisible;
                    });
                  },
                ),
                PortfolioRoute(
                  portfolioShowCaseKeys: _portfolioShowCaseKeys,
                ),
              ],
              builder: (context, child) {
                tabsRouter = AutoTabsRouter.of(context);
                return Scaffold(
                  appBar: tabsRouter?.activeIndex == 2 ? null : const DashboardAppBar(),
                  body: Stack(
                    children: [
                      child,
                      // _quickOrderButton(
                      //   width: MediaQuery.of(context).size.width,
                      //   height: MediaQuery.of(context).size.height,
                      // ),
                    ],
                  ),
                  bottomNavigationBar: DarkenBackgorund(
                    isDarken: _isOverlayVisible,
                    child: PBottomNavigationBar(
                      key: ValueKey(state.selectedTabIndex),
                      currentIndex: state.selectedTabIndex,
                      onTap: (tabIndex) {
                        HapticFeedback.lightImpact();
                        if (tabsRouter?.activeIndex != tabIndex) {
                          _bloc.add(
                            TabChangedEvent(
                              tabIndex: tabIndex,
                            ),
                          );
                          // tabsRouter?.setActiveIndex(tabIndex);
                        }
                      },
                      navigationItems: [
                        getBottomNavigationBarItem(
                          L10n.tr('anasayfa'),
                          ImagesPath.home,
                        ),
                        getBottomNavigationBarItem(
                          L10n.tr('emirler'),
                          ImagesPath.arrows_refresh,
                        ),
                        getBottomNavigationBarItem(
                          L10n.tr('piyasalar'),
                          ImagesPath.graph_line,
                        ),
                        getBottomNavigationBarItem(
                          L10n.tr('portfoy'),
                          ImagesPath.pie_chart,
                        ),
                      ],
                    ),
                  ),
                  floatingActionButton: PFloatingAction(
                    isOverlayVisible: _isOverlayVisible,
                    showCase: _portfolioShowCaseKeys.last,
                    onPressed: () {
                      bool isActivePortfolio = ShowCaseUtils.onCheckShowCaseEvent(ShowCaseEnum.portfolioCase);
                      bool isActiveQuick = ShowCaseUtils.onCheckShowCaseEvent(ShowCaseEnum.quickBuySellCase);
                      if (_authBloc.state.isLoggedIn && isActivePortfolio && isActiveQuick) {
                        ShowCaseUtils.onAddShowCaseEvent(ShowCaseEnum.quickBuySellCase);
                        ShowcaseView.get().startShowCase([_portfolioShowCaseKeys.last.globalKey]);
                      } else {
                        router.push(
                          CreateOrderRoute(),
                        );
                      }
                    },
                  ),
                  floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
                );
              },
            ),
          );
          // );
        },
      ),
    );
  }

  BottomNavigationBarItem getBottomNavigationBarItem(String label, String icon) {
    return BottomNavigationBarItem(
      label: label,
      icon: SvgPicture.asset(
        icon,
        colorFilter: ColorFilter.mode(
          context.pColorScheme.iconSecondary,
          BlendMode.srcIn,
        ),
      ),
      activeIcon: SvgPicture.asset(
        icon,
        colorFilter: ColorFilter.mode(
          context.pColorScheme.primary,
          BlendMode.srcIn,
        ),
      ),
    );
  }

  _showLogoutAlert() {
    PBottomSheet.showError(
      context,
      content: L10n.tr(
        'shutdown_alert',
      ),
      showFilledButton: true,
      filledButtonText: L10n.tr('cikis_yap'),
      onFilledButtonPressed: () {
        getIt<AuthBloc>().add(
          const LogoutEvent(),
        );

        router.maybePop();
        if (Platform.isAndroid) {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        } else if (Platform.isIOS) {
          exit(0);
        }
      },
    );
  }
}
