import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/auth/widgets/count_down_timer_widget.dart';
import 'package:piapiri_v2/app/info/model/info_variant.dart';
import 'package:piapiri_v2/app/member/bloc/member_bloc.dart';
import 'package:piapiri_v2/app/member/bloc/member_event.dart';
import 'package:piapiri_v2/app/member/bloc/member_state.dart';
import 'package:piapiri_v2/common/utils/button_padding.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_bloc.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_event.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/analytics/analytics.dart';
import 'package:piapiri_v2/core/config/analytics/analytics_events.dart';
import 'package:piapiri_v2/core/config/notification_handler.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/insider_event_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:pinput/pinput.dart';

@RoutePage()
class MemberOtpPage extends StatefulWidget {
  final String gsm;
  final String fullName;
  final String? email;
  final bool kvkk;
  final bool etk;
  final int otpTimeout;
  const MemberOtpPage({
    super.key,
    required this.gsm,
    required this.fullName,
    this.email,
    required this.kvkk,
    required this.etk,
    required this.otpTimeout,
  });

  @override
  State<MemberOtpPage> createState() => _MemberOtpPageState();
}

class _MemberOtpPageState extends State<MemberOtpPage> with TickerProviderStateMixin {
  late MemberBloc _memberBloc;
  late AppInfoBloc _appInfoBloc;
  late AnimationController _controller;
  final FocusNode _focusNode = FocusNode();
  bool _isFirstAttempt = true;
  bool _reSendCodeTextIsActive = false;
  String _otp = '';
  int _duration = 10;

  @override
  void initState() {
    _memberBloc = getIt<MemberBloc>();
    _appInfoBloc = getIt<AppInfoBloc>();
    _duration = widget.otpTimeout;
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
      child: PBlocBuilder<AppInfoBloc, AppInfoState>(
        bloc: _appInfoBloc,
        builder: (context, appInfoState) {
          return PBlocBuilder<MemberBloc, MemberState>(
            bloc: _memberBloc,
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
                          L10n.tr('lets_try_otp_title'),
                          style: context.pAppStyle.labelReg18textPrimary,
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
                              setState(() {
                                _otp = pin;
                                if (_isFirstAttempt) {
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
          );
        },
      ),
    );
  }

  _doCheckOtp() {
    _memberBloc.add(CreateMemberEvent(
      fullName: widget.fullName,
      gsm: widget.gsm.replaceAll(' ', ''),
      email: widget.email,
      kvkk: widget.kvkk,
      etk: widget.etk,
      otp: _otp,
      callback: (response) async {
        if (response.success) {
          _appInfoBloc.add(WriteHasMembershipEvent(
            status: true,
            gsm: widget.gsm.replaceAll(' ', ''),
          ));
          getIt<Analytics>().track(
            AnalyticsEvents.splashTryNowOtpSuccessView,
            taxonomy: [
              InsiderEventEnum.memberPage.value,
              InsiderEventEnum.otpPage.value,
            ],
          );
          await getIt<NotificationHandler>().registerForNotifications();
          router.push(
            InfoRoute(
              variant: InfoVariant.success,
              message: L10n.tr('success_create_member'),
              onPressedCloseIcon: () => router.replaceAll([
                DashboardRoute(
                  key: ValueKey('${DashboardRoute.name}-${DateTime.now().millisecondsSinceEpoch}'),
                ),
              ]),
            ),
          );
        } else {
          router.push(
            InfoRoute(
              variant: InfoVariant.failed,
              message: L10n.tr(
                'member.${response.error?.message ?? ''}',
              ),
              showCloseIcon: false,
              buttonText: L10n.tr('giris_yap'),
              onTapButton: () => router.pushAndPopUntil(
                AuthRoute(),
                predicate: (e) => e.settings.name == CreateAccountRoute.name,
              ),
            ),
          );
        }
      },
    ));
  }

  _otpAgain() {
    _memberBloc.add(MemberRequestOtpEvent(
      gsm: widget.gsm.replaceAll(' ', ''),
      onSuccess: (response) {
        setState(() {
          _reSendCodeTextIsActive = false;
          _controller.reverse(from: 1.0);
          _duration = response.data['otpTimeout'];
        });
      },
    ));
  }
}
