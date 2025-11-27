import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/app/contracts/bloc/contracts_bloc.dart';
import 'package:piapiri_v2/app/contracts/bloc/contracts_event.dart';
import 'package:piapiri_v2/app/contracts/bloc/contracts_state.dart';
import 'package:piapiri_v2/app/contracts/page/contracts_list_tile.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/utils/utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/create_account_widget.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/info_widget.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/user_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';

@RoutePage()
class ContractsListPage extends StatefulWidget {
  final String title;
  const ContractsListPage({
    super.key,
    required this.title,
  });

  @override
  State<ContractsListPage> createState() => _ContractsListPageState();
}

class _ContractsListPageState extends State<ContractsListPage> {
  late RemoteConfigValue _cmContracts;
  late final AuthBloc _authBloc = getIt<AuthBloc>();
  late final ContractsBloc _contractsBloc = getIt<ContractsBloc>();
  List _cmContractsList = [];

  @override
  void initState() {
    _cmContracts = remoteConfig.getValue('cmContracts');
    _cmContractsList = jsonDecode(_cmContracts.asString())['contracts'];

    _contractsBloc.add(
      GetGtpContractEvent(),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PInnerAppBar(
        title: widget.title,
      ),
      body: !_authBloc.state.isLoggedIn
          ? CreateAccountWidget(
              memberMessage: L10n.tr('create_account_contracts_alert'),
              loginMessage: L10n.tr('login_contracts_alert'),
              onLogin: () => router.push(
                AuthRoute(
                  afterLoginAction: () async {
                    router.push(
                      ContractsListRoute(
                        title: widget.title,
                      ),
                    );
                  },
                ),
              ),
            )
          : PBlocBuilder<ContractsBloc, ContractsState>(
              bloc: _contractsBloc,
              builder: (context, contractsState) {
                return contractsState.isLoading
                    ? const PLoading()
                    : SafeArea(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              if (UserModel.instance.innerType != null &&
                                  UserModel.instance.innerType == 'INSTITUTION') ...[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: Grid.m,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: Grid.m),
                                        child: PInfoWidget(
                                          infoText: L10n.tr('institution_contracts_alert'),
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                        ),
                                      ),
                                      const PDivider(),
                                    ],
                                  ),
                                ),
                              ],
                              ContractsListTileWidget(
                                  leadingTitle: L10n.tr('uygunluk_testi'),
                                  leadingSubTitle: L10n.tr('uygunluk_testi_description'),
                                  isShowDivider: true,
                                  hasGtpContracts: false,
                                  isConfirmed: false,
                                  onTap: () => router.push(
                                        ContractsRoute(title: L10n.tr('uygunluk_testi')),
                                      )),
                              if (Utils().canTradeAmericanMarket()) ...[
                                ContractsListTileWidget(
                                  leadingTitle: L10n.tr('global_account_onboarding'),
                                  leadingSubTitle: L10n.tr('global_account_onboarding_description'),
                                  isShowDivider: true,
                                  hasGtpContracts: false,
                                  isConfirmed: false,
                                  onTap: () => router.push(
                                    const GlobalAccountOnboardingRoute(),
                                  ),
                                ),
                              ],
                              ListView.separated(
                                itemCount: contractsState.canSignContracts!.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                separatorBuilder: (context, index) => const PDivider(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: Grid.m,
                                  ),
                                ),
                                itemBuilder: (context, index) => ContractsListTileWidget(
                                  leadingTitle: contractsState.canSignContracts?[index].name ?? '',
                                  leadingSubTitle:
                                      L10n.tr('contracts_desc_${contractsState.canSignContracts?[index].enumCode}'),
                                  hasGtpContracts: true,
                                  isConfirmed:
                                      _cmContractsList.contains(contractsState.canSignContracts?[index].enumCode)
                                          ? (contractsState.canSignContracts?[index].cmContractApprovedDate != null)
                                          : contractsState.canSignContracts?[index].gtpContractCreatedDate != null,
                                  approvedDate:
                                      _cmContractsList.contains(contractsState.canSignContracts?[index].enumCode)
                                          ? contractsState.canSignContracts![index].cmContractApprovedDate != null
                                              ? DateTimeUtils.dateFormat(
                                                  contractsState.canSignContracts![index].cmContractApprovedDate!)
                                              : null
                                          : contractsState.canSignContracts?[index].gtpContractCreatedDate != null
                                              ? DateTimeUtils.dateFormat(
                                                  contractsState.canSignContracts![index].gtpContractCreatedDate!)
                                              : null,
                                  onTap: () => _contractsBloc.add(
                                    GetContractPdfEvent(
                                      contractCode: contractsState.canSignContracts![index].cmContractCode!,
                                      onContractCode: (refCode) {
                                        router.push(
                                          GtpContractsPdfRoute(
                                            contractName: contractsState.canSignContracts![index].name!,
                                            contractRefCode: refCode,
                                            cmContractCode: contractsState.canSignContracts![index].cmContractCode!,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
              },
            ),
    );
  }
}
