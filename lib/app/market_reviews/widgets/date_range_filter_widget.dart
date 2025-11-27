import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/picker/date_pickers.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:p_core/extensions/date_time_extensions.dart';
import 'package:piapiri_v2/app/news/widgets/date_widget.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class DateRangeFilterWidget extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;
  final Function(DateTime) onChangedStartDate;
  final Function(DateTime) onChangedEndDate;
  final bool hasDivider;
  const DateRangeFilterWidget({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onChangedStartDate,
    required this.onChangedEndDate,
    this.hasDivider = true,
  });

  @override
  State<DateRangeFilterWidget> createState() => _DateRangeFilterWidgetState();
}

class _DateRangeFilterWidgetState extends State<DateRangeFilterWidget> {
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    _startDate = widget.startDate;

    _endDate = widget.endDate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: Grid.s + Grid.xs,
      children: [
        DateWidget(
          title: L10n.tr('baslangic_tarihi'),
          value: _startDate.formatDayMonthYearDot(),
          onTap: () async => await showPDatePicker(
            context: context,
            initialDate: _startDate,
            cancelTitle: L10n.tr('iptal'),
            doneTitle: L10n.tr('tamam'),
            onChanged: (selectedDate) {
              if (selectedDate == null) return;

              setState(() {
                _startDate = selectedDate;
                widget.onChangedStartDate(_startDate);
              });
            },
          ),
        ),
        if (widget.hasDivider) const PDivider(),
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
                widget.onChangedEndDate(_endDate);
              });
            },
          ),
        )
      ],
    );
  }
}
