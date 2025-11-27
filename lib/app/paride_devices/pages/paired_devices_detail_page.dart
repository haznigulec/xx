import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_event.dart';
import 'package:piapiri_v2/app/avatar/bloc/avatar_bloc.dart';
import 'package:piapiri_v2/app/avatar/bloc/avatar_event.dart';
import 'package:piapiri_v2/app/banner/bloc/banner_bloc.dart';
import 'package:piapiri_v2/app/banner/bloc/banner_event.dart';
import 'package:piapiri_v2/app/paride_devices/bloc/paired_devices_bloc.dart';
import 'package:piapiri_v2/app/paride_devices/bloc/paired_devices_event.dart';
import 'package:piapiri_v2/common/utils/button_padding.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/common/widgets/list/symbol_about_tile.dart';
import 'package:piapiri_v2/core/bloc/tab/tab_bloc.dart';
import 'package:piapiri_v2/core/bloc/tab/tab_event.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/paired_devices_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class PairedDevicesDetailPage extends StatelessWidget {
  final PairedDevicesModel device;
  const PairedDevicesDetailPage({
    super.key,
    required this.device,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PInnerAppBar(
        title: L10n.tr('device_info'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Grid.m,
        ),
        child: Column(
          children: [
            SymbolAboutTile(
              leading: L10n.tr('device'),
              trailing: device.deviceModel ?? L10n.tr('unknown_device'),
            ),
            const PDivider(),
            SymbolAboutTile(
              leading: L10n.tr('last_login_date'),
              trailing: DateTimeUtils.pairedDeviceConvert(device.lastLoginDate),
            ),
            const PDivider(),
            SymbolAboutTile(
              leading: L10n.tr('match_date'),
              trailing: DateTimeUtils.pairedDeviceConvert(device.matchDate),
            ),
          ],
        ),
      ),
      bottomNavigationBar: generalButtonPadding(
        context: context,
        viewPadddingOfBottom: MediaQuery.viewPaddingOf(context).bottom,
        child: device.isCurrentDevice
            ? POutlinedButton(
                text: L10n.tr('unpair_device_and_logout'),
                fillParentWidth: true,
                onPressed: () {
                  PBottomSheet.showError(
                    context,
                    content: L10n.tr(
                      'unpair_device_and_logout_desc',
                      args: [
                        device.deviceModel ?? L10n.tr('unknown_device'),
                      ],
                    ),
                    showOutlinedButton: true,
                    showFilledButton: true,
                    outlinedButtonText: L10n.tr('vazgec'),
                    filledButtonText: L10n.tr('unpair_device'),
                    onOutlinedButtonPressed: () => Navigator.of(context).pop(),
                    onFilledButtonPressed: () {
                      getIt<PairedDevicesBloc>().add(
                        DeletePairedDevicesEvent(
                          device: device,
                          callback: () {
                            router.replaceAll(
                              [
                                DashboardRoute(
                                  key: ValueKey('${DashboardRoute.name}-${DateTime.now().millisecondsSinceEpoch}'),
                                ),
                              ],
                            );

                            getIt<TabBloc>().add(
                              const TabChangedEvent(
                                tabIndex: 0,
                              ),
                            );

                            getIt<AvatarBloc>().add(LogoutAvatarEvent());

                            getIt<AuthBloc>().add(
                              LogoutEvent(
                                shouldRegisterForNotifications: true,
                                callback: () => getIt<BannerBloc>().add(
                                  ResetBannersEvent(),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              )
            : PButton(
                text: L10n.tr('unpair_device'),
                fillParentWidth: true,
                onPressed: () {
                  PBottomSheet.showError(
                    context,
                    content: L10n.tr(
                      'unpair_device_desc',
                      args: [
                        device.deviceModel ?? L10n.tr('unknown_device'),
                      ],
                    ),
                    showOutlinedButton: true,
                    showFilledButton: true,
                    outlinedButtonText: L10n.tr('vazgec'),
                    filledButtonText: L10n.tr('unpair_device'),
                    onOutlinedButtonPressed: () => Navigator.of(context).pop(),
                    onFilledButtonPressed: () {
                      getIt<PairedDevicesBloc>().add(
                        DeletePairedDevicesEvent(
                          device: device,
                          callback: () {
                            getIt<PairedDevicesBloc>().add(
                              GetPairedDevicesEvent(),
                            );

                            Navigator.pop(context);
                            router.pop(context);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}
