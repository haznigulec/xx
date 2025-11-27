import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/picker/date_pickers.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:p_core/extensions/date_time_extensions.dart';
import 'package:piapiri_v2/app/news/journal_constants.dart';
import 'package:piapiri_v2/app/news/model/journal_filter_model.dart';
import 'package:piapiri_v2/app/news/widgets/categories_check_list.dart';
import 'package:piapiri_v2/app/news/widgets/date_widget.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/dynamic_indexed_stack.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/model/symbol_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class RadioModel {
  bool isSelected;
  final String text;

  RadioModel(
    this.isSelected,
    this.text,
  );
}

class JournalFilterWidget extends StatefulWidget {
  final Function(JournalFilterModel) onSetFilter;
  final JournalFilterModel newsFilter;
  final bool? isReview;
  const JournalFilterWidget({
    super.key,
    required this.onSetFilter,
    required this.newsFilter,
    this.isReview = false,
  });

  @override
  State<JournalFilterWidget> createState() => _JournalFilterWidgetState();
}

class _JournalFilterWidgetState extends State<JournalFilterWidget> {
  final List<RadioModel> _sourcesList = [];
  List<String> _selectedCategories = [];
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  final List<SymbolModel> _symbols = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedCategories = widget.newsFilter.newsCategories;
    if (widget.newsFilter.symbols?.isNotEmpty == true) {
      _symbols.addAll(widget.newsFilter.symbols!);
    }
    _startDate = widget.newsFilter.startDate ?? DateTime.now().subtract(const Duration(days: 1));
    _endDate = widget.newsFilter.endDate ?? DateTime.now();
    if (!widget.isReview!) {
      _sourcesList.add(RadioModel(false, L10n.tr('categories')));
    }
    _sourcesList.add(RadioModel(false, L10n.tr('tarih_araligi')));
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.9,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: Grid.s,
              children: [
                _sourcesWidget(),
                Expanded(
                  flex: 7,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          width: 1,
                          color: context.pColorScheme.line,
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.only(
                      left: Grid.s,
                    ),
                    child: DynamicIndexedStack(
                      index: _selectedIndex,
                      children: [
                        if (!widget.isReview!) ...[
                          CategoriesCheckList(
                            dataList: JournalConstants.newsCategories,
                            selectedList: _selectedCategories,
                            onTapBack: (Set<String> selectedSwitches) {
                              _selectedCategories = selectedSwitches.toList();
                            },
                          ),
                        ],
                        _dateWidget()
                      ],
                    ),
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
                JournalFilterModel(
                  newsSources: const [
                    'KAP',
                    'MATRIKS',
                  ],
                  newsCategories: _selectedCategories,
                  startDate: _startDate,
                  endDate: _endDate,
                  symbols: _symbols.toList(),
                ),
              );
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
          onTap: () {
            setState(
              () {
                if (_selectedIndex == i) {
                  _sourcesList[i].isSelected = true;
                } else {
                  _sourcesList[i].isSelected = false;
                }
                _selectedIndex = i;
              },
            );
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
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: Grid.xs + Grid.xxs,
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

    return Expanded(
      flex: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: sourcesListWidget,
      ),
    );
  }

  Widget _dateWidget() {
    return Column(
      children: [
        DateWidget(
          title: L10n.tr('baslangic_tarihi'),
          value: _startDate.formatDayMonthYearDot(),
          onTap: () async {
            await showPDatePicker(
              context: context,
              initialDate: _startDate,
              cancelTitle: L10n.tr('iptal'),
              doneTitle: L10n.tr('tamam'),
              onChanged: (selectedDate) {
                if (selectedDate == null) return;

                setState(() {
                  _startDate = selectedDate;
                });
              },
            );
          },
        ),
        const SizedBox(
          height: Grid.s + Grid.xs,
        ),
        DateWidget(
            title: L10n.tr('bitis_tarihi'),
            value: _endDate.formatDayMonthYearDot(),
            onTap: () async => await showPDatePicker(
                  context: context,
                  initialDate: _endDate,
                  cancelTitle: L10n.tr('iptal'),
                  doneTitle: L10n.tr('tamam'),
                  onChanged: (selectedDate) {
                    if (selectedDate == null) return;

                    setState(() {
                      _endDate = selectedDate;
                    });
                  },
                )),
      ],
    );
  }
}
