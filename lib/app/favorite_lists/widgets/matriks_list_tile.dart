import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:piapiri_v2/app/data_grid/widgets/slide_option.dart';
import 'package:piapiri_v2/app/favorite_lists/bloc/favorite_list_bloc.dart';
import 'package:piapiri_v2/app/favorite_lists/bloc/favorite_list_event.dart';
import 'package:piapiri_v2/app/favorite_lists/widgets/favorite_grid_box.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/diff_percentage.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_consumer.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_bloc.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_state.dart';
import 'package:piapiri_v2/core/config/analytics/analytics.dart';
import 'package:piapiri_v2/core/config/analytics/analytics_events.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/favorite_list.dart';
import 'package:piapiri_v2/core/model/insider_event_enum.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/favorite_sorting_enum.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';

class MatriksListTile extends StatefulWidget {
  final SlidableController controller;
  final FavoriteListItem favoriteListItem;
  final bool showHeatMap;

  const MatriksListTile({
    super.key,
    required this.controller,
    required this.favoriteListItem,
    required this.showHeatMap,
  });

  @override
  State<MatriksListTile> createState() => _MatriksListTileState();
}

class _MatriksListTileState extends State<MatriksListTile> {
  late SymbolBloc _symbolBloc;
  late FavoriteListBloc _favoriteListBloc;
  late MarketListModel _marketListModel;

  @override
  void initState() {
    _symbolBloc = getIt<SymbolBloc>();
    _favoriteListBloc = getIt<FavoriteListBloc>();
    _marketListModel = _symbolBloc.state.watchingItems
            .firstWhereOrNull((element) => element.symbolCode == widget.favoriteListItem.symbol) ??
        MarketListModel(
            symbolCode: widget.favoriteListItem.symbol, updateDate: '', type: widget.favoriteListItem.symbolType.dbKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocConsumer<SymbolBloc, SymbolState>(
      bloc: _symbolBloc,
      listenWhen: (previous, current) =>
          current.isUpdated && current.updatedSymbol.symbolCode == widget.favoriteListItem.symbol,
      listener: (context, state) {
        setState(() {
          _marketListModel =
              state.watchingItems.firstWhereOrNull((element) => element.symbolCode == widget.favoriteListItem.symbol) ??
                  state.updatedSymbol;
        });
      },
      builder: (context, state) {
        final currencySymbol =
            widget.favoriteListItem.symbolType == SymbolTypes.parity ? '' : CurrencyEnum.turkishLira.symbol;
        if (widget.showHeatMap) {
          return FavoriteGridBox(
            key: ValueKey(widget.favoriteListItem.symbol),
            symbolName: _marketListModel.symbolCode,
            symbolIconName: widget.favoriteListItem.symbolType == SymbolTypes.warrant ||
                    widget.favoriteListItem.symbolType == SymbolTypes.option ||
                    widget.favoriteListItem.symbolType == SymbolTypes.future
                ? widget.favoriteListItem.underlyingName
                : widget.favoriteListItem.symbol,
            symbolTypes: widget.favoriteListItem.symbolType,
            price: '$currencySymbol${MoneyUtils().readableMoney(MoneyUtils().getPrice(_marketListModel, null))}',
            diffPercentage: _marketListModel.differencePercent,
            updateDate: _marketListModel.updateDate,
            onTapGrid: () => router.push(
              SymbolDetailRoute(
                symbol: MarketListModel(
                  symbolCode: widget.favoriteListItem.symbol,
                  symbolType: widget.favoriteListItem.symbolType.dbKey,
                  updateDate: '',
                ),
                ignoreDispose: true,
              ),
            ),
          );
        }
        return InkWell(
          splashColor: context.pColorScheme.transparent,
          highlightColor: context.pColorScheme.transparent,
          onTap: () => router.push(
            SymbolDetailRoute(
              symbol: MarketListModel(
                symbolCode: widget.favoriteListItem.symbol,
                description: widget.favoriteListItem.description,
                symbolType: widget.favoriteListItem.symbolType.dbKey,
                updateDate: '',
              ),
              ignoreDispose: true,
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
                      getIt<Analytics>().track(
                        AnalyticsEvents.itemRemovedFromCart,
                        taxonomy: [
                          InsiderEventEnum.controlPanel.value,
                          InsiderEventEnum.marketsPage.value,
                          InsiderEventEnum.favoriteTab.value,
                        ],
                        properties: {
                          'product_id': widget.favoriteListItem.symbol,
                          'name': widget.favoriteListItem.symbol,
                          'image_url': '',
                          'price': _marketListModel.last,
                          'currency': 'TRY',
                        },
                      );

                      _favoriteListBloc.add(
                        UpdateListEvent(
                          name: _favoriteListBloc.state.selectedList?.name ?? '',
                          favoriteListItems: _favoriteListBloc.state.selectedList?.favoriteListItems
                                  .where((element) => element.symbol != widget.favoriteListItem.symbol)
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
                          symbolName: widget.favoriteListItem.symbolType == SymbolTypes.warrant ||
                                  widget.favoriteListItem.symbolType == SymbolTypes.option ||
                                  widget.favoriteListItem.symbolType == SymbolTypes.future
                              ? widget.favoriteListItem.underlyingName
                              : widget.favoriteListItem.symbol,
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
                                widget.favoriteListItem.description,
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
                            percentage: _marketListModel.differencePercent,
                            minfontSize: Grid.s + Grid.xxs,
                          ),
                        ),
                        Expanded(
                          child: AutoSizeText(
                            '$currencySymbol${MoneyUtils().readableMoney(MoneyUtils().getPrice(_marketListModel, null))}',
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
