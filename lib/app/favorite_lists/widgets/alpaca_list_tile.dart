import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:piapiri_v2/app/data_grid/widgets/slide_option.dart';
import 'package:piapiri_v2/app/favorite_lists/bloc/favorite_list_bloc.dart';
import 'package:piapiri_v2/app/favorite_lists/bloc/favorite_list_event.dart';
import 'package:piapiri_v2/app/favorite_lists/widgets/favorite_grid_box.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_bloc.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_state.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/diff_percentage.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_consumer.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/favorite_list.dart';
import 'package:piapiri_v2/core/model/favorite_sorting_enum.dart';
import 'package:piapiri_v2/core/model/us_symbol_snapshot.dart';

class AlpacaListTile extends StatefulWidget {
  final SlidableController controller;
  final FavoriteListItem favoriteListItem;
  final bool showHeatMap;

  const AlpacaListTile({
    super.key,
    required this.controller,
    required this.favoriteListItem,
    required this.showHeatMap,
  });

  @override
  State<AlpacaListTile> createState() => _MatriksListTileState();
}

class _MatriksListTileState extends State<AlpacaListTile> {
  final UsEquityBloc _usEquityBloc = getIt<UsEquityBloc>();
  final FavoriteListBloc _favoriteListBloc = getIt<FavoriteListBloc>();
  late UsSymbolSnapshot _snapshot;

  @override
  void initState() {
    _snapshot = _usEquityBloc.state.polygonWatchingItems
            .firstWhereOrNull((element) => element.ticker == widget.favoriteListItem.symbol) ??
        UsSymbolSnapshot(
          ticker: widget.favoriteListItem.symbol,
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocConsumer<UsEquityBloc, UsEquityState>(
      bloc: _usEquityBloc,
      listenWhen: (previous, current) =>
          current.updatedSymbol?.ticker == widget.favoriteListItem.symbol ||
          (!previous.polygonWatchingItems.any((element) => element.ticker == widget.favoriteListItem.symbol) &&
              current.polygonWatchingItems.any((element) => element.ticker == widget.favoriteListItem.symbol)),
      listener: (context, state) {
          UsSymbolSnapshot? newSnapshot = state.polygonWatchingItems.firstWhereOrNull(
            (element) => element.ticker == widget.favoriteListItem.symbol,
          );
        if (newSnapshot == null) return;
        setState(() {
          _snapshot = newSnapshot;
        });
      },
      builder: (context, state) {

        /// Heatmap gösterilmesi isteniyorsa
        if (widget.showHeatMap) {
          return FavoriteGridBox(
            key: ValueKey(widget.favoriteListItem.symbol),
            symbolName: widget.favoriteListItem.symbol,
            symbolIconName: widget.favoriteListItem.symbol,
            symbolTypes: widget.favoriteListItem.symbolType,
            price: '${CurrencyEnum.dollar.symbol}${MoneyUtils().getUsPrice(_snapshot)}',
            diffPercentage: _snapshot.session?.regularTradingChangePercent ?? 0,
            updateDate: DateTimeUtils.nanoSecondTimestampToTime(_snapshot.session?.timestamp),
            onTapGrid: () => router.push(SymbolUsDetailRoute(symbolName: widget.favoriteListItem.symbol)),
          );
        }

        /// Heatmap gösterilmeyecekse
        return InkWell(
          onTap: () => router.push(
            SymbolUsDetailRoute(
              symbolName: widget.favoriteListItem.symbol,
            ),
          ),
          child: Slidable(
            controller: widget.controller,
            enabled: true,
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              extentRatio: .16,
              children: [
                const Spacer(),
                LayoutBuilder(
                  builder: (context, constraints) => SlideOptions(
                    height: constraints.maxHeight,
                    imagePath: ImagesPath.trash,
                    backgroundColor: context.pColorScheme.critical,
                    iconColor: context.pColorScheme.lightHigh,
                    onTap: () {
                      _favoriteListBloc.add(
                        UpdateListEvent(
                          name: _favoriteListBloc.state.selectedList?.name ?? '',
                          favoriteListItems: _favoriteListBloc.state.selectedList?.favoriteListItems
                                  .where(
                                    (element) => element.symbol != widget.favoriteListItem.symbol,
                                  )
                                  .toList() ??
                              [],
                          id: _favoriteListBloc.state.selectedList?.id ?? 0,
                          sortingEnum:
                              _favoriteListBloc.state.selectedList?.sortingEnum ?? FavoriteSortingEnum.alphabetic,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            child: Container(
              alignment: Alignment.center,
              color: context.pColorScheme.transparent,
              padding: const EdgeInsets.symmetric(
                horizontal: Grid.m,
                vertical: Grid.m - Grid.xs,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        SymbolIcon(
                          symbolName: widget.favoriteListItem.symbol,
                          symbolType: widget.favoriteListItem.symbolType,
                          size: 28,
                        ),
                        const SizedBox(
                          width: Grid.s,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.favoriteListItem.symbol,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: context.pAppStyle.labelReg14textPrimary,
                              ),
                              Text(
                                _snapshot.name ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: context.pAppStyle.labelMed12textSecondary,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: DiffPercentageAutoSize(
                            rowMainAxisAlignment: MainAxisAlignment.center,
                            percentage: _snapshot.session?.regularTradingChangePercent ?? 0,
                            minfontSize: Grid.s + Grid.xxs,
                          ),
                        ),
                        Expanded(
                          child: AutoSizeText(
                            '${CurrencyEnum.dollar.symbol}${MoneyUtils().getUsPrice(_snapshot)}',
                            style: context.pAppStyle.labelMed14textPrimary,
                            maxLines: 1,
                            minFontSize: Grid.s + Grid.xxs,
                            textAlign: TextAlign.end,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
