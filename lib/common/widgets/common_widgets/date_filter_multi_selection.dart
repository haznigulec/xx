import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/account_statement/widgets/date_range_widget.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/bottomsheet_select_tile.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/model/account_statement_date_filter_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class DateFilterMultiSelection extends StatefulWidget {
  final DateFilterMultiEnum selectedDate;
  final Function(DateTime startDate, DateTime endDate) onChangedStartEndDate;
  final Function(DateFilterMultiEnum)? onSelectedDateFilter;
  final bool isSelectedDate;
  final int? differenceDay;
  const DateFilterMultiSelection({
    super.key,
    required this.selectedDate,
    required this.onChangedStartEndDate,
    this.differenceDay,
    this.onSelectedDateFilter,
    this.isSelectedDate = false,
  });

  @override
  State<DateFilterMultiSelection> createState() => _DateFilterMultiSelectionState();
}

class _DateFilterMultiSelectionState extends State<DateFilterMultiSelection> {
  late DateFilterMultiEnum _selectedDate;

  @override
  void initState() {
    _selectedDate = widget.selectedDate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PCustomOutlinedButtonWithIcon(
      text: L10n.tr(widget.selectedDate.name),
      iconSource: ImagesPath.chevron_down,
      foregroundColorApllyBorder: false,
      foregroundColor: widget.isSelectedDate ? context.pColorScheme.primary : null,
      backgroundColor: widget.isSelectedDate ? context.pColorScheme.secondary : null,
      onPressed: () {
        PBottomSheet.show(
          context,
          title: L10n.tr('date_selection'),
          titlePadding: const EdgeInsets.only(
            top: Grid.m,
          ),
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: DateFilterMultiEnum.values.length,
            itemBuilder: (context, index) {
              final date = DateFilterMultiEnum.values[index];
              return BottomsheetSelectTile(
                title: L10n.tr(date.name),
                value: date,
                isSelected: _selectedDate == date,
                onTap: (title, value) {
                  setState(() {
                    _selectedDate = value;

                    widget.onSelectedDateFilter?.call(_selectedDate);

                    if (_selectedDate == DateFilterMultiEnum.sumaryToday) {
                      widget.onChangedStartEndDate(
                        DateTime.now(),
                        DateTime.now(),
                      );

                      router.maybePop();
                    } else if (_selectedDate == DateFilterMultiEnum.sumaryLastSevenDay) {
                      widget.onChangedStartEndDate(
                        DateTime.now().subtract(
                          const Duration(days: 7),
                        ),
                        DateTime.now(),
                      );

                      router.maybePop();
                    } else if (_selectedDate == DateFilterMultiEnum.sumaryLastOneMonth) {
                      widget.onChangedStartEndDate(
                        DateTime.now().subtract(
                          const Duration(days: 30),
                        ),
                        DateTime.now(),
                      );

                      router.maybePop();
                    } else {
                      PBottomSheet.show(
                        context,
                        title: L10n.tr('tarih_araligi'),
                        child: DateRangeWidget(
                            differentDay: widget.differenceDay,
                            onSelected: (selectedStartDate, selectedEndDate) async {
                              widget.onChangedStartEndDate(selectedStartDate, selectedEndDate);

                              await router.maybePop();
                              await router.maybePop();
                            }),
                      );
                    }
                  });
                },
              );
            },
            separatorBuilder: (context, index) => const PDivider(),
          ),
        );
      },
    );
  }
}
