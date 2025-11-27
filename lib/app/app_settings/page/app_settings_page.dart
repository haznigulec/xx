import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:p_core/keys/navigator_keys.dart';
import 'package:piapiri_v2/app/app_settings/bloc/app_settings_bloc.dart';
import 'package:piapiri_v2/app/app_settings/bloc/app_settings_event.dart';
import 'package:piapiri_v2/app/app_settings/bloc/app_settings_state.dart';
import 'package:piapiri_v2/app/app_settings/widgets/settings_tile.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/create_account_widget.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/common/widgets/list/settings_bottomsheet_tile.dart';
import 'package:piapiri_v2/common/widgets/switch_tile/switch_tile.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/dropdown_model.dart';
import 'package:piapiri_v2/core/model/language_enum.dart';
import 'package:piapiri_v2/core/model/timeout_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class AppSettingsPage extends StatefulWidget {
  const AppSettingsPage({super.key});

  @override
  State<AppSettingsPage> createState() => _AppSettingsPageState();
}

class _AppSettingsPageState extends State<AppSettingsPage> {
  late AppSettingsBloc _appSettingsBloc;
  late AuthBloc _authBloc;
  @override
  void initState() {
    super.initState();
    _appSettingsBloc = getIt<AppSettingsBloc>();
    _authBloc = getIt<AuthBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PInnerAppBar(
        title: L10n.tr('uygulama_ayarlari'),
      ),
      body: !_authBloc.state.isLoggedIn
          ? CreateAccountWidget(
              memberMessage: L10n.tr('create_account_app_settings_alert'),
              loginMessage: L10n.tr('login_app_settings_alert'),
              onLogin: () => router.push(
                AuthRoute(
                  afterLoginAction: () async {
                    router.push(
                      const AppSettingsRoute(),
                    );
                  },
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: Grid.m),
              child: PBlocBuilder<AppSettingsBloc, AppSettingsState>(
                bloc: _appSettingsBloc,
                builder: (context, state) {
                  return Column(
                    children: [
                      const SizedBox(
                        height: Grid.m + Grid.xs,
                      ),
                      SettingsBottomsheetTile(
                        title: L10n.tr('language'),
                        selectedValue: _appSettingsBloc.state.generalSettings.language,
                        items: LanguageEnum.values
                            .map(
                              (e) => DropdownModel(
                                name: L10n.tr(e.localizationKey),
                                value: e,
                              ),
                            )
                            .toList(),
                        onSelect: (value) {
                          _appSettingsBloc.add(
                            SetGeneralSettingsEvent(
                              language: value,
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: Grid.s,
                      ),
                      SettingsBottomsheetTile(
                        title: L10n.tr('timeout'),
                        selectedValue: _appSettingsBloc.state.generalSettings.timeout,
                        items: TimeoutEnum.values
                            .map(
                              (e) => DropdownModel(
                                name: L10n.tr(e.localizationKey),
                                value: e,
                              ),
                            )
                            .toList(),
                        onSelect: (value) {
                          _appSettingsBloc.add(
                            SetGeneralSettingsEvent(
                              timeout: value,
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: Grid.m + Grid.xs,
                      ),
                      PSwitchRow(
                        text: L10n.tr('ekrani_acik_tut'),
                        value: _appSettingsBloc.state.generalSettings.keepScreenOpen,
                        onChanged: (value) {
                          _appSettingsBloc.add(
                            SetGeneralSettingsEvent(
                              keepScreenOpen: value,
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: Grid.m + Grid.xs,
                      ),
                      PSwitchRow(
                        text: L10n.tr('touch.id.face.id.active'),
                        value: _appSettingsBloc.state.generalSettings.touchFaceId,
                        onChanged: (value) {
                          _appSettingsBloc.add(
                            SetGeneralSettingsEvent(
                              touchFaceId: value,
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: Grid.s + Grid.xxs,
                      ),
                      SettingsTile(
                        title: L10n.tr('sifre_degistir'),
                        onTap: () => router.push(
                          ChangePasswordRoute(
                            onSuccess: (isSuccess, message) async {
                              await router.maybePop();
                              PBottomSheet.showError(
                                NavigatorKeys.navigatorKey.currentContext!,
                                isSuccess: true,
                                content: L10n.tr(message),
                              );
                            },
                          ),
                        ),
                      ),
                      SettingsTile(
                          title: L10n.tr('reset_application_settings'),
                          imagesPath: ImagesPath.chevron_down,
                          onTap: () {
                            PBottomSheet.showError(context,
                                content: L10n.tr('reset_app_settings_alert'),
                                isCritical: true,
                                showFilledButton: true,
                                showOutlinedButton: true,
                                filledButtonText: L10n.tr('onayla'),
                                outlinedButtonText: L10n.tr('vazgeç'),
                                onOutlinedButtonPressed: () => Navigator.pop(context),
                                onFilledButtonPressed: () {
                                  _appSettingsBloc.add(
                                    ResetApplicationSettingsEvent(),
                                  );
                                });
                          }),
                    ],
                  );
                },
              ),
            ),
    );
  }
}
