import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/ipo/widgets/filter_category_button.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/dynamic_indexed_stack.dart';
import 'package:piapiri_v2/common/widgets/list/selection_list_item.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/model/filter_category_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class EquityFilterSheet extends StatefulWidget {
  final List<FilterCategoryModel> filterCategories;
  final FilterCategoryItemModel? selectedFilterItem;
  final Function(FilterCategoryItemModel selectedCategoryItem) onSetFilter;

  const EquityFilterSheet({
    super.key,
    required this.filterCategories,
    required this.selectedFilterItem,
    required this.onSetFilter,
  });

  @override
  State<EquityFilterSheet> createState() => _EquityFilterSheetState();
}

class _EquityFilterSheetState extends State<EquityFilterSheet> {
  late FilterCategoryItemModel _selectedFilterItem;
  late FilterCategoryModel _selectedFilter;

  @override
  void initState() {
    _selectedFilterItem = widget.selectedFilterItem ?? widget.filterCategories.first.items.first;
    _selectedFilter = widget.filterCategories.firstWhere((element) => element.items.contains(_selectedFilterItem));
    super.initState();
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
                      children: widget.filterCategories
                          .map(
                            (category) => FilterCategoryButton(
                              isSelected: category == _selectedFilter,
                              hasSelectedFilter: category.items.contains(_selectedFilterItem),
                              hasDivider: false,
                              onTap: () {
                                setState(
                                  () {
                                    _selectedFilter = category;
                                  },
                                );
                              },
                              title: L10n.tr(category.categoryLocalization),
                            ),
                          )
                          .toList(),
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
                    index: widget.filterCategories.indexOf(_selectedFilter),
                    children: widget.filterCategories.map(
                      (category) {
                        return ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.sizeOf(context).height * 0.5,
                          ),
                          child: SingleChildScrollView(
                            padding: EdgeInsets.zero,
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Column(
                              children: category.items
                                  .map(
                                    (item) => PRadioButtonListItem(
                                      value: item,
                                      groupValue: _selectedFilterItem,
                                      title: L10n.tr(item.localization),
                                      titleStyle: context.pAppStyle.interRegularBase.copyWith(
                                        fontSize: Grid.m - Grid.xxs,
                                        color: _selectedFilterItem == item
                                            ? context.pColorScheme.primary
                                            : context.pColorScheme.textPrimary,
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedFilterItem = item;
                                        });
                                      },
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        );
                      },
                    ).toList(),
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
                _selectedFilterItem,
              );
              router.maybePop();
            },
          )
        ],
      ),
    );
  }
}
