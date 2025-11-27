import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/place_holder/no_data_widget.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/app/license/bloc/license_bloc.dart';
import 'package:piapiri_v2/app/license/bloc/license_event.dart';
import 'package:piapiri_v2/app/license/bloc/license_state.dart';
import 'package:piapiri_v2/app/license/widgets/license_card.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/create_account_widget.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/info_widget.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/license_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';

@RoutePage()
class LicensesPage extends StatefulWidget {
  const LicensesPage({
    super.key,
  });

  @override
  State<LicensesPage> createState() => _LicensesPageState();
}

class _LicensesPageState extends State<LicensesPage> {
  late LicenseBloc _licenseBloc;
  late AuthBloc _authBloc;

  @override
  void initState() {
    _licenseBloc = getIt<LicenseBloc>();
    _authBloc = getIt<AuthBloc>();
    if (_authBloc.state.isLoggedIn) {
      _licenseBloc.add(
        GetLicensesEvent(),
      );
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PInnerAppBar(
        title: L10n.tr('lisanslarim'),
      ),
      body: !_authBloc.state.isLoggedIn
          ? CreateAccountWidget(
              memberMessage: L10n.tr('create_account_licence_alert'),
              loginMessage: L10n.tr('login_licence_alert'),
              onLogin: () => router.push(
                AuthRoute(
                  afterLoginAction: () async {
                    router.push(
                      const LicensesRoute(),
                    );
                  },
                ),
              ),
            )
          : SafeArea(
              child: PBlocBuilder<LicenseBloc, LicenseState>(
                bloc: _licenseBloc,
                builder: (context, state) {
                  if (state.isLoading) {
                    return const PLoading();
                  }

                  if (state.isFailed || state.licenseList.isEmpty) {
                    return NoDataWidget(
                      message: L10n.tr('no_news_found'),
                    );
                  }

                  return SingleChildScrollView(
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
                          ListView.builder(
                            itemCount: state.licenseList.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(
                              bottom: Grid.s,
                            ),
                            itemBuilder: (context, index) {
                              state.licenseList.sort(
                                (a, b) {
                                  /// Müşterinin sahip olduğu lisansların en üstte gösterilmesi için yapılan işlem.
                                  if (a.hasLicence == b.hasLicence) return 0;
                                  return a.hasLicence == true ? -1 : 1;
                                },
                              );

                              state.licenseList.sort((a, b) {
                                if (a.code == 'KD1') return -1;
                                if (b.code == 'KD1') return 1;
                                return 0;
                              });

                              LicenseModel license = state.licenseList[index];

                              return LicenseCard(
                                license: license,
                                showDivider: index != state.licenseList.length - 1,
                              );
                            },
                          ),
                          PInfoWidget(
                            infoText: L10n.tr('legal_info_1'),
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                          const SizedBox(
                            height: Grid.s + Grid.xs,
                          ),
                          PInfoWidget(
                            infoText: L10n.tr('legal_info_2'),
                          ),
                          const SizedBox(
                            height: Grid.m,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
