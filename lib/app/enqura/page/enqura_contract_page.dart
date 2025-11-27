import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:piapiri_v2/app/enqura/bloc/enqura_bloc.dart';
import 'package:piapiri_v2/app/enqura/bloc/enqura_event.dart';
import 'package:piapiri_v2/app/enqura/bloc/enqura_state.dart';
import 'package:piapiri_v2/app/enqura/model/enqura_create_user_model.dart';
import 'package:piapiri_v2/app/enqura/utils/enqura_page_steps.dart';
import 'package:piapiri_v2/app/enqura/widget/enqura_contrack_check_widget.dart';
import 'package:piapiri_v2/app/enqura/widget/enqura_leave_page.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/analytics/analytics.dart';
import 'package:piapiri_v2/core/config/analytics/analytics_events.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';

@RoutePage()
class EnquraContractPage extends StatefulWidget {
  const EnquraContractPage({
    super.key,
  });

  @override
  State<EnquraContractPage> createState() => _OnlineContractsPageState();
}

class _OnlineContractsPageState extends State<EnquraContractPage> {
  late final EnquraBloc _enquraBloc;
  bool _backButtonPressedDisposeClosedPage = true;
  final ValueNotifier<bool> _resendingNotifier = ValueNotifier<bool>(false);
  final List<String> _isActiveContractList = [];
  final List<String> _isCheckedContractList = [];

  @override
  void initState() {
    super.initState();
    _enquraBloc = getIt.get<EnquraBloc>();
    getIt<Analytics>().track(
      AnalyticsEvents.allOnlineContractsView,
    );
    _enquraBloc.add(
      GetOnboardingContractsEvent(
        sessionNo: _enquraBloc.state.sessionNo ?? '',
        referenceCode: _enquraBloc.state.startIntegration?.referanceCode ?? '',
      ),
    );
  }

  @override
  void dispose() {
    _resendingNotifier.dispose();
    super.dispose();
  }

  Future _onClosePage() async {
    bool isContinue = false;

    if (_isCheckedContractList.isNotEmpty) {
      getIt<Analytics>().track(
        AnalyticsEvents.contractsBackButton,
      );
      isContinue = await toEnquraOnboardingPage(context) ?? true;
    }

    if (isContinue) return;

    setState(() {
      _backButtonPressedDisposeClosedPage = false;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      router.maybePop();
    });
  }

  bool _isActive(String contractCode) {
    return _isActiveContractList.any((e) => e == contractCode);
  }

  bool _isChecked(String contractCode) {
    return _isCheckedContractList.any((e) => e == contractCode);
  }

  bool _isActiveButton() {
    if (_enquraBloc.state.onboardingContracts?.isNotEmpty == true &&
        _enquraBloc.state.onboardingContracts?.length == _isActiveContractList.length &&
        _enquraBloc.state.onboardingContracts?.length == _isCheckedContractList.length) {
      return true;
    }
    return false;
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
        appBar: PInnerAppBar(
          title: L10n.tr('enqura_onlineContracts'),
          //Device'ın back tuşuna engel olması durumu için eklendi
          backButtonPressedDisposeClosedPage: _backButtonPressedDisposeClosedPage,
          backButtonPressedDisposeClosedFunction: () => _onClosePage(),
          onPressed: () => _onClosePage(),
        ),
        body: PBlocBuilder<EnquraBloc, EnquraState>(
          bloc: _enquraBloc,
          builder: (context, state) => state.isLoading
              ? const PLoading()
              : SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Grid.m,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: Grid.s,
                          ),
                          child: Text(
                            L10n.tr('enqura_online_contracts_description'),
                            style: context.pAppStyle.labelReg16textPrimary,
                          ),
                        ),
                        Expanded(
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(vertical: Grid.m),
                            separatorBuilder: (context, index) => const SizedBox(height: Grid.m),
                            itemCount: state.onboardingContracts?.length ?? 0,
                            itemBuilder: (context, index) {
                              var contract = state.onboardingContracts![index];
                              return EquraContractCheckWidget(
                                key: ValueKey('contract_$index'),
                                isActive: _isActive(contract.contractCode),
                                isChecked: _isChecked(contract.contractCode),
                                contratName: contract.contractName,
                                onClick: () async {
                                  _sendEvent(index);
                                  final isChecked = await router.push(
                                    EnquraContractPdfRoute(
                                      title: contract.contractName,
                                      pdfUrl: contract.contractPath,
                                    ),
                                  );
                                  if (isChecked == true && !_isChecked(contract.contractCode)) {
                                    setState(() {
                                      if (!_isActive(contract.contractCode)) {
                                        _isActiveContractList.add(contract.contractCode);
                                      }
                                      _isCheckedContractList.add(contract.contractCode);
                                    });
                                  }
                                },
                                onChange: () {
                                  setState(() {
                                    if (_isChecked(contract.contractCode)) {
                                      _isCheckedContractList.remove(contract.contractCode);
                                    } else {
                                      _isCheckedContractList.add(contract.contractCode);
                                    }
                                  });
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
        persistentFooterButtons: [
          Padding(
            padding: const EdgeInsets.only(
              left: Grid.s,
              right: Grid.s,
              bottom: Grid.m + Grid.xs,
            ),
            child: PButton(
              text: L10n.tr(
                'devam',
              ),
              fillParentWidth: true,
              onPressed: _isActiveButton()
                  ? () async {
                      _enquraBloc.add(
                        CreateOrUpdateUserEvent(
                          user: EnquraCreateUserModel(
                            spis: true,
                            fatca: true,
                            w8: true,
                            agreementSignedAt: DateTime.now().toIso8601String(),
                            agreementIpAddress: await IpAddress().getIpAddress(),
                            agreementAcknowledgement: _isActiveButton(),
                            phoneNumber: _enquraBloc.state.user?.phoneNumber ?? '',
                            currentStep: EnquraPageSteps.onlineContracts,
                          ),
                          onSuccess: () {
                            setState(() {
                              _backButtonPressedDisposeClosedPage = false;
                            });
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _enquraBloc.add(
                                EnquraAccountSettingStatusEvent(
                                  currentStep: EnquraPageSteps.onlineContracts,
                                ),
                              );
                              router.maybePop();
                            });
                          },
                        ),
                      );
                    }
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  _sendEvent(int index) {
    if (index == 0) {
      getIt<Analytics>().track(
        AnalyticsEvents.contract1View,
      );
      return;
    }
    if (index == 1) {
      getIt<Analytics>().track(
        AnalyticsEvents.contract2View,
      );
      return;
    }
    if (index == 2) {
      getIt<Analytics>().track(
        AnalyticsEvents.contract3View,
      );
      return;
    }
  }
}
