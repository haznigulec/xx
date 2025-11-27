import 'dart:async';
import 'dart:developer';
import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:p_core/keys/navigator_keys.dart';
import 'package:p_core/utils/platform_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:piapiri_v2/app/enqura/bloc/enqura_bloc.dart';
import 'package:piapiri_v2/app/enqura/bloc/enqura_event.dart';
import 'package:piapiri_v2/app/enqura/bloc/enqura_state.dart';
import 'package:piapiri_v2/app/enqura/model/enqura_create_user_model.dart';
import 'package:piapiri_v2/app/enqura/utils/enqualify_helper.dart';
import 'package:piapiri_v2/app/enqura/utils/enqura_helpers.dart';
import 'package:piapiri_v2/app/enqura/utils/enqura_page_steps.dart';
import 'package:piapiri_v2/app/enqura/widget/enqura_info_widget.dart';
import 'package:piapiri_v2/app/info/model/info_variant.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/config/analytics/analytics.dart';
import 'package:piapiri_v2/core/config/analytics/analytics_events.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';

@RoutePage()
class EnquraVideoCallPage extends StatefulWidget {
  const EnquraVideoCallPage({
    required this.isComeFromRegisterPage,
    required this.isExistDashboard,
    this.isFirstLaunch = false,
    super.key,
  });

  final bool isComeFromRegisterPage;
  final bool isExistDashboard;
  final bool isFirstLaunch;

  @override
  State<EnquraVideoCallPage> createState() => _EnquraVideoCallPageState();
}

class _EnquraVideoCallPageState extends State<EnquraVideoCallPage> {
  late final EnquraBloc _enquraBloc;
  late String _phoneNumber;
  PageState _pageState = PageState.initial;
  bool _isStartedCall = false;
  bool _isStartedNfcScan = false;

  StreamSubscription? _videoCallSubscription;
  void _listenCallEvents() {
    _videoCallSubscription = EnqualifyEventBridge.stream.listen(
      (payload) async {
        final event = payload['event'] as String?;
        final data = payload['data'];
        log('listenCallEvent event:$event  --- data:$data');
        switch (event) {
          case 'onRoomIDSendFailed':
            _callFinishedOnFailed();
            break;

          // case 'onRoomIDSendSucceed':
          // break;

          // case 'onCallWait':
          //   break;

          case 'onCallStarted':
            _isStartedCall = true;
            break;

          case 'onNfcCompleted':
            _isStartedNfcScan = false;
            await EnqualifyHelper.confirmVerification('NFC');
            await EnqualifyHelper.restartVideoChat();
            break;

          case 'onAgentRequest':
            if (data['request'] == 'OcrRetried') {
              await EnqualifyHelper.runOcrFrontFlow();
              await EnqualifyHelper.confirmVerification('IDText');
              await EnqualifyHelper.restartVideoChat();
            } else if (data['request'] == 'NfcRetried') {
              if (!_isStartedNfcScan) {
                _isStartedNfcScan = true;
                EnqualifyHelper.startNfcRetried(
                  L10n.tr('nfc_scaning'),
                  L10n.tr('nfc_scaning_instruction'),
                );
              }
            } else if (data['request'] == 'LivenessControlRetried') {
              await EnqualifyHelper.runFaceFlow();
              await EnqualifyHelper.confirmVerification('Face');
              await EnqualifyHelper.restartVideoChat();
            } else if (data['request'] == 'BackToVideoCall') {
              await EnqualifyHelper.restartVideoChat();
            }
            break;

          // case 'onForceHangup':
          //   break;

          case 'onLocalHangedUp':
            if (_isStartedCall) {
              await _callFinishedOnFailed();
            } else {
              await EnqualifyHelper.hangupCall();
            }
            break;

          // case 'onRemoteHangedUp':
          //   break;

          // case 'onMaximumCallTimeExpired':
          //   break;

          case 'onResultGetSucceed':
            final verifyCallResult = data['verifyCallResult'];
            final successResponse = L10n.tr('new_customer_result_success');
            final pendingResponse = L10n.tr('new_customer_result_pending');
            if (verifyCallResult == successResponse) {
              await _callFinishedOnSuccess();
            } else if (verifyCallResult == pendingResponse) {
              await _callFinishedOnSuccess(checkStatus300: true);
            } else {
              await _callFinishedOnFailed();
            }
            break;

          case 'onResultGetFailed':
            await _callFinishedOnFailed();
            break;

          case 'onCallSessionCloseResult':
            _videoCallSubscription?.cancel();
            final status = data?['status'] as String?;
            if (status == 'SUCCESS') {
              await _callFinishedOnSuccess();
            } else {
              await _callFinishedOnFailed();
            }
            break;

          case 'onFailure':
            if (data['code'] == 'NFCTimeout') {
              _isStartedNfcScan = false;
              await EnqualifyHelper.confirmVerification('NFC');
              await EnqualifyHelper.restartVideoChat();
            }
            break;
        }
      },
    );
  }

  Future _callFinishedOnSuccess({bool checkStatus300 = false}) async {
    if (PlatformUtils.isAndroid) {
      _videoCallSubscription?.cancel();
      // await EnqualifyHelper.closeFragmentByTag('CameraFragment');
      await EnqualifyHelper.replaceFragment();
      await EnqualifyHelper.exitCall();
    }
    _enquraBloc.add(DestroySDKEvent(runDestroy: PlatformUtils.isAndroid));
    _enquraBloc.add(
      CreateOrUpdateUserEvent(
        user: EnquraCreateUserModel(
          phoneNumber: _phoneNumber,
          videoCallCompleted: true,
          currentStep: EnquraPageSteps.videoCalling,
          videoCallAppointmentTime: DateTime.now().toIso8601String(),
        ),
      ),
    );
    _enquraBloc.add(ClearActiveProcessEvent());
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    getIt<Analytics>().track(
      AnalyticsEvents.accountSuccess,
    );
    //Görüntülü görüşme ekranını kapatır.
    //Enqura page üzerinden Info Page'i açar
    //Info Page'in kapanmasını bekler açar
    await router.popAndPush(
      InfoRoute(
        variant: InfoVariant.success,
        fromGlobalOnboarding: true,
        message: L10n.tr('video_call_finished'),
        subMessage:
            checkStatus300 ? L10n.tr('video_call_finished_status300_message') : L10n.tr('video_call_finished_message'),
        buttonText: L10n.tr('go_to_home_to_explore'),
        onPressedCloseIcon: () async {
          //Info Page'i kapatır.
          await router.maybePop();
        },
        onTapButton: () async {
          //Info Page'i kapatır.
          await router.maybePop();
        },
      ),
    );

    if (widget.isFirstLaunch) {
      router.pushAndPopUntil(
        SplashRoute(
          fromMemberOtp: true,
        ),
        predicate: (_) => false,
      );
    } else {
    //Dashboard replace eder.
    router.replaceAll(
      [
        DashboardRoute(
          key: ValueKey('${DashboardRoute.name}-${DateTime.now().millisecondsSinceEpoch}'),
        ),
      ],
    );
  }
  }

  Future _callFinishedOnFailed() async {
    if (PlatformUtils.isAndroid) {
      _videoCallSubscription?.cancel();
      // await EnqualifyHelper.closeFragmentByTag('CameraFragment');
      await EnqualifyHelper.replaceFragment();
      await EnqualifyHelper.exitCall();
    }

    if (_enquraBloc.state.appointmentData != null) {
      _enquraBloc.add(ClearAppointmentEvent());
    }

    _enquraBloc.add(DestroySDKEvent(runDestroy: PlatformUtils.isAndroid));
    _enquraBloc.add(
      CreateOrUpdateUserEvent(
        user: EnquraCreateUserModel(
          phoneNumber: _phoneNumber,
          currentStep: EnquraPageSteps.financialInformation,
        ),
      ),
    );
    _enquraBloc.add(
      EnquraAccountSettingStatusEvent(
        currentStep: EnquraPageSteps.financialInformation,
      ),
    );

    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    //Görüntülü görüşme ekranını kapatır.
    //Enqura page üzerinden Info Page'i açar
    //Info Page'in kapanmasını bekler açar
    var openAuthenticationPage = await router.popAndPush(
      InfoRoute(
        fromGlobalOnboarding: true,
        variant: InfoVariant.failed,
        message: L10n.tr('start_video_call_finished_error'),
        subMessage: L10n.tr('start_video_call_finished_error_message'),
        buttonText: L10n.tr('retry'),
        onPressedCloseIcon: () async {
          await router.maybePop(false); //Info page kendini kapatır ve Enqura page'e döner
        },
        onTapButton: () async {
          await router.maybePop(true); //Info page kendini kapatır ve Enqura page'e döner
        },
      ),
    );

    //Enqura page'i kapatır ve enqura page'i tekrar ayağa kaldırır.
    router.popAndPush(
      EnquraRoute(
        isComeFromRegisterPage: widget.isComeFromRegisterPage,
        isExistDashboard: widget.isExistDashboard,
        openAuthenticationPage: openAuthenticationPage == true,
        isFirstLaunch: widget.isFirstLaunch,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _enquraBloc = getIt<EnquraBloc>();
    _enquraBloc.add(PostIntegrationAddEvent());
    getIt<Analytics>().track(
      AnalyticsEvents.videoCallStartView,
    );
    _phoneNumber = _enquraBloc.state.user?.phoneNumber ?? '';
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
                      if (_pageState == PageState.loading)
                        EnquraInfoWidget(
                          imageFormatIsSvg: false,
                          imagePath: ImagesPath.videocall,
                          title: L10n.tr('starting_video_call'),
                          subTitle: L10n.tr('starting_video_call_message'),
                        )
                      else
                        EnquraInfoWidget(
                          imageFormatIsSvg: false,
                          imagePath: ImagesPath.videocall,
                          title: L10n.tr('start_video_call'),
                          subTitle: L10n.tr('start_video_call_message'),
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
            child: Visibility(
              visible: _pageState != PageState.loading,
              child: PButton(
                text: _pageState == PageState.initial ? L10n.tr('basla') : L10n.tr('devam'),
                fillParentWidth: true,
                onPressed: _pageState == PageState.loading
                    ? null
                    : () async {
                        if (PlatformUtils.isAndroid) {
                          bool hasCameraPermission = await handlePermission(
                            permission: Permission.camera,
                            message: 'required_camera_permission',
                            ctx: context,
                          );
                          if (!hasCameraPermission) return;

                          bool hasMicrophonePermission = await handlePermission(
                            permission: Permission.microphone,
                            message: 'required_microphone_permission',
                            ctx: NavigatorKeys.navigatorKey.currentContext ?? context,
                          );
                          if (!hasMicrophonePermission) return;
                        }

                        setState(() => _pageState = PageState.loading);
                        if (PlatformUtils.isIos) {
                          bool isCompleted;
                          bool isStatus300;
                          if (getIt<EnquraBloc>().state.appointmentData != null) {
                            await EnqualifyHelper.startIdVerify();
                            var response = await EnqualifyHelper.startAppointmentCall();
                            isCompleted = response.$1;
                            isStatus300 = response.$2;
                          } else {
                            var response = await EnqualifyHelper.startVideoCall();
                            isCompleted = response.$1;
                            isStatus300 = response.$2;
                          }
                          if (isCompleted) {
                            _callFinishedOnSuccess(checkStatus300: isStatus300);
                          } else {
                            await _callFinishedOnFailed();
                          }
                        } else {
                          await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
                          getIt<Analytics>().track(
                            AnalyticsEvents.videoCallWaitingView,
                          );
                          _listenCallEvents();
                          EnqualifyHelper.runCallFlow();
                        }
                      },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
