import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_event.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_state.dart';
import 'package:piapiri_v2/app/auth/widgets/count_down_timer_widget.dart';
import 'package:piapiri_v2/common/utils/button_padding.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:pinput/pinput.dart';

@RoutePage()
class CheckOtpPage extends StatefulWidget {
  final String customerExtId;
  final int otpDuration;
  final bool callOtpAfterClickButton;
  final Function()? onSuccess;
  final Function(String)? onOtpValidated;
  final String? appBarTitle;
  final bool fromAccountClosure;

  const CheckOtpPage({
    super.key,
    required this.customerExtId,
    required this.otpDuration,
    this.callOtpAfterClickButton = true,
    this.onSuccess,
    this.onOtpValidated,
    this.appBarTitle,
    this.fromAccountClosure = false,
  });

  @override
  State<CheckOtpPage> createState() => _CheckOtpPageState();
}

class _CheckOtpPageState extends State<CheckOtpPage> with TickerProviderStateMixin {
  bool _reSendCodeTextIsActive = false;
  String _otp = '';
  bool _isFirstAttempt = true;
  int _duration = 10;
  late AnimationController _controller;
  final FocusNode _focusNode = FocusNode();
  late AuthBloc _authBloc;

  @override
  void initState() {
    _authBloc = getIt<AuthBloc>();
    _duration = widget.otpDuration;
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: _duration),
    );

    super.initState();
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
        borderRadius: BorderRadius.circular(
          Grid.s,
        ),
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
      child: PBlocBuilder<AuthBloc, AuthState>(
        bloc: _authBloc,
        builder: (context, state) {
          return Scaffold(
            appBar: PInnerAppBar(
              title: L10n.tr(widget.appBarTitle ?? 'authentication'),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Grid.m),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: Grid.m),
                    Text(
                      L10n.tr('lets_try_otp_title'),
                      style: context.pAppStyle.labelReg14textPrimary,
                    ),
                    const SizedBox(height: Grid.m - Grid.xs),
                    Text(
                      L10n.tr('lets_try_otp_description'),
                      style: context.pAppStyle.labelReg14textPrimary,
                    ),
                    const SizedBox(height: Grid.m),
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
                        onSubmitted: (_) => {},
                        onCompleted: (pin) {
                          setState(
                            () {
                              _otp = pin;
                              if (_isFirstAttempt) {
                                _doCheckOtp();
                                _isFirstAttempt = false;
                              }
                            },
                          );
                        },
                        androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsUserConsentApi,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: Grid.m + Grid.xs,
                      ),
                      child: CountDownTimer(
                        smsDuration: _duration,
                        controller: _controller,
                        timeIsOver: (timeIsOver) {
                          setState(() {
                            _reSendCodeTextIsActive = true;
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
                  ],
                ),
              ),
            ),
            bottomSheet: generalButtonPadding(
              child: PButton(
                text: L10n.tr('giris_yap'),
                loading: state.isLoading,
                fillParentWidth: true,
                onPressed: _otp.isEmpty || _otp.length < 6 || state.isLoading ? null : _doCheckOtp,
              ),
              context: context,
            ),
          );
        },
      ),
    );
  }

  _otpAgain() {
    _authBloc.add(
      CheckOTPAgainEvent(
        customerExtId: widget.customerExtId,
        onSuccess: (response) {
          setState(
            () {
              _reSendCodeTextIsActive = false;
              _controller.reverse(from: 1.0);
              _duration = response.data['otpTimeout'];
            },
          );
        },
      ),
    );
  }

  _doCheckOtp() async {
    if (widget.callOtpAfterClickButton) {
      _authBloc.add(
        CheckOTPEvent(
          customerExtId: widget.customerExtId,
          otp: _otp,
          onSuccess: (_) {
            if (widget.fromAccountClosure) {
              widget.onOtpValidated?.call(_otp);
              return;
            }
            widget.onSuccess?.call();
          },
        ),
      );
    } else {
      widget.onOtpValidated?.call(_otp);
      await router.maybePop();
    }
  }
}
