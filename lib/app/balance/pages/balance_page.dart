import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/place_holder/no_data_widget.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/balance/bloc/balance_bloc.dart';
import 'package:piapiri_v2/app/balance/bloc/balance_event.dart';
import 'package:piapiri_v2/app/balance/bloc/balance_state.dart';
import 'package:piapiri_v2/app/balance/widget/balance_data_group.dart';
import 'package:piapiri_v2/app/balance/widget/balance_data_single_row.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/bottomsheet_button.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/bottomsheet_select_tile.dart';
import 'package:piapiri_v2/common/widgets/progress_indicators/shimmerize.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/extension/string_extension.dart';
import 'package:piapiri_v2/core/model/conolidate_enum.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class BalancePage extends StatefulWidget {
  final MarketListModel marketListModel;
  const BalancePage({
    super.key,
    required this.marketListModel,
  });

  @override
  State<BalancePage> createState() => _BalancePageState();
}

class _BalancePageState extends State<BalancePage> {
  final BalanceBloc _balanceIncomeBloc = getIt<BalanceBloc>();
  List<ConsolidateEnum> _consolidateEnumList = [];
  late Map _yearData;
  final List<int> _years = [];
  final List<String> _months = [];
  int _selectedYear = DateTime.now().year;
  String _selectedMonth = '03';
  ConsolidateEnum _selectedConsolidate = ConsolidateEnum.consolidate;
  @override
  void initState() {
    _balanceIncomeBloc.add(
      ///Get current year/month info  and set the first year as selected year
      GetYearInfoEvent(
        symbolName: widget.marketListModel.symbolCode,
        callback: (data, consolidateList) {
          _consolidateEnumList = consolidateList;
          _selectedConsolidate = _consolidateEnumList.first;
          _yearData = data;
          _years.addAll(
            data.keys.map((e) => int.parse(e)).toList(),
          );
          if (_years.isEmpty) return;
          _selectedYear = _years.first;
          _months.addAll(
            List<String>.from(
              _yearData[_selectedYear.toString()]['months'],
            ),
          );
          _selectedMonth = _months.first;
          _balanceIncomeBloc.add(
            GetBalanceEvent(
              symbolName: widget.marketListModel.symbolCode,
              month: _selectedMonth,
              year: _selectedYear.toString(),
              isConsolidate: _selectedConsolidate == ConsolidateEnum.consolidate,
            ),
          );
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {});
          });
        },
      ),
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
                  titlePadding: const EdgeInsets.only(
                    top: Grid.m,
                  ),
                  child: ListView.separated(
                    itemCount: _years.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    separatorBuilder: (context, index) => const PDivider(),
                    itemBuilder: (context, index) {
                      return BottomsheetSelectTile(
                        title: _years[index].toString(),
                        value: _years[index],
                        isSelected: _selectedYear == _years[index],
                        onTap: (selectedTitle, value) {
                          setState(() {
                            _selectedYear = value;
                            _months.clear();
                            _months.addAll(List<String>.from(_yearData[_selectedYear.toString()]['months']));
                            if (!_months.contains(_selectedMonth)) {
                              _selectedMonth = _months.first;
                            }
                          });

                          _balanceIncomeBloc.add(
                            GetBalanceEvent(
                              symbolName: widget.marketListModel.symbolCode,
                              month: _selectedMonth,
                              year: value.toString(),
                              isConsolidate: _selectedConsolidate == ConsolidateEnum.consolidate,
                            ),
                          );

                          router.maybePop();
                        },
                      );
                    },
                  ),
                );
              },
            ),
            BottomsheetButton(
              title: L10n.tr(
                DateTimeUtils.monthToPeriodLocalization(_selectedMonth),
              ),
              onPressed: () async {
                if (_months.isEmpty) return;
                PBottomSheet.show(
                  context,
                  title: L10n.tr('month'),
                  titlePadding: const EdgeInsets.only(
                    top: Grid.m,
                  ),
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

                            _balanceIncomeBloc.add(
                              GetBalanceEvent(
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
                  titlePadding: const EdgeInsets.only(
                    top: Grid.m,
                  ),
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
                          onTap: (selectedTitle, consolidateValue) {
                            setState(() {
                              _selectedConsolidate = consolidateValue;
                            });

                            _balanceIncomeBloc.add(
                              GetBalanceEvent(
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
        PBlocBuilder<BalanceBloc, BalanceState>(
          bloc: _balanceIncomeBloc,
          builder: (context, state) {

            if (state.balanceList == null || state.balanceList!.isEmpty || state.isFailed || _years.isEmpty) {
              return Expanded(
                child: NoDataWidget(
                  message: L10n.tr('balance_no_data_message'),
                ),
              );
            }

            return Expanded(
              child: Shimmerize(
                enabled: state.isLoading,
                child: ListView.builder(
                  itemCount: state.balanceList?.length,
                  itemBuilder: (context, index) {
                    bool showBottomDivider = false;
                    Map header = state.balanceList?.keys.elementAt(index);
                    List contentList = state.balanceList?.values.elementAt(index);

                    if (index + 1 != state.balanceList?.length && contentList.isNotEmpty) {
                      if (state.balanceList?.values.elementAt(index + 1).isEmpty) {
                        showBottomDivider = true;
                      }
                    }

                    return Column(
                      children: [
                        if (contentList.isNotEmpty) const PDivider(),
                        const SizedBox(
                          height: Grid.s + Grid.xs,
                        ),
                        contentList.isNotEmpty
                            ? BalanceDataGroup(
                                title: header['description']?.toString().toCapitalizeCaseTr ?? '',
                                value: header['value'].toDouble() ?? 0,
                                contentList: contentList,
                              )
                            : BalanceDataSingleRow(
                                title: header['description']?.toString().toCapitalizeCaseTr ?? '',
                                value: header['value'].toDouble() ?? 0,
                              ),
                        const SizedBox(
                          height: Grid.s + Grid.xs,
                        ),
                        if (showBottomDivider) const PDivider(),
                      ],
                    );
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
