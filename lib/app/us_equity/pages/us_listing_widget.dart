import 'package:collection/collection.dart';
import 'package:piapiri_v2/app/us_equity/us_market_utils.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/bottomsheet_select_tile.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:piapiri_v2/app/favorite_lists/widgets/favorite_grid_box.dart';
import 'package:piapiri_v2/app/fund/widgets/shimmer_fund_list.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_bloc.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_event.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_state.dart';
import 'package:piapiri_v2/app/us_equity/widgets/list_title_widget.dart';
import 'package:piapiri_v2/app/us_equity/widgets/loser_gainer_tile.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/progress_indicators/shimmerize.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_consumer.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/market_movers_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/model/us_market_movers_enum.dart';
import 'package:piapiri_v2/core/model/us_market_status_enum.dart';
import 'package:piapiri_v2/core/model/us_symbol_snapshot.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

class USListingWidget extends StatefulWidget {
  final UsMarketMovers? usMarketMovers;
  final List<String>? symbolNames;
  final int? limit;
  final bool hasTopDivider;
  final String? heatMapSortKey;
  final List<String> ignoreUnsubscribeSymbols;

  const USListingWidget({
    super.key,
    this.usMarketMovers,
    this.symbolNames,
    this.limit,
    this.hasTopDivider = true,
    this.heatMapSortKey,
    this.ignoreUnsubscribeSymbols = const [],
  });

  @override
  State<USListingWidget> createState() => _USListingWidgetState();
}

class _USListingWidgetState extends State<USListingWidget> {
  final UsEquityBloc _usEquityBloc = getIt<UsEquityBloc>();
  List<UsSymbolSnapshot> _sortedList = [];
  List<MarketMoversModel> _symbols = [];
  bool _isLoading = true;
  bool _showHeatMap = false;
  late String _sortKey;
  final List<String> _heatMapProfitFilter = [
    'a_to_z',
    'z_to_a',
    'difference_up',
    'difference_down',
    'last_price_up',
    'last_price_down',
  ];


  final ScrollController _scrollController = ScrollController();
  @override
  initState() {
    _sortKey = widget.usMarketMovers == UsMarketMovers.gainers ? 'difference_down' : 'difference_up';
    _symbols =
        (widget.usMarketMovers == UsMarketMovers.gainers ? _usEquityBloc.state.gainers : _usEquityBloc.state.losers)
            .toList();
    if (widget.limit != null) {
      _symbols = _symbols.take(widget.limit!).toList();
    }
    _usEquityBloc.add(
      SubscribeSymbolEvent(
        symbolName: widget.usMarketMovers != null ? _symbols.map((e) => e.symbol!).toList() : widget.symbolNames ?? [],
        callback: (symbols, _) {
          _sortedList = symbols;
          _sortList();
          for (var i = 0; i < _sortedList.length; i++) {
            UsSymbolSnapshot snapshot = _sortedList[i];
            if (snapshot.session?.regularTradingChangePercent == null ||
                snapshot.session?.regularTradingChangePercent == 0) {
              MarketMoversModel? marketMover = _symbols.firstWhereOrNull(
                (element) => element.symbol == snapshot.ticker,
              );
              if (marketMover != null) {
                _sortedList[i] = _sortedList[i].copyWith(
                  session: snapshot.session?.copyWith(
                    regularTradingChangePercent: marketMover.changePercent ?? 0.0,
                    regularTradingChange: marketMover.change ?? 0.0,
                  ),
                );
              }
            }
          }
          _isLoading = false;
          setState(() {});
        },
      ),
    );
    super.initState();
  }

  @override
  dispose() {
    _usEquityBloc.add(
      UnsubscribeSymbolEvent(
        symbolName: _sortedList
            .where((element) => !widget.ignoreUnsubscribeSymbols.contains(element.ticker))
            .map((e) => e.ticker)
            .toList(),
      ),
    );

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocConsumer<UsEquityBloc, UsEquityState>(
      bloc: _usEquityBloc,
      listener: (context, state) {
        List<UsSymbolSnapshot> snapshotList = [];
        for (String element in _sortedList.map((e) => e.ticker)) {
          UsSymbolSnapshot? snapshot = state.polygonWatchingItems.firstWhereOrNull(
            (item) => item.ticker == element,
          );
          if (snapshot == null) continue;
          snapshotList.add(snapshot);
        }

        _sortList();
        setState(() {
          _sortedList = snapshotList;
        });
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                if (_showHeatMap) ...[
                  const SizedBox(
                    width: Grid.s,
                  ),
                  PCustomOutlinedButtonWithIcon(
                    text: '${L10n.tr('sorting')} : ${L10n.tr(_sortKey)}',
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    iconSource: ImagesPath.chevron_down,
                    foregroundColorApllyBorder: false,
                    foregroundColor: context.pColorScheme.primary,
                    backgroundColor: context.pColorScheme.secondary,
                    onPressed: () => _openSorting(),
                  ),
                  const SizedBox(
                    width: Grid.s,
                  ),
                ],
                Spacer(),
            if (widget.limit == null)
                  Padding(
                    padding: const EdgeInsets.only(right: Grid.m),
                    child: InkWell(
                      child: SvgPicture.asset(
                        _showHeatMap ? ImagesPath.drag : ImagesPath.table,
                        width: 24,
                        height: 24,
                        colorFilter: ColorFilter.mode(
                          context.pColorScheme.iconPrimary,
                          BlendMode.srcIn,
                        ),
                      ),
                      onTap: () => setState(() => _showHeatMap = !_showHeatMap),
                    ),
                  ),
              ],
            ),
            SizedBox(
              height: _showHeatMap ? Grid.m : Grid.s,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Grid.m,
              ),
              child: _showHeatMap
                  ? GridView.builder(
                      controller: _scrollController,
                      itemCount: _sortedList.length,
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 3,
                        crossAxisSpacing: 3,
                        crossAxisCount: 3,
                      ),
                      itemBuilder: (context, index) {
                        final symbol = _sortedList[index];
                        return FavoriteGridBox(
                          key: ValueKey('USMOVERS_${symbol.ticker}'),
                          symbolName: symbol.ticker,
                          symbolIconName: symbol.ticker,
                          symbolTypes: SymbolTypes.foreign,
                          price: '${CurrencyEnum.dollar.symbol}${MoneyUtils().readableMoney(symbol.fmv ?? 0)}',
                          diffPercentage: UsMarketUtils().getDiffPercent(symbol),
                          updateDate: symbol.session?.timestamp == null
                              ? '-'
                              : DateTimeUtils.timeFormat(
                                  DateTimeUtils.dateFromTimestamp(symbol.session!.timestamp, isNanoTimestamp: true)!,
                                  showSeconds: true,
                                ),
                          onTapGrid: (symbol) => router.push(
                            SymbolUsDetailRoute(
                              symbolName: symbol.ticker,
                              ignoreUnsubscribeSymbols: true,
                            ),
                          ),
                        );
                      })
                  : Column(
                      children: [
                        ListTitleWidget(
                          leadingTitle: 'usEquityStats.symbol',
                          trailingTitle: 'usEquityStats.priceAndChange',
                          hasTopDivider: widget.hasTopDivider,
                          openSorting: _openSorting,
                        ),
                        _sortedList.isEmpty || _isLoading
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: Grid.s,
                                ),
                                child: Shimmerize(
                                  enabled: true,
                                  child: ShimmerFundList(
                                    itemCount: widget.limit ?? 12, // Adjust the number of items as needed
                                  ),
                                ),
                              )
                            : ListView.separated(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                separatorBuilder: (context, index) => const PDivider(),
                                itemCount: _sortedList.length,
                                itemBuilder: (context, index) {
                                  final symbol = _sortedList[index];
                                  return LoserGainerTile(
                                    key: ValueKey('USMOVERS_${symbol.ticker}'),
                                    snapshot: symbol,
                                  );
                                },
                              ),
                      ],
                    ),
            ),
          ],
        );
      },
    );
  }

  _sortList() {

    switch (_sortKey) {
      case 'a_to_z':
        _sortedList.sort(
          (a, b) => (a.ticker).compareTo(b.ticker),
        );

        break;
      case 'z_to_a':
        _sortedList.sort(
          (b, a) => (a.ticker).compareTo(b.ticker),
        );

        break;
      case 'last_price_up':
        _sortedList.sort(
          (a, b) => (a.fmv ?? 0).compareTo(b.fmv ?? 0),
        );

        break;
      case 'last_price_down':
        _sortedList.sort(
          (b, a) => (a.fmv ?? 0).compareTo(b.fmv ?? 0),
        );

        break;
      case 'difference_up':
        // PreMarket Sorting
        if (_sortedList.any((e) => e.marketStatus == UsMarketStatus.preMarket)) {
          _sortedList.sort(
            (a, b) => (a.session?.earlyTradingChangePercent ?? 0).compareTo(b.session?.earlyTradingChangePercent ?? 0),
          );
          return;
        }
        // Late Market Sorting
        if (_sortedList.any((e) => e.marketStatus == UsMarketStatus.afterMarket)) {
          _sortedList.sort(
            (a, b) => (a.session?.lateTradingChangePercent ?? 0).compareTo(b.session?.lateTradingChangePercent ?? 0),
          );
          return;
        }
        // Regular Market Sorting
        _sortedList.sort(
          (a, b) =>
              (a.session?.regularTradingChangePercent ?? 0).compareTo(b.session?.regularTradingChangePercent ?? 0),
        );
        break;

      case 'difference_down':
        // PreMarket Sorting
        if (_sortedList.any((e) => e.marketStatus == UsMarketStatus.preMarket)) {
          _sortedList.sort(
            (b, a) => (a.session?.earlyTradingChangePercent ?? 0).compareTo(b.session?.earlyTradingChangePercent ?? 0),
          );
          return;
        }
        // Late Market Sorting
        if (_sortedList.any((e) => e.marketStatus == UsMarketStatus.afterMarket)) {
          _sortedList.sort(
            (b, a) => (a.session?.lateTradingChangePercent ?? 0).compareTo(b.session?.lateTradingChangePercent ?? 0),
          );
          return;
        }
        // Regular Market Sorting
        _sortedList.sort(
          (b, a) =>
              (a.session?.regularTradingChangePercent ?? 0).compareTo(b.session?.regularTradingChangePercent ?? 0),
        );
        break;

      default:
    }
  }

  void _openSorting() {
    PBottomSheet.show(
      context,
      title: L10n.tr('sorting'),
      titlePadding: const EdgeInsets.only(
        top: Grid.m,
      ),
      child: ListView.separated(
        itemCount: _heatMapProfitFilter.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final filterKey = _heatMapProfitFilter[index];

          return BottomsheetSelectTile(
            title: L10n.tr(filterKey),
            isSelected: filterKey == _sortKey,
            onTap: (title, value) async {
              await router.maybePop();
              setState(() => _sortKey = filterKey);
              _sortList();
            },
          );
        },
        separatorBuilder: (context, index) => const PDivider(),
      ),
    );
  }
}
