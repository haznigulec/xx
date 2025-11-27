import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/pdf_viewer/pdf_viewer.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:internet_file/internet_file.dart';
import 'package:pdfx/pdfx.dart';
import 'package:piapiri_v2/app/contracts/bloc/contracts_bloc.dart';
import 'package:piapiri_v2/app/contracts/bloc/contracts_event.dart';
import 'package:piapiri_v2/app/contracts/bloc/contracts_state.dart';
import 'package:piapiri_v2/app/global_account_onboarding/bloc/global_account_onboarding_bloc.dart';
import 'package:piapiri_v2/app/global_account_onboarding/bloc/global_account_onboarding_event.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/app_config.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/user_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class GlobalAccountOnboardingPdfPage extends StatefulWidget {
  const GlobalAccountOnboardingPdfPage({
    super.key,
  });

  @override
  State<GlobalAccountOnboardingPdfPage> createState() => _GlobalAccountOnboardingPdfPageState();
}

class _GlobalAccountOnboardingPdfPageState extends State<GlobalAccountOnboardingPdfPage> {
  bool _isLastPage = false;
  late ContractsBloc _contractsBloc;
  late GlobalAccountOnboardingBloc _globalOnboardingBloc;
  PdfControllerPinch? _pdfControllerPinch;
  late RemoteConfigValue _gtpContracts;
  String _americanAccountContract = '';
  @override
  void initState() {
    _gtpContracts = remoteConfig.getValue('gtpContracts');
    _americanAccountContract = jsonDecode(_gtpContracts.asString())['americanAccountContract'];
    _contractsBloc = getIt<ContractsBloc>();
    _globalOnboardingBloc = getIt<GlobalAccountOnboardingBloc>();
    _contractsBloc.add(
      GetContractPdfEvent(
        contractCode: _americanAccountContract,
        onContractCode: (refCode) {
          setState(() {
            _pdfControllerPinch = PdfControllerPinch(
              document: PdfDocument.openData(
                InternetFile.get('${AppConfig.instance.contractUrl}$refCode'),
              ),
            );
          });
        },
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
    _pdfControllerPinch?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerTheme: const DividerThemeData(
          color: Colors.transparent,
        ),
      ),
      child: PBlocBuilder<ContractsBloc, ContractsState>(
        bloc: _contractsBloc,
        builder: (context, state) {
          return Scaffold(
            appBar: PInnerAppBar(
              title: L10n.tr('agreements'),
            ),
            persistentFooterButtons: [
              PButton(
                text: L10n.tr('onayla'),
                fillParentWidth: true,
                onPressed: _isLastPage && _pdfControllerPinch != null
                    ? () {
                        _contractsBloc.add(
                          ApproveGptConractEvent(
                              contractRefCode: state.contractPdf?.contractRefCode ?? '',
                              contractCode: _americanAccountContract,
                              accountExtId: UserModel.instance.accountId,
                              successCallback: () {
                                PBottomSheet.showError(
                                  context,
                                  isDismissible: false,
                                  enableDrag: false,
                                  isSuccess: true,
                                  content: L10n.tr('global_onboarding.contracts_approve_success'),
                                  showFilledButton: true,
                                  filledButtonText: L10n.tr('devam'),
                                  onFilledButtonPressed: () {
                                    router.popUntilRouteWithName(GlobalAccountOnboardingRoute.name);
                                    _globalOnboardingBloc.add(
                                      AccountSettingStatusEvent(),
                                    );
                                  },
                                );
                              }),
                        );
                      }
                    : null,
              ),
            ],
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Grid.m,
                  ),
                  child: Text(
                    state.contractPdf?.contractDescription ?? '',
                    style: context.pAppStyle.labelReg16textPrimary,
                  ),
                ),
                const SizedBox(
                  height: Grid.m,
                ),
                Expanded(
                  child: _pdfControllerPinch == null
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : PPdfViewer(
                          hasSlider: true,
                          pdfControllerPinch: _pdfControllerPinch!,
                          url: '${AppConfig.instance.contractUrl}${state.contractPdf?.contractRefCode ?? ''}',
                          onError: (error) => PBottomSheet.showError(
                            context,
                            content: error.toString(),
                          ),
                          onPageChanged: (int? page, int? total) {
                            if (page != null && total != null && page == total) {
                              setState(() {
                                _isLastPage = true;
                              });
                            }
                          },
                          isLast: (isLast) {
                            setState(() {
                              _isLastPage = true;
                            });
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
