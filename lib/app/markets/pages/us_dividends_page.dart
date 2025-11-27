import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:piapiri_v2/app/us_equity/us_market_utils.dart';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/progress_indicators/shimmerize.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/favorite_lists/widgets/favorite_grid_box.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_bloc.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_event.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_state.dart';
import 'package:piapiri_v2/app/us_equity/widgets/list_title_widget.dart';
import 'package:piapiri_v2/app/us_equity/widgets/loser_gainer_tile.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/model/us_symbol_snapshot.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';

@RoutePage()
class UsDividendPage extends StatefulWidget {
  final List<String> symbolList;
  const UsDividendPage({
    required this.symbolList,
    super.key,
  });

  @override
  State<UsDividendPage> createState() => _UsDividendPageState();
}

class _UsDividendPageState extends State<UsDividendPage> {
  late final UsEquityBloc _usEquityBloc;

  Timer? _scrollTimer;
  final ScrollController _scrollController = ScrollController();

  List<GlobalObjectKey> _keys = [];
  List<UsSymbolSnapshot> _symbolList = [];
  List<UsSymbolSnapshot> _watchingItems = [];
  List<String> _ignoreUnsubcription = [];
  bool _showHeatMap = false;

  void _onScroll() {
    _scrollTimer?.cancel();
    _scrollTimer = Timer(const Duration(milliseconds: 100), _updateSubscriptions);
  }

  void _updateSubscriptions() {
    if (!mounted) return;

    final RenderBox? listViewBox = context.findRenderObject() as RenderBox?;
    if (listViewBox == null) return;

    final double listViewTop = listViewBox.localToGlobal(Offset.zero).dy;
    final double listViewBottom = listViewTop + listViewBox.size.height;

    Set<String> currentlyVisibleSymbols = {};

    for (UsSymbolSnapshot item in _symbolList) {
      final key = _keys[_symbolList.indexOf(item)];
      final RenderObject? renderObject = key.currentContext?.findRenderObject();

      if (renderObject is RenderBox) {
        final Offset offset = renderObject.localToGlobal(Offset.zero);
        final double itemTop = offset.dy;
        final double itemBottom = itemTop + renderObject.size.height;

        if (itemBottom > listViewTop && itemTop < listViewBottom) {
          currentlyVisibleSymbols.add(item.ticker);
        }
      }
    }

    List<String> subscribeList =
        currentlyVisibleSymbols.difference(_watchingItems.map((e) => e.ticker).toSet()).toList();
    List<String> unsubscribeList =
        _watchingItems.map((e) => e.ticker).toSet().difference(currentlyVisibleSymbols).toList();
    _susbcribeList(subscribeList, unsubscribeList);
    _watchingItems = _symbolList.where((element) => currentlyVisibleSymbols.contains(element.ticker)).toList();
  }

  void _susbcribeList(List<String> susbcribe, List<String> unSubscribe) {
    if (unSubscribe.isNotEmpty) {
      _usEquityBloc.add(
        UnsubscribeSymbolEvent(
          symbolName: unSubscribe
              .where(
                (e) => !_ignoreUnsubcription.contains(e),
              )
              .toList(),
        ),
      );
    }

    if (susbcribe.isNotEmpty) {
      // Bazi sembollerin detay bilgisi zaman zaman polygondan saglananmiyor.
      // Callback de bunun kontrolu yapilarak, eksik semboller listeden kaldirilir.
      // Ekranda yeni gozuken sembollerin tespiti icin tekrar _updateSubscriptions cagrilir.
      _usEquityBloc.add(
        SubscribeSymbolEvent(
          symbolName: susbcribe.map((e) => e).toList(),
          callback: (symbols, _) {
            if (symbols.length != susbcribe.length) {
              List<String> missingSymbols = susbcribe.where((e) => !symbols.any((s) => s.ticker == e)).toList();
              _symbolList.removeWhere((e) => missingSymbols.contains(e.ticker));
              _keys.removeWhere((key) => missingSymbols.contains(key.value));
              _watchingItems.removeWhere((e) => missingSymbols.contains(e.ticker));
              _updateSubscriptions();
            }
          },
        ),
      );
    }
  }

  void _initialize() {
    _symbolList = widget.symbolList
        .map(
          (symbol) => UsSymbolSnapshot(
            ticker: symbol,
          ),
        )
        .toList();
    _keys = _symbolList
        .map(
          (e) => GlobalObjectKey(
            'us_div_${e.ticker}',
          ),
        )
        .toList();
    _scrollController.addListener(_onScroll);
    int watchItemsLength = 20;
    _watchingItems = _symbolList.length < watchItemsLength ? _symbolList : _symbolList.sublist(0, watchItemsLength);
    _susbcribeList(_watchingItems.map((e) => e.ticker).toList(), []);
  }

  @override
  void initState() {
    _usEquityBloc = getIt<UsEquityBloc>();
    _ignoreUnsubcription = [
      ..._usEquityBloc.state.favoriteIncomingDividends,
      ..._usEquityBloc.state.losers.take(5).map((e) => e.symbol!),
      ..._usEquityBloc.state.gainers.take(5).map((e) => e.symbol!),
    ];
    _initialize();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _usEquityBloc.add(
      UnsubscribeSymbolEvent(
        symbolName: _watchingItems.map((e) => e.ticker).where((e) => !_ignoreUnsubcription.contains(e)).toList(),
      ),
    );

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PInnerAppBar(
        title: L10n.tr('symbol_will_be_dist_divident'),
      ),
      body: PBlocBuilder<UsEquityBloc, UsEquityState>(
        bloc: _usEquityBloc,
        builder: (context, state) {
          if (state.allIncomingDividendsState == PageState.loading) {
            return Container(
              color: context.pColorScheme.transparent,
              alignment: Alignment.center,
              child: const PLoading(),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Grid.m,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: SvgPicture.asset(
                    _showHeatMap ? ImagesPath.drag : ImagesPath.table,
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                      context.pColorScheme.iconPrimary,
                      BlendMode.srcIn,
                    ),
                  ),
                  onTap: () {
                    setState(() => _showHeatMap = !_showHeatMap);
                    _scrollController.jumpTo(0);
                  },
                ),
                SizedBox(
                  height: _showHeatMap ? Grid.m : Grid.s,
                ),
                ListTitleWidget(
                  leadingTitle: 'usEquityStats.symbol',
                  trailingTitle: 'usEquityStats.priceAndChange',
                  hasTopDivider: true,
                  openSorting: () {},
                ),
                Expanded(
                  child: _showHeatMap
                      ? GridView.builder(
                          controller: _scrollController,
                          itemCount: _symbolList.length,
                          shrinkWrap: true,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisSpacing: 3,
                            crossAxisSpacing: 3,
                            crossAxisCount: 3,
                          ),
                          itemBuilder: (context, index) {
                            bool shimmerize = true;
                            UsSymbolSnapshot? usSymbol = state.polygonWatchingItems.firstWhereOrNull(
                              (e) => e.ticker == _symbolList[index].ticker,
                            );
                            if (usSymbol != null) {
                              shimmerize = false;
                            } else {
                              usSymbol = _symbolList[index];
                            }

                            return Shimmerize(
                              enabled: shimmerize,
                              child: FavoriteGridBox(
                                key: _keys[index],
                                symbolName: usSymbol.ticker,
                                symbolIconName: usSymbol.ticker,
                                symbolTypes: SymbolTypes.foreign,
                                price: '${CurrencyEnum.dollar.symbol}${MoneyUtils().readableMoney(usSymbol.fmv ?? 0)}',
                                diffPercentage: UsMarketUtils().getDiffPercent(usSymbol),
                                updateDate: usSymbol.session?.timestamp == null
                                    ? '-'
                                    : DateTimeUtils.timeFormat(
                                        DateTimeUtils.dateFromTimestamp(usSymbol.session!.timestamp,
                                            isNanoTimestamp: true)!,
                                        showSeconds: true,
                                      ),
                                onTapGrid: (symbol) => router.push(
                                  SymbolUsDetailRoute(
                                    symbolName: symbol.ticker,
                                    ignoreUnsubscribeSymbols: true,
                                  ),
                                ),
                              ),
                            );
                          })
                      : ListView.separated(
                          padding: const EdgeInsets.only(
                            bottom: Grid.l,
                          ),
                          shrinkWrap: true,
                          controller: _scrollController,
                          itemCount: _symbolList.length,
                          separatorBuilder: (context, index) => const PDivider(),
                          itemBuilder: (context, index) {
                            bool shimmerize = true;
                            UsSymbolSnapshot? usSymbol = state.polygonWatchingItems.firstWhereOrNull(
                              (e) => e.ticker == _symbolList[index].ticker,
                            );
                            if (usSymbol != null) {
                              shimmerize = false;
                            } else {
                              usSymbol = _symbolList[index];
                            }

                            return LoserGainerTile(
                              key: _keys[index],
                              shimmerize: shimmerize,
                              snapshot: usSymbol,
                              isDividend: true,
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
