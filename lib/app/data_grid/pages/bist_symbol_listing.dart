import 'dart:async';

import 'package:collection/collection.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/app/data_grid/widgets/american_underlying.dart';
import 'package:piapiri_v2/app/data_grid/widgets/bist_underlying.dart';
import 'package:piapiri_v2/app/data_grid/widgets/grid_box.dart';
import 'package:piapiri_v2/app/data_grid/widgets/symbol_list_column.dart';
import 'package:piapiri_v2/app/favorite_lists/bloc/favorite_list_bloc.dart';
import 'package:piapiri_v2/app/favorite_lists/bloc/favorite_list_event.dart';
import 'package:piapiri_v2/app/symbol_detail/symbol_detail_utils.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/progress_indicators/shimmerize.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_consumer.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_bloc.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_event.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_state.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/ranker_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class BistSymbolListing extends StatefulWidget {
  /// Listelenmek istenen semboller
  final List<MarketListModel> symbols;

  /// Sembol listesinde gösterilecek sütunlar. Max 3 sütun olabilir.
  final List<String> columns;

  /// Column boşluklarını eşitlemek için kullanılır
  final bool columnsSpacingIsEqual;

  /// Liste görünümündeki ScrollPhysics
  final ScrollPhysics? listScrollPhysics;

  /// Sembol listesindeki her bir eleman için oluşturulacak widget
  final Widget Function(MarketListModel symbol, SlidableController controller) itemBuilder;

  /// Sıralama özelliğinin aktif olup olmadığını belirler. Varsayılan değeri true'dir.
  final bool sortEnabled;

  ///Yukselenler dusenler listesi icin subscribe olunacak key
  final String? statsKey;

  ///Gosterilmek istenen Ranker List
  final RankerEnum? rankerEnum;

  ///Yukselenler dusenler listesi icin gosterilecek eleman sayisi
  final int? rankerListLength;

  /// En ustteki Divideri kaldirir. Varsayılan değeri true'dir.
  final bool showTopDivider;

  /// Ilk sutunun yanına icon eklemek için kullanılır.
  final Widget? columnIcon;

  /// Gosterilen listenin varsa dayanak varligi
  final String? underlyingName;

  /// Eğer sembol listesi boş ise gösterilecek mesajın key'i
  final String emptyListKey;

  /// HeatMap özelliğinin aktif olup olmadığını belirler. Varsayılan değeri false'dir.
  final bool heatMapEnabled;

  // Listenin altina konulacak paddingi alir
  final EdgeInsets listBottomPadding;

  // Listeden cikarken unsub yapilmayacak hisselerin listesini alir
  final List<String> ignoreUnsubList;

  // outPadding kullanılan yerde itemBuilder' a margin geçilmeli
  final EdgeInsets outPadding;

  final double horizontalPadding;

  final String? heatMapSortKey;

  const BistSymbolListing({
    super.key,
    required this.symbols,
    required this.columns,
    this.columnsSpacingIsEqual = false,
    this.listScrollPhysics,
    required this.itemBuilder,
    this.sortEnabled = true,
    this.statsKey,
    this.rankerEnum,
    this.rankerListLength,
    this.showTopDivider = true,
    this.columnIcon,
    this.underlyingName,
    this.emptyListKey = 'no_data',
    this.heatMapEnabled = false,
    this.listBottomPadding = EdgeInsets.zero,
    this.ignoreUnsubList = const [],
    this.outPadding = EdgeInsets.zero,
    this.horizontalPadding = 0,
    this.heatMapSortKey,
  });
  @override
  State<BistSymbolListing> createState() => _BistSymbolListingState();
}

class _BistSymbolListingState extends State<BistSymbolListing> with TickerProviderStateMixin {
  late SymbolBloc _symbolBloc;
  late FavoriteListBloc _favoriteListBloc;
  final List<MarketListModel> _symbolList = [];
  final Map<String, int> _initialOrder = {};
  late List<String> _symbolNames;
  bool _isSortAscending = true;
  List<SlidableController> _slidabelControllerList = [];
  final ScrollController _scrollController = ScrollController();
  List<MarketListModel> _watchingItems = [];
  List<GlobalObjectKey> _keys = [];
  bool? _isUnderlyingAmerican;
  Timer? _scrollTimer;
  final GlobalKey _listViewKey = GlobalKey();
  bool _isWrapExpanded = true;

  @override
  initState() {
    _symbolBloc = getIt<SymbolBloc>();
    _favoriteListBloc = getIt<FavoriteListBloc>();

    if (getIt<AuthBloc>().state.isLoggedIn) {
      _favoriteListBloc.add(
        GetListEvent(),
      );
    }
    if (widget.statsKey != null && widget.rankerEnum != null) {
      _symbolBloc.add(
        SymbolSubscribeStatsEvent(
          statsKey: widget.statsKey!,
          unsubscribeKey: '',
          rankerEnum: widget.rankerEnum!,
        ),
      );
      _keys = List.generate(35, (index) => GlobalObjectKey(index));
      _slidabelControllerList = List.generate(35, (index) => SlidableController(this));
    } else {
      _symbolList.addAll(widget.symbols);

      for (var i = 0; i < _symbolList.length; i++) {
        _initialOrder[_symbolList[i].symbolCode] = i;
      }

      _scrollController.addListener(_onScroll);
      _slidabelControllerList = List.generate(_symbolList.length, (index) => SlidableController(this));
      _keys = _symbolList.map((e) => GlobalObjectKey(e.symbolCode)).toList();
      int watchItemsLength = widget.heatMapEnabled ? 18 : 14;
      _watchingItems = _symbolList.length < watchItemsLength ? _symbolList : _symbolList.sublist(0, watchItemsLength);

      getAlreadySubscribedSymbols();
      List<MarketListModel> subsList = _symbolList
          .where((element) => _watchingItems.map((e) => e.symbolCode).contains(element.symbolCode))
          .toList(growable: true);

      if (widget.underlyingName != null) {
        _symbolBloc.add(
          GetSymbolDetailEvent(
            symbolName: widget.underlyingName!,
            callback: (MarketListModel symbolModel) {
              setState(() {
                _isUnderlyingAmerican = symbolModel.exchangeCode.isEmpty && symbolModel.marketCode.isEmpty;
              });
              if (!_isUnderlyingAmerican!) {
                subsList.add(symbolModel);
              }
              _symbolBloc.add(
                SymbolSubTopicsEvent(
                  symbols: subsList,
                ),
              );
              _updateSubscriptions(addSubsList: [if (!_isUnderlyingAmerican!) symbolModel]);
            },
          ),
        );
      } else {
        _symbolBloc.add(
          SymbolSubTopicsEvent(
            symbols: subsList,
          ),
        );
      }
    }
    _symbolNames = _symbolList.map((e) => e.symbolCode).toList();

    super.initState();
  }

  ///Heatmap tusu trigger edildiginde subscribe olunmasi gereken sembollerin listesini gunceller
  @override
  void didUpdateWidget(covariant BistSymbolListing oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Heatmap AÇIKTAN KAPALIYA geçtiyse ve normal listedeysek,
    // listeyi ilk haline döndür
    if (oldWidget.heatMapEnabled == true && widget.heatMapEnabled == false && widget.statsKey == null) {
      _resetSortToInitialOrder();
      return; // aşağıdakileri çalıştırma
    }

    if (widget.heatMapEnabled != oldWidget.heatMapEnabled) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updateSubscriptions();
      });
    }

    // HeatMap açıkken sort değiştiyse, o anki listeyi bir kere sırala
    if (widget.heatMapEnabled &&
        widget.statsKey == null && // ranker listelerden bağımsız, sadece normal listede
        widget.heatMapSortKey != oldWidget.heatMapSortKey) {
      _sortHeatMapOnce(widget.heatMapSortKey);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _scrollTimer?.cancel();
    if (widget.statsKey != null && widget.rankerEnum != null) {
      _symbolBloc.add(
        SymbolUnsubcribeRankerListEvent(
          statsKey: widget.statsKey!,
          rankerEnum: widget.rankerEnum!,
        ),
      );
    }
    List<MarketListModel> unSubsList = _symbolList;
    if (!(_isUnderlyingAmerican ?? false) && widget.underlyingName != null) {
      unSubsList.add(
        MarketListModel(
          symbolCode: widget.underlyingName!,
          updateDate: '',
        ),
      );
    }
    unSubsList = unSubsList.where((element) => !widget.ignoreUnsubList.contains(element.symbolCode)).toList();
    _symbolBloc.add(
      SymbolUnsubsubscribeEvent(
        symbolList: unSubsList,
      ),
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.columns.length > 3) {
      throw Exception('columns length must be less than 3');
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: widget.horizontalPadding,
      ),
      child: Column(
        children: [
          if (widget.underlyingName != null &&
              !widget.heatMapEnabled &&
              (widget.statsKey != null || _symbolNames.isNotEmpty)) ...[
            Shimmerize(
              enabled: _isUnderlyingAmerican == null,
              child: _isUnderlyingAmerican ?? false
                  ? Padding(
                      padding: widget.outPadding,
                      child: AmericanUnderlying(
                        key: ValueKey('AMERICAN_UNDERLYING_${widget.underlyingName!}'),
                        underlyingName: widget.underlyingName!,
                      ),
                    )
                  : Padding(
                      padding: widget.outPadding,
                      child: BistUnderlying(
                        key: ValueKey('BIST_UNDERLYING_${widget.underlyingName!}'),
                        underlyingName: widget.underlyingName!,
                      ),
                    ),
            ),
            const SizedBox(
              height: Grid.s + Grid.xs,
            ),
          ],
          if (!widget.heatMapEnabled)
            SymbolListColumn(
              columns: widget.columns,
              columnsSpacingIsEqual: widget.columnsSpacingIsEqual,
              extraPadding: widget.outPadding,
              sortEnabled: widget.sortEnabled,
              showTopDivider: widget.showTopDivider,
              columnIcon: widget.columnIcon,
              onTapSort: () async {
                _isWrapExpanded = shouldWrapExpanded();
                setState(() {
                  _isSortAscending = !_isSortAscending;
                });
                _scrollController.jumpTo(
                  !_isSortAscending
                      ? _scrollController.position.maxScrollExtent
                      : _scrollController.position.minScrollExtent,
                );
                for (var element in _slidabelControllerList) {
                  element.close();
                }
                _updateSubscriptions();
              },
            ),
          if (widget.statsKey == null && _symbolNames.isEmpty)
            Expanded(
              child: Padding(
                padding: widget.outPadding,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      ImagesPath.search,
                      width: 32,
                      height: 32,
                      colorFilter: ColorFilter.mode(
                        context.pColorScheme.iconSecondary,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(
                      height: Grid.m,
                    ),
                    Text(
                      L10n.tr(widget.emptyListKey),
                      style: context.pAppStyle.labelReg14textPrimary,
                    )
                  ],
                ),
              ),
            )
          else ...[
            PBlocConsumer<SymbolBloc, SymbolState>(
                bloc: _symbolBloc,
                buildWhen: (previous, current) => widget.rankerEnum == RankerEnum.future
                    ? previous.viopRankerList != current.viopRankerList
                    : widget.rankerEnum == RankerEnum.equity
                        ? previous.equityRankerList != current.equityRankerList
                        : previous.warrantRankerList != current.warrantRankerList,
                listenWhen: (previous, current) =>
                    previous.type != current.type &&
                    (current.type == PageState.updated || current.type == PageState.success) &&
                    _symbolNames.contains(current.updatedSymbol.symbolCode),
                listener: (context, state) {
                  int indexOfSymbol =
                      _symbolList.indexWhere((element) => element.symbolCode == state.updatedSymbol.symbolCode);
                  if (indexOfSymbol == -1) return;

                  MarketListModel marketListModel = SymbolDetailUtils().fetchWithSubscribedSymbol(
                    state.updatedSymbol,
                    _symbolList[indexOfSymbol],
                  );

                  setState(() {
                    _symbolList.removeAt(indexOfSymbol);
                    _symbolList.insert(indexOfSymbol, marketListModel);
                  });
                },
                builder: (context, state) {
                  if ((state.type == PageState.loading) && widget.statsKey == null) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  List<MarketListModel> currentSymbolList = widget.rankerEnum == RankerEnum.future
                      ? state.viopRankerList
                      : widget.statsKey != null
                          ? widget.rankerEnum == RankerEnum.equity
                              ? state.equityRankerList
                              : state.warrantRankerList
                          : _symbolList;
                  if (currentSymbolList.isNotEmpty) {
                    return wrapExpanded(
                      widget.heatMapEnabled
                          ? Padding(
                              padding: widget.outPadding,
                              child: GridView.builder(
                                  controller: _scrollController,
                                  itemCount: widget.rankerListLength ?? currentSymbolList.length,
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    mainAxisSpacing: 3,
                                    crossAxisSpacing: 3,
                                    crossAxisCount: 3,
                                  ),
                                  itemBuilder: (context, index) {
                                    MarketListModel marketListModel = currentSymbolList[index];
                                    return GridBox(
                                      key: _keys[index],
                                      onTapGrid: (symbol) => router.push(
                                        SymbolDetailRoute(
                                          symbol: symbol,
                                          ignoreDispose: true,
                                        ),
                                      ),
                                      symbol: marketListModel,
                                    );
                                  }),
                            )
                          : ListView.separated(
                              key: _listViewKey,
                              controller: _scrollController,
                              reverse: !_isSortAscending,
                              physics: widget.listScrollPhysics,
                              itemCount: widget.rankerListLength ?? currentSymbolList.length,
                              shrinkWrap: true,
                              padding: widget.listBottomPadding,
                              itemBuilder: (context, index) {
                                if (index >= currentSymbolList.length) return const SizedBox();
                                MarketListModel marketListModel = currentSymbolList[index];
                                return widget.statsKey != null
                                    ? widget.itemBuilder(marketListModel, _slidabelControllerList[index])
                                    : Container(
                                        key: _keys[index],
                                        child: widget.itemBuilder(
                                          marketListModel,
                                          _slidabelControllerList[index],
                                        ),
                                      );
                              },
                              separatorBuilder: (context, index) => PDivider(
                                padding: widget.outPadding,
                              ),
                            ),
                    );
                  } else {
                    return const SizedBox();
                  }
                }),
          ],
        ],
      ),
    );
  }

  void _resetSortToInitialOrder() {
    if (_initialOrder.isEmpty || _symbolList.isEmpty) return;

    setState(() {
      _symbolList.sort((a, b) {
        final ai = _initialOrder[a.symbolCode] ?? 1 << 20;
        final bi = _initialOrder[b.symbolCode] ?? 1 << 20;
        return ai.compareTo(bi);
      });
      _keys = _symbolList.map((e) => GlobalObjectKey(e.symbolCode)).toList();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isSortAscending) {
        _scrollController.jumpTo(
          _scrollController.position.maxScrollExtent,
        );
      }

      _updateSubscriptions();
    });
  }

  void _sortHeatMapOnce(String? sortKey) {
    if (sortKey == null) return;
    if (_symbolList.isEmpty) return;

    setState(() {
      // 1) A-Z / Z-A: TÜM listeyi sırala
      if (sortKey == 'a_to_z' || sortKey == 'z_to_a') {
        _symbolList.sort((a, b) {
          final cmp = a.symbolCode.compareTo(b.symbolCode);
          return sortKey == 'a_to_z' ? cmp : -cmp;
        });
      } else {
        // 2) Diğer tüm sıralamalar: sadece subscribe olmuşları sırala

        // Subscribe olmuş semboller (hem bloc state hem de _watchingItems üzerinden)
        final subscribedCodes = <String>{
          ..._symbolBloc.state.watchingItems.map((e) => e.symbolCode),
          ..._watchingItems.map((e) => e.symbolCode),
        };

        // Mevcut sırayı korumak için önce kopya alıyoruz
        final List<MarketListModel> all = List<MarketListModel>.from(_symbolList);

        // Sıralanacak olanlar: subscribe olmuş olanlar
        final List<MarketListModel> subscribed = all.where((e) => subscribedCodes.contains(e.symbolCode)).toList();

        // Dokunulmayacak olanlar: subscribe olmayanlar (kendi iç sıraları korunacak)
        final List<MarketListModel> notSubscribed = all.where((e) => !subscribedCodes.contains(e.symbolCode)).toList();

        switch (sortKey) {
          case 'difference_up':
            subscribed.sort((a, b) => a.differencePercent.compareTo(b.differencePercent));
            break;
          case 'difference_down':
            subscribed.sort((a, b) => b.differencePercent.compareTo(a.differencePercent));
            break;
          case 'last_price_up':
            subscribed.sort((a, b) => MoneyUtils().getPrice(a, null).compareTo(MoneyUtils().getPrice(b, null)));
            break;
          case 'last_price_down':
            subscribed.sort((a, b) => MoneyUtils().getPrice(b, null).compareTo(MoneyUtils().getPrice(a, null)));
            break;
        }

        // Yeni liste: önce subscribe olanlar (sıralı), sonra olmayanlar (eski sırayla)
        _symbolList
          ..clear()
          ..addAll(subscribed)
          ..addAll(notSubscribed);
      }

      // Key ve watching list güncelle
      _keys = _symbolList.map((e) => GlobalObjectKey(e.symbolCode)).toList();
    });

    // Yeni sıraya göre yeniden subscribe et
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateSubscriptions();
    });
  }

  /// Scroll eventi tetiklendiginde subscribe olunmasi gereken sembollerin listesini gunceller.
  ///  Timer kullanilmasinin sebebi scroll islemi tamamlandiginda bu fonskiyonun calismasi.
  void _onScroll() {
    _scrollTimer?.cancel();
    _scrollTimer = Timer(const Duration(milliseconds: 200), _updateSubscriptions);
  }

  ///Ekranda gozuken elemanlari yakalayarak subscribe olunmasi gereken sembollerin listesini gunceller.
  void _updateSubscriptions({
    List<MarketListModel>? addSubsList,
  }) {
    if (!mounted) return;

    final RenderBox? listViewBox = context.findRenderObject() as RenderBox?;
    if (listViewBox == null) return;

    final double listViewTop = listViewBox.localToGlobal(Offset.zero).dy;
    final double listViewBottom = listViewTop + listViewBox.size.height;

    Set<String> currentlyVisibleSymbols = {};

    for (var marketListModel in _symbolList) {
      final key = GlobalObjectKey(marketListModel.symbolCode);
      final RenderObject? renderObject = key.currentContext?.findRenderObject();

      if (renderObject is RenderBox) {
        final Offset offset = renderObject.localToGlobal(Offset.zero);
        final double itemTop = offset.dy;
        final double itemBottom = itemTop + renderObject.size.height;

        if (itemBottom > listViewTop && itemTop < listViewBottom) {
          currentlyVisibleSymbols.add(marketListModel.symbolCode);
        }
      }
    }

    List<String> subscribeList =
        currentlyVisibleSymbols.difference(_watchingItems.map((e) => e.symbolCode).toSet()).toList();

    List<String> unsubscribeList =
        _watchingItems.map((e) => e.symbolCode).toSet().difference(currentlyVisibleSymbols).toList();
    susbcribeList(subscribeList, unsubscribeList);

    _watchingItems = _symbolList.where((element) => currentlyVisibleSymbols.contains(element.symbolCode)).toList();
  }

  void susbcribeList(List<String> susbcribe, List<String> unSubscribe) {
    _symbolBloc.add(
      SymbolSubTopicsEvent(
        symbols: _symbolList
            .where(
              (element) => susbcribe.contains(
                element.symbolCode,
              ),
            )
            .toList(),
      ),
    );
    //     _symbolBloc.add(
    //   SymbolUnsubsubscribeEvent(
    //     symbolList: _symbolList
    //         .where(
    //           (element) => unSubscribe.contains(
    //             element.symbolCode,
    //           ),
    //         )
    //         .toList(),
    //   ),
    // );
  }

  ///Listviewin ekranda kapladigi yukseklik ile listenin icindeki verilerin yuksekligini karsilastirir.
  ///Eger listviewin kapladigi yukseklik, listviewin icindeki verilerin yuksekliginden kucukse true doner.
  bool shouldWrapExpanded() {
    double listViewHeight = 0;

    final listViewContext = _listViewKey.currentContext;
    if (listViewContext != null) {
      final listViewRenderObject = listViewContext.findRenderObject();
      if (listViewRenderObject is RenderBox && listViewRenderObject.hasSize) {
        listViewHeight = listViewRenderObject.size.height;
      }
    }

    double listViewItemsHeight = 0;
    for (final key in _keys) {
      final ctx = key.currentContext;
      if (ctx == null) continue;
      final ro = ctx.findRenderObject();
      if (ro is RenderBox && ro.hasSize) {
        listViewItemsHeight += ro.size.height;
      }
    }

    return listViewHeight < listViewItemsHeight;
  }

  ///Listenin icindeki veriler expanded a gerek kalmadan ekrana sigiyor ise Expanded widgetini kullanmaz.
  Widget wrapExpanded(Widget child) {
    return _isWrapExpanded ? Expanded(child: child) : child;
  }

  // Zaten subscribe olunmus sembollerin initialDatasi gelmedigi icin BlocConsumer ile bu hisselerin fiyatlari yakalanamiyor.
  // Bu yuzden subscribe olunmus sembollerin baslangic fiyatlari burada cekiliyor ve consumer da update ediliyor.
  void getAlreadySubscribedSymbols() {
    for (MarketListModel symbol in _symbolList) {
      MarketListModel? marketListModel =
          _symbolBloc.state.watchingItems.firstWhereOrNull((element) => element.symbolCode == symbol.symbolCode);
      if (marketListModel != null) {
        int indexOfSymbol = _symbolList.indexWhere((element) => element.symbolCode == symbol.symbolCode);
        if (indexOfSymbol == -1) return;
        MarketListModel removedModel = _symbolList.removeAt(indexOfSymbol);
        if (indexOfSymbol > _symbolList.length - 1) {
          _symbolList.add(
            SymbolDetailUtils().fetchWithSubscribedSymbol(
              marketListModel,
              removedModel,
            ),
          );
        } else {
          _symbolList.insert(
            indexOfSymbol,
            SymbolDetailUtils().fetchWithSubscribedSymbol(
              marketListModel,
              removedModel,
            ),
          );
        }
      }
    }
  }
}
