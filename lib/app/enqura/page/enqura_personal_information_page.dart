import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/picker/date_pickers.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/textfields/text_field.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/enqura/bloc/enqura_bloc.dart';
import 'package:piapiri_v2/app/enqura/bloc/enqura_event.dart';
import 'package:piapiri_v2/app/enqura/bloc/enqura_state.dart';
import 'package:piapiri_v2/app/enqura/model/enqura_create_user_model.dart';
import 'package:piapiri_v2/app/enqura/utils/enqualify_helper.dart';
import 'package:piapiri_v2/app/enqura/utils/enqura_page_steps.dart';
import 'package:piapiri_v2/app/enqura/widget/enqura_leave_page.dart';
import 'package:piapiri_v2/app/info/model/info_variant.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/phone_number_formatter.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';

@RoutePage()
class EnquraPersonalInformationPage extends StatefulWidget {
  final String title;

  const EnquraPersonalInformationPage({
    super.key,
    required this.title,
  });

  @override
  State<EnquraPersonalInformationPage> createState() => _EnquraPersonalInformationPageState();
}

class _EnquraPersonalInformationPageState extends State<EnquraPersonalInformationPage> {
  late EnquraBloc _enquraBloc;
  bool _backButtonPressedDisposeClosedPage = true;

  late bool _formIsEnabled;
  late TextEditingController _idNoController;
  late TextEditingController _birthdayController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  final FocusNode _tcFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();

  bool _isValidIdNo = false;
  bool _isValidEmail = false;
  bool _isValidPhone = false;
  DateTime? _dateOfBirthday;
  bool _idNoHasText = false;
  bool _birthdayHasText = false;
  bool _emailHasText = false;
  bool _phoneHasText = false;

  final ValueNotifier<bool> _isEnabledButton = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _enquraBloc = getIt<EnquraBloc>();
    _formIsEnabled = _enquraBloc.state.user == null;
    _idNoController = TextEditingController();
    _birthdayController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _idNoController.addListener(() {
      final newValue = _idNoController.text.isNotEmpty;
      if (_idNoHasText != newValue) {
        setState(() => _idNoHasText = newValue);
      }
    });
    _birthdayController.addListener(() {
      final newValue = _birthdayController.text.isNotEmpty;
      if (_birthdayHasText != newValue) {
        setState(() => _birthdayHasText = newValue);
      }
    });
    _emailController.addListener(() {
      final newValue = _emailController.text.isNotEmpty;
      if (_emailHasText != newValue) {
        setState(() => _emailHasText = newValue);
      }
    });
    _phoneController.addListener(() {
      final newValue = _phoneController.text.isNotEmpty;
      if (_phoneHasText != newValue) {
        setState(() => _phoneHasText = newValue);
      }
    });
    _fillData();
  }

  @override
  void dispose() {
    _idNoController.dispose();
    _birthdayController.dispose();
    _emailController.dispose();
    _isEnabledButton.dispose();
    super.dispose();
  }

  Future _onClosePage() async {
    bool isContinue = false;
    final phoneNumber = _formatPhoneNumber(_enquraBloc.state.user?.phoneNumber?.substring(1) ?? '');
    final email = _enquraBloc.state.user?.email ?? '';
    if (_phoneController.text != phoneNumber || _emailController.text != email) {
      isContinue = await toEnquraOnboardingPage(context) ?? true;
    }

    if (isContinue) return;
    setState(() {
      _backButtonPressedDisposeClosedPage = false;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      router.maybePop();
    });
  }

  void _fillData() {
    final user = _enquraBloc.state.user;
    if (user != null) {
      _idNoController.text = _enquraBloc.state.user?.identityNumber ?? '';
      _emailController.text = _enquraBloc.state.user?.email ?? '';
      final phoneNumber = _enquraBloc.state.user?.phoneNumber?.substring(1) ?? '';
      if (phoneNumber.isNotEmpty) {
        _phoneController.text = _formatPhoneNumber(phoneNumber);
      }

      if (user.birthDate != null) {
        _dateOfBirthday = user.birthDate;
        _birthdayController.text = DateTimeUtils.dateFormat(_dateOfBirthday!);
      }

      if (!_formIsEnabled && _idNoController.text.length == 11) {
        _isValidIdNo = true;
      }

      _checkButtonEnabled();
    }
  }

  String _formatPhoneNumber(String text) {
    if (text.length <= 3) {
      return text;
    } else if (text.length <= 6) {
      return '${text.substring(0, 3)} ${text.substring(3)}';
    } else if (text.length <= 8) {
      return '${text.substring(0, 3)} ${text.substring(3, 6)} ${text.substring(6)}';
    } else {
      return '${text.substring(0, 3)} ${text.substring(3, 6)} ${text.substring(6, 8)} ${text.substring(8)}';
    }
  }

  bool _validateEmail(String email) {
    if (email.isEmpty) return true;
    const pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    return RegExp(pattern).hasMatch(email);
  }

  bool _validatePhone(String phone) {
    if (phone.isEmpty) return false;
    const pattern = r'^5\d{2} \d{3} \d{2} \d{2}$';
    final regex = RegExp(pattern);
    return regex.hasMatch(phone);
  }

  void _checkButtonEnabled() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final shouldEnable = _isValidIdNo && _dateOfBirthday != null && _isValidPhone && _isValidEmail;
      if (_isEnabledButton.value != shouldEnable) {
        _isEnabledButton.value = shouldEnable;
      }
    });
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
        resizeToAvoidBottomInset: false,
        appBar: PInnerAppBar(
          title: L10n.tr(widget.title),
          backButtonPressedDisposeClosedPage: _backButtonPressedDisposeClosedPage,
          backButtonPressedDisposeClosedFunction: () => _onClosePage(),
          onPressed: () => _onClosePage(),
        ),
        body: PBlocBuilder<EnquraBloc, EnquraState>(
          bloc: _enquraBloc,
          builder: (context, state) => state.isLoading
              ? const PLoading()
              : GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: Grid.m,
                        right: Grid.m,
                        top: Grid.s + Grid.xs,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          spacing: Grid.m + Grid.xs,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            PTextField.number(
                              label: L10n.tr('tc_no'),
                              enabled: _formIsEnabled,
                              labelColor: context.pColorScheme.textSecondary,
                              textStyle: _formIsEnabled
                                  ? context.pAppStyle.labelMed18textPrimary
                                  : context.pAppStyle.labelMed16textSecondary.copyWith(fontSize: Grid.m + Grid.xxs),
                              controller: _idNoController,
                              maxLength: 11,
                              hasText: _idNoHasText,
                              textInputAction: TextInputAction.done,
                              validator: PValidator(
                                focusNode: _tcFocusNode,
                                validateEmptyInput: true,
                                validate: (value) {
                                  if (value != null && value.isNotEmpty) {
                                    if (value.length == 11) {
                                      _isValidIdNo = true;
                                      _checkButtonEnabled();
                                      return null;
                                    } else {
                                      _isValidIdNo = false;
                                      _checkButtonEnabled();
                                      return L10n.tr('tc_no_limit_alert', args: ['11']);
                                    }
                                  }
                                  _isValidIdNo = false;
                                  _checkButtonEnabled();
                                  return null;
                                },
                              ),
                            ),
                            InkWell(
                              onTap: !_formIsEnabled
                                  ? null
                                  : () => showPDatePicker(
                                        context: context,
                                        initialDate: _dateOfBirthday,
                                        doneTitle: L10n.tr('tamam'),
                                        cancelTitle: L10n.tr('iptal'),
                                        onChanged: (DateTime? selectedDate) {
                                          setState(() {
                                            _dateOfBirthday = selectedDate;
                                            if (selectedDate != null) {
                                              _birthdayController.text = DateTimeUtils.dateFormat(selectedDate);
                                            } else {
                                              _birthdayController.clear();
                                            }
                                          });
                                          _checkButtonEnabled();
                                        },
                                      ),
                              child: PTextField(
                                label: L10n.tr('birth'),
                                labelColor: context.pColorScheme.textSecondary,
                                textStyle: _formIsEnabled
                                    ? context.pAppStyle.labelMed18textPrimary
                                    : context.pAppStyle.labelMed16textSecondary.copyWith(fontSize: Grid.m + Grid.xxs),
                                controller: _birthdayController,
                                enabled: false,
                                hasText: _birthdayHasText,
                                suffixWidget: Transform.scale(
                                  scale: 0.4,
                                  child: SvgPicture.asset(
                                    ImagesPath.calendar,
                                    width: Grid.m,
                                    height: Grid.m,
                                    colorFilter: ColorFilter.mode(
                                      context.pColorScheme.primary,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            PTextField.email(
                              controller: _emailController,
                              label: L10n.tr('email'),
                              labelColor: context.pColorScheme.textSecondary,
                              textStyle: context.pAppStyle.labelMed18textPrimary,
                              hasText: _emailHasText,
                              validator: PValidator(
                                focusNode: _emailFocusNode,
                                validateEmptyInput: true,
                                validate: (value) {
                                  if (value != null && value.isNotEmpty) {
                                    if (_validateEmail(value)) {
                                      _isValidEmail = true;
                                      _checkButtonEnabled();
                                      return null;
                                    } else {
                                      _isValidEmail = false;
                                      _checkButtonEnabled();
                                      return L10n.tr('lets_try_valid_email_validity');
                                    }
                                  }
                                  _isValidEmail = false;
                                  _checkButtonEnabled();
                                  return null;
                                },
                              ),
                            ),
                            PTextField.phone(
                              controller: _phoneController,
                              label: L10n.tr('lets_try_phone'),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                                PhoneNumberFormatter()
                              ],
                              labelColor: context.pColorScheme.textSecondary,
                              textStyle: context.pAppStyle.labelMed18textPrimary,
                              prefixText: '+90 ',
                              prefixStyle: context.pAppStyle.labelMed18textPrimary,
                              hasText: _phoneHasText,
                              validator: PValidator(
                                focusNode: _phoneFocusNode,
                                validateEmptyInput: true,
                                validate: (value) {
                                  if (value == null || value.isEmpty) {
                                    _isValidPhone = false;
                                    _checkButtonEnabled();
                                    return null;
                                  }
                                  if (!_validatePhone(value)) {
                                    _isValidPhone = false;
                                    _checkButtonEnabled();
                                    return L10n.tr('lets_try_valid_phone_validity');
                                  }
                                  _isValidPhone = true;
                                  _checkButtonEnabled();
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
        ),
        persistentFooterButtons: [
          Padding(
            padding: const EdgeInsets.only(
              bottom: Grid.m + Grid.xs,
              left: Grid.s,
              right: Grid.s,
            ),
            child: PBlocBuilder<EnquraBloc, EnquraState>(
              bloc: _enquraBloc,
              builder: (context, state) => ValueListenableBuilder<bool>(
                valueListenable: _isEnabledButton,
                builder: (context, isEnabled, child) {
                  return PButton(
                    text: L10n.tr('devam'),
                    fillParentWidth: true,
                    onPressed: !state.isLoading && isEnabled
                        ? () {
                            final newPhoneNumber = '0${_phoneController.text}'.replaceAll(' ', '');
                            final oldPhoneNumber = state.phoneNumber;
                            if (oldPhoneNumber != newPhoneNumber) {
                              // OTP Gereklidir.Süreç yeniden başlamalı ref codee eski telefon numarası ile alındı.
                              PBottomSheet.showError(
                                context,
                                customImagePath: ImagesPath.info,
                                content: L10n.tr('enqura_phone_number_changed_info'),
                                showFilledButton: true,
                                showOutlinedButton: true,
                                outlinedButtonText: L10n.tr('vazgec'),
                                filledButtonText: L10n.tr('devam'),
                                onOutlinedButtonPressed: () => router.maybePop(),
                                onFilledButtonPressed: () {
                                  //Uyarı Modalı kapandı Otp ekranı açıldı.
                                  //EnquraPage/EnquraPersonalPage/OtpPage
                                  router.popAndPush(
                                    EnquraOtpRoute(
                                      user: EnquraCreateUserModel(
                                        email: _emailController.text,
                                        identityNumber: _idNoController.text,
                                        phoneNumber: newPhoneNumber,
                                        birthDate: _dateOfBirthday,
                                        sessionNo: _enquraBloc.state.sessionNo,
                                        guid: _enquraBloc.state.guid,
                                        currentStep: _enquraBloc.state.user?.occupation?.isNotEmpty == true
                                            ? EnquraPageSteps.financialInformation
                                            : EnquraPageSteps.personalInformation,
                                      ),
                                      onSuccess: () {
                                        _enquraBloc.add(
                                          StartIntegrationEvent(
                                            sessionNo: _enquraBloc.state.sessionNo ?? '',
                                            identityNumber: int.parse(_enquraBloc.state.user?.identityNumber ?? ''),
                                            birthYear: _enquraBloc.state.user?.birthDate?.year ?? 0,
                                            birthMonth: _enquraBloc.state.user?.birthDate?.month ?? 0,
                                            birthDay: _enquraBloc.state.user?.birthDate?.day ?? 0,
                                            phone: _enquraBloc.state.user?.phoneNumber ?? '',
                                            etk: _enquraBloc.state.user?.etk ?? false,
                                            errorCallback: (integrationModel) async {
                                              //OTP ekranı kapatıldı. Info Ekranı açıldı.
                                              //EnquraPage/EnquraPersonalPage/InfoPage
                                              await router.popAndPush(
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

                                              //Not await bittikten sonra:
                                              //Info Ekranı kapatıldı.
                                              //EnquraPage/EnquraPersonalPage

                                              setState(() {
                                                //EnquraPersonalPage kapatılmasına izin verilir.
                                                _backButtonPressedDisposeClosedPage = false;
                                              });

                                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                                //EnquraPersonalPage kapatıldı.
                                                //EnquraPage
                                                router.maybePop();
                                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                                  //Kullanıcı kayıtları temizlendi.
                                                  //EnquraPage kapatıldı.
                                                  //EnquraPage'e gelinen sayfaya geri dönüldü.
                                                  _enquraBloc.add(ClearActiveProcessEvent());
                                                  router.popAndPush(
                                                    EnquraRegisterRoute(),
                                                  );
                                                });
                                              });
                                            },
                                            successCallback: () async {
                                              if (_enquraBloc.state.sdkIsActive) {
                                                await EnqualifyHelper.onDestroySDK();
                                              }
                                              _enquraBloc.add(
                                                InitializeSDKEvent(
                                                  checkAppointment: false,
                                                ),
                                              );
                                              _enquraBloc.add(
                                                CreateOrUpdateUserEvent(
                                                  user: EnquraCreateUserModel(
                                                    email: _emailController.text,
                                                    phoneNumber: newPhoneNumber,
                                                    buddyReferenceCode:
                                                        _enquraBloc.state.user?.buddyReferenceCode ?? '',
                                                    sessionNo: _enquraBloc.state.sessionNo,
                                                    guid: _enquraBloc.state.guid,
                                                    currentStep: _enquraBloc.state.user?.occupation?.isNotEmpty == true
                                                        ? EnquraPageSteps.financialInformation
                                                        : EnquraPageSteps.personalInformation,
                                                  ),
                                                ),
                                              );
                                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                                _enquraBloc.add(
                                                  EnquraAccountSettingStatusEvent(
                                                    currentStep: _enquraBloc.state.user?.occupation?.isNotEmpty == true
                                                        ? EnquraPageSteps.financialInformation
                                                        : EnquraPageSteps.personalInformation,
                                                  ),
                                                );

                                                //OTP ekranı kapatıldı.
                                                //EnquraPage/EnquraPersonalPage
                                                router.maybePop();
                                                setState(() {
                                                  //EnquraPersonalPage kapatılmasına izin verilir.
                                                  _backButtonPressedDisposeClosedPage = false;
                                                });
                                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                                  _enquraBloc.add(
                                                    GetUserEvent(
                                                      guid: _enquraBloc.state.guid ?? '',
                                                      phoneNumber: newPhoneNumber,
                                                      isFirstInitialize: false,
                                                    ),
                                                  );
                                                  //EnquraPersonalPage kapatıldı.
                                                  //EnquraPage
                                                  router.maybePop();
                                                });
                                              });
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              );
                            } else {
                              // OTP gerekmez. Süreç yeniden başlamamalı.
                              _enquraBloc.add(
                                CreateOrUpdateUserEvent(
                                  user: EnquraCreateUserModel(
                                    email: _emailController.text,
                                    identityNumber: _idNoController.text,
                                    phoneNumber: newPhoneNumber,
                                    birthDate: _dateOfBirthday,
                                    sessionNo: _enquraBloc.state.sessionNo,
                                    guid: _enquraBloc.state.guid,
                                    currentStep: _enquraBloc.state.user?.occupation?.isNotEmpty == true
                                        ? EnquraPageSteps.financialInformation
                                        : EnquraPageSteps.personalInformation,
                                  ),
                                  onSuccess: () {
                                    _enquraBloc.add(
                                      GetUserEvent(
                                        guid: _enquraBloc.state.guid ?? '',
                                        phoneNumber: newPhoneNumber,
                                        isFirstInitialize: false,
                                        forceOldStatus: _enquraBloc.state.accountSettingStatus,
                                      ),
                                    );
                                    setState(() {
                                      _backButtonPressedDisposeClosedPage = false;
                                    });
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      router.maybePop();
                                    });
                                  },
                                ),
                              );
                            }
                          }
                        : null,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
