import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/picker/date_pickers.dart';
import 'package:piapiri_v2/common/widgets/progress_indicators/circle_progress_indicator.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/textfields/text_field.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:p_core/extensions/date_time_extensions.dart';
import 'package:p_core/utils/keyboard_utils.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_event.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_state.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/phone_number_formatter.dart';
import 'package:piapiri_v2/common/widgets/textfields/keyboard_done_action.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/utils/localization_utils.dart';

class IndividualPasswordPage extends StatefulWidget {
  const IndividualPasswordPage({super.key});

  @override
  State<IndividualPasswordPage> createState() => _IndividualPasswordPageState();
}

//Bireysel Hesap
class _IndividualPasswordPageState extends State<IndividualPasswordPage> with AutomaticKeepAliveClientMixin {
  final TextEditingController _tcNoTC = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _mobilePhoneTC = TextEditingController();
  final FocusNode _tcNoFocusNode = FocusNode();
  final FocusNode _mobilePhoneFocusNode = FocusNode();

  bool isChoosenDate = false;
  DateTime? _dateOfBirthDateTime;
  late AuthBloc _authBloc;
  bool _isKeyboardVisible = false;
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _authBloc = getIt<AuthBloc>();
    _tcNoFocusNode.addListener(_onFocusChange);
    _mobilePhoneFocusNode.addListener(_onFocusChange);

    super.initState();
  }

  void _onFocusChange() {
    setState(() {
      _isKeyboardVisible = _tcNoFocusNode.hasFocus || _mobilePhoneFocusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    _tcNoFocusNode.removeListener(_onFocusChange);
    _mobilePhoneFocusNode.removeListener(_onFocusChange);
    _tcNoFocusNode.dispose();
    _mobilePhoneFocusNode.dispose();
    _tcNoTC.dispose();
    _mobilePhoneTC.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return PBlocBuilder<AuthBloc, AuthState>(
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
                              focusNode: _tcNoFocusNode,
                              child: PTextField.number(
                                label: L10n.tr('tc_no'),
                                controller: _tcNoTC,
                                focusNode: _tcNoFocusNode,
                                maxLength: 11,
                                textInputAction: TextInputAction.done,
                                labelColor: context.pColorScheme.textSecondary,
                              ),
                            ),
                            const SizedBox(
                              height: Grid.m + Grid.xs,
                            ),
                            KeyboardDoneAction(
                              focusNode: _mobilePhoneFocusNode,
                              child: PTextField.phone(
                                label: L10n.tr('mobile_phone'),
                                controller: _mobilePhoneTC,
                                focusNode: _mobilePhoneFocusNode,
                                prefixText: '+90 ',
                                labelColor: context.pColorScheme.textSecondary,
                                textInputAction: TextInputAction.done,
                                inputFormatters: [PhoneNumberFormatter()],
                              ),
                            ),
                            const SizedBox(
                              height: Grid.m + Grid.xs,
                            ),
                            InkWell(
                              onTap: () async => showPDatePicker(
                                context: context,
                                initialDate: _dateOfBirthDateTime,
                                doneTitle: L10n.tr('tamam'),
                                cancelTitle: L10n.tr('iptal'),
                                onChanged: (selectedDate) {
                                  setState(() {
                                    _dateController.text = DateTimeUtils.dateFormat(selectedDate ?? DateTime.now());
                                    _dateOfBirthDateTime = selectedDate;
                                  });
                                },
                              ),
                              child: PTextField(
                                label: L10n.tr('birth'),
                                controller: _dateController,
                                maxLength: 11,
                                enabled: false,
                                labelColor: context.pColorScheme.textSecondary,
                                onChanged: (selectedDate) {
                                  setState(() {
                                    _dateOfBirthDateTime = DateTime.parse(selectedDate);
                                  });
                                },
                                suffixWidget: Transform.scale(
                                  scale: 0.4,
                                  child: SvgPicture.asset(
                                    ImagesPath.calendar,
                                    width: 17,
                                    height: 17,
                                    colorFilter: ColorFilter.mode(
                                      context.pColorScheme.primary,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: Grid.m,
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
    );
  }

  _goCheckOtpScreen() async {
    KeyboardUtils.dismissKeyboard();

    if (_tcNoTC.text.isEmpty || _mobilePhoneTC.text.isEmpty || _dateOfBirthDateTime == null) {
      return PBottomSheet.showError(
        context,
        content: L10n.tr('lutfen_tum_alanlari_doldurunuz'),
      );
    }

    if (_tcNoTC.text.toString().length != 11) {
      return PBottomSheet.showError(
        context,
        content: L10n.tr(
          'tc_no_limit_alert',
          args: ['11'],
        ),
      );
    }

    if (_mobilePhoneTC.text.replaceAll(' ', '').length != 10) {
      return PBottomSheet.showError(
        context,
        content: L10n.tr(
          'phone_limit_alert',
          args: ['10'],
        ),
      );
    }

    _authBloc.add(
      ForgotPasswordEvent(
        tcNo: _tcNoTC.text,
        cellPhone: _mobilePhoneTC.text.replaceAll(' ', ''),
        birthDate: _dateOfBirthDateTime!.formatToJson(),
        taxNo: '',
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
                        isSuccess: true,
                        content: L10n.tr('password_successfully_reset'),
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
