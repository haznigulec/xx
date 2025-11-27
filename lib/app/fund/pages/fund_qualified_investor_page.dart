import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/pdf_viewer/pdf_viewer.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:internet_file/internet_file.dart';
import 'package:pdfx/pdfx.dart';
import 'package:piapiri_v2/app/contracts/bloc/contracts_bloc.dart';
import 'package:piapiri_v2/app/contracts/bloc/contracts_event.dart';
import 'package:piapiri_v2/app/contracts/bloc/contracts_state.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/app_config.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/user_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';

@RoutePage()
class FundQualifiedInvestorPage extends StatefulWidget {
  const FundQualifiedInvestorPage({
    super.key,
  });

  @override
  State<FundQualifiedInvestorPage> createState() => _FundQualifiedInvestorPageState();
}

class _FundQualifiedInvestorPageState extends State<FundQualifiedInvestorPage> {
  late ContractsBloc _contractsBloc;

  @override
  void initState() {
    _contractsBloc = getIt<ContractsBloc>();
    _contractsBloc.add(
      GetContractPdfEvent(contractCode: 'NYBF'),
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
      child: PBlocBuilder<ContractsBloc, ContractsState>(
        bloc: _contractsBloc,
        builder: (context, state) {
          return Scaffold(
            appBar: PInnerAppBar(
              title: L10n.tr('nybf_contract'),
            ),
            persistentFooterButtons: [
              PButton(
                fillParentWidth: true,
                onPressed: state.isLoading
                    ? null
                    : () {
                        _contractsBloc.add(
                          ApproveGptConractEvent(
                            contractRefCode: state.contractPdf?.contractRefCode ?? '',
                            contractCode: 'NYBF',
                            accountExtId: UserModel.instance.accountId,
                            successCallback: () {
                              PBottomSheet.showError(
                                context,
                                content: L10n.tr('nybf_approve_message'),
                                isSuccess: true,
                                isDismissible: false,
                                enableDrag: false,
                                showFilledButton: true,
                                filledButtonText: L10n.tr('tamam'),
                                onFilledButtonPressed: () {
                                  router.popUntilRouteWithName(
                                    FundOrderRoute.name,
                                  );
                                },
                              );
                            },
                          ),
                        );
                      },
                text: L10n.tr('onayla'),
              ),
            ],
            body: SafeArea(
              child: state.contractPdf?.contractRefCode == null || state.isLoading
                  ? const PLoading()
                  : Padding(
                      padding: const EdgeInsets.all(
                        Grid.m,
                      ),
                      child: PPdfViewer(
                        pdfControllerPinch: PdfControllerPinch(
                          document: PdfDocument.openData(
                            InternetFile.get(
                                '${AppConfig.instance.contractUrl}${state.contractPdf?.contractRefCode ?? ''}'),
                          ),
                        ),
                        url: '${AppConfig.instance.contractUrl}${state.contractPdf?.contractRefCode ?? ''}',
                        onError: (error) {
                          return PBottomSheet.showError(
                            context,
                            content: error.toString(),
                          );
                        },
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
