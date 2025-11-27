import 'package:collection/collection.dart';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:piapiri_v2/app/favorite_lists/widgets/alpaca_list_tile.dart';
import 'package:piapiri_v2/app/favorite_lists/widgets/favorite_listing_column.dart';
import 'package:piapiri_v2/app/favorite_lists/widgets/matriks_list_tile.dart';
import 'package:piapiri_v2/app/favorite_lists/widgets/no_fav.dart';
import 'package:piapiri_v2/app/favorite_lists/widgets/shimmer_home_favorite_list_widget.dart';
import 'package:piapiri_v2/app/favorite_lists/widgets/tefas_list_tile.dart';
import 'package:piapiri_v2/app/fund/bloc/fund_bloc.dart';
import 'package:piapiri_v2/app/fund/bloc/fund_event.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_bloc.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_event.dart';
import 'package:piapiri_v2/common/widgets/progress_indicators/shimmerize.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_bloc.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_event.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/favorite_list.dart';
import 'package:piapiri_v2/core/model/fund_model.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/symbol_soruce_enum.dart';

class FavoriteSymbolListing extends StatefulWidget {
  /// Listelenmek istenen semboller
  final List<FavoriteListItem> symbols;
  final bool isHome;

  /// HeatMap gösterilsin mi?
  final bool showHeatMap;
  const FavoriteSymbolListing({
    super.key,
    required this.symbols,
    this.showHeatMap = false,
    required this.isHome,
  });

  @override
  State<FavoriteSymbolListing> createState() => _FavoriteSymbolListingState();
}

class _FavoriteSymbolListingState extends State<FavoriteSymbolListing> with TickerProviderStateMixin {
  final SymbolBloc _symbolBloc = getIt<SymbolBloc>();
  final UsEquityBloc _usEquityBloc = getIt<UsEquityBloc>();
  final FundBloc _fundBloc = getIt<FundBloc>();
  List<MarketListModel> matriksSymbols = [];
  List<String> alpacaSymbols = [];
  List<String> tefasSymbols = [];
  List<FundDetailModel> tefasSymbolDetails = [];

  List<SlidableController> _slidabelControllerList = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _slidabelControllerList = List.generate(widget.symbols.length, (index) => SlidableController(this));

    /// Listedeki sembolleri subscribe olunacak sunucuya gore ayirir
    matriksSymbols.addAll(widget.symbols
        .where((element) => element.symbolSource == SymbolSourceEnum.matriks)
        .map((e) => MarketListModel(symbolCode: e.symbol, type: e.symbolType.dbKey, updateDate: ''))
        .toList());
    alpacaSymbols.addAll(widget.symbols
        .where((element) => element.symbolSource == SymbolSourceEnum.alpaca)
        .map((e) => e.symbol)
        .toList());
    tefasSymbols.addAll(widget.symbols
        .where((element) => element.symbolSource == SymbolSourceEnum.tefas)
        .map((e) => e.symbol)
        .toList());

    /// Sunucuya gore ayrilmis sembollerden datalari ceker
    if (matriksSymbols.isNotEmpty) {
      _symbolBloc.add(SymbolSubTopicsEvent(symbols: matriksSymbols));
    }
    if (alpacaSymbols.isNotEmpty) {
      _usEquityBloc.add(SubscribeSymbolEvent(symbolName: alpacaSymbols));
    }
    if (tefasSymbols.isNotEmpty) {
      _fundBloc.add(GetDetailsEvent(
        fundCodeList: tefasSymbols,
        callBack: (List<FundDetailModel> fundDetailModelList) {
          tefasSymbolDetails = fundDetailModelList;
          setState(() {});
        },
      ));
    }

    super.initState();
  }

  @override
  void dispose() {
    if (matriksSymbols.isNotEmpty) {
      _symbolBloc.add(SymbolUnsubsubscribeEvent(symbolList: matriksSymbols));
    }
    if (alpacaSymbols.isNotEmpty) {
      _usEquityBloc.add(UnsubscribeSymbolEvent(symbolName: alpacaSymbols));
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// Eğer fon sembollerin detayları gelmediyse loading gösterir
    if (tefasSymbols.isNotEmpty && tefasSymbolDetails.isEmpty) {
      return const Center(
        child: Shimmerize(
          enabled: true,
          child: ShimmerHomeFavoriteListWidget(),
        ),
      );
    }

    return widget.symbols.isEmpty
        ? const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Grid.m,
            ),
            child: NoFav(),
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!widget.showHeatMap) ...[
                /// Favori listesinin başlığı
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Grid.m,
                  ),
                  child: FavoriteListingColumn(
                    onTap: () {
                      for (var element in _slidabelControllerList) {
                        element.close();
                      }
                    },
                    tefasSymbolDetails: tefasSymbolDetails,
                  ),
                )
              ],
              widget.showHeatMap

                  /// HeatMap gösterimine gecer
                  ? Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.only(
                          left: Grid.m,
                          right: Grid.m,
                          bottom: Grid.l,
                        ),
                        controller: _scrollController,
                        itemCount: widget.symbols.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisSpacing: 3,
                          crossAxisSpacing: 3,
                          crossAxisCount: 3,
                        ),
                        itemBuilder: (context, index) {
                          /// Sembolun tipine gore ilgili widget doner data guncellemeleri bu widgetlerin icinde gerceklesir
                          FavoriteListItem favoriteListItem = widget.symbols[index];
                          if (favoriteListItem.symbolSource == SymbolSourceEnum.matriks) {
                            return MatriksListTile(
                              key: ValueKey(favoriteListItem.symbol),
                              controller: _slidabelControllerList[index],
                              favoriteListItem: favoriteListItem,
                              showHeatMap: widget.showHeatMap,
                            );
                          }
                          if (favoriteListItem.symbolSource == SymbolSourceEnum.alpaca) {
                            return AlpacaListTile(
                              key: ValueKey(favoriteListItem.symbol),
                              controller: _slidabelControllerList[index],
                              favoriteListItem: favoriteListItem,
                              showHeatMap: widget.showHeatMap,
                            );
                          }
                          if (favoriteListItem.symbolSource == SymbolSourceEnum.tefas) {
                            return TefasListTile(
                              key: ValueKey(favoriteListItem.symbol),
                              controller: _slidabelControllerList[index],
                              favoriteListItem: favoriteListItem,
                              fundDetailModel: tefasSymbolDetails.firstWhereOrNull(
                                (element) => favoriteListItem.symbol == favoriteListItem.symbol,
                              ),
                              showHeatMap: widget.showHeatMap,
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    )

                  /// Liste gosterimine gecer
                  : widget.isHome
                      ? _getlistVisible()
                      : Expanded(
                          child: _getlistVisible(),
                        ),
            ],
          );
  }

  SlidableAutoCloseBehavior _getlistVisible() {
    return SlidableAutoCloseBehavior(
      child: ListView.separated(
        physics: widget.isHome ? const NeverScrollableScrollPhysics() : const AlwaysScrollableScrollPhysics(),
        controller: _scrollController,
        itemCount: widget.symbols.length,
        shrinkWrap: true,
        padding: EdgeInsets.only(
          bottom: !widget.isHome ? Grid.l : 0,
        ),
        separatorBuilder: (context, index) => const PDivider(
          padding: EdgeInsets.symmetric(
            horizontal: Grid.m,
          ),
        ),
        itemBuilder: (context, index) {
          /// Sembolun tipine gore ilgili widget doner data guncellemeleri bu widgetlerin icinde gerceklesir
          FavoriteListItem favoriteListItem = widget.symbols[index];
          if (favoriteListItem.symbolSource == SymbolSourceEnum.matriks) {
            return MatriksListTile(
              key: ValueKey(favoriteListItem.symbol),
              controller: _slidabelControllerList[index],
              favoriteListItem: favoriteListItem,
              showHeatMap: widget.showHeatMap,
            );
          }
          if (favoriteListItem.symbolSource == SymbolSourceEnum.alpaca) {
            return AlpacaListTile(
              key: ValueKey(favoriteListItem.symbol),
              controller: _slidabelControllerList[index],
              favoriteListItem: favoriteListItem,
              showHeatMap: widget.showHeatMap,
            );
          }
          if (favoriteListItem.symbolSource == SymbolSourceEnum.tefas) {
            return TefasListTile(
              key: ValueKey(favoriteListItem.symbol),
              controller: _slidabelControllerList[index],
              favoriteListItem: favoriteListItem,
              fundDetailModel:
                  tefasSymbolDetails.where((element) => element.code == favoriteListItem.symbol).firstOrNull,
              showHeatMap: widget.showHeatMap,
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
