import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/pdf_viewer/pdf_viewer.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:internet_file/internet_file.dart';
import 'package:pdfx/pdfx.dart';
import 'package:piapiri_v2/app/contracts/bloc/contracts_bloc.dart';
import 'package:piapiri_v2/app/contracts/bloc/contracts_event.dart';
import 'package:piapiri_v2/app/contracts/model/get_required_contracts_model.dart';
import 'package:piapiri_v2/core/config/app_config.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class ContractsPdfItem extends StatefulWidget {
  final RequiredContractsModel? requiredContractsModel;
  final int index;
  final int lastIndex;

  final PageController pageController;

  const ContractsPdfItem({
    super.key,
    required this.requiredContractsModel,
    required this.index,
    required this.lastIndex,
    required this.pageController,
  });

  @override
  State<ContractsPdfItem> createState() => _ContractsPdfItemState();
}

class _ContractsPdfItemState extends State<ContractsPdfItem> {
  bool _isLastPage = false;
  final List<String> approveList = [];
  late ContractsBloc _contractsBloc;
  late PdfControllerPinch _pdfControllerPinch;

  @override
  void initState() {
    _contractsBloc = getIt<ContractsBloc>();
    _contractsBloc.add(
      RequiredContractsEvent(),
    );
    _pdfControllerPinch = PdfControllerPinch(
      document: PdfDocument.openData(
        InternetFile.get(
          '${AppConfig.instance.contractUrl}${widget.requiredContractsModel!.contractRefCode!}',
        ),
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Grid.m,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: Grid.m + Grid.xs,
          ),
          Text(
            widget.requiredContractsModel?.contractDescription ?? '',
            style: context.pAppStyle.labelReg16textPrimary,
          ),
          const SizedBox(
            height: Grid.m,
          ),
          Expanded(
            child: PPdfViewer(
              pdfControllerPinch: _pdfControllerPinch,
              url: '${AppConfig.instance.contractUrl}${widget.requiredContractsModel!.contractRefCode!}',
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
              hasSlider: true,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.paddingOf(context).bottom + Grid.xs,
            ),
            child: PButton(
              text: L10n.tr('onayliyorum'),
              fillParentWidth: true,
              onPressed: _isLastPage
                  ? () {
                      if (widget.index != widget.lastIndex) {
                        setState(() {
                          _isLastPage = false;
                        });
                        approveList.add(widget.requiredContractsModel?.contractRefCode ?? '');
                        widget.pageController.nextPage(
                          duration: const Duration(seconds: 1),
                          curve: Curves.easeIn,
                        );
                      } else {
                        approveList.add(widget.requiredContractsModel?.contractRefCode ?? '');
                        _contractsBloc.add(
                          ApproveUserContractEvent(
                            contractRefCode: approveList,
                            onSuccess: (isSucceed) {
                              if (isSucceed) {
                                router.popUntilRouteWithName(ContractsRoute.name);
                                _contractsBloc.add(
                                  GetCustomerAnswersEvent(),
                                );
                              }
                            },
                          ),
                        );
                      }
                    }
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
