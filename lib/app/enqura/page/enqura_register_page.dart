import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/picker/date_pickers.dart';
import 'package:piapiri_v2/common/widgets/selection_control/checkbox.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/textfields/text_field.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/enqura/bloc/enqura_bloc.dart';
import 'package:piapiri_v2/app/enqura/bloc/enqura_event.dart';
import 'package:piapiri_v2/app/enqura/bloc/enqura_state.dart';
import 'package:piapiri_v2/app/enqura/model/enqura_create_user_model.dart';
import 'package:piapiri_v2/app/enqura/page/enqura_validate_referance_code_widget.dart';
import 'package:piapiri_v2/app/enqura/utils/enqura_page_steps.dart';
import 'package:piapiri_v2/app/enqura/widget/enqura_leave_page.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/phone_number_formatter.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/common/widgets/textfields/keyboard_done_action.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_bloc.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_event.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/analytics/analytics.dart';
import 'package:piapiri_v2/core/config/analytics/analytics_events.dart';
import 'package:piapiri_v2/core/config/app_config.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';
import 'package:styled_text/tags/styled_text_tag.dart';
import 'package:styled_text/widgets/styled_text.dart';

@RoutePage()
class EnquraRegisterPage extends StatefulWidget {
  final bool isFirstLaunch;
  const EnquraRegisterPage({
    super.key,
    this.isFirstLaunch = false,
  });

  @override
  State<EnquraRegisterPage> createState() => _EnquraRegisterPageState();
}

class _EnquraRegisterPageState extends State<EnquraRegisterPage> {
  late EnquraBloc _enquraBloc;
  late AppInfoBloc _appInfoBloc;

  bool _backButtonPressedDisposeClosedPage = true;
  bool _isInitialized = false;

  final TextEditingController _idNoController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _idNoFocusNode = FocusNode();
  // final FocusNode _birthFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  bool _isSelectedKVKK = false;
  bool _isSelectedETK = false;
  bool _isAcceptedReferanceCode = false;
  String? _referanceCode;
  late final bool _isReferancePageAvailable;

  final ValueNotifier<String> _idNoNotifier = ValueNotifier('');
  final ValueNotifier<DateTime?> _birthDateNotifier = ValueNotifier(null);
  final ValueNotifier<String> _phoneNotifier = ValueNotifier('');
  final ValueNotifier<String> _emailNotifier = ValueNotifier('');
  final ValueNotifier<bool> _isValidNotifier = ValueNotifier(false);

  void _updateIdNoAndValidate() {
    _idNoNotifier.value = _idNoController.text;
    _checkFormValidity();
  }

  void _updateBirthDateValidate() {
    _birthDateNotifier.value = DateTimeUtils.strToDate(_birthDateController.text);
    _checkFormValidity();
  }

  void _updatePhoneAndValidate() {
    _phoneNotifier.value = _phoneNoController.text;
    _checkFormValidity();
  }

  void _updateEmailAndValidate() {
    _emailNotifier.value = _emailController.text;
    _checkFormValidity();
  }

  void _checkFormValidity() {
    _isValidNotifier.value = _validateForm();
  }

  bool _validateForm() {
    // Zorunlu alanlar dolu mu kontrolü
    final requiredFieldsFilled = _idNoNotifier.value.isNotEmpty &&
        _birthDateNotifier.value != null &&
        _emailNotifier.value.isNotEmpty &&
        _phoneNotifier.value.isNotEmpty;

    final idNoValid = _validateIdNo(_idNoNotifier.value);

    // final birthValid = _validateBirth(_birthDateNotifier.value); && birthValid

    // Email ya boş ya da geçerli format
    final emailValid = _validateEmail(_emailNotifier.value);

    // Telefon formatı doğru mu
    final phoneValid = _validatePhone(_phoneNotifier.value);

    return requiredFieldsFilled && idNoValid && emailValid && phoneValid && _isSelectedKVKK;
  }

  bool _validateIdNo(String idNo) {
    if (idNo.isNotEmpty && idNo.length == 11) {
      return true;
    }
    return false;
  }

  bool _validateBirth(DateTime? birth) {
    if (birth == null) return false;
    final today = DateTime.now();
    final age = today.year - birth.year;
    final hasBirthdayPassed = (today.month > birth.month) || (today.month == birth.month && today.day >= birth.day);
    final realAge = hasBirthdayPassed ? age : age - 1;
    return realAge >= 18;
  }

  bool _validateEmail(String email) {
    if (email.isEmpty) return false;
    const pattern = r'^[a-zA-Z0-9.a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    final regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  bool _validatePhone(String phone) {
    if (phone.isEmpty) return false;
    const pattern = r'^5\d{2} \d{3} \d{2} \d{2}$';
    final regex = RegExp(pattern);
    return regex.hasMatch(phone);
  }

  @override
  void initState() {
    super.initState();

    getIt<Analytics>().track(
      AnalyticsEvents.formView,
    );

    _enquraBloc = getIt<EnquraBloc>();
    _appInfoBloc = getIt<AppInfoBloc>();

    _enquraBloc.add(GenerateRegisterValuesEvent());
    _enquraBloc.add(GetTokenEvent(
      onSuccess: () {
        setState(() {
          _isInitialized = true;
        });
      },
    ));

    _isReferancePageAvailable = remoteConfig.getBool(
      AppConfig.instance.isProd ? 'isReferanceAvailableOnRegister_prod' : 'isReferanceAvailableOnRegister_dev',
    );

    _idNoController.addListener(_updateIdNoAndValidate);
    _birthDateController.addListener(_updateBirthDateValidate);
    _phoneNoController.addListener(_updatePhoneAndValidate);
    _emailController.addListener(_updateEmailAndValidate);
  }

  @override
  void dispose() {
    _idNoController.removeListener(_updateIdNoAndValidate);
    _birthDateController.removeListener(_updateBirthDateValidate);
    _phoneNoController.removeListener(_updatePhoneAndValidate);
    _emailController.removeListener(_updateEmailAndValidate);
    _idNoNotifier.dispose();
    _birthDateNotifier.dispose();
    _phoneNotifier.dispose();
    _emailNotifier.dispose();
    _isValidNotifier.dispose();
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
        resizeToAvoidBottomInset: false,
        appBar: PInnerAppBar(
          dividerHeight: 0,
          title: '',
          backButtonPressedDisposeClosedPage: _backButtonPressedDisposeClosedPage,
          backButtonPressedDisposeClosedFunction: () async {
            getIt<Analytics>().track(
              AnalyticsEvents.formBottomSheetView,
            );

            final isContinue = await toEnquraOnboardingPage(
                  context,
                  contentText: L10n.tr('account_opening_info_alert'),
                  aproveText: L10n.tr('continue_process'),
                  rejectText: L10n.tr('do_it_later'),
                ) ??
                true;

            if (isContinue) return;

            setState(() {
              _backButtonPressedDisposeClosedPage = false;
            });

            WidgetsBinding.instance.addPostFrameCallback(
              (_) {
                router.maybePop();
              },
            );
          },
        ),
        body: !_isInitialized
            ? const Center(
                child: PLoading(),
              )
            : GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Grid.m,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  L10n.tr('welcome_piapiri'),
                                  textAlign: TextAlign.start,
                                  style: context.pAppStyle.labelMed18textPrimary,
                                ),
                                const SizedBox(
                                  height: Grid.l / 2,
                                ),
                                Text(
                                  L10n.tr(
                                    'lets_try_description',
                                  ),
                                  style: context.pAppStyle.labelReg14textPrimary,
                                  textAlign: TextAlign.start,
                                ),
                                const SizedBox(
                                  height: Grid.l - Grid.xs,
                                ),
                                ValueListenableBuilder<String>(
                                  valueListenable: _idNoNotifier,
                                  builder: (context, value, child) => KeyboardDoneAction(
                                    focusNode: _idNoFocusNode,
                                    child: PTextField.number(
                                      controller: _idNoController,
                                      maxLength: 11,
                                      label: L10n.tr('tc_no'),
                                      labelColor: context.pColorScheme.textSecondary,
                                      floatingLabelSize: Grid.m,
                                      hasText: value.isNotEmpty,
                                      validator: PValidator(
                                        focusNode: _idNoFocusNode,
                                        validate: (value) {
                                          if (value != null && value.isNotEmpty) {
                                            if (!_validateIdNo(value)) {
                                              return L10n.tr('tc_no_limit_alert', args: ['11']);
                                            }
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: Grid.m,
                                ),
                                ValueListenableBuilder<DateTime?>(
                                  valueListenable: _birthDateNotifier,
                                  builder: (context, birthDate, child) => PTextField(
                                    onTap: () async => showPDatePicker(
                                      context: context,
                                      initialDate: birthDate,
                                      doneTitle: L10n.tr('tamam'),
                                      cancelTitle: L10n.tr('iptal'),
                                      onChanged: (selectedDate) {
                                        _birthDateController.text =
                                            DateTimeUtils.dateFormat(selectedDate ?? DateTime.now());
                                        _birthDateNotifier.value = selectedDate;
                                      },
                                    ),
                                    readOnly: true,
                                    label: L10n.tr('birth'),
                                    controller: _birthDateController,
                                    labelColor: context.pColorScheme.textSecondary,
                                    floatingLabelSize: Grid.m,
                                    hasText: birthDate != null,
                                    onChanged: (selectedDate) {
                                      _birthDateNotifier.value = DateTime.parse(selectedDate);
                                    },
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
                                const SizedBox(
                                  height: Grid.m,
                                ),
                                ValueListenableBuilder<String>(
                                  valueListenable: _emailNotifier,
                                  builder: (context, value, child) => PTextField.email(
                                    controller: _emailController,
                                    label: L10n.tr('lets_try_email'),
                                    labelColor: context.pColorScheme.textSecondary,
                                    floatingLabelSize: Grid.m,
                                    hasText: value.isNotEmpty,
                                    validator: PValidator(
                                      focusNode: _emailFocusNode,
                                      validate: (value) {
                                        if (value != null && value.isNotEmpty) {
                                          if (!_validateEmail(value)) {
                                            return L10n.tr('lets_try_valid_email_validity');
                                          }
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: Grid.m,
                                ),
                                ValueListenableBuilder<String>(
                                  valueListenable: _phoneNotifier,
                                  builder: (context, value, child) => KeyboardDoneAction(
                                    focusNode: _phoneFocusNode,
                                    child: PTextField.number(
                                      controller: _phoneNoController,
                                      focusNode: _phoneFocusNode,
                                      label: L10n.tr('lets_try_phone'),
                                      labelColor: context.pColorScheme.textSecondary,
                                      floatingLabelSize: Grid.m,
                                      prefixText: '+90 ',
                                      hasText: value.isNotEmpty,
                                      validator: PValidator(
                                        focusNode: _phoneFocusNode,
                                        validate: (value) {
                                          if (value == null || value.isEmpty) {
                                            return L10n.tr('lets_try_phone_validity');
                                          }
                                          if (!_validatePhone(value)) {
                                            return L10n.tr('lets_try_valid_phone_validity');
                                          }
                                          return null;
                                        },
                                      ),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(10),
                                        PhoneNumberFormatter()
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: Grid.l - Grid.xs,
                                ),
                                PCheckboxRow(
                                  padding: const EdgeInsets.only(
                                    right: Grid.s,
                                  ),
                                  value: _isSelectedKVKK,
                                  removeCheckboxPadding: true,
                                  labelWidget: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: L10n.tr('member_kvkk_richText'),
                                          style: context.pAppStyle.labelMed14primary,
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              router.push(
                                                MemberPdfRoute(
                                                  title: L10n.tr('member_kvkk_richText'),
                                                  selectedKVKK: (bool selectedKVKK) {
                                                    setState(() {
                                                      _isSelectedKVKK = selectedKVKK;
                                                      _checkFormValidity();
                                                    });
                                                  },
                                                ),
                                              );
                                            },
                                        ),
                                        TextSpan(
                                          text: "'${L10n.tr('member_kvkk_richTextContinue')}",
                                          style: context.pAppStyle.labelReg14textPrimary,
                                        ),
                                      ],
                                    ),
                                  ),
                                  onChanged: (bool? value) {
                                    if (value == true && _isSelectedKVKK == false) {
                                      router.push(
                                        MemberPdfRoute(
                                          title: L10n.tr('member_kvkk_richText'),
                                          selectedKVKK: (bool selectedKVKK) {
                                            setState(() {
                                              _isSelectedKVKK = selectedKVKK;
                                              _checkFormValidity();
                                            });
                                          },
                                        ),
                                      );
                                    } else {
                                      setState(() {
                                        _isSelectedKVKK = value == true;
                                        _checkFormValidity();
                                      });
                                    }
                                  },
                                ),
                                const SizedBox(
                                  height: Grid.l / 2,
                                ),
                                PCheckboxRow(
                                  value: _isSelectedETK,
                                  padding: const EdgeInsets.only(
                                    right: Grid.s,
                                  ),
                                  labelStyle: context.pAppStyle.labelReg14textPrimary,
                                  removeCheckboxPadding: true,
                                  label: L10n.tr('member_etk'),
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _isSelectedETK = value == true;
                                    });
                                  },
                                ),
                                if (_isReferancePageAvailable) ...[
                                  const SizedBox(
                                    height: Grid.m + Grid.xs,
                                  ),
                                  PCustomPrimaryTextButton(
                                    iconAlignment: IconAlignment.start,
                                    iconSpacing: Grid.s,
                                    margin: const EdgeInsets.only(
                                      left: Grid.xxs,
                                    ),
                                    icon: SvgPicture.asset(
                                      ImagesPath.hediye,
                                      width: Grid.l - Grid.xs,
                                      height: Grid.l - Grid.xs,
                                      colorFilter: ColorFilter.mode(
                                        context.pColorScheme.primary,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    text: L10n.tr(
                                      _isAcceptedReferanceCode
                                          ? 'accepted_referance_code'
                                          : 'have_you_got_referance_code',
                                    ),
                                    style: context.pAppStyle.labelMed14primary,
                                    onPressed: _isAcceptedReferanceCode
                                        ? null
                                        : () async {
                                            final String? result = await PBottomSheet.show<String?>(
                                              context,
                                              child: const EnquraValidateReferanceCodeWidget(),
                                            );
                                            if (result?.isNotEmpty == true) {
                                              setState(() {
                                                _isAcceptedReferanceCode = true;
                                                _referanceCode = result;
                                              });
                                            }
                                          },
                                  ),
                                ]
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: Grid.s,
                          ),
                          child: StyledText(
                            text: L10n.tr(
                              'guaranteed_secure_transactions_from_unlu',
                              namedArgs: {
                                'spk_lisance': '<bold>${L10n.tr('spk_lisance')}</bold>',
                                'unlu': '<bold>${L10n.tr('unlu')}</bold>',
                              },
                            ),
                            textAlign: TextAlign.center,
                            style: context.pAppStyle.labelReg14textPrimary,
                            tags: {
                              'bold': StyledTextTag(
                                style: context.pAppStyle.labelMed14textPrimary,
                              ),
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        persistentFooterButtons: !_isInitialized
            ? null
            : [
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: Grid.m + Grid.xs,
                    left: Grid.s,
                    right: Grid.s,
                  ),
                  child: ValueListenableBuilder<bool>(
                    valueListenable: _isValidNotifier,
                    builder: (context, isValid, child) => PBlocBuilder<EnquraBloc, EnquraState>(
                      bloc: _enquraBloc,
                      builder: (context, state) => PButton(
                        text: L10n.tr('devam'),
                        fillParentWidth: true,
                        loading: state.isLoading,
                        onPressed: state.isLoading || !isValid
                            ? null
                            : () {
                                if (!_isSelectedKVKK) {
                                  PBottomSheet.showError(
                                    context,
                                    content: L10n.tr('lets_try_kvkk_alert'),
                                    isDismissible: true,
                                    showFilledButton: true,
                                    filledButtonText: L10n.tr('tamam'),
                                    onFilledButtonPressed: () => router.maybePop(),
                                  );
                                  return;
                                }

                                final isValid = _validateBirth(_birthDateNotifier.value);
                                if (!isValid) {
                                  PBottomSheet.showError(
                                    context,
                                    content: L10n.tr('create_account_min_age_error'),
                                    filledButtonText: L10n.tr('tamam'),
                                    showFilledButton: true,
                                    onFilledButtonPressed: () => router.maybePop(),
                                  );
                                  return;
                                }

                                _enquraBloc.add(
                                  CheckIsCustomerEvent(
                                    sessionNo: _enquraBloc.state.sessionNo ?? '',
                                    tckn: _idNoController.text,
                                    onSuccess: (isActiveUser) {
                                      if (isActiveUser) {
                                        PBottomSheet.showError(
                                          context,
                                          content: L10n.tr('active_customer_account'),
                                          filledButtonText: L10n.tr('giris_yap'),
                                          showFilledButton: true,
                                          onFilledButtonPressed: () async {
                                            await router.maybePop();
                                            await router.pushAndPopUntil(
                                              AuthRoute(
                                                fromSplash: true,
                                              ),
                                              predicate: (_) => false,
                                            );
                                          },
                                        );
                                        return;
                                      }
                                      router.push(
                                        EnquraOtpRoute(
                                          user: EnquraCreateUserModel(
                                            email: _emailController.text,
                                            identityNumber: _idNoController.text,
                                            phoneNumber: '0${_phoneNoController.text}'.replaceAll(' ', ''),
                                            birthDate: _birthDateNotifier.value ?? DateTime.now(),
                                            kvkk: _isSelectedKVKK,
                                            etk: _isSelectedETK,
                                            buddyReferenceCode: _referanceCode,
                                            sessionNo: _enquraBloc.state.sessionNo,
                                            guid: _enquraBloc.state.guid,
                                            currentStep: EnquraPageSteps.personalInformation,
                                          ),
                                          onSuccess: () async {
                                            _appInfoBloc.add(
                                              WriteHasMembershipEvent(
                                                gsm: '0${_phoneNoController.text}'.replaceAll(' ', ''),
                                                status: true,
                                              ),
                                            );
                                            await router.maybePop();
                                            setState(() {
                                              _backButtonPressedDisposeClosedPage = false;
                                            });
                                            WidgetsBinding.instance.addPostFrameCallback((_) {
                                              getIt<Analytics>().track(
                                                AnalyticsEvents.leadIdSuccess,
                                              );
                                              router.popAndPush(
                                                EnquraRoute(
                                                  isComeFromRegisterPage: true,
                                                  isFirstLaunch: widget.isFirstLaunch,
                                                ),
                                              );
                                            });
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                      ),
                    ),
                  ),
                )
              ],
      ),
    );
  }
}
