import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/pdf_viewer/pdf_viewer.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:internet_file/internet_file.dart';
import 'package:pdfx/pdfx.dart';
import 'package:piapiri_v2/app/contracts/bloc/contracts_bloc.dart';
import 'package:piapiri_v2/app/contracts/bloc/contracts_event.dart';
import 'package:piapiri_v2/app/contracts/bloc/contracts_state.dart';
import 'package:piapiri_v2/common/utils/button_padding.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/app_config.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/user_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class GtpContractsPdfPage extends StatefulWidget {
  final String contractRefCode;
  final String cmContractCode;
  final String contractName;

  const GtpContractsPdfPage({
    super.key,
    required this.contractRefCode,
    required this.cmContractCode,
    required this.contractName,
  });

  @override
  State<GtpContractsPdfPage> createState() => _GtpContractsPdfPagePageState();
}

class _GtpContractsPdfPagePageState extends State<GtpContractsPdfPage> {
  bool _isLastPage = false;
  late ContractsBloc _contractsBloc;

  PdfControllerPinch? _pdfControllerPinch;
  @override
  void initState() {
    _contractsBloc = getIt<ContractsBloc>();
    _pdfControllerPinch = PdfControllerPinch(
      document: PdfDocument.openData(
        InternetFile.get('${AppConfig.instance.contractUrl}${widget.contractRefCode}'),
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
              title: L10n.tr(widget.contractName),
            ),
            bottomNavigationBar: generalButtonPadding(
              context: context,
              child: PButton(
                text: L10n.tr('contract_approve'),
                fillParentWidth: true,
                onPressed: _isLastPage && _pdfControllerPinch != null
                    ? () {
                        _contractsBloc.add(
                          ApproveGptConractEvent(
                              contractRefCode: widget.contractRefCode,
                              contractCode: widget.cmContractCode,
                              accountExtId: UserModel.instance.accountId,
                              successCallback: () {
                                _contractsBloc.add(
                                  GetGtpContractEvent(
                                    onSuccess: () => PBottomSheet.showError(
                                      context,
                                      isDismissible: false,
                                      enableDrag: false,
                                      isSuccess: true,
                                      content: L10n.tr('gtp.contracts_approve_success'),
                                      showFilledButton: true,
                                      filledButtonText: L10n.tr('devam'),
                                      onFilledButtonPressed: () {
                                        router.popUntilRouteWithName(
                                          ContractsListRoute.name,
                                        );
                                      },
                                    ),
                                  ),
                                );
                              }),
                        );
                      }
                    : null,
              ),
            ),
            body: _pdfControllerPinch == null
                ? const Center(child: CircularProgressIndicator())
                : PPdfViewer(
                    hasSlider: true,
                    onTotalPage: (totalPage) {
                      if (totalPage == 1) {
                        setState(() {
                          _isLastPage = true;
                        });
                      }
                    },
                    pdfControllerPinch: _pdfControllerPinch!,
                    url: '${AppConfig.instance.contractUrl}${widget.contractRefCode}',
                    onError: (error) => PBottomSheet.showError(
                      context,
                      content: error.toString(),
                    ),
                    onPageChanged: (int? page, int? total) {
                      if (page != null && total != null && page == total || total == 1) {
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
          );
        },
      ),
    );
  }
}
