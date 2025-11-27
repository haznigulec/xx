import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/place_holder/no_data_widget.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/app/paride_devices/bloc/paired_devices_bloc.dart';
import 'package:piapiri_v2/app/paride_devices/bloc/paired_devices_event.dart';
import 'package:piapiri_v2/app/paride_devices/bloc/paired_devices_state.dart';
import 'package:piapiri_v2/app/paride_devices/widgets/paired_device_card.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/create_account_widget.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/common/widgets/progress_indicators/shimmerize.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/paired_devices_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class PairedDevicesPage extends StatefulWidget {
  const PairedDevicesPage({super.key});

  @override
  State<PairedDevicesPage> createState() => _PairedDevicesPageState();
}

class _PairedDevicesPageState extends State<PairedDevicesPage> {
  final PairedDevicesBloc _pairedDevicesBloc = getIt<PairedDevicesBloc>();
  final AuthBloc _authBloc = getIt<AuthBloc>();

  @override
  void initState() {
    _pairedDevicesBloc.add(
      GetPairedDevicesEvent(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PInnerAppBar(
        title: L10n.tr('paired_devices'),
      ),
      body: !_authBloc.state.isLoggedIn
          ? CreateAccountWidget(
              memberMessage: L10n.tr('create_account_paired_devices_alert'),
              loginMessage: L10n.tr('login_paired_devices_alert'),
              onLogin: () => router.push(
                AuthRoute(
                  afterLoginAction: () async {
                    router.push(
                      const PairedDevicesRoute(),
                    );
                  },
                ),
              ),
            )
          : SafeArea(
              child: PBlocBuilder<PairedDevicesBloc, PairedDevicesState>(
                bloc: _pairedDevicesBloc,
                builder: (context, state) {
                  if ((state.isFailed || state.pairedDeviceList.isEmpty) && state.isNotLoading) {
                    return NoDataWidget(
                      message: L10n.tr('no_paired_devices_found'),
                    );
                  }

                  return Shimmerize(
                    enabled: state.isLoading,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Grid.m,
                        ),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: Grid.s,
                            ),
                            ListView.separated(
                              itemCount:
                                  state.isLoading && state.pairedDeviceList.isEmpty ? 6 : state.pairedDeviceList.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              separatorBuilder: (_, __) => const PDivider(),
                              padding: const EdgeInsets.only(
                                bottom: Grid.s,
                              ),
                              itemBuilder: (context, index) {
                                if (state.isLoading) {
                                  return const PairedDeviceCard.loading();
                                }
                                PairedDevicesModel device = state.pairedDeviceList[index];
                                return PairedDeviceCard(
                                  device: device,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
