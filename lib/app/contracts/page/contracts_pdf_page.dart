import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/pdf_viewer/pdf_viewer.dart';
import 'package:piapiri_v2/common/widgets/place_holder/no_data_widget.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_file/internet_file.dart';
import 'package:pdfx/pdfx.dart';
import 'package:piapiri_v2/app/contracts/bloc/contracts_bloc.dart';
import 'package:piapiri_v2/app/contracts/bloc/contracts_event.dart';
import 'package:piapiri_v2/app/contracts/bloc/contracts_state.dart';
import 'package:piapiri_v2/app/contracts/model/get_required_contracts_model.dart';
import 'package:piapiri_v2/app/global_account_onboarding/bloc/global_account_onboarding_bloc.dart';
import 'package:piapiri_v2/app/global_account_onboarding/bloc/global_account_onboarding_event.dart';
import 'package:piapiri_v2/app/info/model/info_variant.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/app_config.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';

@RoutePage()
class ContractsPdfPage extends StatefulWidget {
  const ContractsPdfPage({super.key});

  @override
  State<ContractsPdfPage> createState() => _ContractsPdfPageState();
}

class _ContractsPdfPageState extends State<ContractsPdfPage> {
  final PageController _pageController = PageController();
  late ContractsBloc _contractsBloc;
  late GlobalAccountOnboardingBloc _globalOnboardingBloc;
  late PdfControllerPinch _pdfControllerPinch;

  @override
  void initState() {
    _globalOnboardingBloc = getIt<GlobalAccountOnboardingBloc>();
    _contractsBloc = getIt<ContractsBloc>();
    _contractsBloc.add(
      RequiredContractsEvent(callback: (contractRefCode) {
        _pdfControllerPinch = PdfControllerPinch(
          document: PdfDocument.openData(
            InternetFile.get('${AppConfig.instance.contractUrl}$contractRefCode'),
          ),
        );
      }),
    );

    super.initState();
  }

  List<String> approveList = [];
  String? error;
  String filePath = '';
  Uint8List fileBytes = Uint8List.fromList([]);
  bool isLastPage = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PInnerAppBar(
        title: L10n.tr('agreements'),
      ),
      body: PBlocBuilder<ContractsBloc, ContractsState>(
        bloc: _contractsBloc,
        builder: (context, state) {
          if (state.isInitial || state.isLoading) {
            return const PLoading();
          }

          if (state.getRequiredContractsModel != null && state.getRequiredContractsModel!.isNotEmpty) {
            return PageView.builder(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              itemCount: state.getRequiredContractsModel?.length,
              itemBuilder: (context, index) {
                _pdfControllerPinch = PdfControllerPinch(
                  document: PdfDocument.openData(
                    InternetFile.get(
                        AppConfig.instance.contractUrl + state.getRequiredContractsModel![index].contractRefCode!),
                  ),
                );
                int lastIndex = state.getRequiredContractsModel!.length - 1;
                return _pdfPage(
                  state.getRequiredContractsModel?[index],
                  index,
                  lastIndex,
                );
              },
            );
          } else {
            return NoDataWidget(message: L10n.tr('no_data'));
          }
        },
      ),
    );
  }

  _pdfPage(
    RequiredContractsModel? requiredContractsModel,
    index,
    lastIndex,
  ) {
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
            requiredContractsModel?.contractDescription ?? '',
            style: context.pAppStyle.labelReg16textPrimary,
          ),
          const SizedBox(
            height: Grid.m,
          ),
          Expanded(
            child: PPdfViewer(
              pdfControllerPinch: _pdfControllerPinch,
              url: '${AppConfig.instance.contractUrl}${requiredContractsModel!.contractRefCode!}',
              onError: (error) => PBottomSheet.showError(
                context,
                content: error.toString(),
              ),
              onPageChanged: (int? page, int? total) {
                if (page != null && total != null && page == total) {
                  setState(() {
                    isLastPage = true;
                  });
                }
              },
              onTotalPage: (totalPage) => {
                if (totalPage == 1)
                  {
                    setState(() {
                      isLastPage = true;
                    }),
                  }
              },
              isLast: (isLast) {
                setState(() {
                  isLastPage = true;
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
              onPressed: isLastPage
                  ? () {
                      if (index != lastIndex) {
                        setState(() {
                          isLastPage = false;
                        });
                        approveList.add(requiredContractsModel.contractRefCode ?? '');
                        _pageController.nextPage(duration: const Duration(seconds: 1), curve: Curves.easeIn);
                      } else {
                        approveList.add(requiredContractsModel.contractRefCode ?? '');
                        return _contractsBloc.add(
                          ApproveUserContractEvent(
                            contractRefCode: approveList,
                            onSuccess: (isSucceed) {
                              if (isSucceed) {
                                router.push(
                                  InfoRoute(
                                    variant: InfoVariant.success,
                                    message: L10n.tr(
                                      'suitability_contract_approved_successfully',
                                      args: [
                                        _contractsBloc.state.setSurveyAnswersModel?.suitableRisks?.last.riskName ?? '-'
                                      ],
                                    ),
                                    onPressedCloseIcon: () {
                                      if (router.isPageInStack(GlobalAccountOnboardingRoute.name)) {
                                        //amerikan hesap açılışından geliyorsa tekrar oraya gönder
                                        router.popUntilRouteWithName(GlobalAccountOnboardingRoute.name);
                                        _globalOnboardingBloc.add(
                                          AccountSettingStatusEvent(),
                                        );
                                      } else {
                                        router.popUntilRouteWithName(DashboardRoute.name);
                                      }
                                    },
                                  ),
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
