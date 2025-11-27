import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/account_statement/model/summary_type_enum.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/bottomsheet_select_tile.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/date_filter_multi_selection.dart';
import 'package:piapiri_v2/core/config/app_info.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/account_statement_date_filter_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class DomesticAccountStatementFilters extends StatefulWidget {
  final String selectedAccount;
  final SummaryTypeEnum selectedSummaryType;
  final DateFilterMultiEnum selectedDate;
  final Function(String) onChangedAccount;
  final Function(SummaryTypeEnum) onChangedSummaryType;
  final Function(DateTime startDate, DateTime endDate) onChangedStartEndDate;
  final Function(DateFilterMultiEnum) onSelectedDateFilter;

  const DomesticAccountStatementFilters({
    super.key,
    required this.selectedAccount,
    required this.selectedSummaryType,
    required this.selectedDate,
    required this.onChangedAccount,
    required this.onChangedStartEndDate,
    required this.onChangedSummaryType,
    required this.onSelectedDateFilter,
  });

  @override
  State<DomesticAccountStatementFilters> createState() => _DomesticAccountStatementFiltersState();
}

class _DomesticAccountStatementFiltersState extends State<DomesticAccountStatementFilters> {
  String _selectedAccount = '';
  List<String> _accountNames = [];
  SummaryTypeEnum _selectedSummaryType = SummaryTypeEnum.allExtract;

  @override
  void initState() {
    _accountNames = [
      'tum_hesaplar',
      ...getIt<AppInfo>().accountList.map(
            (e) => e['accountExtId'].toString(),
          ),
    ];
    _selectedAccount = widget.selectedAccount;
    _selectedSummaryType = widget.selectedSummaryType;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Grid.m,
      ),
      child: Row(
        spacing: Grid.s,
        children: [
          PCustomOutlinedButtonWithIcon(
            text: L10n.tr(_selectedAccount),
            iconSource: ImagesPath.chevron_down,
            onPressed: () {
              PBottomSheet.show(
                context,
                title: L10n.tr('account_selection'),
                titlePadding: const EdgeInsets.only(
                  top: Grid.m,
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: _accountNames.length,
                  itemBuilder: (context, index) {
                    return BottomsheetSelectTile(
                      title: L10n.tr(_accountNames[index]),
                      value: _accountNames[index],
                      isSelected: _selectedAccount == _accountNames[index],
                      onTap: (title, value) {
                        setState(() {
                          _selectedAccount = value;
                          widget.onChangedAccount(_selectedAccount);
                          router.maybePop();
                        });
                      },
                    );
                  },
                  separatorBuilder: (context, index) => const PDivider(),
                ),
              );
            },
          ),
          PCustomOutlinedButtonWithIcon(
            text: L10n.tr(_selectedSummaryType.name),
            iconSource: ImagesPath.chevron_down,
            onPressed: () {
              PBottomSheet.show(context,
                  title: L10n.tr('selecting_summary_type'),
                  titlePadding: const EdgeInsets.only(
                    top: Grid.m,
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: SummaryTypeEnum.values.length,
                    separatorBuilder: (context, index) => const PDivider(),
                    itemBuilder: (context, index) {
                      final summaryType = SummaryTypeEnum.values[index];
                      return BottomsheetSelectTile(
                        title: L10n.tr(summaryType.name),
                        value: summaryType,
                        isSelected: _selectedSummaryType == summaryType,
                        onTap: (title, value) {
                          setState(() {
                            _selectedSummaryType = value;
                            widget.onChangedSummaryType(_selectedSummaryType);
                            router.maybePop();
                          });
                        },
                      );
                    },
                  ));
            },
          ),
          DateFilterMultiSelection(
            selectedDate: widget.selectedDate,
            isSelectedDate: true,
            onChangedStartEndDate: (startDate, endDate) {
              setState(() {
                widget.onChangedStartEndDate(
                  startDate,
                  endDate,
                );
              });
            },
            onSelectedDateFilter: (selectedDateFilter) {
              widget.onSelectedDateFilter(selectedDateFilter);
            },
          ),
        ],
      ),
    );
  }
}
