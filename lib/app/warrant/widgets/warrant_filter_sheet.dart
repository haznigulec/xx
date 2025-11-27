import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/list/selection_list_item.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/ipo/widgets/filter_category_button.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/dynamic_indexed_stack.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/model/risk_level_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class WarrantFilterSheet extends StatefulWidget {
  final Set<String> maturityDateSet;
  final String? selectedMaturity;
  final RiskLevelEnum? selectedRisk;
  final String? selectedType;
  final Function(String?, RiskLevelEnum?, String?) onSetFilter;

  const WarrantFilterSheet({
    super.key,
    required this.onSetFilter,
    required this.maturityDateSet,
    this.selectedMaturity,
    this.selectedRisk,
    this.selectedType,
  });

  @override
  State<WarrantFilterSheet> createState() => _WarrantFilterSheetState();
}

class _WarrantFilterSheetState extends State<WarrantFilterSheet> {
  String? _selectedMaturity;
  String? _selectedType;
  RiskLevelEnum? _selectedRisk;
  int _selectedCategory = 0;

  @override
  void initState() {
    super.initState();
    _selectedMaturity = widget.selectedMaturity;
    _selectedType = widget.selectedType;
    _selectedRisk = widget.selectedRisk;
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
                          title: L10n.tr('warrant.filter.maturity'),
                          isSelected: _selectedCategory == 0,
                          hasDivider: false,
                          hasSelectedFilter: _selectedMaturity != null,
                          onTap: () {
                            setState(() {
                              _selectedCategory = 0;
                            });
                          },
                        ),
                        FilterCategoryButton(
                          title: L10n.tr('warrant.filter.risk_level'),
                          isSelected: _selectedCategory == 1,
                          hasDivider: false,
                          hasSelectedFilter: _selectedRisk != null,
                          onTap: () {
                            setState(() {
                              _selectedCategory = 1;
                            });
                          },
                        ),
                        FilterCategoryButton(
                          title: L10n.tr('warrant.filter.call_put'),
                          hasDivider: false,
                          isSelected: _selectedCategory == 2,
                          hasSelectedFilter: _selectedType != null,
                          onTap: () {
                            setState(() {
                              _selectedCategory = 2;
                            });
                          },
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
                      _riskLevelWidget(),
                      _warrantTypeWidget(),
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
                _selectedRisk,
                _selectedType,
              );
              router.maybePop();
            },
          )
        ],
      ),
    );
  }

  Widget _maturityWidget() {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.5,
      ),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: widget.maturityDateSet
              .map(
                (e) => PRadioButtonListItem(
                  value: e,
                  groupValue: _selectedMaturity,
                  onChanged: (value) {
                    setState(
                      () {
                        _selectedMaturity = value;
                      },
                    );
                  },
                  title: e,
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _riskLevelWidget() {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.5,
      ),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: RiskLevelEnum.values
              .map(
                (e) => PRadioButtonListItem(
                  value: e,
                  groupValue: _selectedRisk,
                  onChanged: (value) {
                    setState(() {
                      _selectedRisk = value;
                    });
                  },
                  title: '',
                  titleIcon: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: Grid.s,
                        height: Grid.s,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            Grid.s,
                          ),
                          color: e.color,
                        ),
                      ),
                      const SizedBox(
                        width: Grid.s,
                      ),
                      Text(
                        L10n.tr(e.text),
                        style: context.pAppStyle.labelMed14textPrimary,
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _warrantTypeWidget() {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.5,
      ),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            PRadioButtonListItem(
              title: L10n.tr('warrant.filter.c'),
              value: 'C',
              groupValue: _selectedType,
              onChanged: (value) {
                setState(() {
                  _selectedType = value;
                });
              },
            ),
            PRadioButtonListItem(
              title: L10n.tr('warrant.filter.p'),
              value: 'P',
              groupValue: _selectedType,
              onChanged: (value) {
                setState(() {
                  _selectedType = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
