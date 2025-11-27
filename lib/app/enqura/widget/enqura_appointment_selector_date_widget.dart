import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:p_core/utils/platform_utils.dart';
import 'package:piapiri_v2/app/enqura/utils/enqualify_helper.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/ink_wrapper.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';

class EnquraAppointmentSelectorDateWidget extends StatefulWidget {
  final ValueChanged<DateTime> onDateSelected;
  final DateTime? initialDate;
  final String callType;

  const EnquraAppointmentSelectorDateWidget({
    required this.onDateSelected,
    required this.callType,
    this.initialDate,
    super.key,
  });

  @override
  State<EnquraAppointmentSelectorDateWidget> createState() => _EnquraAppointmentSelectorDateWidgetState();
}

class _EnquraAppointmentSelectorDateWidgetState extends State<EnquraAppointmentSelectorDateWidget> {
  late DateTimeUtils _dateTimeUtils;
  late DateTime _today;
  late DateTime _focusedMonth;
  DateTime? _selectedDate;

  final Set<DateTime> _availableDays = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _dateTimeUtils = DateTimeUtils();
    final now = DateTime.now();
    _today = DateTime(now.year, now.month, now.day);
    _focusedMonth = _today;
    _selectedDate = widget.initialDate;
    _getAppointmentDays();
  }

  Future<void> _getAppointmentDays() async {
    setState(() {
      _isLoading = true;
    });

    _availableDays.clear();
    final monthStart = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final monthEnd = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0);

    var response = await EnqualifyHelper.getAvailableAppointments(
      widget.callType,
      monthStart.add(Duration(hours: PlatformUtils.isAndroid ? 00 : 9)),
      monthEnd.add(Duration(hours: PlatformUtils.isAndroid ? 23 : 18)),
    );

    if (response != null) {
      for (var e in response.data) {
        final date = DateTime(
          e.date.dateTime.date.year,
          e.date.dateTime.date.month,
          e.date.dateTime.date.day,
        );
        _availableDays.add(date);
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        padding: const EdgeInsets.symmetric(
          vertical: (4 * Grid.xl) + (Grid.m - Grid.xxs),
        ),
        alignment: Alignment.center,
        child: const PLoading(),
      );
    }

    final daysInMonth = _getDaysInMonth(_focusedMonth);
    final firstWeekday = DateTime(_focusedMonth.year, _focusedMonth.month, 1).weekday;
    final days = [
      ...List<DateTime?>.filled(firstWeekday - 1, null),
      ...daysInMonth,
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: Grid.m),
        _buildWeekDays(),
        const SizedBox(height: Grid.s),
        GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: Grid.xs,
            crossAxisSpacing: Grid.xs,
          ),
          itemCount: days.length,
          itemBuilder: (context, index) {
            final date = days[index];
            if (date == null) return const SizedBox.shrink();

            final isToday = _dateTimeUtils.isSameDay(date, _today);
            final isSelected = _selectedDate != null && _dateTimeUtils.isSameDay(date, _selectedDate!);

            final hasAppointment = _availableDays.contains(DateTime(date.year, date.month, date.day));

            return GestureDetector(
              onTap: () {
                if (date.compareTo(_today) >= 0 && hasAppointment) {
                  setState(() => _selectedDate = date);
                }
              },
              child: Container(
                decoration: isSelected
                    ? BoxDecoration(
                        shape: BoxShape.circle,
                        color: context.pColorScheme.primary,
                      )
                    : null,
                alignment: Alignment.center,
                child: Text(
                  '${date.day}',
                  style: date.compareTo(_today) < 0 || !hasAppointment
                      ? context.pAppStyle.labelReg20textQuaternary
                      : isSelected
                          ? context.pAppStyle.labelMed20backgroundColor
                          : isToday
                              ? context.pAppStyle.labelReg20primary
                              : context.pAppStyle.labelMed20textPrimary,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: Grid.m),
        PButton(
          text: L10n.tr('devam'),
          onPressed: () {
            Navigator.pop(context);
            widget.onDateSelected.call(_selectedDate ?? _today);
          },
          fillParentWidth: true,
        ),
      ],
    );
  }

  Widget _buildHeader() {
    final locale = Localizations.localeOf(context).toString();
    final monthName = DateFormat.MMMM(locale).format(_focusedMonth);
    bool backIsActive = _today.year == _focusedMonth.year && _today.month == _focusedMonth.month ? false : true;
    return Row(
      children: [
        Text(
          '${monthName[0].toUpperCase()}${monthName.substring(1)}',
          style: context.pAppStyle.labelMed18textPrimary,
        ),
        const Spacer(),
        InkWrapper(
          onTap: !backIsActive
              ? null
              : () {
                  setState(() {
                    _focusedMonth = DateTime(
                      _focusedMonth.year,
                      _focusedMonth.month - 1,
                    );
                  });
                  _getAppointmentDays();
                },
          child: SvgPicture.asset(
            ImagesPath.chevron_left,
            width: Grid.l - Grid.xs,
            height: Grid.l - Grid.xs,
            colorFilter: ColorFilter.mode(
              !backIsActive ? context.pColorScheme.textQuaternary : context.pColorScheme.primary,
              BlendMode.srcIn,
            ),
          ),
        ),
        InkWrapper(
          onTap: () {
            setState(() {
              _focusedMonth = DateTime(
                _focusedMonth.year,
                _focusedMonth.month + 1,
              );
            });
            _getAppointmentDays();
          },
          child: SvgPicture.asset(
            ImagesPath.chevron_right,
            width: Grid.l - Grid.xs,
            height: Grid.l - Grid.xs,
            colorFilter: ColorFilter.mode(
              context.pColorScheme.primary,
              BlendMode.srcIn,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeekDays() {
    final weekDays = [
      L10n.tr('calendar_mon'),
      L10n.tr('calendar_tue'),
      L10n.tr('calendar_wed'),
      L10n.tr('calendar_thu'),
      L10n.tr('calendar_fri'),
      L10n.tr('calendar_sat'),
      L10n.tr('calendar_sun'),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: weekDays
          .map((day) => Expanded(
                child: Center(
                  child: Text(
                    day,
                    overflow: TextOverflow.ellipsis,
                    style: context.pAppStyle.labelMed14textSecondary,
                  ),
                ),
              ))
          .toList(),
    );
  }

  List<DateTime> _getDaysInMonth(DateTime month) {
    final lastDay = DateTime(month.year, month.month + 1, 0);
    return List.generate(lastDay.day, (index) => DateTime(month.year, month.month, index + 1));
  }
}
