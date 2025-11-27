import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/keep_alive_wrapper.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';
import 'package:piapiri_v2/common/widgets/tab_controller/model/tab_bar_item.dart';
import 'package:piapiri_v2/common/widgets/tab_controller/tab_controllers/p_main_tab_controller.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/advices/enum/market_type_enum.dart';
import 'package:piapiri_v2/app/alarm/bloc/alarm_bloc.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/app/favorite_lists/widgets/add_favorite_icon.dart';
import 'package:piapiri_v2/app/license/bloc/license_bloc.dart';
import 'package:piapiri_v2/app/license/bloc/license_event.dart';
import 'package:piapiri_v2/app/market_reviews/bloc/reports_bloc.dart';
import 'package:piapiri_v2/app/markets/pages/markets_video_page.dart';
import 'package:piapiri_v2/app/symbol_detail/pages/symbol_data_page.dart';
import 'package:piapiri_v2/app/symbol_detail/pages/symbol_financial_page.dart';
import 'package:piapiri_v2/app/symbol_detail/pages/symbol_summary_page.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/buy_sell_buttons.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/ink_wrapper.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_bloc.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_event.dart';
import 'package:piapiri_v2/core/config/analytics/analytics.dart';
import 'package:piapiri_v2/core/config/analytics/analytics_events.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/insider_event_enum.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/order_action_type_enum.dart';
import 'package:piapiri_v2/core/model/symbol_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class SymbolDetailPage extends StatefulWidget {
  final MarketListModel symbol;
  final bool ignoreDispose;
  const SymbolDetailPage({
    super.key,
    required this.symbol,
    this.ignoreDispose = false,
  });

  @override
  State<SymbolDetailPage> createState() => _SymbolDetailPageState();
}

class _SymbolDetailPageState extends State<SymbolDetailPage> {
  final SymbolBloc _symbolBloc = getIt<SymbolBloc>();
  final AuthBloc _authBloc = getIt<AuthBloc>();
  final LicenseBloc _licenseBloc = getIt<LicenseBloc>();
  final AlarmBloc _alarmBloc = getIt<AlarmBloc>();
  final ReportsBloc _reportsBloc = getIt<ReportsBloc>();
  final ValueNotifier<MarketListModel?> symbolNotifier = ValueNotifier(null);
  final ValueNotifier<bool> showBuySellNotifier = ValueNotifier(false);

  SymbolTypes? symbolType;

  List<MarketListModel> symbolsToSubscribe = [];

  List<Widget> _cachedPages = [];


  @override
  initState() {
    _symbolBloc.add(
      GetSymbolDetailEvent(
        symbolName: widget.symbol.symbolCode,
        callback: (symbolModel) {
          symbolNotifier.value = symbolModel;
          if (symbolNotifier.value == null) return;
          symbolType = stringToSymbolType(symbolModel.type);
          symbolsToSubscribe = [symbolModel];
          if (symbolType == SymbolTypes.future ||
              symbolType == SymbolTypes.option ||
              symbolType == SymbolTypes.warrant) {
            symbolsToSubscribe.add(
              MarketListModel(
                symbolCode: symbolModel.underlying,
                updateDate: '',
              ),
            );
          }
          _cachedPages = _buildPages(symbolModel);

          _symbolBloc.add(
            SymbolSubTopicsEvent(
              symbols: symbolsToSubscribe,
            ),
          );

          _symbolBloc.add(
            GetBuySellButtonsEnabledEvent(
              symbolName: symbolModel.symbolCode,
              symbolType: symbolModel.symbolType,
              callback: (showBuySellButtons) {
                showBuySellNotifier.value = showBuySellButtons;
              },
            ),
          );
        },
      ),
    );

    if (_licenseBloc.state.licenseList.isEmpty) {
      _licenseBloc.add(
        GetLicensesEvent(),
      );
    }

    getIt<Analytics>().track(
      AnalyticsEvents.productDetailPageView,
      taxonomy: [
        InsiderEventEnum.controlPanel.value,
        InsiderEventEnum.marketsPage.value,
        InsiderEventEnum.istanbulStockExchangeTab.value,
        InsiderEventEnum.equityTab.value,
      ],
      properties: {
        'product_id': widget.symbol.symbolCode,
        'name': widget.symbol.symbolCode,
        'image_url': '',
        'price': widget.symbol.bid,
        'currency': 'TRY',
      },
    );

    super.initState();
  }

  @override
  dispose() {
    if (!widget.ignoreDispose) {
      _symbolBloc.add(
        SymbolUnsubsubscribeEvent(
          symbolList: symbolsToSubscribe,
        ),
      );
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<MarketListModel?>(
        valueListenable: symbolNotifier,
        builder: (context, symbol, _) {
          if (symbol == null) {
            return Scaffold(
              appBar: PInnerAppBar(
                title: L10n.tr(
                  widget.symbol.symbolCode,
                ),
              ),
              body: const PLoading(
                isFullScreen: true,
              ),
            );
          }

          return Scaffold(
            appBar: PInnerAppBar(
              title: L10n.tr(widget.symbol.symbolCode),
              actions: !_authBloc.state.isLoggedIn
                  ? null
                  : [
                      Row(
                        children: [
                          /// Sembolu favorilere eklemek icin
                          AddFavoriteIcon(
                            symbolCode: symbol.symbolCode,
                            symbolType: symbolType!,
                          ),
                          const SizedBox(width: Grid.s),

                          /// Sembol alarmi olusturmak icin
                          InkWrapper(
                            child: SvgPicture.asset(
                              ImagesPath.alarm,
                              height: 24,
                              width: 24,
                              colorFilter: ColorFilter.mode(
                                context.pColorScheme.iconPrimary,
                                BlendMode.srcIn,
                              ),
                            ),
                            onTap: () {
                              if (_alarmBloc.state.priceAlarms.length + _alarmBloc.state.newsAlarms.length >= 90) {
                                PBottomSheet.showError(
                                  context,
                                  content: L10n.tr('max_alarm_limit_reached'),
                                );
                                return;
                              }

                              router.push(
                                CreatePriceNewsAlarmRoute(
                                  symbol: SymbolModel.fromMarketListModel(symbol),
                                ),
                              );
                            },
                          ),

                          if ([
                            SymbolTypes.equity,
                            SymbolTypes.warrant,
                            SymbolTypes.indexType,
                          ].contains(symbolType)) ...[
                            const SizedBox(
                              width: Grid.s,
                            ),
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
                                    symbolName: symbol.symbolCode,
                                    underLyingName: symbol.underlying,
                                    description: symbol.description,
                                    symbolType: symbolType!,
                                    marketListModel: symbol,
                                  ),
                                );
                              },
                            ),
                          ]
                        ],
                      ),
                    ],
            ),
            body: (symbolType == SymbolTypes.parity || symbolType == SymbolTypes.crypto)
                ? SymbolSummary(
                    symbol: symbol,
                    type: symbolType!,
                  )
                : PMainTabController(
                    key: ValueKey("SymbolDetail_${symbol.symbolCode}"),
                    tabs: _buildTabsFromCache(),
                  ),
            bottomNavigationBar: ValueListenableBuilder<bool>(
                valueListenable: showBuySellNotifier,
                builder: (context, showBuySellButtons, _) {
                  if (!showBuySellButtons) return const SizedBox.shrink();
                  return BuySellButtons(
                    onTapBuy: () {
                      symbolType == SymbolTypes.future || symbolType == SymbolTypes.option
                          ? router.push(
                              CreateOptionOrderRoute(
                                symbol: symbol,
                                action: OrderActionTypeEnum.buy,
                              ),
                            )
                          : router.push(
                              CreateOrderRoute(
                                symbol: symbol,
                                action: OrderActionTypeEnum.buy,
                              ),
                            );
                    },
                    onTapSell: () {
                      symbolType == SymbolTypes.future || symbolType == SymbolTypes.option
                          ? router.push(
                              CreateOptionOrderRoute(
                                symbol: symbol,
                                action: OrderActionTypeEnum.sell,
                              ),
                            )
                          : router.push(
                              CreateOrderRoute(
                                symbol: symbol,
                                action: OrderActionTypeEnum.sell,
                              ),
                            );
                    },
                  )
                    ;
                }),
          );
        });
  }

  List<PTabItem> _buildTabsFromCache() {
    final titles = <String>[
      L10n.tr('summary'),
      L10n.tr('data'),
      L10n.tr('financial'),
      L10n.tr('video'),
    ];

    return [
      for (int i = 0; i < _cachedPages.length; i++)
        PTabItem(
          title: titles[i],
          page: _cachedPages[i], // 🔥 initState tekrar çalışmaz, hep aynı instance
        )
    ];
  }

  List<Widget> _buildPages(MarketListModel symbol) {
    final list = <Widget>[
      KeepAliveWrapper(
        child: SymbolSummary(symbol: symbol, type: symbolType!),
      ),
    ];

    if ([SymbolTypes.equity, SymbolTypes.warrant, SymbolTypes.future, SymbolTypes.option].contains(symbolType)) {
      list.add(
        KeepAliveWrapper(
          child: SymbolData(symbol: symbol),
        ),
      );
    }

    if (symbolType == SymbolTypes.equity) {
      list.add(
        KeepAliveWrapper(
          child: SymbolFinancialPage(marketListModel: symbol),
        ),
      );
    }

    if (symbolType == SymbolTypes.equity &&
        _reportsBloc.state.bistVideoReportList.any((group) => group.symbols.contains(symbol.symbolCode))) {
      list.add(
        KeepAliveWrapper(
          child: MarketsVideoPage(
            marketType: MarketTypeEnum.marketBist,
            subSymbol: symbol.symbolCode,
          ),
        ),
      );
    }

    return list;
  }
}
