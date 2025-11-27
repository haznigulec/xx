import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:p_core/utils/platform_utils.dart';
import 'package:piapiri_v2/app/enqura/utils/enqualify_helper.dart';
import 'package:piapiri_v2/app/enqura/utils/enqura_helpers.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/ink_wrapper.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';

class EnquraAppointmentSelectorTimeWidget extends StatefulWidget {
  final DateTime appoinmentDay;
  final String callType;
  final Function(AppointmentSlotItem?) onSelectedAppointment;

  const EnquraAppointmentSelectorTimeWidget({
    required this.appoinmentDay,
    required this.callType,
    required this.onSelectedAppointment,
    super.key,
  });

  @override
  State<EnquraAppointmentSelectorTimeWidget> createState() => _EnquraAppointmentSelectorTimeWidgetState();
}

class _EnquraAppointmentSelectorTimeWidgetState extends State<EnquraAppointmentSelectorTimeWidget> {
  final List<AppointmentSlotItem> _appointmentTimes = [];
  AppointmentSlotItem? _selectedAppointment;
  late final Future<void> _appointmentFuture;

  @override
  void initState() {
    super.initState();
    _appointmentFuture = _getAppointmentTimes();
  }

  Future<void> _getAppointmentTimes() async {
    var response = await EnqualifyHelper.getAvailableAppointments(
      widget.callType,
      widget.appoinmentDay.add(Duration(hours: PlatformUtils.isAndroid ? 00 : 9)),
      widget.appoinmentDay.add(Duration(hours: PlatformUtils.isAndroid ? 23 : 18)),
    );
    if (response != null) {
      final now = DateTime.now();

      if (DateTimeUtils().isSameDay(widget.appoinmentDay, now)) {
        _appointmentTimes.addAll(response.data.where((e) {
          final parts = e.startTime.split(':');
          final targetTime = DateTime(
            now.year,
            now.month,
            now.day,
            int.parse(parts[0]),
            int.parse(parts[1]),
            int.parse(parts[2]),
          );
          return targetTime.isAfter(now);
        }));
      } else {
        _appointmentTimes.addAll(response.data);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _appointmentFuture,
      builder: (context, snapshot) => ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.6,
        ),
        child: snapshot.connectionState != ConnectionState.done
            ? const Center(child: PLoading())
            : Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.only(
                        top: Grid.m,
                        bottom: Grid.l,
                      ),
                      itemCount: _appointmentTimes.length,
                      itemBuilder: (context, index) {
                        final item = _appointmentTimes[index];
                        final timeText = formatTimeRange(item);
                        final isSelected = _selectedAppointment == item;
                        return InkWrapper(
                          onTap: () {
                            setState(() {
                              _selectedAppointment = item;
                            });
                          },
                          child: Row(
                            children: [
                              AnimatedContainer(
                                width: 5,
                                height: isSelected ? 30.0 : 0.0,
                                duration: const Duration(milliseconds: 300),
                                decoration: BoxDecoration(
                                  color: context.pColorScheme.primary,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(
                                      Grid.m,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: Grid.xs,
                              ),
                              Text(
                                timeText,
                                style: isSelected
                                    ? context.pAppStyle.labelReg16primary
                                    : context.pAppStyle.labelReg16textPrimary,
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const PDivider(
                        padding: EdgeInsets.symmetric(
                          vertical: Grid.m,
                        ),
                      ),
                    ),
                  ),
                  PButton(
                    text: L10n.tr('devam'),
                    onPressed: () {
                      Navigator.pop(context);
                      widget.onSelectedAppointment.call(_selectedAppointment);
                    },
                    fillParentWidth: true,
                  ),
                ],
              ),
      ),
    );
  }
}
