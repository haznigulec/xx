import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/tab_controller/model/tab_bar_item.dart';
import 'package:piapiri_v2/common/widgets/tab_controller/tab_controllers/p_main_tab_controller.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/advices/enum/market_type_enum.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/app/create_us_order/bloc/create_us_orders_bloc.dart';
import 'package:piapiri_v2/app/create_us_order/bloc/create_us_orders_event.dart';
import 'package:piapiri_v2/app/favorite_lists/widgets/add_favorite_icon.dart';
import 'package:piapiri_v2/app/global_account_onboarding/bloc/global_account_onboarding_bloc.dart';
import 'package:piapiri_v2/app/global_account_onboarding/bloc/global_account_onboarding_event.dart';
import 'package:piapiri_v2/app/market_reviews/bloc/reports_bloc.dart';
import 'package:piapiri_v2/app/markets/pages/markets_video_page.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_bloc.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_event.dart';
import 'package:piapiri_v2/app/us_symbol_detail/pages/symbol_us_summary_page.dart';
import 'package:piapiri_v2/app/us_symbol_detail/widgets/buy_sell_buttons.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/ink_wrapper.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/alpaca_account_status_enum.dart';
import 'package:piapiri_v2/core/model/order_action_type_enum.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/model/ticker_overview.dart';
import 'package:piapiri_v2/core/model/us_symbol_snapshot.dart';
import 'package:piapiri_v2/core/model/user_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';

@RoutePage()
class SymbolUsDetailPage extends StatefulWidget {
  final String symbolName;
  final bool ignoreUnsubscribeSymbols;
  const SymbolUsDetailPage({
    super.key,
    required this.symbolName,
    this.ignoreUnsubscribeSymbols = false,
  });

  @override
  State<SymbolUsDetailPage> createState() => _SymbolUsDetailPageState();
}

class _SymbolUsDetailPageState extends State<SymbolUsDetailPage> {
  final UsEquityBloc _usEquityBloc = getIt<UsEquityBloc>();
  final GlobalAccountOnboardingBloc _globalOnboardingBloc = getIt<GlobalAccountOnboardingBloc>();
  final CreateUsOrdersBloc _createUsOrdersBloc = getIt<CreateUsOrdersBloc>();
  final AuthBloc _authBloc = getIt<AuthBloc>();
  final ReportsBloc _reportsBloc = getIt<ReportsBloc>();
  late UserModel _userModel;
  TickerOverview? _tickerOverview;
  UsSymbolSnapshot? _usSymbolSnapshot;
  @override
  initState() {
    _userModel = UserModel.instance;

    if (Utils().canTradeAmericanMarket() && _userModel.alpacaAccountStatus) {
      _createUsOrdersBloc.add(
        GetTradeLimitEvent(),
      );
    }

    _usEquityBloc.add(
      SubscribeSymbolEvent(
          symbolName: [widget.symbolName],
          callback: (symbols, _) {
            setState(() {
              _usSymbolSnapshot = symbols.first;
            });
          }),
    );

    _usEquityBloc.add(
      GetTickerOverviewEvent(
        symbolName: widget.symbolName,
        callback: (TickerOverview? tickerOverview) {
          setState(() {
            _tickerOverview = tickerOverview;
          });
        },
      ),
    );

    _usEquityBloc.add(
      GetDividendWeeklyEvent(
        symbols: [
          widget.symbolName,
        ],
      ),
    );

    _usEquityBloc.add(
      GetDividendYearlyEvent(
        symbols: [
          widget.symbolName,
        ],
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
    if (!widget.ignoreUnsubscribeSymbols) {
      _usEquityBloc.add(
        UnsubscribeSymbolEvent(symbolName: [widget.symbolName]),
      );
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isActiveVideoTab =
        _reportsBloc.state.usVideoReportList.any((group) => group.symbols.any((symbol) => symbol == widget.symbolName));
    return Scaffold(
      appBar: PInnerAppBar(
        title: L10n.tr(widget.symbolName),
        actions: [
          Row(
            children: [
              /// Sembolu favorilere eklemek icin
              AddFavoriteIcon(
                symbolCode: widget.symbolName,
                symbolType: SymbolTypes.foreign,
              ),
              const SizedBox(width: Grid.s),
              InkWrapper(
                child: SvgPicture.asset(
                  ImagesPath.arrows_across,
                  height: 24,
                  width: 24,
                  colorFilter: ColorFilter.mode(
                    context.pColorScheme.iconPrimary,
                    BlendMode.srcIn,
                  ),
                ),
                onTap: () {
                  router.push(
                    CompareRoute(
                      symbolName: widget.symbolName,
                      underLyingName: '',
                      description: _tickerOverview?.description ?? '',
                      symbolType: SymbolTypes.foreign,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),

      body: _tickerOverview == null || _usSymbolSnapshot == null
          ? const Center(
              child: PLoading(),
            )
          : PMainTabController(
              key: UniqueKey(),
              showTabbar: isActiveVideoTab,
              tabs: [
                PTabItem(
                  title: L10n.tr('summary'),
                  page: SymbolUsSummary(
                    tickerOverview: _tickerOverview!,
                    usSymbolSnapshot: _usSymbolSnapshot!,
                  ),
                ),
                if (isActiveVideoTab)
                  PTabItem(
                    title: L10n.tr('video'),
                    page: MarketsVideoPage(
                      marketType: MarketTypeEnum.marketUs,
                      subSymbol: widget.symbolName,
                    ),
                  ),
              ],
            ),
      //1-) Sembol remote configte yoksa
      //2-) Sembol tradable ise
      //3-) Kullanıcı dijitalse ve kurumsal hesap değilse

      bottomNavigationBar: !Utils().canTradeAmericanMarket() ||
              _tickerOverview == null ||
              _usSymbolSnapshot == null ||
              !_authBloc.state.isLoggedIn
          ? null
          : BuySellButtons(
              onTapBuy: () => _checkCapraAccount(OrderActionTypeEnum.buy),
              onTapSell: () => _checkCapraAccount(OrderActionTypeEnum.sell),
            ),
    );
  }

  _checkCapraAccount(OrderActionTypeEnum action) {
    AlpacaAccountStatusEnum? alpacaAccountStatus;
    _globalOnboardingBloc.add(
      AccountSettingStatusEvent(
        succesCallback: (accountSettingStatus) {
          setState(() {
            alpacaAccountStatus = AlpacaAccountStatusEnum.values.firstWhereOrNull(
              (e) => e.value == accountSettingStatus.accountStatus,
            );
          });
          if (alpacaAccountStatus != AlpacaAccountStatusEnum.active) {
            PBottomSheet.showError(
              context,
              content: alpacaAccountStatus == null
                  ? L10n.tr('alpaca_account_not_active')
                  : L10n.tr('portfolio.${alpacaAccountStatus!.descriptionKey}'),
              showFilledButton: true,
              showOutlinedButton: true,
              filledButtonText: alpacaAccountStatus == null ? L10n.tr('get_started') : L10n.tr('go_agreements'),
              outlinedButtonText: L10n.tr('afterwards'),
              onOutlinedButtonPressed: () => router.maybePop(),
              onFilledButtonPressed: () async {
                Navigator.of(context).pop();
                router.push(
                  const GlobalAccountOnboardingRoute(),
                );
              },
            );
          } else {
            _routeCreateOrder(action);
          }
        },
      ),
    );
  }

  _routeCreateOrder(OrderActionTypeEnum action) {
    router.push(
      CreateUsOrderRoute(
        symbol: widget.symbolName,
        action: action,
      ),
    );
  }
}
