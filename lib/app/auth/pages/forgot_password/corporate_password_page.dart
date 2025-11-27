import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/progress_indicators/circle_progress_indicator.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_event.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_state.dart';
import 'package:piapiri_v2/common/widgets/textfields/keyboard_done_action.dart';
import 'package:piapiri_v2/common/widgets/textfields/text_field.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/utils/localization_utils.dart';

class CorporatePasswordPage extends StatefulWidget {
  const CorporatePasswordPage({super.key});

  @override
  State<CorporatePasswordPage> createState() => _CorporatePasswordPageState();
}

class _CorporatePasswordPageState extends State<CorporatePasswordPage> with AutomaticKeepAliveClientMixin {
  final TextEditingController _mobilePhoneTC = TextEditingController();
  final TextEditingController _taxNoTC = TextEditingController();
  final FocusNode _mobilePhoneFocusNode = FocusNode();
  final FocusNode _taxNoFocusNode = FocusNode();

  @override
  bool get wantKeepAlive => true;

  late AuthBloc _authBloc;
  bool _isKeyboardVisible = false;

  @override
  void initState() {
    _authBloc = getIt<AuthBloc>();
    _mobilePhoneFocusNode.addListener(_onFocusChange);
    _taxNoFocusNode.addListener(_onFocusChange);

    super.initState();
  }

  void _onFocusChange() {
    setState(() {
      _isKeyboardVisible = _mobilePhoneFocusNode.hasFocus || _taxNoFocusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    _mobilePhoneFocusNode.removeListener(_onFocusChange);
    _taxNoFocusNode.removeListener(_onFocusChange);
    _mobilePhoneFocusNode.dispose();
    _taxNoFocusNode.dispose();
    _mobilePhoneTC.dispose();
    _taxNoTC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Theme(
      data: Theme.of(context).copyWith(
        dividerTheme: const DividerThemeData(
          color: Colors.transparent,
        ),
      ),
      child: PBlocBuilder<AuthBloc, AuthState>(
        bloc: _authBloc,
        builder: (context, state) {
          return state.isLoading
              ? const PCircularProgressIndicator()
              : Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Grid.m,
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(
                                height: Grid.l,
                              ),
                              KeyboardDoneAction(
                                focusNode: _mobilePhoneFocusNode,
                                child: PTextField.number(
                                  focusNode: _mobilePhoneFocusNode,
                                  controller: _mobilePhoneTC,
                                  label: L10n.tr('mobile_phone'),
                                  maxLength: 10,
                                  prefixText: '+90 ',
                                  labelColor: context.pColorScheme.textSecondary,
                                  textInputAction: TextInputAction.done,
                                ),
                              ),
                              const SizedBox(height: Grid.s),
                              KeyboardDoneAction(
                                focusNode: _taxNoFocusNode,
                                child: PTextField.number(
                                  focusNode: _taxNoFocusNode,
                                  controller: _taxNoTC,
                                  label: L10n.tr('vergi_numarasi'),
                                  maxLength: 10,
                                  labelColor: context.pColorScheme.textSecondary,
                                  textInputAction: TextInputAction.done,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    AnimatedPadding(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.only(
                        bottom: _isKeyboardVisible ? Grid.xxl : Grid.xl,
                        left: Grid.m,
                        right: Grid.m,
                      ),
                      child: PButton(
                        text: L10n.tr('devam'),
                        onPressed: () => _goCheckOtpScreen(),
                        fillParentWidth: true,
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }

  _goCheckOtpScreen() async {
    if (_taxNoTC.text.isEmpty || _mobilePhoneTC.text.isEmpty) {
      return PBottomSheet.showError(
        context,
        content: L10n.tr('lutfen_tum_alanlari_doldurunuz'),
      );
    }

    if (_taxNoTC.text.toString().length != 10) {
      return PBottomSheet.showError(
        context,
        content: L10n.tr('lutfen_gecerli_bir_vergi_no_giriniz'),
      );
    }

    if (_mobilePhoneTC.text.replaceAll(' ', '').length != 10) {
      return PBottomSheet.showError(
        context,
        content: L10n.tr(
          'lets_try_phone_validity',
          args: ['10'],
        ),
      );
    }

    _authBloc.add(
      ForgotPasswordEvent(
        taxNo: _taxNoTC.text,
        cellPhone: _mobilePhoneTC.text.replaceAll(' ', ''),
        onSuccess: (forgotResponse) async {
          router.push(
            CheckOtpRoute(
              customerExtId: forgotResponse['customerExtId'],
              otpDuration: forgotResponse['otpTimeout'],
              callOtpAfterClickButton: false,
              onOtpValidated: (otp) {
                _authBloc.add(
                  ResetPasswordEvent(
                    customerId: forgotResponse['customerExtId'],
                    otp: otp,
                    onSuccess: () {
                      router.popUntilRouteWithName(AuthRoute.name);
                      PBottomSheet.showError(
                        context,
                        content: L10n.tr('password_successfully_reset'),
                        isSuccess: true,
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
}
