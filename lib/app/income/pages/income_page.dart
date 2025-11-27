import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/place_holder/no_data_widget.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/income/bloc/income_bloc.dart';
import 'package:piapiri_v2/app/income/bloc/income_event.dart';
import 'package:piapiri_v2/app/income/bloc/income_state.dart';
import 'package:piapiri_v2/app/income/widget/income_data_group.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/bottomsheet_button.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/bottomsheet_select_tile.dart';
import 'package:piapiri_v2/common/widgets/progress_indicators/shimmerize.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/conolidate_enum.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class IncomePage extends StatefulWidget {
  final MarketListModel marketListModel;
  const IncomePage({
    super.key,
    required this.marketListModel,
  });

  @override
  State<IncomePage> createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  final IncomeBloc _incomeBloc = getIt<IncomeBloc>();
  List<ConsolidateEnum> _consolidateEnumList = [];
  late Map _yearData;
  final List<int> _years = [];
  final List<String> _months = [];
  int _selectedYear = DateTime.now().year;
  String _selectedMonth = '03';
  ConsolidateEnum _selectedConsolidate = ConsolidateEnum.consolidate;
  @override
  void initState() {
    _incomeBloc.add(
      GetYearInfoEvent(
          symbolName: widget.marketListModel.symbolCode,
          callback: (data, consolidateList) {
            _consolidateEnumList = consolidateList;
            _selectedConsolidate = _consolidateEnumList.first;
            _yearData = data;
            _years.addAll(data.keys.map((e) => int.parse(e)).toList());
            if (_years.isEmpty) return;
            _selectedYear = _years.first;
            _months.addAll(List<String>.from(_yearData[_selectedYear.toString()]['months']));

            _selectedMonth = _months.first;

            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {});
            });

            _incomeBloc.add(
              GetIncomeEvent(
                symbolName: widget.marketListModel.symbolCode,
                month: _selectedMonth,
                year: _selectedYear.toString(),
                isConsolidate: _selectedConsolidate == ConsolidateEnum.consolidate,
              ),
            );
          }),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: Grid.s + Grid.xs,
      children: [
        Row(
          spacing: Grid.s,
          children: [
            BottomsheetButton(
              title: _selectedYear.toString(),
              onPressed: () async {
                if (_years.isEmpty) return;
                PBottomSheet.show(
                  context,
                  title: L10n.tr('year'),
                  child: SizedBox(
                    child: ListView.separated(
                      itemCount: _years.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        return BottomsheetSelectTile(
                          title: _years[index].toString(),
                          value: _years[index],
                          isSelected: _selectedYear == _years[index],
                          onTap: (selectedTitle, value) {
                            setState(() {
                              _selectedYear = value;
                              _months.clear();

                              _months.addAll(
                                List<String>.from(
                                  _yearData[_selectedYear.toString()]['months'],
                                ),
                              );

                              if (!_months.contains(_selectedMonth)) {
                                _selectedMonth = _months.first;
                              }
                            });

                            _incomeBloc.add(
                              GetIncomeEvent(
                                  symbolName: widget.marketListModel.symbolCode,
                                  month: _selectedMonth,
                                  year: value.toString(),
                                  isConsolidate: _selectedConsolidate == ConsolidateEnum.consolidate),
                            );

                            router.maybePop();
                          },
                        );
                      },
                      separatorBuilder: (context, index) => const PDivider(),
                    ),
                  ),
                );
              },
            ),
            BottomsheetButton(
              title: L10n.tr(DateTimeUtils.monthToPeriodLocalization(_selectedMonth)),
              onPressed: () async {
                if (_months.isEmpty) return;
                PBottomSheet.show(
                  context,
                  title: L10n.tr('month'),
                  child: SizedBox(
                    child: ListView.separated(
                      itemCount: _months.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      separatorBuilder: (context, index) => const PDivider(),
                      itemBuilder: (context, index) {
                        return BottomsheetSelectTile(
                          title: L10n.tr(DateTimeUtils.monthToPeriodLocalization(_months[index])),
                          value: _months[index],
                          isSelected: _selectedMonth == _months[index],
                          onTap: (selectedTitle, value) {
                            setState(() {
                              _selectedMonth = value;
                            });

                            _incomeBloc.add(
                              GetIncomeEvent(
                                symbolName: widget.marketListModel.symbolCode,
                                month: value,
                                year: _selectedYear.toString(),
                                isConsolidate: _selectedConsolidate == ConsolidateEnum.consolidate,
                              ),
                            );
                            router.maybePop();
                          },
                        );
                      },
                    ),
                  ),
                );
              },
            ),
            BottomsheetButton(
              title: L10n.tr(_selectedConsolidate.localication),
              onPressed: () async {
                if (_consolidateEnumList.isEmpty) return;
                PBottomSheet.show(
                  context,
                  title: L10n.tr('konsolidasyon'),
                  child: SizedBox(
                    child: ListView.separated(
                      itemCount: _consolidateEnumList.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      separatorBuilder: (context, index) => const PDivider(),
                      itemBuilder: (context, index) {
                        ConsolidateEnum item = _consolidateEnumList[index];

                        return BottomsheetSelectTile(
                          title: L10n.tr(item.localication),
                          value: item,
                          isSelected: _selectedConsolidate == _consolidateEnumList[index],
                          onTap: (selectedTitle, value) {
                            setState(() {
                              _selectedConsolidate = value;
                            });

                            _incomeBloc.add(
                              GetIncomeEvent(
                                symbolName: widget.marketListModel.symbolCode,
                                month: _selectedMonth,
                                year: _selectedYear.toString(),
                                isConsolidate: _selectedConsolidate == ConsolidateEnum.consolidate,
                              ),
                            );

                            router.maybePop();
                          },
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        PBlocBuilder<IncomeBloc, IncomeState>(
          bloc: _incomeBloc,
          builder: (context, state) {
            if (state.balanceList == null || state.balanceList!.isEmpty || _years.isEmpty) {
              return Expanded(
                child: NoDataWidget(
                  message: L10n.tr('income_no_data_message'),
                ),
              );
            }

            return Shimmerize(
              enabled: state.isLoading,
              child: Expanded(
                child: ListView.builder(
                  itemCount: state.balanceList!.length,
                  itemBuilder: (context, index) {
                    Map header = state.balanceList?.keys.elementAt(index);
                    List contentList = state.balanceList?.values.elementAt(index);

                    return contentList.isNotEmpty
                        ? Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: Grid.l / 2),
                                child: IncomeDataGroup(
                                  title: header['description'] ?? '',
                                  value: header['value'].toDouble() ?? 0,
                                  contentList: contentList,
                                ),
                              ),
                              const PDivider()
                            ],
                          )
                        : const SizedBox();
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
