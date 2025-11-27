import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/fund/bloc/fund_state.dart';
import 'package:piapiri_v2/app/fund/widgets/filter_check_list.dart';
import 'package:piapiri_v2/common/utils/constant.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/dynamic_indexed_stack.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/core/model/dropdown_model.dart';
import 'package:piapiri_v2/core/model/fund_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class RadioModel {
  bool isSelected;
  final String text;

  RadioModel(
    this.isSelected,
    this.text,
  );
}

class FundFilterWidget extends StatefulWidget {
  final FundState state;
  final Function(String, String) onChangeSubType;
  final Function(FundFilterModel) onApply;
  const FundFilterWidget({
    super.key,
    required this.state,
    required this.onChangeSubType,
    required this.onApply,
  });

  @override
  State<FundFilterWidget> createState() => _FundFilterWidgetState();
}

class _FundFilterWidgetState extends State<FundFilterWidget> {
  final List<RadioModel> _sourcesList = [];
  int _selectedIndex = 0;
  late FundFilterModel _fundFilter;
  @override
  void initState() {
    super.initState();
    _fundFilter = widget.state.fundFilter.copyWith();
    _sourcesList.add(RadioModel(false, L10n.tr('fon_tipi')));
    _sourcesList.add(RadioModel(false, L10n.tr('semsiye_fon_turu')));
    _sourcesList.add(RadioModel(false, L10n.tr('fon_unvan_tipi')));
    _sourcesList.add(RadioModel(false, L10n.tr('tefas_islem_durumu')));
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
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 3,
                  child: _sourcesWidget(),
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
                  flex: 4,
                  child: DynamicIndexedStack(
                    index: _selectedIndex,
                    children: List.generate(
                      _sourcesList.length,
                      (index) => ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.sizeOf(context).height * 0.5,
                        ),
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: index == 0
                              ? FilterRadioList(
                                  dataList: fundTypes
                                      .map(
                                        (e) => DropdownModel(
                                          name: L10n.tr(e['Code']!),
                                          value: e['Code'],
                                        ),
                                      )
                                      .toList(),
                                  selectedValue: _fundFilter.fundType,
                                  onTapBack: (String? selectedValue, String? selectedName) {
                                    setState(() {
                                      _fundFilter = _fundFilter.copyWith(
                                        fundType: selectedValue,
                                        fundTypeName: selectedName,
                                      );
                                    });
                                  },
                                )
                              : index == 1
                                  ? FilterRadioList(
                                      dataList: widget.state.subTypeFilter
                                          .map(
                                            (e) => DropdownModel(
                                              name: L10n.tr('fund_umbrella_fund_type_${e['Code']!}'),
                                              value: e['Code'],
                                            ),
                                          )
                                          .toList(),
                                      selectedValue: _fundFilter.subType,
                                      onTapBack: (String? selectedValue, String? selectedName) {
                                        setState(
                                          () {
                                            _fundFilter = _fundFilter.copyWith(
                                              subType: selectedValue,
                                              subTypeName: selectedName,
                                              fundTitle: 'ALL',
                                              fundTitleName: L10n.tr('all'),
                                            );
                                          },
                                        );
                                        widget.onChangeSubType(_fundFilter.institution, selectedValue ?? 'ALL');
                                      },
                                    )
                                  : index == 2
                                      ? FilterRadioList(
                                          dataList: widget.state.fundTitleList
                                              .map(
                                                (e) => DropdownModel(
                                                  name: L10n.tr('fund_title_type_${e['Code']!}'),
                                                  value: e['Code'],
                                                ),
                                              )
                                              .toList(),
                                          selectedValue: _fundFilter.fundTitle,
                                          onTapBack: (String? selectedValue, String? selectedName) {
                                            setState(() {
                                              _fundFilter = _fundFilter.copyWith(
                                                fundTitle: selectedValue,
                                                fundTitleName: selectedName,
                                              );
                                            });
                                          },
                                        )
                                      : index == 3
                                          ? FilterRadioList(
                                              dataList: tefasStatuses
                                                  .map(
                                                    (e) => DropdownModel(
                                                      name: L10n.tr('fund_transaction_status_${e['Code']!}'),
                                                      value: e['Code'],
                                                    ),
                                                  )
                                                  .toList(),
                                              selectedValue: _fundFilter.tefasType,
                                              onTapBack: (String? selectedValue, String? selectedName) {
                                                setState(() {
                                                  _fundFilter = _fundFilter.copyWith(
                                                    tefasType: selectedValue,
                                                    tefasTypeName: selectedName,
                                                  );
                                                });
                                              },
                                            )
                                          : const SizedBox.shrink(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: Grid.s,
          ),
          PButton(
            text: L10n.tr('kaydet'),
            fillParentWidth: true,
            onPressed: () {
              widget.onApply(_fundFilter);
              router.maybePop();
            },
          )
        ],
      ),
    );
  }

  Widget _sourcesWidget() {
    List<Widget> sourcesListWidget = [
      const SizedBox(
        height: Grid.s,
      )
    ];

    for (var i = 0; i < _sourcesList.length; i++) {
      sourcesListWidget.add(
        InkWell(
          splashColor: context.pColorScheme.transparent,
          highlightColor: context.pColorScheme.transparent,
          onTap: () {
            setState(() {
              if (_selectedIndex == i) {
                _sourcesList[i].isSelected = true;
              } else {
                _sourcesList[i].isSelected = false;
              }
              _selectedIndex = i;
            });
          },
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: Grid.s + Grid.xs,
            ),
            child: Row(
              children: [
                Container(
                  width: 5,
                  height: 30.0,
                  decoration: BoxDecoration(
                    color: _selectedIndex == i ? context.pColorScheme.primary : Colors.transparent,
                    border: Border.all(
                      width: 3.0,
                      color: _selectedIndex == i ? context.pColorScheme.primary : Colors.transparent,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(30.0),
                    ),
                  ),
                ),
                const SizedBox(
                  width: Grid.s,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: Grid.xs + Grid.xxs,
                      bottom: Grid.xs + Grid.xxs,
                      right: Grid.xxs,
                    ),
                    child: Text(
                      _sourcesList[i].text,
                      style: context.pAppStyle.interMediumBase.copyWith(
                        fontSize: Grid.m,
                        color: _selectedIndex == i ? context.pColorScheme.primary : context.pColorScheme.textPrimary,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sourcesListWidget,
    );
  }
}
