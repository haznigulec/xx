import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/list/selection_list_item.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/ipo/widgets/filter_category_button.dart';
import 'package:piapiri_v2/app/viop/viop_constants.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/dynamic_indexed_stack.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/model/transaction_type_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class ViopFilterSheet extends StatefulWidget {
  final String? selectedMaturity;
  final SymbolTypes? selectedContractType;
  final TransactionTypeEnum? selectedTransactionType;
  final List<String> maturityList;
  final Function(String? maturity, SymbolTypes? contractType, TransactionTypeEnum? transactionType) onSetFilter;

  const ViopFilterSheet({
    super.key,
    this.selectedMaturity,
    this.selectedContractType,
    this.selectedTransactionType,
    required this.maturityList,
    required this.onSetFilter,
  });

  @override
  State<ViopFilterSheet> createState() => _ViopFilterSheetState();
}

class _ViopFilterSheetState extends State<ViopFilterSheet> {
  String? _selectedMaturity;
  SymbolTypes? _selectedContractType;
  TransactionTypeEnum? _selectedTransactionType;
  int _selectedCategory = 0;

  @override
  void initState() {
    super.initState();
    _selectedMaturity = widget.selectedMaturity;
    _selectedContractType = widget.selectedContractType;
    _selectedTransactionType = widget.selectedTransactionType;
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.7,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: Grid.m - Grid.xs,
                    ),
                    child: Column(
                      children: [
                        FilterCategoryButton(
                          isSelected: _selectedCategory == 0,
                          hasDivider: false,
                          hasSelectedFilter: _selectedMaturity != null,
                          onTap: () {
                            setState(() {
                              _selectedCategory = 0;
                            });
                          },
                          title: L10n.tr('maturity'),
                        ),
                        FilterCategoryButton(
                          isSelected: _selectedCategory == 1,
                          hasDivider: false,
                          hasSelectedFilter: _selectedContractType != null,
                          onTap: () {
                            setState(() {
                              _selectedCategory = 1;
                            });
                          },
                          title: L10n.tr('contract_type'),
                        ),
                        if (_selectedContractType == SymbolTypes.option)
                          FilterCategoryButton(
                            isSelected: _selectedCategory == 2,
                            hasDivider: false,
                            hasSelectedFilter: _selectedTransactionType != null,
                            onTap: () {
                              setState(() {
                                _selectedCategory = 2;
                              });
                            },
                            title: L10n.tr('islem_tipi'),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: Grid.s,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: Grid.m - Grid.xs,
                  ),
                  child: VerticalDivider(
                    width: 1,
                    thickness: 1,
                    color: context.pColorScheme.line,
                  ),
                ),
                const SizedBox(
                  width: Grid.s,
                ),
                Expanded(
                  flex: 2,
                  child: DynamicIndexedStack(
                    index: _selectedCategory,
                    children: [
                      _maturityWidget(),
                      _contractTypeWidget(),
                      _transactionTypeWidget(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: Grid.m,
          ),
          PButton(
            text: L10n.tr('kaydet'),
            fillParentWidth: true,
            onPressed: () {
              widget.onSetFilter(
                _selectedMaturity,
                _selectedContractType,
                _selectedTransactionType,
              );
              router.maybePop();
            },
          )
        ],
      ),
    );
  }

  Widget _maturityWidget() {
    return _selectedCategory != 0
        ? const SizedBox.shrink()
        : ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * 0.5,
            ),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: widget.maturityList
                    .map(
                      (e) => PRadioButtonListItem(
                        title: e,
                        value: e,
                        groupValue: _selectedMaturity,
                        onChanged: (value) {
                          setState(
                            () {
                              _selectedMaturity = value;
                            },
                          );
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
          );
  }

  Widget _contractTypeWidget() {
    return _selectedCategory != 1
        ? const SizedBox.shrink()
        : ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * 0.5,
            ),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: ViopConstants()
                    .contractTypes
                    .map(
                      (e) => PRadioButtonListItem(
                        value: e,
                        groupValue: _selectedContractType,
                        onChanged: (value) {
                          setState(() {
                            _selectedContractType = value;
                          });
                        },
                        title: L10n.tr(e.localization),
                      ),
                    )
                    .toList(),
              ),
            ),
          );
  }

  Widget _transactionTypeWidget() {
    return _selectedCategory != 2
        ? const SizedBox.shrink()
        : ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * 0.5,
            ),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: TransactionTypeEnum.values
                    .where((element) => element.value != null)
                    .toList()
                    .map(
                      (e) => PRadioButtonListItem(
                        value: e,
                        groupValue: _selectedTransactionType,
                        onChanged: (value) {
                          setState(() {
                            _selectedTransactionType = value;
                          });
                        },
                        title: L10n.tr(e.localizationKey),
                      ),
                    )
                    .toList(),
              ),
            ),
          );
  }
}
