import 'dart:async';
import 'dart:developer';
import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/place_holder/no_data_widget.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:p_core/keys/navigator_keys.dart';
import 'package:p_core/utils/platform_utils.dart';
import 'package:piapiri_v2/app/enqura/bloc/enqura_bloc.dart';
import 'package:piapiri_v2/app/enqura/bloc/enqura_event.dart';
import 'package:piapiri_v2/app/enqura/bloc/enqura_state.dart';
import 'package:piapiri_v2/app/enqura/utils/enqualify_helper.dart';
import 'package:piapiri_v2/app/enqura/utils/enqura_helpers.dart';
import 'package:piapiri_v2/app/enqura/utils/enqura_page_steps.dart';
import 'package:piapiri_v2/app/enqura/widget/enqura_id_card_liveness_widget.dart';
import 'package:piapiri_v2/app/enqura/widget/enqura_id_card_nfc_scan_widget.dart';
import 'package:piapiri_v2/app/enqura/widget/enqura_id_card_scan_widget.dart';
import 'package:piapiri_v2/app/enqura/widget/enqura_leave_page.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/config/analytics/analytics.dart';
import 'package:piapiri_v2/core/config/analytics/analytics_events.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';
import 'package:permission_handler/permission_handler.dart';

@RoutePage()
class EnquraAuthenticationPage extends StatefulWidget {
  const EnquraAuthenticationPage({super.key});

  @override
  State<EnquraAuthenticationPage> createState() => _EnquraAuthenticationPageState();
}

class _EnquraAuthenticationPageState extends State<EnquraAuthenticationPage> {
  late EnquraBloc _enquraBloc;
  bool _backButtonPressedDisposeClosedPage = true;
  late final PageController _pageController;
  final ValueNotifier<int> _currentPageNotifier = ValueNotifier<int>(0);

  PageState _ocrStatus = PageState.initial;
  bool _isCheckedInfo = false;
  PageState _nfcStatus = PageState.initial;
  StreamSubscription? _nfcScanningSubscription;
  final ValueNotifier<double> _nfcScanningProgressNotifier = ValueNotifier<double>(0);
  PageState _livenessStatus = PageState.initial;
  bool isIos = PlatformUtils.isIos;

  @override
  void initState() {
    super.initState();
    _enquraBloc = getIt<EnquraBloc>();
    _pageController = PageController();
    if (!_enquraBloc.state.sdkIsActive) {
      _enquraBloc.add(InitializeSDKEvent(checkAppointment: false));
    }
  }

  @override
  void dispose() {
    _currentPageNotifier.dispose();
    _nfcScanningSubscription?.cancel();
    _nfcScanningProgressNotifier.dispose();
    super.dispose();
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
          title: L10n.tr('authentication'),
          backButtonPressedDisposeClosedPage: _backButtonPressedDisposeClosedPage,
          backButtonPressedDisposeClosedFunction: () => _onClosePage(),
          onPressed: () => _onClosePage(),
        ),
        body: PBlocBuilder<EnquraBloc, EnquraState>(
          bloc: _enquraBloc,
          builder: (context, state) => state.isLoading
              ? const PLoading()
              : !state.sdkIsActive
                  ? NoDataWidget(
                      message: L10n.tr('enqura_sdk_starting_error'),
                    )
                  : SafeArea(
                      child: PageView(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: _pageController,
                        onPageChanged: (index) {
                          switch (index) {
                            case 0:
                              // OCR sayfası event
                              _currentPageNotifier.value = 0;
                              getIt<Analytics>().track(
                                AnalyticsEvents.idVerificationStartView,
                              );
                              break;
                            case 1:
                              // NFC sayfası event
                              _currentPageNotifier.value = 1;
                              getIt<Analytics>().track(
                                AnalyticsEvents.idNfcView,
                              );
                              break;
                            case 2:
                              // Liveness sayfası event
                              _currentPageNotifier.value = 2;
                              getIt<Analytics>().track(
                                AnalyticsEvents.livenessCheckStartView,
                              );
                              break;
                          }
                        },
                        children: [
                          EnquraIdCardScanWidget(
                            pageState: _ocrStatus,
                            isCheckedInfo: _isCheckedInfo,
                            isCheckedInfoChanged: (isChecked) {
                              setState(() => _isCheckedInfo = isChecked);
                            },
                          ),
                          EnquraIdCardNfcScanWidget(
                            pageState: _nfcStatus,
                            nfcScanningProgressNotifier: _nfcScanningProgressNotifier,
                          ),
                          EnquraIdCardLivenessWidget(
                            pageState: _livenessStatus,
                          ),
                        ],
                      ),
                    ),
        ),
        persistentFooterButtons: [
          ValueListenableBuilder(
            valueListenable: _currentPageNotifier,
            builder: (context, currentPage, child) => Padding(
              padding: const EdgeInsets.only(
                bottom: Grid.m + Grid.xs,
                left: Grid.s,
                right: Grid.s,
              ),
              child: PButton(
                text: (currentPage == 0 && _ocrStatus == PageState.initial) ||
                        (currentPage == 1 && _nfcStatus == PageState.initial) ||
                        (currentPage == 2 && _livenessStatus == PageState.initial)
                    ? L10n.tr('basla')
                    : L10n.tr('devam'),
                fillParentWidth: true,
                onPressed: _nfcStatus == PageState.loading || _livenessStatus == PageState.loading || !_isCheckedInfo
                    ? null
                    : () async {
                        if (_pageController.page == 0) {
                          await _onClickIDCardScanButton();
                        } else if (_pageController.page == 1) {
                          await _onClickIDCardNfcScanButton();
                        } else if (_pageController.page == 2) {
                          await _onClickIDCardLivenessButton();
                        }
                      },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future _onClosePage() async {
    getIt<Analytics>().track(
      AnalyticsEvents.ocrBackButton,
    );
    bool isContinue = await toEnquraOnboardingPage(
          context,
          contentText: L10n.tr('scan_id_card_almost_done_message'),
          aproveText: L10n.tr('continue_process'),
          rejectText: L10n.tr('do_it_later'),
        ) ??
        true;

    if (isContinue) return;

    setState(() {
      _backButtonPressedDisposeClosedPage = false;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      router.maybePop();
    });
  }

  Future _onClickIDCardScanButton() async {
    if (_ocrStatus == PageState.failed) {
      setState(() {
        _ocrStatus = PageState.initial;
      });
      return;
    }

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

    return _startIDCardOCRScan();
  }

  Future _startIDCardOCRScan() async {
    if (!isIos) {
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    }
    bool isCompletedOCR;
    if (isIos) {
      final Completer<void> integrationAddCompleter = Completer<void>();

      await EnqualifyHelper.startIdVerify();
      await EnqualifyHelper.startSelfService();
      _enquraBloc.add(PostIntegrationAddEvent(
        onCallback: () {
          integrationAddCompleter.complete();
        },
      ));
      await integrationAddCompleter.future;
      isCompletedOCR = await EnqualifyHelper.startIdFront();
    } else {
      isCompletedOCR = await EnqualifyHelper.runOcrFrontFlow();
    }
    if (isCompletedOCR) {
      _enquraBloc.add(
        ValidateOCREvent(
          sessionNo: _enquraBloc.state.sessionNo ?? '',
          refCode: _enquraBloc.state.startIntegration?.referanceCode ?? '',
          isValidCallback: (isValid) async {
            if (isValid) {
              setState(() {
                _ocrStatus = PageState.success;
              });
              WidgetsBinding.instance.addPostFrameCallback(
                (_) {
                  _pageController.jumpToPage(1);
                },
              );
            } else {
              setState(() {
                _ocrStatus = PageState.failed;
              });
            }
          },
        ),
      );
    } else {
      setState(() {
        _ocrStatus = PageState.failed;
      });
    }
    if (!isIos) {
      await EnqualifyHelper.closeFragmentByTag('CameraFragment');
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }

  Future _onClickIDCardNfcScanButton() async {
    if (_nfcStatus == PageState.failed) {
      setState(() {
        _nfcStatus = PageState.initial;
      });
      return;
    }

    if (isIos) {
      setState(() => _nfcStatus = PageState.loading);
      bool isNFCCompleted = await EnqualifyHelper.startNFC();
      if (isNFCCompleted) {
        setState(() => _nfcStatus = PageState.success);
        _pageController.jumpToPage(2);
      } else {
        setState(() => _nfcStatus = PageState.failed);
      }
    } else {
      final isDeviceHasNfc = await EnqualifyHelper.isDeviceHasNfc();
      if (!isDeviceHasNfc) {
        await PBottomSheet.showError(NavigatorKeys.navigatorKey.currentContext ?? context,
            content: L10n.tr('device_not_supperted_nfc_message'),
            filledButtonText: L10n.tr('Bu Adımı Atla'),
            showFilledButton: true, onFilledButtonPressed: () {
          Navigator.of(context).pop();
        });
        _pageController.jumpToPage(2);
        return;
      }

      final isNfcEnabled = await EnqualifyHelper.isNfcEnabled();
      if (!isNfcEnabled) {
        await PBottomSheet.showError(
          NavigatorKeys.navigatorKey.currentContext ?? context,
          content: L10n.tr('nfc_disabled_message'),
          filledButtonText: L10n.tr('tamam'),
          showFilledButton: true,
          onFilledButtonPressed: () {
            Navigator.of(context).pop();
          },
        );
      }

      _listenNfcProgress();
      EnqualifyHelper.runNfcFlow();
      setState(() => _nfcStatus = PageState.loading);
    }
  }

  void _listenNfcProgress() {
    _nfcScanningSubscription = EnqualifyEventBridge.stream.listen((payload) async {
      final event = payload['event'] as String?;
      log('NFC EVENT $event');
      switch (event) {
        case 'onNfcReadStarted':
        case 'onNfcTagDetected':
          _nfcScanningProgressNotifier.value = 0.0;
          break;
        case 'onNfcFirstLevel':
          _nfcScanningProgressNotifier.value = 0.25;
          break;
        case 'onNfcSecondLevel':
          _nfcScanningProgressNotifier.value = 0.50;
          break;
        case 'onNfcThirdLevel':
          _nfcScanningProgressNotifier.value = 0.75;
          break;
        case 'onNfcFourthLevel':
        case 'onNfcCompleted':
          _nfcScanningProgressNotifier.value = 1.0;
          break;
        case 'onNfcStored':
          _nfcScanningProgressNotifier.value = 1.0;
          await Future.delayed(const Duration(milliseconds: 100));
          setState(() => _nfcStatus = PageState.success);
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            _pageController.jumpToPage(2);
            _nfcScanningSubscription?.cancel();
            await EnqualifyHelper.closeFragmentByTag('NFCBaseFragment');
          });
          break;
        case 'onNfcReadError':
        case 'onNfcStoreFailed':
        case 'onNfcBACDataFailure':
          _nfcScanningProgressNotifier.value = 0.0;
          break;
        case 'onFailure':
          _nfcScanningProgressNotifier.value = 0.0;
          setState(() => _nfcStatus = PageState.failed);
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            await _nfcScanningSubscription?.cancel();
            await _nfcScanningSubscription?.cancel();
            await EnqualifyHelper.closeFragmentByTag('NFCBaseFragment');
          });
          break;
      }
    });
  }

  Future _onClickIDCardLivenessButton() async {
    if (_livenessStatus == PageState.failed) {
      setState(() {
        _livenessStatus = PageState.initial;
      });
      return;
    }

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

    setState(() => _livenessStatus = PageState.loading);
    bool isCompleted;
    if (isIos) {
      isCompleted = await EnqualifyHelper.startFaceDetect();
    } else {
      isCompleted = await EnqualifyHelper.runFaceFlow();
    }
    if (isCompleted) {
      _enquraBloc.add(
        EnquraAccountSettingStatusEvent(
          currentStep: EnquraPageSteps.identityVerification,
        ),
      );

      if (PlatformUtils.isAndroid) {
        _enquraBloc.add(PostIntegrationAddEvent());
        await EnqualifyHelper.closeFragmentByTag('CameraFragment');
      }

      setState(() {
        _livenessStatus = PageState.success;
        _backButtonPressedDisposeClosedPage = false;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        router.maybePop();
      });
    } else {
      if (PlatformUtils.isAndroid) {
        await EnqualifyHelper.closeFragmentByTag('CameraFragment');
      }
      setState(() => _livenessStatus = PageState.failed);
    }
  }
}
