import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/app_settings/bloc/app_settings_bloc.dart';
import 'package:piapiri_v2/app/app_settings/bloc/app_settings_event.dart';
import 'package:piapiri_v2/app/app_settings/bloc/app_settings_state.dart';
import 'package:piapiri_v2/common/utils/button_padding.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/info_widget.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/common/widgets/textfields/password_field.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';

@RoutePage()
class ChangePasswordPage extends StatefulWidget {
  final Function(bool isSuccess, String message) onSuccess;
  final bool isChangePasswordRequired;
  const ChangePasswordPage({
    super.key,
    required this.onSuccess,
    this.isChangePasswordRequired = false,
  });

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  late AppSettingsBloc _settingsBloc;
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _newPasswordAgainController = TextEditingController();
  String? _oldPasswordErrorText;
  String? _newPasswordErrorText;
  String? _newPasswordAgainErrorText;
  late bool _backButtonPressedDisposeClosedPage;

  @override
  initState() {
    super.initState();
    _settingsBloc = getIt<AppSettingsBloc>();
    _backButtonPressedDisposeClosedPage = widget.isChangePasswordRequired;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PInnerAppBar(
        title: L10n.tr('sifre_degistir'),
        backButtonPressedDisposeClosedPage: _backButtonPressedDisposeClosedPage,
        backButtonPressedDisposeClosedFunction: () {
          PBottomSheet.show(
            context,
            child: Column(
              children: [
                Text(
                  L10n.tr('log_out_alert'),
                ),
                const SizedBox(
                  height: Grid.m,
                ),
                PButton(
                  text: L10n.tr('cikis_yap'),
                  fillParentWidth: true,
                  onPressed: () {
                    setState(() {
                      _backButtonPressedDisposeClosedPage = false;
                    });
                    WidgetsBinding.instance.addPostFrameCallback(
                      (_) {
                        router.pushAndPopUntil(
                          SplashRoute(),
                          predicate: (_) => false,
                        );
                      },
                    );
                  },
                )
              ],
            ),
          );
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Grid.m,
        ),
        child: PBlocBuilder<AppSettingsBloc, AppSettingsState>(
          bloc: _settingsBloc,
          builder: (context, state) {
            if (state.isLoading) return const Center(child: PLoading());
            return Column(
              children: [
                const SizedBox(
                  height: Grid.m + Grid.xs,
                ),
                SizedBox(
                  height: 68,
                  child: PasswordField(
                    controller: _oldPasswordController,
                    labelText: L10n.tr('eski_sifre'),
                    errorText: _oldPasswordErrorText,
                    onChanged: (text) {
                      setState(() {
                        _oldPasswordController.text = text;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: Grid.s,
                ),
                SizedBox(
                  height: 68,
                  child: PasswordField(
                    controller: _newPasswordController,
                    labelText: L10n.tr('yeni_sifre'),
                    errorText: _newPasswordErrorText,
                    onChanged: (text) {
                      setState(() {
                        _newPasswordController.text = text;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: Grid.s,
                ),
                SizedBox(
                  height: 68,
                  child: PasswordField(
                    controller: _newPasswordAgainController,
                    labelText: L10n.tr('yeni_sifre_tekrar'),
                    errorText: _newPasswordAgainErrorText,
                    onChanged: (text) {
                      setState(() {
                        _newPasswordAgainController.text = text;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: Grid.s + Grid.xs,
                ),
                PInfoWidget(
                  infoText: L10n.tr('profile_password_hint'),
                ),
                const SizedBox(
                  height: Grid.s + Grid.xs,
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: PBlocBuilder<AppSettingsBloc, AppSettingsState>(
        bloc: _settingsBloc,
        builder: (context, state) {
          if (state.isLoading) return const SizedBox.shrink();
          return generalButtonPadding(
            context: context,
            child: PButton(
              fillParentWidth: true,
              text: L10n.tr('kaydet'),
              onPressed: _isButtonDisabled() ? null : _onPressed,
              variant: PButtonVariant.brand,
            ),
          );
        },
      ),
    );
  }

  bool _isButtonDisabled() {
    return _oldPasswordController.text.isEmpty ||
        _newPasswordController.text.isEmpty ||
        _newPasswordAgainController.text.isEmpty;
  }

  void _onPressed() {
    if (_oldPasswordController.text.length < 6 || _oldPasswordController.text.length > 8) {
      setState(() {
        _oldPasswordErrorText = L10n.tr('password_length');
      });
    } else {
      setState(() {
        _oldPasswordErrorText = null;
      });
    }

    if (_newPasswordController.text.length < 6 || _newPasswordController.text.length > 8) {
      setState(() {
        _newPasswordErrorText = L10n.tr('password_length');
      });
    } else {
      setState(() {
        _newPasswordErrorText = null;
      });
    }
    if (_newPasswordAgainController.text != _newPasswordController.text) {
      setState(() {
        _newPasswordAgainErrorText = L10n.tr('new_password_again_error');
      });
    } else {
      setState(() {
        _newPasswordAgainErrorText = null;
      });
    }

    if (_oldPasswordErrorText == null && _newPasswordErrorText == null && _newPasswordAgainErrorText == null) {
      _settingsBloc.add(
        ChangePasswordEvent(
            oldPassword: _oldPasswordController.text,
            newPassword: _newPasswordController.text,
            onSuccess: (message, isSuccess) async {
              if (widget.isChangePasswordRequired) {
                if (isSuccess) {
                  await PBottomSheet.show(
                    context,
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          ImagesPath.check_circle,
                          width: 52,
                          height: 52,
                          colorFilter: ColorFilter.mode(
                            context.pColorScheme.primary,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(
                          height: Grid.m,
                        ),
                        Text(
                          L10n.tr(
                            message.toString(),
                          ),
                          textAlign: TextAlign.center,
                          style: context.pAppStyle.labelReg16textPrimary,
                        ),
                        const SizedBox(
                          height: Grid.m,
                        ),
                        PButton(
                          fillParentWidth: true,
                          text: L10n.tr('tamam'),
                          onPressed: () {
                            router.maybePop();
                          },
                        ),
                        const SizedBox(
                          height: Grid.l,
                        ),
                      ],
                    ),
                  );

                  router.push(
                    AuthRoute(),
                  );
                } else {
                  PBottomSheet.showError(
                    context,
                    isSuccess: isSuccess,
                    content: L10n.tr(
                      message.toString(),
                    ),
                  );
                }
              } else {
                widget.onSuccess(isSuccess, message);
              }
            }),
      );
    }
  }
}
