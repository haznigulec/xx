import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/picker/date_pickers.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:p_core/extensions/date_time_extensions.dart';
import 'package:piapiri_v2/app/economic_calender/bloc/economic_calender_bloc.dart';
import 'package:piapiri_v2/app/economic_calender/bloc/economic_calender_event.dart';
import 'package:piapiri_v2/app/news/widgets/date_widget.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class ECDateFilterWidget extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;
  const ECDateFilterWidget({
    super.key,
    required this.startDate,
    required this.endDate,
  });

  @override
  State<ECDateFilterWidget> createState() => _ECDateFilterWidgetState();
}

class _ECDateFilterWidgetState extends State<ECDateFilterWidget> {
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  late EconomicCalenderBloc _economicCalenderBloc;
  @override
  void initState() {
    _economicCalenderBloc = getIt<EconomicCalenderBloc>();
    _startDate = widget.startDate;
    _endDate = widget.endDate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        const Padding(
          padding: EdgeInsets.symmetric(vertical: Grid.m),
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
        PButton(
          text: L10n.tr('kaydet'),
          fillParentWidth: true,
          onPressed: _startDate.isAfter(_endDate)
              ? null
              : () {
                  _economicCalenderBloc.add(
                    GetCalendarItemsEvent(
                      startDate: _startDate,
                      endDate: _endDate,
                      isChangedDates: true,
                    ),
                  );
                  router.maybePop();
                },
        ),
      ],
    );
  }
}
