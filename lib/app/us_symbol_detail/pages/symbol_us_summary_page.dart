import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/advices/enum/market_type_enum.dart';
import 'package:piapiri_v2/app/markets/widgets/us_symbol_dividend_carousel_widget.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/market_review_list.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_bloc.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_event.dart';
import 'package:piapiri_v2/app/us_symbol_detail/widgets/dividend_detail_widget.dart';
import 'package:piapiri_v2/app/us_symbol_detail/widgets/market_info_tile.dart';
import 'package:piapiri_v2/app/us_symbol_detail/widgets/symbol_us_chart.dart';
import 'package:piapiri_v2/app/us_symbol_detail/widgets/us_brief_widget.dart';
import 'package:piapiri_v2/app/us_symbol_detail/widgets/us_performance_gauges_widget.dart';
import 'package:piapiri_v2/app/us_symbol_detail/widgets/us_symbol_info.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/ticker_overview.dart';
import 'package:piapiri_v2/core/model/us_symbol_snapshot.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class SymbolUsSummary extends StatefulWidget {
  final TickerOverview tickerOverview;
  final UsSymbolSnapshot usSymbolSnapshot;

  const SymbolUsSummary({
    super.key,
    required this.tickerOverview,
    required this.usSymbolSnapshot,
  });

  @override
  State<SymbolUsSummary> createState() => _SymbolUsSummaryState();
}

class _SymbolUsSummaryState extends State<SymbolUsSummary> {
  final UsEquityBloc _usEquityBloc = getIt<UsEquityBloc>();
  List<String>? _relatedTickers;
  @override
  void initState() {
    _usEquityBloc.add(
      GetCustomBarsEvent(
        symbols: widget.tickerOverview.ticker,
      ),
    );
    _usEquityBloc.add(
      GetRelatedTickersEvent(
        symbolName: widget.tickerOverview.ticker,
        callback: (relatedTickers) {
          if (relatedTickers != null) {
            setState(() {
              _relatedTickers = relatedTickers;
            });
          }
        },
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Grid.m,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UsSymbolInfo(
              symbol: widget.usSymbolSnapshot,
              tickerOverview: widget.tickerOverview,
            ),
            Row(
              spacing: Grid.s,
              children: [
                Expanded(
                  child: MarketInfoTile(
                    symbolName: widget.tickerOverview.ticker,
                  ),
                ),
                InkWell(
                  child: SvgPicture.asset(
                    ImagesPath.arrows_diagonal,
                    width: 18,
                    height: 18,
                  ),
                  onTap: () => router.push(
                    TradingviewRoute(
                      symbol: widget.tickerOverview.ticker,
                      usSymbolExchange: widget.tickerOverview.primaryExchange,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: Grid.l,
            ),
            SymbolUsChart(
              symbol: widget.tickerOverview.ticker,
            ),
            const SizedBox(
              height: Grid.l,
            ),
            UsBrief(
              usSymbolSnapshot: widget.usSymbolSnapshot,
              tickerOverview: widget.tickerOverview,
            ),
            const SizedBox(
              height: Grid.l,
            ),
            UsPerformanceGaugesWidget(
              ticker: widget.tickerOverview.ticker,
            ),
            DividendDetailWidget(
              symbol: widget.tickerOverview.ticker,
            ),
            MarketReviewList(
              symbolName: widget.tickerOverview.ticker,
              mainGroup: MarketTypeEnum.marketUs.value,
            ),
            if (_relatedTickers != null && _relatedTickers!.isNotEmpty)
              UsSymbolDividendCarouselWidget(
                title: L10n.tr('related_symbols'),
                key: ValueKey('RELATED_SYMBOLS_$_relatedTickers'),
                symbolList: _relatedTickers ?? [],
                padding: EdgeInsets.zero,
                showAllButton: false,
              ),
            const SizedBox(
              height: Grid.l,
            ),
          ],
        ),
      ),
    );
  }
}
