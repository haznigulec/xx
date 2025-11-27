import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piapiri_v2/app/advices/enum/market_type_enum.dart';
import 'package:piapiri_v2/app/data_grid/pages/bist_symbol_listing.dart';
import 'package:piapiri_v2/app/dividend/bloc/dividend_bloc.dart';
import 'package:piapiri_v2/app/dividend/bloc/dividend_event.dart';
import 'package:piapiri_v2/app/dividend/bloc/dividend_state.dart';
import 'package:piapiri_v2/app/dividend/widgets/symbol_dividend_carousel_widget.dart';
import 'package:piapiri_v2/app/equity/widgets/equity_front_list_tile.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/bloc/quick_portfolio_bloc.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/bloc/quick_portfolio_event.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/model/specific_list_bist_type_enum.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/specific_list_widget.dart';
import 'package:piapiri_v2/app/sectors/bloc/sectors_bloc.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/utils.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/common/widgets/chip/chip.dart';
import 'package:piapiri_v2/common/widgets/exchange_overlay/widgets/show_case_view.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/sectors_widget.dart';
import 'package:piapiri_v2/common/widgets/progress_indicators/shimmerize.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_bloc.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_event.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_state.dart';
import 'package:piapiri_v2/core/config/analytics/analytics.dart';
import 'package:piapiri_v2/core/config/analytics/analytics_events.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/insider_event_enum.dart';
import 'package:piapiri_v2/core/model/ranker_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:visibility_detector/visibility_detector.dart';

class EquityFrontPage extends StatefulWidget {
  final List<ShowCaseViewModel> bistShowCaseKeys;

  const EquityFrontPage({
    required this.bistShowCaseKeys,
    super.key,
  });

  @override
  State<EquityFrontPage> createState() => _EquityFrontPageState();
}

class _EquityFrontPageState extends State<EquityFrontPage> with AutomaticKeepAliveClientMixin {
  final int _equityListTileHeight = 65;
  String _subcribeKey = 'high';
  final SymbolBloc _symbolBloc = getIt<SymbolBloc>();
  final DividendBloc _dividendBloc = getIt<DividendBloc>();
  final QuickPortfolioBloc _quickPortfolioBloc = getIt<QuickPortfolioBloc>();
  final SectorsBloc _sectorsBloc = getIt<SectorsBloc>();
  bool _showDividens = false;
  @override
  bool get wantKeepAlive => true; // sayfa bellekte tutulur

  @override
  void initState() {
    _symbolBloc.add(
      SymbolSubscribeStatsEvent(
        statsKey: _subcribeKey,
        unsubscribeKey: '',
        rankerEnum: RankerEnum.equity,
      ),
    );
    _dividendBloc.add(
      GetIncomingDividentEvent(),
    );
    _quickPortfolioBloc.add(
      GetSpecificListEvent(
        mainGroup: MarketTypeEnum.marketBist.value,
      ),
    );
    Utils.setListPageEvent(pageName: 'EquityFrontPage');
    getIt<Analytics>().track(
      AnalyticsEvents.listingPageView,
      taxonomy: [
        InsiderEventEnum.controlPanel.value,
        InsiderEventEnum.marketsPage.value,
        InsiderEventEnum.istanbulStockExchangeTab.value,
        InsiderEventEnum.equityTab.value,
      ],
    );

    super.initState();
  }

  @override
  dispose() {
    _symbolBloc.add(
      SymbolUnsubcribeRankerListEvent(
        statsKey: _subcribeKey,
        rankerEnum: RankerEnum.equity,
      ),
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: Grid.m,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Grid.m,
            ),
            child: Text(
              L10n.tr('highlights'),
              style: context.pAppStyle.interMediumBase.copyWith(
                fontSize: Grid.m + Grid.xxs,
              ),
            ),
          ),
          const SizedBox(
            height: Grid.s,
          ),
          SizedBox(
            height: Grid.l + Grid.m,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: Grid.m,
              ),
              child: ShowCaseView(
                showCase: widget.bistShowCaseKeys.first,
                targetPadding: const EdgeInsets.symmetric(
                  horizontal: Grid.s,
                  vertical: Grid.xs,
                ),
                targetRadius: BorderRadius.circular(
                  Grid.l,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    PChoiceChip(
                      label: L10n.tr('equityStats.high'),
                      selected: _subcribeKey == 'high',
                      chipSize: ChipSize.medium,
                      enabled: true,
                      onSelected: (_) {
                        if (_subcribeKey != 'high') {
                          setState(() {
                            _subcribeKey = 'high';
                          });
                        }
                      },
                    ),
                    const SizedBox(
                      width: Grid.xs,
                    ),
                    PChoiceChip(
                      label: L10n.tr('equityStats.low'),
                      selected: _subcribeKey == 'low',
                      chipSize: ChipSize.medium,
                      enabled: true,
                      onSelected: (_) {
                        if (_subcribeKey != 'low') {
                          setState(() {
                            _subcribeKey = 'low';
                          });
                        }
                      },
                    ),
                    const SizedBox(
                      width: Grid.xs,
                    ),
                    PChoiceChip(
                      label: L10n.tr('equityStats.volume'),
                      selected: _subcribeKey == 'volume',
                      chipSize: ChipSize.medium,
                      enabled: true,
                      onSelected: (_) {
                        if (_subcribeKey != 'volume') {
                          setState(() {
                            _subcribeKey = 'volume';
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: Grid.s,
          ),

          /// Hisse Yukselenler, Dusenler, Hacim liderleri
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Grid.m,
            ),
            child: PBlocBuilder<SymbolBloc, SymbolState>(
              bloc: _symbolBloc,
              buildWhen: (previous, current) =>
                  previous.equityRankerList.length < 5 &&
                  current.equityRankerList.length != previous.equityRankerList.length,
              builder: (context, state) {
                int rankerListLength = state.equityRankerList.length < 5 ? state.equityRankerList.length : 5;
                return SizedBox(
                  height: rankerListLength == 0 ? 50 : 38 + _equityListTileHeight * rankerListLength.toDouble(),
                  child: BistSymbolListing(
                    key: ValueKey('EQUITY_$_subcribeKey'),
                    listScrollPhysics: const NeverScrollableScrollPhysics(),
                    symbols: const [],
                    statsKey: _subcribeKey,
                    rankerEnum: RankerEnum.equity,
                    rankerListLength: rankerListLength,
                    showTopDivider: false,
                    sortEnabled: false,
                    columns: [
                      L10n.tr('equity_column_symbol'),
                      L10n.tr('lastAndChange'),
                    ],
                    itemBuilder: (symbol, controller) => EquityFrontListTile(
                      key: ValueKey(symbol.symbolCode),
                      symbol: symbol,
                      onTap: () => router.push(
                        SymbolDetailRoute(symbol: symbol),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Grid.m,
            ),
            child: ShowCaseView(
              showCase: widget.bistShowCaseKeys.skip(1).first,
              targetRadius: BorderRadius.circular(
                Grid.m,
              ),
              targetPadding: const EdgeInsets.symmetric(
                horizontal: Grid.s,
                vertical: Grid.xxs,
              ),
              tooltipPosition: TooltipPosition.top,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: Grid.s,
                  ),
                  Text(
                    L10n.tr('equity.show_all_symbols_message'),
                    style: context.pAppStyle.labelReg14textSecondary,
                  ),
                  const SizedBox(
                    height: Grid.s + Grid.xs,
                  ),
                  PCustomOutlinedButtonWithIcon(
                    text: L10n.tr('equity.show_all_symbols'),
                    iconSource: ImagesPath.arrow_up_right,
                    buttonType: PCustomOutlinedButtonTypes.mediumSecondary,
                    onPressed: () {
                      router.push(
                        EquityRoute(
                          disposeStatsKey: _subcribeKey,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: Grid.l,
          ),
          SpecificListWidget(
            tab: BistType.equityBist.type,
            leftPadding: Grid.m,
            rightPadding: Grid.m,
          ),

          /// Bist Sektorler
          SectorsWidget(
            title: L10n.tr('bist_sectors'),
            leftPadding: Grid.m,
            rightPadding: Grid.m,
            sectors: _sectorsBloc.state.bistSectors.map(
              (e) {
                return {
                  'name': L10n.tr(e.groupName),
                  'code': e.groupName,
                };
              },
            ).toList(),
            onPressed: (name, key) => router.push(
              SectorsRoute(
                sectorModel: _sectorsBloc.state.bistSectors.firstWhere(
                  (element) => element.groupName == key,
                ),
              ),
            ),
          ),

          /// Yakında Temettü Dağıtacaklar
          VisibilityDetector(
            key: const Key('IncomingDividendsVisibilityDetector'),
            onVisibilityChanged: (visibilityInfo) {
              if (visibilityInfo.visibleFraction > 0) {
                _showDividens = true;
                setState(() {});
              }
            },
            child: Shimmerize(
              enabled: !_showDividens,
              child: BlocBuilder<DividendBloc, DividendState>(
                bloc: _dividendBloc,
                builder: (context, state) {
                  if (state.incomingDividendsState == PageState.loading) {
                    return const PLoading();
                  }

                  if (state.incomingDividendsState != PageState.success) {
                    return const SizedBox.shrink();
                  }

                  final dividends = state.incomingDividends;
                  if (dividends != null && dividends.isNotEmpty) {
                    return SymbolDividendCarouselWidget(
                      enabled: _showDividens,
                      incomingDividends: dividends,
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
