import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/place_holder/no_data_widget.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/app/campaigns/bloc/campaigns_bloc.dart';
import 'package:piapiri_v2/app/campaigns/bloc/campaigns_event.dart';
import 'package:piapiri_v2/app/campaigns/bloc/campaigns_state.dart';
import 'package:piapiri_v2/app/campaigns/widgets/campaign_card.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/create_account_widget.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/info_widget.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';

@RoutePage()
class CampaignPage extends StatefulWidget {
  const CampaignPage({super.key});

  @override
  State<CampaignPage> createState() => _CampaignPageState();
}

class _CampaignPageState extends State<CampaignPage> {
  late CampaignsBloc _bloc;
  late AuthBloc _authBloc;

  @override
  void initState() {
    _bloc = getIt<CampaignsBloc>();
    _authBloc = getIt<AuthBloc>();

    if (_authBloc.state.isLoggedIn) {
      _bloc.add(
        CampaignsGetEvent(),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PInnerAppBar(
        title: L10n.tr('campaigns.title'),
      ),
      body: !_authBloc.state.isLoggedIn
          ? CreateAccountWidget(
              memberMessage: L10n.tr('create_account_campaign_alert'),
              loginMessage: L10n.tr('login_campaign_alert'),
              onLogin: () => router.push(
                AuthRoute(
                  afterLoginAction: () async {
                    router.push(
                      const CampaignRoute(),
                    );
                  },
                ),
              ),
            )
          : PBlocBuilder<CampaignsBloc, CampaignsState>(
              bloc: _bloc,
              builder: (context, state) {
                if (state.isLoading) {
                  return const PLoading();
                }

                if (state.campaigns.isEmpty) {
                  return NoDataWidget(
                    message: L10n.tr('no_campaings_found'),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.only(
                    left: Grid.m,
                    right: Grid.m,
                    top: Grid.m + Grid.xs,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: Grid.m,
                    children: [
                      PInfoWidget(
                        infoText: getIt<AuthBloc>().state.isLoggedIn
                            ? state.rightToParticipate
                                ? L10n.tr('campaigns.has_rtp_desc')
                                : L10n.tr('campaigns.has_not_rtp_desc')
                            : L10n.tr('campaigns.not_logged_in_desc'),
                      ),
                      Expanded(
                        child: ListView.separated(
                          shrinkWrap: true,
                          separatorBuilder: (_, __) => const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: Grid.m,
                            ),
                            child: PDivider(),
                          ),
                          padding: const EdgeInsets.only(
                            bottom: Grid.m,
                          ),
                          itemCount: state.campaigns.length,
                          itemBuilder: (context, index) {
                            return CampaignCard(
                              campaign: state.campaigns[index],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
