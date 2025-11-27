import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/auth/widgets/count_down_timer_widget.dart';
import 'package:piapiri_v2/app/enqura/bloc/enqura_bloc.dart';
import 'package:piapiri_v2/app/enqura/bloc/enqura_event.dart';
import 'package:piapiri_v2/app/enqura/bloc/enqura_state.dart';
import 'package:piapiri_v2/app/enqura/model/enqura_create_user_model.dart';
import 'package:piapiri_v2/common/utils/button_padding.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/config/analytics/analytics.dart';
import 'package:piapiri_v2/core/config/analytics/analytics_events.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:pinput/pinput.dart';

@RoutePage()
class EnquraOtpPage extends StatefulWidget {
  const EnquraOtpPage({
    this.isRegisterOTP = true,
    required this.user,
    required this.onSuccess,
    super.key,
  });
  final bool isRegisterOTP;
  final EnquraCreateUserModel user;
  final Function() onSuccess;
  @override
  State<EnquraOtpPage> createState() => _EnquraOtpPageState();
}

class _EnquraOtpPageState extends State<EnquraOtpPage> with TickerProviderStateMixin {
  late EnquraBloc _enquraBloc;
  late AnimationController _controller;
  int _controllerKey = 0;
  final FocusNode _focusNode = FocusNode();

  bool _isInitialized = false;
  bool _isFirstAttempt = true;
  bool _reSendCodeTextIsActive = false;
  bool _isTimeOver = false;
  String _otpCode = '';
  int _duration = 0;

  @override
  void initState() {
    super.initState();
    _enquraBloc = getIt<EnquraBloc>();
    getIt<Analytics>().track(
      AnalyticsEvents.otpView,
    );
    _otpStart();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: Grid.xxl,
      height: Grid.xxl,
      textStyle: context.pAppStyle.labelMed18primary,
      decoration: BoxDecoration(
        color: context.pColorScheme.card,
        borderRadius: BorderRadius.circular(Grid.s),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      color: context.pColorScheme.secondary,
      borderRadius: BorderRadius.circular(Grid.s),
    );

    return Theme(
      data: Theme.of(context).copyWith(
        dividerTheme: const DividerThemeData(
          color: Colors.transparent,
        ),
      ),
      child: PBlocBuilder<EnquraBloc, EnquraState>(
        bloc: _enquraBloc,
        builder: (context, state) {
          return Scaffold(
            appBar: PInnerAppBar(
              dividerHeight: 0,
              title: L10n.tr(''),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Grid.m),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: Grid.m),
                    Text(
                      L10n.tr('enqura_otp_title'),
                      style: context.pAppStyle.labelMed18textPrimary,
                    ),
                    const SizedBox(height: Grid.m - Grid.xs),
                    Text(
                      L10n.tr('enqura_otp_description'),
                      style: context.pAppStyle.labelReg14textPrimary,
                    ),
                    const SizedBox(height: Grid.m),
                    if (_isInitialized) ...[
                      Center(
                        child: Pinput(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          focusNode: _focusNode,
                          length: 6,
                          defaultPinTheme: defaultPinTheme,
                          focusedPinTheme: focusedPinTheme,
                          pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                          showCursor: true,
                          autofocus: true,
                          onSubmitted: (_) {},
                          onChanged: (value) {
                            if (value.length < 6) {
                              setState(() {
                                _otpCode = value;
                              });
                            }
                          },
                          onCompleted: (pin) {
                            setState(() {
                              _otpCode = pin;
                              if (_isFirstAttempt && !_isTimeOver) {
                                _doCheckOtp();
                                _isFirstAttempt = false;
                              }
                            });
                          },
                          androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsUserConsentApi,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: Grid.m + Grid.xs,
                        ),
                        child: CountDownTimer(
                          key: ValueKey(_controllerKey),
                          smsDuration: _duration,
                          controller: _controller,
                          timeIsOver: (timeIsOver) {
                            setState(() {
                              _reSendCodeTextIsActive = true;
                              _isTimeOver = true;
                            });
                          },
                        ),
                      ),
                      Center(
                        child: GestureDetector(
                          onTap: _reSendCodeTextIsActive ? () async => await _otpAgain() : null,
                          child: Text(
                            L10n.tr('kodu_tekrar_gonder'),
                            style: context.pAppStyle.interRegularBase.copyWith(
                              fontSize: Grid.m,
                              color: _reSendCodeTextIsActive
                                  ? context.pColorScheme.primary
                                  : context.pColorScheme.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            ),
            bottomSheet: generalButtonPadding(
              child: PButton(
                text: L10n.tr('devam'),
                loading: _isInitialized && state.type == PageState.loading,
                fillParentWidth: true,
                onPressed: !_isInitialized ||
                        _otpCode.isEmpty ||
                        _otpCode.length < 6 ||
                        state.type == PageState.loading ||
                        _isTimeOver
                    ? null
                    : () => _doCheckOtp(),
              ),
              context: context,
            ),
          );
        },
      ),
    );
  }

  void _doCheckOtp() {
    if (widget.isRegisterOTP) {
      _enquraBloc.add(
        CreateOrUpdateUserEvent(
          user: widget.user.copyWith(otpCode: _otpCode),
          onSuccess: () => widget.onSuccess.call(),
        ),
      );
    } else {
      _enquraBloc.add(
        CheckOtpEvent(
          sessionNo: widget.user.sessionNo ?? '',
          phoneNo: widget.user.phoneNumber ?? '',
          otpCode: _otpCode,
          onSuccess: () => widget.onSuccess.call(),
        ),
      );
    }
  }

  void _otpStart() {
    _enquraBloc.add(
      SendOtpEvent(
        sessionNo: _enquraBloc.state.sessionNo ?? '',
        phoneNo: widget.user.phoneNumber ?? '',
        onSuccess: (response) {
          setState(() {
            if (!_isInitialized) {
              _isInitialized = true;
            }

            _isTimeOver = false;
            _reSendCodeTextIsActive = false;
            _duration = response.data['expireInSec'];
            _controller = AnimationController(
              vsync: this,
              duration: Duration(seconds: _duration),
            );
            _controller.reverse(from: 1.0);
          });
        },
      ),
    );
  }

  Future<void> _otpAgain() async {
    _enquraBloc.add(
      SendOtpEvent(
        sessionNo: _enquraBloc.state.sessionNo ?? '',
        phoneNo: widget.user.phoneNumber ?? '',
        onSuccess: (response) {
          setState(() {
            _isTimeOver = false;
            _reSendCodeTextIsActive = false;
            _duration = response.data['expireInSec'];
            _controller.dispose();
            _controller = AnimationController(
              vsync: this,
              duration: Duration(seconds: _duration),
            );
            _controller.reverse(from: 1.0);
            _controllerKey++;
          });
        },
      ),
    );
  }
}
