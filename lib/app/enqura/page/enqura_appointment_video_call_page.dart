import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/enqura/bloc/enqura_bloc.dart';
import 'package:piapiri_v2/app/enqura/bloc/enqura_event.dart';
import 'package:piapiri_v2/app/enqura/bloc/enqura_state.dart';
import 'package:piapiri_v2/app/enqura/model/enqura_create_user_model.dart';
import 'package:piapiri_v2/app/enqura/utils/enqura_page_steps.dart';
import 'package:piapiri_v2/app/enqura/widget/enqura_appointment_approve_widget.dart';
import 'package:piapiri_v2/app/enqura/widget/enqura_appointment_selector_date_widget.dart';
import 'package:piapiri_v2/app/enqura/widget/enqura_appointment_selector_time_widget.dart';
import 'package:piapiri_v2/app/enqura/widget/enqura_info_widget.dart';
import 'package:piapiri_v2/app/info/model/info_variant.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/app_config.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';

@RoutePage()
class EnquraAppointmentVideoCallPage extends StatefulWidget {
  const EnquraAppointmentVideoCallPage({
    super.key,
    this.isFirstLaunch = false,
  });
  final bool isFirstLaunch;
  @override
  State<EnquraAppointmentVideoCallPage> createState() => _EnquraAppointmentVideoCallPageState();
}

class _EnquraAppointmentVideoCallPageState extends State<EnquraAppointmentVideoCallPage> {
  late final EnquraBloc _enquraBloc;
  DateTime? _appointmentDate;
  late Map _workingHours;
  @override
  initState() {
    super.initState();
    _enquraBloc = getIt<EnquraBloc>();
    if (!_enquraBloc.state.sdkIsActive) {
      _enquraBloc.add(InitializeSDKEvent(checkAppointment: false));
    }
    _workingHours = jsonDecode(remoteConfig.getValue('agentWorkingHours').asString())['hours']
        [AppConfig.instance.flavor == Flavor.dev ? 'dev' : 'prod'];
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerTheme: const DividerThemeData(
          color: Colors.transparent,
        ),
      ),
      child: Scaffold(
        appBar: PInnerAppBar(
          title: L10n.tr('video_call'),
        ),
        body: PBlocBuilder<EnquraBloc, EnquraState>(
          bloc: _enquraBloc,
          builder: (context, state) => state.isLoading
              ? const PLoading()
              : Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Grid.m,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Spacer(),
                      EnquraInfoWidget(
                        imageFormatIsSvg: false,
                        imagePath: ImagesPath.videocall,
                        title: L10n.tr('create_video_call_boking'),
                        subTitle: _isWithinWorkingHours()
                            ? L10n.tr('create_video_call_boking_message_active')
                            : L10n.tr('create_video_call_boking_message'),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
        ),
        persistentFooterButtons: [
          Padding(
            padding: const EdgeInsets.only(
              left: Grid.s,
              right: Grid.s,
              bottom: Grid.m + Grid.xs,
            ),
            child: PButton(
              text: L10n.tr('devam'),
              fillParentWidth: true,
              onPressed: () => _onOpenCalender(),
            ),
          ),
        ],
      ),
    );
  }

  _onOpenCalender() {
    PBottomSheet.show(
      context,
      title: L10n.tr('select_booking_date'),
      child: EnquraAppointmentSelectorDateWidget(
        initialDate: _appointmentDate,
        callType: _enquraBloc.state.callType,
        onDateSelected: (selectedDate) {
          _appointmentDate = selectedDate;
          if (_appointmentDate == null) return;
          PBottomSheet.show(
            context,
            title: L10n.tr('select_booking_date'),
            titlePadding: const EdgeInsets.only(
              top: Grid.m,
            ),
            child: EnquraAppointmentSelectorTimeWidget(
              appoinmentDay: _appointmentDate!,
              callType: _enquraBloc.state.callType,
              onSelectedAppointment: (appointment) {
                if (appointment == null) return;
                PBottomSheet.show(
                  context,
                  child: EnquraAppoinmentApproveWidget(
                    appointment: appointment,
                    callType: _enquraBloc.state.callType,
                    onApproved: () {
                      _enquraBloc.add(
                        SaveAppointmentEvent(
                          appointmentItem: appointment,
                          onCallback: (isSuccess) async {
                            if (isSuccess) {
                              final parts = appointment.startTime.split(':');
                              final meetingTime = DateTime(
                                appointment.date.dateTime.date.year,
                                appointment.date.dateTime.date.month,
                                appointment.date.dateTime.date.day,
                                int.parse(parts[0]),
                                int.parse(parts[1]),
                                int.parse(parts[2]),
                              );
                              _enquraBloc.add(
                                CreateOrUpdateUserEvent(
                                  user: EnquraCreateUserModel(
                                    phoneNumber: _enquraBloc.state.phoneNumber,
                                    videoCallAppointmentDate: meetingTime.toIso8601String(),
                                    videoCallAppointmentTime: appointment.startTime,
                                    currentStep: EnquraPageSteps.appointmentCreated,
                                  ),
                                ),
                              );
                              _enquraBloc.add(
                                SetMeetingDataEvent(
                                  sessionNo: _enquraBloc.state.sessionNo ?? '',
                                  referanceCode: _enquraBloc.state.startIntegration?.referanceCode ?? '',
                                  meetingTime: meetingTime,
                                ),
                              );
                            }

                            final isButtonReturn = await router.popAndPush(
                              InfoRoute(
                                variant: isSuccess ? InfoVariant.success : InfoVariant.failed,
                                fromGlobalOnboarding: true,
                                message: isSuccess
                                    ? L10n.tr('saved_video_call_appointment')
                                    : L10n.tr('error_saved_video_call_appointment'),
                                subMessage: isSuccess ? L10n.tr('inform_video_call_appointment') : null,
                                subMessageStyle: context.pAppStyle.labelReg18textPrimary,
                                buttonText: isSuccess ? L10n.tr('go_to_home_to_explore') : L10n.tr('try_again'),
                                onPressedCloseIcon: () {
                                  router.maybePop(false);
                                },
                                onTapButton: () {
                                  router.maybePop(true);
                                },
                              ),
                            );

                            if (isSuccess && isButtonReturn == true) {
                              if (widget.isFirstLaunch) {
                                router.pushAndPopUntil(
                                  SplashRoute(
                                    fromMemberOtp: true,
                                  ),
                                  predicate: (_) => false,
                                );
                              } else {
                              router.replaceAll(
                                [
                                  DashboardRoute(
                                    key: ValueKey('${DashboardRoute.name}-${DateTime.now().millisecondsSinceEpoch}'),
                                  ),
                                ],
                              );
                              }
                            } else if (isSuccess) {
                              _enquraBloc.add(GetAppointmentEvent());
                            } else {
                              router.push(EnquraAppointmentVideoCallRoute(
                                isFirstLaunch: widget.isFirstLaunch,
                              ));
                            }
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  bool _isWithinWorkingHours() {
    final now = DateTime.now();
    final startParts = (_workingHours['start'] as String).split(':');
    final endParts = (_workingHours['end'] as String).split(':');

    final start = TimeOfDay(hour: int.parse(startParts[0]), minute: int.parse(startParts[1]));
    final end = TimeOfDay(hour: int.parse(endParts[0]), minute: int.parse(endParts[1]));

    final nowTod = TimeOfDay.fromDateTime(now);

    bool isAfterStart = nowTod.hour > start.hour || (nowTod.hour == start.hour && nowTod.minute >= start.minute);
    bool isBeforeEnd = nowTod.hour < end.hour || (nowTod.hour == end.hour && nowTod.minute <= end.minute);

    return isAfterStart && isBeforeEnd;
  }
}
