import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/data_grid/pages/bist_symbol_listing.dart';
import 'package:piapiri_v2/app/equity/widgets/equity_list_tile.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/bloc/quick_portfolio_bloc.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/bloc/quick_portfolio_state.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/model/specific_list_bist_type_enum.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/model/specific_list_model.dart';
import 'package:piapiri_v2/app/viop/widgets/viop_list_tile.dart';
import 'package:piapiri_v2/app/warrant/widgets/warrant_list_tile.dart';
import 'package:piapiri_v2/common/utils/utils.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';

@RoutePage()
class SpecificListDetailPage extends StatefulWidget {
  final SpecificListModel specificListItem;
  const SpecificListDetailPage({
    super.key,
    required this.specificListItem,
  });

  @override
  State<SpecificListDetailPage> createState() => _SpecificListDetailPageState();
}

class _SpecificListDetailPageState extends State<SpecificListDetailPage> {
  late QuickPortfolioBloc _quickPortfolioBloc;
  @override
  void initState() {
    Utils.setListPageEvent(
      pageName: widget.specificListItem.tab == BistType.equityBist.type
          ? 'EquitySpecificListPage'
          : widget.specificListItem.tab == BistType.viopBist.type
              ? 'ViopSpecificListPage'
              : 'WarrantSpecificListPage',
    );
    _quickPortfolioBloc = getIt<QuickPortfolioBloc>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<QuickPortfolioBloc, QuickPortfolioState>(
      bloc: _quickPortfolioBloc,
      builder: (context, state) {
        if (state.isLoading) {
          return const PLoading();
        }
        return Scaffold(
          appBar: PInnerAppBar(
            title: L10n.tr(widget.specificListItem.listName),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Grid.m,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.specificListItem.description,
                  style: context.pAppStyle.labelReg14textPrimary,
                ),
                const SizedBox(
                  height: Grid.xs + Grid.s,
                ),
                Expanded(
                    child: BistSymbolListing(
                  key: widget.specificListItem.tab == BistType.equityBist.type
                      ? ValueKey('SpecificList${widget.specificListItem.symbolNames.map((e) => e).join('_')}')
                      : widget.specificListItem.tab == BistType.warrantBist.type
                          ? ValueKey('SpecificList${widget.specificListItem.symbolNames.map((e) => e).join('_')}')
                          : ValueKey('SpecificList${widget.specificListItem.symbolNames.map((e) => e).join('_')}'),
                  sortEnabled: false,
                  symbols: widget.specificListItem.tab == BistType.equityBist.type
                      ? state.equitySymbolList
                          .where((e) => widget.specificListItem.symbolNames.contains(e.symbolCode))
                          .toList()
                      : widget.specificListItem.symbolType == SpecialListSymbolTypeEnum.equity.type
                          ? state.homepageEquitySymbolList
                              .where((e) => widget.specificListItem.symbolNames.contains(e.symbolCode))
                              .toList()
                          : widget.specificListItem.tab == BistType.warrantBist.type
                              ? state.warrantSymbolList
                                  .where((e) => widget.specificListItem.symbolNames.contains(e.symbolCode))
                                  .toList()
                              : widget.specificListItem.symbolType == SpecialListSymbolTypeEnum.warrant.type
                                  ? state.homepageWarrantSymbolList
                                      .where((e) => widget.specificListItem.symbolNames.contains(e.symbolCode))
                                      .toList()
                                  : widget.specificListItem.tab == BistType.viopBist.type
                                      ? state.viopSymbolList
                                          .where((e) => widget.specificListItem.symbolNames.contains(e.symbolCode))
                                          .toList()
                                      : state.homepageViopSymbolList
                                          .where((e) => widget.specificListItem.symbolNames.contains(e.symbolCode))
                                          .toList(),
                  columnsSpacingIsEqual: widget.specificListItem.tab == BistType.equityBist.type,
                  columns: [
                    if (widget.specificListItem.tab == BistType.equityBist.type ||
                        widget.specificListItem.symbolType == SpecialListSymbolTypeEnum.equity.type) ...[
                      '${L10n.tr('equity')} (${widget.specificListItem.symbolNames.length})',
                      L10n.tr('equity_column_difference'),
                      L10n.tr('equity_column_last_price'),
                    ] else if (widget.specificListItem.tab == BistType.viopBist.type ||
                        widget.specificListItem.symbolType == SpecialListSymbolTypeEnum.viop.type) ...[
                      '${L10n.tr('viop')} (${widget.specificListItem.symbolNames.length})',
                      L10n.tr('last_change_maturity'),
                    ] else if (widget.specificListItem.tab == BistType.warrantBist.type ||
                        widget.specificListItem.symbolType == SpecialListSymbolTypeEnum.warrant.type) ...[
                      '${L10n.tr('warrant')} (${widget.specificListItem.symbolNames.length})',
                      L10n.tr('last_change_maturity'),
                    ] else ...[
                      ''
                    ],
                  ],
                  itemBuilder: (symbol, controller) => widget.specificListItem.tab == BistType.equityBist.type ||
                          widget.specificListItem.symbolType == SpecialListSymbolTypeEnum.equity.type
                      ? EquityListTile(
                          key: ValueKey(symbol.symbolCode),
                          controller: controller,
                          symbol: symbol,
                          onTap: () => router.push(
                            SymbolDetailRoute(
                              symbol: symbol,
                              ignoreDispose: true,
                            ),
                          ),
                          enableSwiping: false,
                        )
                      : widget.specificListItem.tab == BistType.warrantBist.type ||
                              widget.specificListItem.symbolType == SpecialListSymbolTypeEnum.warrant.type
                          ? WarrantListTile(
                              key: ValueKey(symbol.symbolCode),
                              controller: controller,
                              symbol: symbol,
                              onTap: () => router.push(
                                SymbolDetailRoute(
                                  symbol: symbol,
                                  ignoreDispose: true,
                                ),
                              ),
                            )
                          : ViopListTile(
                              key: ValueKey(symbol.symbolCode),
                              controller: controller,
                              symbol: symbol,
                              showSymbolIcon: true,
                              onTap: () => router.push(
                                SymbolDetailRoute(
                                  symbol: symbol,
                                  ignoreDispose: true,
                                ),
                              ),
                            ),
                  statsKey: null,
                )),
                const SizedBox(
                  height: Grid.m,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
