import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:p_core/extensions/date_time_extensions.dart';
import 'package:piapiri_v2/app/news/widgets/date_widget.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/info_widget.dart';
import 'package:piapiri_v2/common/widgets/picker/date_pickers.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class DateRangeWidget extends StatefulWidget {
  final Function(DateTime, DateTime) onSelected;
  final int? differentDay;
  const DateRangeWidget({
    super.key,
    required this.onSelected,
    this.differentDay,
  });

  @override
  State<DateRangeWidget> createState() => _DateRangeWidgetState();
}

class _DateRangeWidgetState extends State<DateRangeWidget> {
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Column(
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
              });
            },
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(
            vertical: Grid.s + Grid.xs,
          ),
          child: PDivider(),
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
          ),
        ),
        const SizedBox(
          height: Grid.m,
        ),
        if (widget.differentDay != null) ...[
          const PDivider(),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: Grid.m,
            ),
            child: PInfoWidget(
              infoText: L10n.tr(
                'max_date_different',
                args: [
                  widget.differentDay.toString(),
                ],
              ),
            ),
          ),
        ],
        PButton(
          text: L10n.tr('kaydet'),
          fillParentWidth: true,
          onPressed: widget.differentDay != null && _startDate.difference(_endDate).inDays < -widget.differentDay!
              ? null
              : () {
                  widget.onSelected(_startDate, _endDate);

                  router.maybePop();
                },
        ),
      ],
    );
  }
}
