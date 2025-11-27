import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_event.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_state.dart';
import 'package:piapiri_v2/app/auth/widgets/change_password_text_field_widget.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/info_widget.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class ChangeExpiredPasswordPage extends StatefulWidget {
  final String customerExtId;
  final bool fromLoginPage;
  const ChangeExpiredPasswordPage({
    super.key,
    required this.customerExtId,
    this.fromLoginPage = false,
  });

  @override
  State<ChangeExpiredPasswordPage> createState() => _ChangeExpiredPasswordPageState();
}

class _ChangeExpiredPasswordPageState extends State<ChangeExpiredPasswordPage> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _reNewPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>(debugLabel: 'change_password');
  late AuthBloc _authBloc;
  bool _isFormValid = false; // Form geçerliliğini takip eden değişken

  @override
  void initState() {
    _authBloc = getIt<AuthBloc>();

    // Form alanlarını dinleyerek geçerliliği kontrol et
    _oldPasswordController.addListener(_validateForm);
    _newPasswordController.addListener(_validateForm);
    _reNewPasswordController.addListener(_validateForm);

    super.initState();
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _reNewPasswordController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _isFormValid = _formKey.currentState?.validate() ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
        dividerTheme: const DividerThemeData(
          color: Colors.transparent,
        ),
      ),
      child: PBlocBuilder<AuthBloc, AuthState>(
        bloc: _authBloc,
        builder: (context, state) {
          return Scaffold(
            appBar: PInnerAppBar(
              title: L10n.tr('sifre_degistir'),
            ),
            body: SafeArea(
              child: Form(
                key: _formKey,
                onChanged: _validateForm, // Formun her değişikliğinde kontrol et
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Grid.m,
                  ),
                  child: Column(
                    spacing: Grid.m,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: Grid.xs,
                      ),
                      ChangePasswordTextFieldWidget(
                        textEditingController: _oldPasswordController,
                        labelText: L10n.tr('eski_sifre'),
                        validation: (value) {
                          if (value == null || value.isEmpty) {
                            return L10n.tr('please_enter_old_password');
                          }
                          return null;
                        },
                      ),
                      ChangePasswordTextFieldWidget(
                        textEditingController: _newPasswordController,
                        labelText: L10n.tr('yeni_sifre'),
                        validation: (value) {
                          if (value == null || value.isEmpty) {
                            return L10n.tr('please_enter_valid_password');
                          } else if (value.length < 6 || value.length > 8) {
                            return L10n.tr('please_enter_password_right_length');
                          }
                          return null;
                        },
                      ),
                      ChangePasswordTextFieldWidget(
                        textEditingController: _reNewPasswordController,
                        labelText: L10n.tr('yeni_sifre_tekrar'),
                        validation: (value) {
                          if (value == null || value.isEmpty) {
                            return L10n.tr('please_enter_valid_password');
                          } else if (value.length < 6 || value.length > 8) {
                            return L10n.tr('please_enter_password_right_length');
                          } else if (value != _newPasswordController.text) {
                            return L10n.tr('new_passwords_not_compatible_warning');
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: Grid.xs,
                      ),
                      PInfoWidget(
                        infoText: L10n.tr('profile_password_hint'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            persistentFooterButtons: [
              PButton(
                loading: state.isLoading,
                fillParentWidth: true,
                onPressed: state.isLoading || !_isFormValid ? null : _changePassword,
                text: L10n.tr('degistir'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _changePassword() async {
    if (_formKey.currentState!.validate()) {
      _authBloc.add(
        RequestOtpEvent(
          customerId: widget.customerExtId,
          onSuccess: (response) {
            router.push(
              CheckOtpRoute(
                customerExtId: widget.customerExtId,
                otpDuration: response.data['otpTimeout'],
                callOtpAfterClickButton: false,
                onOtpValidated: (otp) {
                  _authBloc.add(
                    ChangeExpiredPasswordEvent(
                      customerId: widget.customerExtId,
                      oldPassword: _oldPasswordController.text,
                      newPassword: _newPasswordController.text,
                      otpCode: otp,
                      isTCKN: widget.customerExtId.length == 11,
                      onSuccess: () {
                        return PBottomSheet.showError(
                          context,
                          content: L10n.tr('password_changed_success'),
                          showFilledButton: true,
                          filledButtonText: L10n.tr('tamam'),
                          onFilledButtonPressed: () {
                            router.pushAndPopUntil(AuthRoute(), predicate: (_) => false);
                          },
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
}
