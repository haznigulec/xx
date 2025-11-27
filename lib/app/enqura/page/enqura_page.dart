import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/enqura/bloc/enqura_bloc.dart';
import 'package:piapiri_v2/app/enqura/bloc/enqura_event.dart';
import 'package:piapiri_v2/app/enqura/bloc/enqura_state.dart';
import 'package:piapiri_v2/app/enqura/model/account_setting_status_model.dart';
import 'package:piapiri_v2/app/enqura/utils/enqualify_helper.dart';
import 'package:piapiri_v2/app/enqura/utils/enqura_page_steps.dart';
import 'package:piapiri_v2/app/enqura/widget/enqura_leave_page.dart';
import 'package:piapiri_v2/app/enqura/widget/enqura_tile.dart';
import 'package:piapiri_v2/app/info/model/info_variant.dart';
import 'package:piapiri_v2/common/utils/constant.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/analytics/analytics.dart';
import 'package:piapiri_v2/core/config/analytics/analytics_events.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';
import 'package:styled_text/widgets/styled_text.dart';

@RoutePage()
class EnquraPage extends StatefulWidget {
  final bool isFirstLaunch;
  final bool isComeFromRegisterPage;
  final bool isExistDashboard;
  final bool openAuthenticationPage;

  const EnquraPage({
    this.isFirstLaunch = false,
    this.isComeFromRegisterPage = false,
    this.isExistDashboard = false,
    this.openAuthenticationPage = false,
    super.key,
  });
  @override
  State<EnquraPage> createState() => _EnquraPageState();
}

class _EnquraPageState extends State<EnquraPage> {
  late EnquraBloc _enquraBloc;
  bool _isInitialized = false;
  bool _backButtonPressedDisposeClosedPage = true;

  @override
  void initState() {
    EnqualifyHelper.setEventHandler((event, data) {});

    _enquraBloc = getIt<EnquraBloc>();
    getIt<Analytics>().track(
      AnalyticsEvents.processAccountStepsView,
    );
    _enquraBloc.add(
      GetTokenEvent(
        setNewToken: !widget.isComeFromRegisterPage,
        onSuccess: () {
          _enquraBloc.add(OtpStatusEvent(otpIsRequired: !widget.isComeFromRegisterPage));
          _enquraBloc.add(GetCountriesEvent());
          _enquraBloc.add(GetProfessionsEvent());
          _enquraBloc.add(
            GenerateRegisterValuesEvent(
              onGenerateSessionNo: !widget.isComeFromRegisterPage,
              callback: () {
                _enquraBloc.add(
                  GetUserEvent(
                    guid: _enquraBloc.state.guid ?? '',
                    phoneNumber: _enquraBloc.state.phoneNumber ?? '',
                    isFirstInitialize: true,
                    errorCallback: (completer) {
                      _enquraBloc.add(ClearActiveProcessEvent());
                      setState(() => _isInitialized = true);
                      WidgetsBinding.instance.addPostFrameCallback(
                        (_) {
                          router.popAndPush(
                            EnquraRegisterRoute(
                              isFirstLaunch: widget.isFirstLaunch,
                            ),
                          );
                          WidgetsBinding.instance.addPostFrameCallback(
                            (_) {
                              completer.complete();
                            },
                          );
                        },
                      );
                    },
                    successCallback: () async {
                      final startIntegration = StartIntegrationEvent(
                        sessionNo: _enquraBloc.state.sessionNo ?? '',
                        identityNumber: int.parse(_enquraBloc.state.user?.identityNumber ?? ''),
                        birthYear: _enquraBloc.state.user?.birthDate?.year ?? 0,
                        birthMonth: _enquraBloc.state.user?.birthDate?.month ?? 0,
                        birthDay: _enquraBloc.state.user?.birthDate?.day ?? 0,
                        phone: _enquraBloc.state.user?.phoneNumber ?? '',
                        etk: _enquraBloc.state.user?.etk ?? false,
                        errorCallback: (integrationModel) async {
                          setState(() => _isInitialized = true);
                          await router.push(
                            InfoRoute(
                              variant: InfoVariant.failed,
                              message: L10n.tr('scan_id_card_failed'),
                              subMessage: integrationModel.onboardingExists
                                  ? L10n.tr('register_onboardingExists')
                                  : integrationModel.gtpUserExists
                                      ? L10n.tr('register_gtpUserExists')
                                      : L10n.tr('invalid_identity_information'),
                              buttonText: L10n.tr('try_again'),
                              showCloseIcon: false,
                              onTapButton: () async {
                                router.maybePop();
                              },
                            ),
                          );
                          _enquraBloc.add(ClearActiveProcessEvent());
                          router.popAndPush(
                            EnquraRegisterRoute(
                              isFirstLaunch: widget.isFirstLaunch,
                            ),
                          );
                        },
                        successCallback: () {
                          setState(() => _isInitialized = true);
                          if (widget.openAuthenticationPage) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              router.push(
                                EnquraOtpRoute(
                                  isRegisterOTP: false,
                                  user: _enquraBloc.state.user!.copyWith(
                                    sessionNo: _enquraBloc.state.sessionNo,
                                  ),
                                  onSuccess: () async {
                                    await router.maybePop();
                                    WidgetsBinding.instance.addPostFrameCallback(
                                      (_) {
                                        router.push(
                                          const EnquraAuthenticationRoute(),
                                        );
                                      },
                                    );
                                  },
                                ),
                              );
                            });
                          }
                        },
                      );
                      if (_enquraBloc.state.appointmentReferenceCode?.isNotEmpty == true) {
                        _enquraBloc.add(
                          InitializeSDKEvent(
                            checkAppointment: true,
                            callback: (isActiveAppointment) async {
                              if (isActiveAppointment) {
                                _enquraBloc
                                    .add(EnquraAccountSettingStatusEvent(currentStep: EnquraPageSteps.onlineContracts));
                                setState(() => _isInitialized = true);
                              } else {
                                _enquraBloc.add(ClearAppointmentEvent(
                                  onCallback: () {
                                    _enquraBloc.add(startIntegration);
                                  },
                                ));
                              }
                            },
                          ),
                        );
                      } else {
                        _enquraBloc.add(startIntegration);
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
    super.initState();
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
          ledingIcon: ImagesPath.x,
          title: '',
          dividerHeight: 0,
          backButtonPressedDisposeClosedPage: _backButtonPressedDisposeClosedPage,
          backButtonPressedDisposeClosedFunction: () => _onWillPop(context),
          onPressed: () => _onWillPop(context),
        ),
        body: PBlocBuilder<EnquraBloc, EnquraState>(
          bloc: _enquraBloc,
          builder: (context, state) => !_isInitialized || state.isLoading
              ? const PLoading()
              : SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Grid.m,
                    ),
                    child: state.accountSettingStatus?.accountStatus != null
                        ? Text(
                            L10n.tr('success'),
                          ) // hesap açıldığındaki ekranda ne gözükecek
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: Grid.m,
                              ),
                              Text(
                                L10n.tr('enqura_create_account'),
                                style: context.pAppStyle.labelMed18textPrimary,
                              ),
                              const SizedBox(
                                height: Grid.m - Grid.xs,
                              ),
                              Text(
                                L10n.tr('enqura_create_account_description'),
                                style: context.pAppStyle.labelReg14textPrimary,
                              ),
                              const SizedBox(
                                height: Grid.m - Grid.xs,
                              ),
                              Text(
                                L10n.tr('enqura_create_account_estimated_time'),
                                style: context.pAppStyle.labelMed14primary,
                              ),
                              const SizedBox(
                                height: Grid.m - Grid.xs,
                              ),
                              Expanded(
                                child: ListView.separated(
                                  itemCount: enquraOnboardingList.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return EnquraTileWidget(
                                      number: index + 1,
                                      text: enquraOnboardingList[index],
                                      state: state,
                                      onClick: () => _onClickEnquraTile(index),
                                    );
                                  },
                                  separatorBuilder: (BuildContext context, int index) => const PDivider(),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: Grid.m + Grid.xs,
                                ),
                                child: Text(
                                  L10n.tr('enqura_onboarding_info'),
                                  textAlign: TextAlign.center,
                                  style: context.pAppStyle.labelReg14textPrimary,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
        ),
        persistentFooterButtons: [
          PBlocBuilder<EnquraBloc, EnquraState>(
            bloc: _enquraBloc,
            builder: (context, state) => !_isInitialized || state.isLoading
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.only(
                      bottom: Grid.m + Grid.xs,
                      left: Grid.s,
                      right: Grid.s,
                    ),
                    child: PButton(
                      text: L10n.tr(
                        (state.accountSettingStatus?.personalInformation ?? 0) == 0
                            ? 'startProcess'
                            : 'continueProcess',
                      ),
                      fillParentWidth: true,
                      onPressed: state.isLoading
                          ? null
                          : () => _onStartOrNext(
                                state.accountSettingStatus ?? EnquraAccountSettingStatusModel(),
                              ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void _checkAppointment() {
    _enquraBloc.add(
      GetAppointmentEvent(
        onCallback: (appointmentData) {
          if (appointmentData?.isPriorityCustomer == true) {
            router.push(
              EnquraVideoCallRoute(
                isComeFromRegisterPage: widget.isComeFromRegisterPage,
                isExistDashboard: widget.isExistDashboard,
              ),
            );
          } else {
            final appointment = _enquraBloc.state.appointmentData!;
            final startDate = appointment.startDate.dateTime.date;
            final startTime = appointment.startDate.dateTime.time;
            final endTime = appointment.endDate.dateTime.time;
            final appointmentDate = DateTime(
              startDate.year,
              startDate.month,
              startDate.day,
            );

            PBottomSheet.showError(
              context,
              content: '',
              showFilledButton: true,
              contentWidget: StyledText(
                text: L10n.tr(
                  'hold_appointment_message',
                  namedArgs: {
                    'date': '<bold>${DateTimeUtils.dateFormat(appointmentDate)}</bold>',
                    'time': '<bold>${'${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')} - '
                        '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}'}</bold>',
                  },
                ),
                textAlign: TextAlign.center,
              ),
              filledButtonText: L10n.tr('tamam'),
              onFilledButtonPressed: () => router.maybePop(),
            );
          }
        },
      ),
    );
  }

  void _onStartOrNext(EnquraAccountSettingStatusModel model) {
    if (_enquraBloc.state.user != null && _enquraBloc.state.otpIsRequired) {
      router.push(
        EnquraOtpRoute(
          isRegisterOTP: false,
          user: _enquraBloc.state.user!.copyWith(
            sessionNo: _enquraBloc.state.sessionNo,
          ),
          onSuccess: () async {
            await router.maybePop();
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _onStartOrNext(model);
            });
          },
        ),
      );
      return;
    }

    if (_enquraBloc.state.appointmentData != null) {
      _checkAppointment();
      return;
    }

    if (model.personalInformation == 0) {
      router.push(
        EnquraPersonalInformationRoute(
          title: L10n.tr('enqura_personalInformation'),
        ),
      );
    } else if (model.financialInformation == 0) {
      router.push(
        EnquraFinancialInformationRoute(
          title: L10n.tr('enqura_financialInformation'),
        ),
      );
    } else if (model.identityVerification == 0) {
      router.push(
        const EnquraAuthenticationRoute(),
      );
    } else if (model.onlineContracts == 0) {
      if (_enquraBloc.state.startIntegration!.manualAdresRequired) {
        router.push(
          const EnquraAdressInfoRoute(),
        );
      } else {
        router.push(
          const EnquraContractRoute(),
        );
      }
    } else if (model.videoCall == 0) {
      _enquraBloc.add(
        GetVideoCallAvailabilityEvent(
          sessionNo: _enquraBloc.state.sessionNo ?? '',
          onSuccessCallBack: (canConnectVideoCall, completer) {
            router.push(
              canConnectVideoCall
                  ? EnquraVideoCallRoute(
                      isComeFromRegisterPage: widget.isComeFromRegisterPage,
                      isExistDashboard: widget.isExistDashboard,
                      isFirstLaunch: widget.isFirstLaunch,
                    )
                  : EnquraAppointmentVideoCallRoute(
                      isFirstLaunch: widget.isFirstLaunch,
                    ),
            );
            WidgetsBinding.instance.addPostFrameCallback((_) {
              completer.complete();
            });
          },
        ),
      );
    }
  }

  void _onClickEnquraTile(int currentStep) {
    if (_enquraBloc.state.user != null && _enquraBloc.state.otpIsRequired) {
      router.push(
        EnquraOtpRoute(
          isRegisterOTP: false,
          user: _enquraBloc.state.user!.copyWith(
            sessionNo: _enquraBloc.state.sessionNo,
          ),
          onSuccess: () async {
            await router.maybePop();
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _onClickEnquraTile(currentStep);
            });
          },
        ),
      );
      return;
    }

    if (_enquraBloc.state.appointmentData != null) {
      _checkAppointment();
      return;
    }

    if (currentStep == 0) {
      router.push(
        EnquraPersonalInformationRoute(
          title: L10n.tr('enqura_personalInformation'),
        ),
      );
    } else if (_enquraBloc.state.accountSettingStatus?.personalInformation == 1 && currentStep == 1) {
      router.push(
        EnquraFinancialInformationRoute(
          title: L10n.tr('enqura_financialInformation'),
        ),
      );
    } else if (_enquraBloc.state.accountSettingStatus?.financialInformation == 1 &&
        _enquraBloc.state.accountSettingStatus?.identityVerification == 0 &&
        currentStep == 2) {
      router.push(
        const EnquraAuthenticationRoute(),
      );
    } else if (_enquraBloc.state.accountSettingStatus?.identityVerification == 1 &&
        _enquraBloc.state.accountSettingStatus?.onlineContracts == 0 &&
        currentStep == 3) {
      if (_enquraBloc.state.startIntegration!.manualAdresRequired) {
        router.push(
          const EnquraAdressInfoRoute(),
        );
      } else {
        router.push(
          const EnquraContractRoute(),
        );
      }
    } else if (_enquraBloc.state.accountSettingStatus?.onlineContracts == 1 &&
        _enquraBloc.state.accountSettingStatus?.videoCall == 0 &&
        currentStep == 4) {
      _enquraBloc.add(
        GetVideoCallAvailabilityEvent(
          sessionNo: _enquraBloc.state.sessionNo ?? '',
          onSuccessCallBack: (canConnectVideoCall, completer) {
            router.push(
              canConnectVideoCall
                  ? EnquraVideoCallRoute(
                      isComeFromRegisterPage: widget.isComeFromRegisterPage,
                      isExistDashboard: widget.isExistDashboard,
                    )
                  : EnquraAppointmentVideoCallRoute(
                      isFirstLaunch: widget.isFirstLaunch,
                    ),
            );
            WidgetsBinding.instance.addPostFrameCallback((_) {
              completer.complete();
            });
          },
        ),
      );
    }
  }

  Future<void> _onWillPop(BuildContext context) async {
    bool isContinue = false;
    if (widget.isComeFromRegisterPage) {
      getIt<Analytics>().track(
        AnalyticsEvents.enquraPageBackButton,
      );
      isContinue = await toEnquraOnboardingPage(
            context,
            contentText: L10n.tr('enqura_leave_page_warning_after_registered'),
            aproveText: L10n.tr('continue_process'),
            rejectText: L10n.tr('do_it_later'),
          ) ??
          true;
    }

    if (isContinue) return;
    setState(() {
      _backButtonPressedDisposeClosedPage = false;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isExistDashboard) {
        router.maybePop();
      } else {
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
      }
    });
  }
}
