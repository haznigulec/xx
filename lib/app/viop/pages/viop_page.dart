import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/app/data_grid/pages/bist_symbol_listing.dart';
import 'package:piapiri_v2/app/markets/model/market_menu.dart';
import 'package:piapiri_v2/app/search_symbol/symbol_search_utils.dart';
import 'package:piapiri_v2/app/viop/bloc/viop_bloc.dart';
import 'package:piapiri_v2/app/viop/bloc/viop_event.dart';
import 'package:piapiri_v2/app/viop/bloc/viop_state.dart';
import 'package:piapiri_v2/app/viop/widgets/viop_filter.dart';
import 'package:piapiri_v2/app/viop/widgets/viop_list_tile.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/delayed_info_widget.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/analytics/analytics.dart';
import 'package:piapiri_v2/core/config/analytics/analytics_events.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/insider_event_enum.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';

@RoutePage()
class ViopPage extends StatefulWidget {
  final bool showSymbolIcon;
  final String? underlyingName;
  final String? subMarketCode;
  final List<String> ignoreUnsubList;
  final bool awaitDisposeTime;

  const ViopPage({
    super.key,
    this.showSymbolIcon = true,
    this.underlyingName,
    this.subMarketCode,
    this.ignoreUnsubList = const [],
    this.awaitDisposeTime = false,
  });

  @override
  State<ViopPage> createState() => _ViopPageState();
}

class _ViopPageState extends State<ViopPage> {
  final ViopBloc _viopBloc = getIt<ViopBloc>();
  final AuthBloc _authBloc = getIt<AuthBloc>();
  late final bool _hasSubMarketCode;
  late final String _listUniqKey;
  //state üzerindeki isloding yeterli olmadığı için eklendi
  final ValueNotifier<bool> initialized = ValueNotifier(false);

  @override
  void initState() {
    _hasSubMarketCode = widget.subMarketCode?.isNotEmpty == true;
    Utils.setListPageEvent(pageName: 'ViopPage');
    getIt<Analytics>().track(
      AnalyticsEvents.listingPageView,
      taxonomy: [
        InsiderEventEnum.controlPanel.value,
        InsiderEventEnum.marketsPage.value,
        InsiderEventEnum.istanbulStockExchangeTab.value,
        InsiderEventEnum.viopTab.value,
      ],
    );
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.awaitDisposeTime) {
        // viop page dispose süresi için gerekli.
        await Future.delayed(const Duration(milliseconds: 100));
      }
      _viopBloc.add(
        ViopInitEvent(
          underlyingName: widget.underlyingName,
          subMarketCode: widget.subMarketCode,
          callback: (symbols) {
            initialized.value = true;
          },
        ),
      );
    });
    _listUniqKey = DateTime.now().microsecondsSinceEpoch.toString();
    super.initState();
  }

  @override
  dispose() {
    _viopBloc.add(
      OnDisposeEvent(),
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PInnerAppBar(
        title: L10n.tr(widget.subMarketCode ?? 'viop.all'),
        actions: [
          if (!_hasSubMarketCode)
            PIconButton(
              type: PIconButtonType.outlined,
              svgPath: ImagesPath.search,
              sizeType: PIconButtonSize.xl,
              onPressed: () => SymbolSearchUtils.goSymbolDetail(),
            ),
        ],
      ),
      body: PBlocBuilder<ViopBloc, ViopState>(
        bloc: _viopBloc,
        buildWhen: (p, c) {
          if (!identical(p.symbolList, c.symbolList)) {
            return true;
          }
          return false;
        },
        builder: (context, state) {
          return ValueListenableBuilder<bool>(
              valueListenable: initialized,
              builder: (context, initialized, _) {
                if (!initialized || state.isLoading) return const PLoading();
                return SafeArea(
                  top: false,
                  left: false,
                  right: false,
                  bottom: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!_authBloc.state.isLoggedIn)
                        DelayedInfoWidget(
                          delayedSymbols: [
                            SymbolTypes.future.matriks,
                            SymbolTypes.option.matriks,
                          ],
                          activeIndex: 2,
                          marketMenu: MarketMenu.istanbulStockExchange,
                          marketIndex: 2,
                        ),
                      const SizedBox(
                        height: Grid.m,
                      ),
                      ViopFilter(
                        subMarketCode: widget.subMarketCode,
                      ),
                      const SizedBox(height: Grid.m),
                      SlidableAutoCloseBehavior(
                        child: Expanded(
                          child: BistSymbolListing(
                            key: ValueKey(
                              'Viop${_listUniqKey}_${state.symbolList.map((e) => e.symbolCode).join('_')}',
                            ),
                            symbols: state.symbolList,
                            underlyingName: widget.subMarketCode == null ? state.selectedUnderlying : null,
                            ignoreUnsubList: widget.ignoreUnsubList,
                            columns: [
                              L10n.tr('viop'),
                              L10n.tr('last_change_maturity'),
                            ],
                            outPadding: const EdgeInsets.symmetric(
                              horizontal: Grid.m,
                            ),
                            itemBuilder: (symbol, controller) => ViopListTile(
                              key: ValueKey(
                                'Viop${_listUniqKey}_${symbol.marketCode}',
                              ),
                              margin: const EdgeInsets.symmetric(
                                horizontal: Grid.m,
                              ),
                              controller: controller,
                              symbol: symbol,
                              showSymbolIcon: widget.showSymbolIcon,
                              onTap: () {
                                router.push(
                                  SymbolDetailRoute(
                                    symbol: symbol,
                                    ignoreDispose: true,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
          );
        },
      ),
    );
  }
}
