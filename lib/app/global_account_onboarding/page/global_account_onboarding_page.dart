import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/contracts/bloc/contracts_bloc.dart';
import 'package:piapiri_v2/app/contracts/bloc/contracts_event.dart';
import 'package:piapiri_v2/app/contracts/bloc/contracts_state.dart';
import 'package:piapiri_v2/app/global_account_onboarding/bloc/global_account_onboarding_bloc.dart';
import 'package:piapiri_v2/app/global_account_onboarding/bloc/global_account_onboarding_event.dart';
import 'package:piapiri_v2/app/global_account_onboarding/bloc/global_account_onboarding_state.dart';
import 'package:piapiri_v2/app/global_account_onboarding/model/account_setting_status_model.dart';
import 'package:piapiri_v2/app/global_account_onboarding/widget/account_status_widget.dart';
import 'package:piapiri_v2/app/global_account_onboarding/widget/onboarding_tile.dart';
import 'package:piapiri_v2/common/utils/constant.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/model/alpaca_account_status_enum.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class GlobalAccountOnboardingPage extends StatefulWidget {
  const GlobalAccountOnboardingPage({super.key});

  @override
  State<GlobalAccountOnboardingPage> createState() => _GlobalAccountOnboardingPageState();
}

class _GlobalAccountOnboardingPageState extends State<GlobalAccountOnboardingPage> {
  late GlobalAccountOnboardingBloc _globalOnboardingBloc;
  late ContractsBloc _contractsBloc;
  @override
  void initState() {
    _globalOnboardingBloc = getIt<GlobalAccountOnboardingBloc>();
    _contractsBloc = getIt<ContractsBloc>();
    _globalOnboardingBloc.add(
      AccountSettingStatusEvent(),
    );
    _contractsBloc.add(
      GetCustomerAnswersEvent(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerTheme: const DividerThemeData(
          color: Colors.transparent,
        ),
      ),
      child: PBlocBuilder<GlobalAccountOnboardingBloc, GlobalAccountOnboardingState>(
        bloc: _globalOnboardingBloc,
        builder: (context, state) {
          return PBlocBuilder<ContractsBloc, ContractsState>(
            bloc: _contractsBloc,
            builder: (context, contactsState) {
              return Scaffold(
                appBar: PInnerAppBar(
                  title: L10n.tr('global_account_onboarding'),
                ),
                body: SafeArea(
                  child: state.isLoading || state.accountSettingStatus == null
                      ? const PLoading()
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Grid.m,
                          ),
                          child: state.accountSettingStatus?.accountStatus != null
                              ? accountStatusSwitch(state.accountSettingStatus!.accountStatus!)
                              : Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: Grid.m + Grid.xs),
                                      child: Text(
                                        L10n.tr('global_account_onboarding_description'),
                                        style: context.pAppStyle.labelReg16textPrimary,
                                      ),
                                    ),
                                    ListView.separated(
                                      itemCount: globalAccountOnboardingList.length,
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return OnBoardingTileWidget(
                                          number: index + 1,
                                          text: globalAccountOnboardingList[index],
                                          state: state,
                                        );
                                      },
                                      separatorBuilder: (BuildContext context, int index) => const PDivider(),
                                    ),
                                  ],
                                ),
                        ),
                ),
                persistentFooterButtons: [
                  state.accountSettingStatus?.accountStatus == null
                      ? Container(
                          color: context.pColorScheme.transparent,
                          padding: const EdgeInsets.symmetric(
                            horizontal: Grid.s,
                          ),
                          child: PButton(
                            text: L10n.tr(
                              state.accountSettingStatus?.personalInformation == 0 ? 'startProcess' : 'continueProcess',
                            ),
                            fillParentWidth: true,
                            onPressed: state.accountSettingStatus != null &&
                                    !(state.accountSettingStatus!.isSuitableCapra ?? false)
                                ? () {
                                    //  amerikan borsası hesabı açabilme yetkisi var mı?
                                    PBottomSheet.showError(
                                      context,
                                      content: contactsState.getCustomerAnswersModel?.riskLevel == 'Çok Yüksek Riskli'
                                          ? L10n.tr('suitable_capra_contracts_alert')
                                          : L10n.tr('suitable_capra_alert'),
                                      showFilledButton: true,
                                      filledButtonText: L10n.tr(
                                          contactsState.getCustomerAnswersModel?.riskLevel == 'Çok Yüksek Riskli'
                                              ? 'approve_contracts'
                                              : 'go_contracts'),
                                      onFilledButtonPressed: () => router.push(
                                        contactsState.getCustomerAnswersModel?.riskLevel == 'Çok Yüksek Riskli'
                                            ? const GlobalAccountOnboardingPdfRoute()
                                            : ContractsRoute(
                                                title: L10n.tr('uygunluk_testi'),
                                              ),
                                      ),
                                    );
                                  }
                                : _getParameterValue(
                                    state.accountSettingStatus,
                                  ),
                          ),
                        )
                      : const SizedBox(),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Function()? _getParameterValue(AccountSettingStatusModel? model) {
    if (model == null) return null;
    //kişisel bilgileri doldurdu mu?
    if (model.personalInformation == 0) {
      return () => router.push(
            PersonalInformationRoute(
              title: L10n.tr('global_account_onboarding'),
            ),
          );
      //finansal bilgileri doldurdu mu?
    } else if (model.financialInformation == 0) {
      return () => router.push(
            FinancialInformationRoute(
              title: L10n.tr('global_account_onboarding'),
            ),
          );
      //online sözleşmeleri onayladı mı?
    } else if (model.onlineContracts == 0) {
      return () => router.push(
            OnlineContractsRoute(
              title: L10n.tr('global_account_onboarding'),
            ),
          );
    }
    return () => router.push(
          OnlineContractsRoute(
            title: L10n.tr('global_account_onboarding'),
          ),
        );
  }
}

Widget accountStatusSwitch(String accountStatus) {
  AlpacaAccountStatusEnum alpacaAccountStatusEnum = AlpacaAccountStatusEnum.values.firstWhere(
    (e) => e.value == accountStatus,
    orElse: () => AlpacaAccountStatusEnum.approvalPending,
  );
  return AccountStatusWidget(
    infoText: L10n.tr(alpacaAccountStatusEnum.localizationKey),
    description: L10n.tr(alpacaAccountStatusEnum.descriptionKey),
    iconPath: alpacaAccountStatusEnum.iconPath,
  );
}
