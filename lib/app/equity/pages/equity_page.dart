import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/bottomsheet_select_tile.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/data_grid/pages/bist_symbol_listing.dart';
import 'package:piapiri_v2/app/dividend/bloc/dividend_bloc.dart';
import 'package:piapiri_v2/app/equity/bloc/equity_bloc.dart';
import 'package:piapiri_v2/app/equity/bloc/equity_event.dart';
import 'package:piapiri_v2/app/equity/bloc/equity_state.dart';
import 'package:piapiri_v2/app/equity/equity_constants.dart';
import 'package:piapiri_v2/app/equity/widgets/equity_filter_sheet.dart';
import 'package:piapiri_v2/app/equity/widgets/equity_list_tile.dart';
import 'package:piapiri_v2/app/markets/model/market_menu.dart';
import 'package:piapiri_v2/app/search_symbol/symbol_search_utils.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/utils.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/delayed_info_widget.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_bloc.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_event.dart';
import 'package:piapiri_v2/core/config/analytics/analytics.dart';
import 'package:piapiri_v2/core/config/analytics/analytics_events.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/filter_category_model.dart';
import 'package:piapiri_v2/core/model/insider_event_enum.dart';
import 'package:piapiri_v2/core/model/ranker_enum.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class EquityPage extends StatefulWidget {
  final String? disposeStatsKey;
  const EquityPage({
    super.key,
    this.disposeStatsKey,
  });

  @override
  State<EquityPage> createState() => _EquityPageState();
}

class _EquityPageState extends State<EquityPage> {
  final EquityBloc _equityBloc = getIt<EquityBloc>();
  final SymbolBloc _symbolBloc = getIt<SymbolBloc>();
  final DividendBloc _dividendBloc = getIt<DividendBloc>();
  late List<FilterCategoryModel> _filterCategories;
  late FilterCategoryItemModel _selectedFilterItem;
  bool _showHeatMap = false;

  String? _selectedHeatMapProfitFilter;
  final List<String> _heatMapProfitFilter = [
    'a_to_z',
    'z_to_a',
    'difference_up',
    'difference_down',
    'last_price_up',
    'last_price_down',
  ];

  @override
  void initState() {
    Utils.setListPageEvent(pageName: 'EquityPage');
    getIt<Analytics>().track(
      AnalyticsEvents.listingPageView,
      taxonomy: [
        InsiderEventEnum.controlPanel.value,
        InsiderEventEnum.marketsPage.value,
        InsiderEventEnum.istanbulStockExchangeTab.value,
        InsiderEventEnum.equityTab.value,
      ],
    );
    _filterCategories = _loadFilterCategories();
    _selectedFilterItem = _filterCategories.first.items.first;
    _equityBloc.add(
      InitEvent(
        callback: (symbols) {},
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    _equityBloc.add(
      SelectListEvent(
        selectedList: EquityConstants().indexShares.first,
      ),
    );
    _symbolBloc.add(
      SymbolSubscribeStatsEvent(
        statsKey: widget.disposeStatsKey ?? '',
        rankerEnum: RankerEnum.equity,
      ),
    );

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<EquityBloc, EquityState>(
      bloc: _equityBloc,
      builder: (context, state) {
        return Scaffold(
          appBar: PInnerAppBar(
            title: L10n.tr('equity.all'),
            actions: [
              PIconButton(
                type: PIconButtonType.outlined,
                svgPath: ImagesPath.search,
                sizeType: PIconButtonSize.xl,
                onPressed: () => SymbolSearchUtils.goSymbolDetail(),
              ),
            ],
          ),
          body: SafeArea(
            top: false,
            left: false,
            right: false,
            bottom: true,
            child: _selectedFilterItem.type != '20' && state.symbolList.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DelayedInfoWidget(
                        delayedSymbols: [SymbolTypes.equity.matriks],
                        activeIndex: 2,
                        marketMenu: MarketMenu.istanbulStockExchange,
                      ),
                      const SizedBox(
                        height: Grid.m,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Grid.m,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _listButton(
                              state,
                              state.selectedList,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: Grid.m,
                      ),
                      SlidableAutoCloseBehavior(
                        child: Expanded(
                          child: BistSymbolListing(
                            key: ValueKey('EQUITY_${state.selectedList.value}'),
                            symbols: state.symbolList,
                            heatMapEnabled: _showHeatMap,
                            outPadding: const EdgeInsets.symmetric(
                              horizontal: Grid.m,
                            ),
                            columns: [
                              L10n.tr('equity_column_symbol'),
                              L10n.tr('equity_column_difference'),
                              L10n.tr('equity_column_last_price'),
                            ],
                            columnsSpacingIsEqual: true,
                            rankerEnum: _selectedFilterItem.type == '20' ? RankerEnum.equity : null,
                            ignoreUnsubList: _dividendBloc.state.incomingDividends ?? [],
                            itemBuilder: (symbol, controller) => EquityListTile(
                              key: ValueKey(symbol.symbolCode),
                              margin: const EdgeInsets.symmetric(
                                horizontal: Grid.m,
                              ),
                              controller: controller,
                              symbol: symbol,
                              onTap: () => router.push(
                                SymbolDetailRoute(
                                  symbol: symbol,
                                  ignoreDispose: true,
                                ),
                              ),
                              // _selectedFilterItem.type != '20' ise bu listenin ranker list olugunu belirtir
                              enableSwiping: _selectedFilterItem.type != '20',
                            ),
                            statsKey: _selectedFilterItem.type == '20' ? _selectedFilterItem.value : null,
                            heatMapSortKey: _showHeatMap ? _selectedHeatMapProfitFilter : null,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
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
            isSelected: filterKey == _selectedHeatMapProfitFilter,
            onTap: (title, value) async {
              await router.maybePop();
              setState(() => _selectedHeatMapProfitFilter = filterKey);
            },
          );
        },
        separatorBuilder: (context, index) => const PDivider(),
      ),
    );
  }

  Widget _listButton(
    EquityState state,
    FilterCategoryItemModel? selectedList,
  ) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - (Grid.m * 2),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  PCustomOutlinedButtonWithIcon(
                    text: L10n.tr(_selectedFilterItem.localization),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    iconSource: ImagesPath.chevron_down,
                    foregroundColorApllyBorder: false,
                    foregroundColor: context.pColorScheme.primary,
                    backgroundColor: context.pColorScheme.secondary,
                    iconAlignment: IconAlignment.end,
                    onPressed: () {
                      PBottomSheet.show(
                        context,
                        title: L10n.tr('Filtrele'),
                        titlePadding: const EdgeInsets.only(
                          top: Grid.m,
                        ),
                        child: EquityFilterSheet(
                          filterCategories: _filterCategories,
                          selectedFilterItem: _selectedFilterItem,
                          onSetFilter: (FilterCategoryItemModel selectedCategoryItem) {
                            if (selectedCategoryItem.type == '20') {
                              _equityBloc.add(
                                SelectListEvent(
                                  selectedList: selectedCategoryItem,
                                  callback: (symbols) {
                                    _symbolBloc.add(
                                      SymbolSubscribeStatsEvent(
                                        statsKey: selectedCategoryItem.value,
                                        unsubscribeKey: _selectedFilterItem.value,
                                        rankerEnum: RankerEnum.equity,
                                      ),
                                    );
                                    setState(() {
                                      _selectedFilterItem = selectedCategoryItem;
                                      if (_selectedHeatMapProfitFilter != null) {
                                        _selectedHeatMapProfitFilter = null;
                                      }
                                    });
                                  },
                                ),
                              );
                              return;
                            }
                            _equityBloc.add(
                              SelectListEvent(
                                selectedList: selectedCategoryItem,
                              ),
                            );
                            setState(() {
                              _selectedFilterItem = selectedCategoryItem;
                              if (_selectedHeatMapProfitFilter != null) {
                                _selectedHeatMapProfitFilter = null;
                              }
                            });
                          },
                        ),
                      );
                    },
                  ),
                  if (_showHeatMap) ...[
                    const SizedBox(
                      width: Grid.s,
                    ),
                    PCustomOutlinedButtonWithIcon(
                      text: _selectedHeatMapProfitFilter != null
                          ? '${L10n.tr('sorting')} : ${L10n.tr(_selectedHeatMapProfitFilter!)}'
                          : L10n.tr('sorting'),
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
                ],
              ),
            ),
          ),
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
            onTap: () => setState(() => _showHeatMap = !_showHeatMap),
          ),
        ],
      ),
    );
  }

  List<FilterCategoryModel> _loadFilterCategories() {
    return [
      FilterCategoryModel(
        categoryLocalization: L10n.tr('index_shares'),
        items: EquityConstants()
            .indexShares
            .map(
              (e) => FilterCategoryItemModel(
                localization: e.localization,
                value: e.value,
                type: e.type,
              ),
            )
            .toList(),
      ),
      FilterCategoryModel(
        categoryLocalization: L10n.tr('highlights'),
        items: EquityConstants()
            .highlights
            .map((e) => FilterCategoryItemModel(
                  localization: e.localization,
                  value: e.value,
                  type: e.type,
                ))
            .toList(),
      ),
      FilterCategoryModel(
        categoryLocalization: L10n.tr('markets'),
        items: EquityConstants()
            .markets
            .map((e) => FilterCategoryItemModel(
                  localization: e.localization,
                  value: e.value,
                  type: e.type,
                ))
            .toList(),
      ),
      FilterCategoryModel(
        categoryLocalization: L10n.tr('indices'),
        items: EquityConstants()
            .indices
            .map((e) => FilterCategoryItemModel(
                  localization: e.localization,
                  value: e.value,
                  type: e.type,
                ))
            .toList(),
      ),
    ];
  }
}
