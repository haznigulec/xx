import 'package:auto_route/auto_route.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:piapiri_v2/app/data_grid/widgets/slide_option.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/place_holder/no_data_widget.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piapiri_v2/app/search_symbol/bloc/symbol_search_bloc.dart';
import 'package:piapiri_v2/app/search_symbol/bloc/symbol_search_event.dart';
import 'package:piapiri_v2/app/search_symbol/bloc/symbol_search_state.dart';
import 'package:piapiri_v2/app/search_symbol/enum/symbol_search_filter_enum.dart';
import 'package:piapiri_v2/app/search_symbol/widgets/symbol_search_field.dart';
import 'package:piapiri_v2/app/search_symbol/widgets/symbol_search_filter.dart';
import 'package:piapiri_v2/app/search_symbol/widgets/symbol_search_tile.dart';
import 'package:piapiri_v2/common/utils/debouncer.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/symbol_model.dart';
import 'package:piapiri_v2/core/model/transaction_type_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';

@RoutePage()
class SymbolSearchPage extends StatefulWidget {
  final int? maxSelectedCount;
  final Function(List<SymbolModel>) onTapSymbol;
  final Function(List<SymbolModel>)? onTapDeleteSymbol;
  final bool showExchangesFilter;
  final String? title;
  final bool isCheckbox;
  final String? appBarTitle;
  final List<SymbolModel>? selectedSymbolList;
  final bool fromNewsAlarm;
  final bool fromPerformanceCompare;
  final List<SymbolSearchFilterEnum>? filterList;
  final SymbolSearchFilterEnum selectedFilter;
  final String? selectedUnderlying;
  final String? hintText;

  const SymbolSearchPage({
    super.key,
    this.maxSelectedCount,
    required this.onTapSymbol,
    this.onTapDeleteSymbol,
    this.showExchangesFilter = true,
    this.title,
    this.isCheckbox = false,
    this.appBarTitle,
    this.selectedSymbolList,
    this.fromNewsAlarm = false,
    this.fromPerformanceCompare = false,
    this.filterList,
    this.selectedFilter = SymbolSearchFilterEnum.all,
    this.selectedUnderlying,
    this.hintText,
  });

  @override
  State<SymbolSearchPage> createState() => _SymbolSearchPageState();
}

class _SymbolSearchPageState extends State<SymbolSearchPage> {
  late final SymbolSearchBloc _symbolSearchBloc;
  final TextEditingController _controller = TextEditingController();
  List<SymbolSearchFilterEnum> _filterList = [];
  final List<Map<String, dynamic>> _exchangeList = [
    {
      'Code': '0',
      'TrName': 'Tüm Semboller',
      'EnName': 'All Symbols',
    }
  ];
  String _selectedExchangeCode = '0';
  bool _showSearchResultList = false;
  final List<SymbolModel> _selectedSymbolList = [];
  late SymbolSearchFilterEnum _selectedFilter;
  String? _selectedUnderlying;
  String? _selectedMaturity;
  TransactionTypeEnum? _selectedTransactionType;
  final Debouncer _onSearchDebouncer = Debouncer(delay: const Duration(milliseconds: 500));
  @override
  void initState() {
    _symbolSearchBloc = getIt<SymbolSearchBloc>();
    _selectedFilter = widget.selectedFilter;
    _selectedUnderlying = widget.selectedUnderlying;
    _filterList = widget.filterList ?? SymbolSearchFilterEnum.values;
    if ((_selectedFilter == SymbolSearchFilterEnum.future || _selectedFilter == SymbolSearchFilterEnum.option) &&
        _selectedUnderlying != null) {
      _symbolSearchBloc.add(
        GetUnderlyingListEvent(filter: _selectedFilter, maturity: _selectedMaturity),
      );
      _symbolSearchBloc.add(
        GetMaturityListEvent(filter: _selectedFilter, underlying: _selectedUnderlying),
      );
      _searchSymbol();
    }
    _symbolSearchBloc.add(
      GetOldSearchesEvent(
        filterDbKeys: _getFilterDbKeys(),
      ),
    );
    _symbolSearchBloc.add(
      GetExchangeListEvent(
        callback: (results) {
          setState(() {
            _exchangeList.addAll(results);
          });
        },
      ),
    );

    if (widget.selectedSymbolList?.isNotEmpty == true) {
      _selectedSymbolList.addAll(widget.selectedSymbolList!);
    }

    super.initState();
  }

  @override
  dispose() {
    _onSearchDebouncer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !widget.fromPerformanceCompare,
      onPopInvokedWithResult: (didPop, pop) {
        if (didPop) return;
        context.router.maybePop([_selectedSymbolList]);
        Navigator.of(context).pop([_selectedSymbolList]);
      },
      child: Scaffold(
        appBar: widget.appBarTitle == null
            ? null
            : PInnerAppBar(
                usePopScope: false,
                title: widget.appBarTitle!,
              ),
        body: SafeArea(
          child: Stack(
            children: [
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: Grid.xs,
                  ),
                  child: BlocBuilder<SymbolSearchBloc, SymbolSearchState>(
                    bloc: _symbolSearchBloc,
                    builder: (context, state) {
                      List<SymbolModel> currentList = _showSearchResultList ? state.searchResults : state.oldSearches;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: Grid.s,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Grid.m,
                            ),
                            child: SymbolSearchField(
                              controller: _controller,
                              showCancelButton: !(widget.fromNewsAlarm || widget.fromPerformanceCompare),
                              onTapSuffix: () {
                                _controller.clear();
                                _showSearchResultList = false;
                                _symbolSearchBloc.add(
                                  GetOldSearchesEvent(
                                    filterDbKeys: _getFilterDbKeys(),
                                  ),
                                );
                                setState(() {});
                              },
                              onChanged: (value) {
                                _onSearchDebouncer.debounce(() async {
                                  _searchSymbol();
                                });
                              },
                            ),
                          ),
                          const SizedBox(
                            height: Grid.m + Grid.xs,
                          ),
                          if (widget.showExchangesFilter)
                            SymbolSearchFilter(
                              filterList: _filterList,
                              selectedFilter: _selectedFilter,
                              selectedUnderlying: widget.selectedUnderlying,
                              onFilterChanged: (
                                SymbolSearchFilterEnum filter,
                                String? underlying,
                                String? maturity,
                                TransactionTypeEnum? transactionType,
                              ) {
                                setState(() {
                                  _selectedFilter = filter;
                                  _selectedUnderlying = underlying;
                                  _selectedMaturity = maturity;
                                  _selectedTransactionType = transactionType;
                                });
                                _searchSymbol();
                                _symbolSearchBloc.add(
                                  GetOldSearchesEvent(
                                    filterDbKeys: _getFilterDbKeys(),
                                  ),
                                );
                              },
                            ),
                          if (!_showSearchResultList)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Grid.m,
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    L10n.tr('recent_searches'),
                                    style: context.pAppStyle.labelReg14textPrimary.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: Grid.s,
                                  ),
                                ],
                              ),
                            ),
                          Expanded(
                            child: state.isLoading
                                ? const PLoading()
                                : _showSearchResultList && currentList.isEmpty
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: Grid.m,
                                        ),
                                        child: NoDataWidget(
                                          iconName: ImagesPath.search,
                                          message: L10n.tr('no_search_data', args: [_controller.text]),
                                        ),
                                      )
                                    : SlidableAutoCloseBehavior(
                                        child: ListView.builder(
                                          itemCount: currentList.length,
                                          padding: EdgeInsets.only(
                                            bottom: !widget.isCheckbox ||
                                                    widget.fromNewsAlarm ||
                                                    widget.fromPerformanceCompare
                                                ? 0
                                                : 86,
                                          ),
                                          itemBuilder: (context, index) {
                                            final valueKeyStr = currentList[index].name + currentList[index].typeCode;
                                            return Slidable(
                                              key: ValueKey(valueKeyStr),
                                              enabled: !_showSearchResultList,
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
                                                        _symbolSearchBloc.add(
                                                          RemoveOldSearchesEvent(
                                                            symbolModel: currentList[index],
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              child: SymbolSearchTile(
                                                horizontalPadding: Grid.m,
                                                symbol: currentList[index],
                                                isSelected: _selectedSymbolList.any(
                                                  (element) =>
                                                      element.name == currentList[index].name &&
                                                      element.typeCode == currentList[index].typeCode,
                                                ),
                                                isCheckbox: widget.isCheckbox,
                                                onTapSymbol: (symbol) {
                                                  if (widget.isCheckbox) {
                                                    bool isSelected = _selectedSymbolList.any(
                                                      (e) => e.name == symbol.name && e.typeCode == symbol.typeCode,
                                                    );
                                                    if (isSelected) {
                                                      setState(
                                                        () {
                                                          if (widget.fromNewsAlarm || widget.fromPerformanceCompare) {
                                                            widget.onTapDeleteSymbol?.call([symbol]);
                                                          }
                                                          _selectedSymbolList.removeWhere(
                                                            (e) =>
                                                                e.name == symbol.name && e.typeCode == symbol.typeCode,
                                                          );
                                                        },
                                                      );
                                                    } else {
                                                      //Max selected control added
                                                      if (widget.maxSelectedCount != null &&
                                                          _selectedSymbolList.length == widget.maxSelectedCount) {
                                                        PBottomSheet.showError(
                                                          context,
                                                          content: L10n.tr(
                                                            'max_selected_message',
                                                            args: [
                                                              widget.maxSelectedCount.toString(),
                                                            ],
                                                          ),
                                                          showFilledButton: true,
                                                          filledButtonText: L10n.tr('tamam'),
                                                          onFilledButtonPressed: () {
                                                            Navigator.of(context).pop();
                                                          },
                                                        );
                                                        return;
                                                      }

                                                      if (widget.fromPerformanceCompare &&
                                                          _selectedSymbolList.isNotEmpty &&
                                                          _selectedSymbolList.first.typeCode != symbol.typeCode) {
                                                        PBottomSheet.showError(
                                                          context,
                                                          content: L10n.tr(
                                                            'diffrent_symbol_type_non_selectable_message',
                                                          ),
                                                          showFilledButton: true,
                                                          filledButtonText: L10n.tr('tamam'),
                                                          onFilledButtonPressed: () {
                                                            Navigator.of(context).pop();
                                                          },
                                                        );
                                                        return;
                                                      }

                                                      setState(() {
                                                        if (widget.fromNewsAlarm || widget.fromPerformanceCompare) {
                                                          widget.onTapSymbol([symbol]);
                                                        }
                                                        _selectedSymbolList.add(symbol);
                                                      });
                                                    }
                                                  } else {
                                                    widget.onTapSymbol([symbol]);
                                                    _symbolSearchBloc.add(
                                                      SetOldSearchesEvent(
                                                        symbolModel: symbol,
                                                      ),
                                                    );
                                                  }
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  !widget.isCheckbox || widget.fromNewsAlarm || widget.fromPerformanceCompare
                      ? const SizedBox.shrink()
                      : Container(
                          color: context.pColorScheme.backgroundColor,
                          padding: const EdgeInsets.all(
                            Grid.m,
                          ),
                          child: PButton(
                            text: L10n.tr('kaydet'),
                            fillParentWidth: true,
                            onPressed: () async {
                              widget.onTapSymbol(_selectedSymbolList);
                              await router.maybePop();
                            },
                          ),
                        ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _searchSymbol() {
    if ((_controller.text.isNotEmpty && _controller.text.length > 1) ||
        (_selectedUnderlying != null || _selectedMaturity != null || _selectedTransactionType?.value != null)) {
      _showSearchResultList = true;
      _symbolSearchBloc.add(
        SearchSymbolEvent(
          symbolName: _controller.text,
          exchangeCode: _selectedExchangeCode,
          underlying: _selectedUnderlying,
          maturity: _selectedMaturity,
          transactionType: _selectedTransactionType,
          callback: (results) {},
          filterDbKeys: _getFilterDbKeys(),
        ),
      );
      setState(() {}); // Refresh the UI when typing
    } else {
      setState(() {
        _showSearchResultList = false;
        _selectedExchangeCode = '0';
      });
    }
  }

  List<String> _getFilterDbKeys() {
    List<String> filterDbKeys = [];
    if (_selectedFilter == SymbolSearchFilterEnum.all) {
      for (SymbolSearchFilterEnum filter in _filterList) {
        if (filter.dbKeys != null) {
          for (var element in filter.dbKeys!) {
            filterDbKeys.add(element);
          }
        }
      }
    } else {
      filterDbKeys = _selectedFilter.dbKeys!;
    }
    return filterDbKeys;
  }
}
