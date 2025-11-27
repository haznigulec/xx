import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/search_symbol/bloc/symbol_search_bloc.dart';
import 'package:piapiri_v2/app/search_symbol/bloc/symbol_search_event.dart';
import 'package:piapiri_v2/app/search_symbol/bloc/symbol_search_state.dart';
import 'package:piapiri_v2/app/search_symbol/enum/symbol_search_filter_enum.dart';
import 'package:piapiri_v2/app/search_symbol/widgets/symbol_search_filter_chip.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/bottomsheet_select_tile.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/model/transaction_type_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class SymbolSearchFilter extends StatefulWidget {
  final List<SymbolSearchFilterEnum> filterList;
  final SymbolSearchFilterEnum? selectedFilter;
  final String? selectedUnderlying;
  final Function(
          SymbolSearchFilterEnum filter, String? underlying, String? maturity, TransactionTypeEnum? transactionType)
      onFilterChanged;

  const SymbolSearchFilter({
    super.key,
    required this.filterList,
    this.selectedFilter,
    this.selectedUnderlying,
    required this.onFilterChanged,
  });

  @override
  State<SymbolSearchFilter> createState() => _SymbolSearchFilterState();
}

class _SymbolSearchFilterState extends State<SymbolSearchFilter> {
  late SymbolSearchBloc _symbolSearchBloc;
  late ScrollController _firstRowController;
  late ScrollController _secondRowController;
  String? _selectedUnderlying;
  String? _selectedMaturity;
  TransactionTypeEnum? _selectedTransactionType;

  @override
  void initState() {
    super.initState();
    _symbolSearchBloc = getIt<SymbolSearchBloc>();
    _selectedUnderlying = widget.selectedUnderlying;
    _firstRowController = ScrollController();
    _secondRowController = ScrollController();
  }

  @override
  void dispose() {
    _firstRowController.dispose();
    _secondRowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool showSecondRowFilter = widget.filterList.length > 5;
    int secondRowFilterstartIndex = showSecondRowFilter ? 5 : widget.filterList.length;

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          SizedBox(
            height: 28,
            child: ListView.separated(
              controller: _firstRowController,
              padding: const EdgeInsets.symmetric(
                horizontal: Grid.m,
              ),
              itemCount: widget.filterList.take(secondRowFilterstartIndex).length,
              separatorBuilder: (context, index) => const SizedBox(
                width: 8,
              ),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return SymbolSearchFilterChip(
                  text: L10n.tr(widget.filterList[index].localization),
                  isSelected:
                      widget.selectedFilter != null ? widget.selectedFilter == widget.filterList[index] : index == 0,
                  onTap: () {
                    setState(() {
                      _selectedUnderlying = null;
                      _selectedMaturity = null;
                      _selectedTransactionType = null;
                    });

                    if (widget.filterList[index] == SymbolSearchFilterEnum.option ||
                        widget.filterList[index] == SymbolSearchFilterEnum.future) {
                      _symbolSearchBloc.add(
                        GetMaturityListEvent(
                          filter: widget.filterList[index],
                          underlying: _selectedUnderlying,
                        ),
                      );
                      _symbolSearchBloc.add(
                        GetUnderlyingListEvent(
                          filter: widget.filterList[index],
                          maturity: _selectedMaturity,
                        ),
                      );
                    }

                    widget.onFilterChanged(
                      widget.filterList[index],
                      _selectedUnderlying,
                      _selectedMaturity,
                      _selectedTransactionType,
                    );

                    _firstRowController.animateTo(
                      index * 80.0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                );
              },
            ),
          ),
          if (showSecondRowFilter) ...[
            const SizedBox(
              height: Grid.s + Grid.xs,
            ),
            SizedBox(
              height: 28,
              child: ListView.separated(
                controller: _secondRowController,
                padding: const EdgeInsets.symmetric(
                  horizontal: Grid.m,
                ),
                itemCount: widget.filterList.skip(secondRowFilterstartIndex).length,
                separatorBuilder: (context, index) => const SizedBox(
                  width: Grid.s,
                ),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, idx) {
                  int index = idx + secondRowFilterstartIndex;
                  return SymbolSearchFilterChip(
                    text: L10n.tr(widget.filterList[index].localization),
                    isSelected:
                        widget.selectedFilter != null ? widget.selectedFilter == widget.filterList[index] : index == 0,
                    onTap: () {
                      setState(() {
                        _selectedUnderlying = null;
                        _selectedMaturity = null;
                        _selectedTransactionType = null;
                      });

                      widget.onFilterChanged(
                        widget.filterList[index],
                        _selectedUnderlying,
                        _selectedMaturity,
                        _selectedTransactionType,
                      );

                      _secondRowController.animateTo(
                        idx * 80.0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  );
                },
              ),
            ),
          ],
          const SizedBox(
            height: Grid.s + Grid.xs,
          ),

          // Filtre detayları (Future/Option seçilirse)
          if (widget.selectedFilter == SymbolSearchFilterEnum.future ||
              widget.selectedFilter == SymbolSearchFilterEnum.option)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Grid.m,
              ),
              child: PBlocBuilder<SymbolSearchBloc, SymbolSearchState>(
                bloc: _symbolSearchBloc,
                builder: (context, state) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 17,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              L10n.tr(widget.selectedFilter == SymbolSearchFilterEnum.future
                                  ? 'futures_trade_filters'
                                  : 'option_market_filters'),
                              textAlign: TextAlign.center,
                              style: context.pAppStyle.labelMed16primary.copyWith(height: 0.6),
                            ),
                            const SizedBox(
                              width: Grid.s,
                            ),
                            const Expanded(
                              child: PDivider(),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: Grid.s + Grid.xs,
                      ),
                      Row(
                        children: [
                          PCustomOutlinedButtonWithIcon(
                            text: _selectedUnderlying ?? L10n.tr('underlying_asset'),
                            iconSource: ImagesPath.chevron_down,
                            foregroundColorApllyBorder: false,
                            foregroundColor: _selectedUnderlying != null ? context.pColorScheme.primary : null,
                            backgroundColor: _selectedUnderlying != null ? context.pColorScheme.secondary : null,
                            iconAlignment: IconAlignment.end,
                            onPressed: () => _showUnderlyingBottomSheet(context, state),
                          ),
                          if (widget.selectedFilter == SymbolSearchFilterEnum.option) ...[
                            const SizedBox(width: Grid.s),
                            PCustomOutlinedButtonWithIcon(
                              text: L10n.tr(_selectedTransactionType?.value != null
                                  ? _selectedTransactionType!.localizationKey
                                  : 'islem_tipi'),
                              iconSource: ImagesPath.chevron_down,
                              foregroundColorApllyBorder: false,
                              foregroundColor:
                                  _selectedTransactionType?.value != null ? context.pColorScheme.primary : null,
                              backgroundColor:
                                  _selectedTransactionType?.value != null ? context.pColorScheme.secondary : null,
                              iconAlignment: IconAlignment.end,
                              onPressed: () => _showTransactionTypeBottomSheet(context),
                            ),
                          ],
                          const SizedBox(width: Grid.s),
                          PCustomOutlinedButtonWithIcon(
                            text: _selectedMaturity ?? L10n.tr('maturity'),
                            iconSource: ImagesPath.chevron_down,
                            foregroundColorApllyBorder: false,
                            foregroundColor: _selectedMaturity != null ? context.pColorScheme.primary : null,
                            backgroundColor: _selectedMaturity != null ? context.pColorScheme.secondary : null,
                            iconAlignment: IconAlignment.end,
                            onPressed: () => _showMaturityBottomSheet(context, state),
                          ),
                        ],
                      ),
                      const SizedBox(height: Grid.s + Grid.xs),
                      const PDivider(),
                      const SizedBox(height: Grid.s),
                    ],
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  void _showUnderlyingBottomSheet(BuildContext context, SymbolSearchState state) {
    PBottomSheet.show(
      context,
      title: L10n.tr('underlying_asset'),
      child: Container(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
        child: ListView.separated(
          itemCount: state.underlyingList.length,
          shrinkWrap: true,
          separatorBuilder: (context, _) => const PDivider(),
          itemBuilder: (context, index) => BottomsheetSelectTile(
            title: state.underlyingList[index],
            isSelected: false,
            prefix: index == 0
                ? const SizedBox(
                    width: Grid.m - Grid.xxs,
                  )
                : SymbolIcon(
                    symbolName: state.underlyingList[index],
                    symbolType: widget.selectedFilter == SymbolSearchFilterEnum.future
                        ? SymbolTypes.future
                        : SymbolTypes.option,
                    size: 14,
                  ),
            onTap: (String title, value) {
              setState(() {
                title == L10n.tr('all') ? _selectedUnderlying = null : _selectedUnderlying = title;
              });
              _symbolSearchBloc.add(
                GetMaturityListEvent(
                  filter: widget.selectedFilter ?? SymbolSearchFilterEnum.all,
                  underlying: _selectedUnderlying,
                ),
              );
              widget.onFilterChanged(
                widget.selectedFilter ?? SymbolSearchFilterEnum.all,
                _selectedUnderlying,
                _selectedMaturity,
                _selectedTransactionType,
              );
              router.maybePop();
            },
          ),
        ),
      ),
    );
  }

  void _showTransactionTypeBottomSheet(BuildContext context) {
    List<TransactionTypeEnum> transactionTypeList = TransactionTypeEnum.values;
    PBottomSheet.show(
      context,
      title: L10n.tr('islem_tipi'),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.3,
        ),
        child: ListView.separated(
          itemCount: transactionTypeList.length,
          shrinkWrap: true,
          separatorBuilder: (context, _) => const PDivider(),
          itemBuilder: (context, index) => BottomsheetSelectTile(
            title: L10n.tr(transactionTypeList[index].localizationKey),
            value: transactionTypeList[index],
            isSelected: _selectedTransactionType == null && index == 0 ||
                _selectedTransactionType == transactionTypeList[index],
            onTap: (String title, value) {
              setState(() {
                _selectedTransactionType = value;
              });
              widget.onFilterChanged(
                widget.selectedFilter ?? SymbolSearchFilterEnum.all,
                _selectedUnderlying,
                _selectedMaturity,
                _selectedTransactionType,
              );
              router.maybePop();
            },
          ),
        ),
      ),
    );
  }

  void _showMaturityBottomSheet(BuildContext context, SymbolSearchState state) {
    PBottomSheet.show(
      context,
      title: L10n.tr('maturity'),
      child: Container(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
        child: ListView.separated(
          itemCount: state.maturityList.length,
          shrinkWrap: true,
          separatorBuilder: (context, _) => const PDivider(),
          itemBuilder: (context, index) => BottomsheetSelectTile(
            title: state.maturityList[index],
            isSelected: _selectedMaturity == null && index == 0 || _selectedMaturity == state.maturityList[index],
            onTap: (String title, value) {
              setState(() {
                title == L10n.tr('all_maturities') ? _selectedMaturity = null : _selectedMaturity = title;
              });
              _symbolSearchBloc.add(
                GetUnderlyingListEvent(
                  filter: widget.selectedFilter ?? SymbolSearchFilterEnum.all,
                  maturity: _selectedMaturity,
                ),
              );
              widget.onFilterChanged(
                widget.selectedFilter ?? SymbolSearchFilterEnum.all,
                _selectedUnderlying,
                _selectedMaturity,
                _selectedTransactionType,
              );
              router.maybePop();
            },
          ),
        ),
      ),
    );
  }
}
