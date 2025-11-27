import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/pdf_viewer/pdf_viewer.dart';
import 'package:piapiri_v2/common/widgets/place_holder/no_data_widget.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:internet_file/internet_file.dart';
import 'package:pdfx/pdfx.dart';
import 'package:piapiri_v2/app/contracts/bloc/contracts_bloc.dart';
import 'package:piapiri_v2/app/contracts/bloc/contracts_event.dart';
import 'package:piapiri_v2/app/contracts/bloc/contracts_state.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/app_config.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';

@RoutePage()
class T0ContractPage extends StatefulWidget {
  final String accountExtId;

  const T0ContractPage({
    super.key,
    required this.accountExtId,
  });

  @override
  State<T0ContractPage> createState() => _T0ContractPageState();
}

class _T0ContractPageState extends State<T0ContractPage> {
  PdfControllerPinch? _pdfControllerPinch;
  String? _pdfUrl;
  late bool _isLastPage;
  final bool _hasSlider = true;
  late ContractsBloc _contractsBloc;
  final String _contractCode = 'T0_CREDIT';

  @override
  void initState() {
    _isLastPage = false;
    _contractsBloc = getIt<ContractsBloc>();
    _contractsBloc.add(
      GetContractPdfEvent(
        contractCode: _contractCode,
        onContractCode: (p0) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) {
              setState(
                () {
                  _pdfUrl =
                      '${AppConfig.instance.contractUrl}${_contractsBloc.state.contractPdf?.contractRefCode ?? ''}';
                  if (_pdfUrl != null) {
                    _pdfControllerPinch = PdfControllerPinch(
                      document: PdfDocument.openData(
                        InternetFile.get(_pdfUrl!),
                      ),
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PInnerAppBar(
        title: L10n.tr('t0_credit_contract'),
      ),
      body: PBlocBuilder<ContractsBloc, ContractsState>(
        bloc: _contractsBloc,
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: PLoading());
          }

          if (_pdfControllerPinch == null || _pdfUrl == null) {
            return NoDataWidget(message: L10n.tr('no_data'));
          }

          return PPdfViewer(
            pdfControllerPinch: _pdfControllerPinch!,
            url: _pdfUrl!,
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
            onTotalPage: (totalPage) => {
              if (totalPage == 1)
                {
                  setState(() {
                    _isLastPage = true;
                  }),
                }
            },
            isLast: (isLast) {
              setState(() {
                _isLastPage = true;
              });
            },
            hasSlider: _hasSlider,
          );
        },
      ),
      persistentFooterButtons: [
        PButton(
          text: L10n.tr('onayla'),
          fillParentWidth: true,
          onPressed: _isLastPage
              ? () {
                  _contractsBloc.add(
                    ApproveGptConractEvent(
                      contractCode: _contractCode,
                      accountExtId: widget.accountExtId,
                      contractRefCode: _contractsBloc.state.contractPdf?.contractRefCode ?? '',
                    ),
                  );
                  router.maybePop();
                }
              : null,
        ),
      ],
    );
  }
}
