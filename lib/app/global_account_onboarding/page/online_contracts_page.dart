import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/selection_control/checkbox.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:piapiri_v2/app/global_account_onboarding/bloc/global_account_onboarding_bloc.dart';
import 'package:piapiri_v2/app/global_account_onboarding/bloc/global_account_onboarding_event.dart';
import 'package:piapiri_v2/app/global_account_onboarding/bloc/global_account_onboarding_state.dart';
import 'package:piapiri_v2/app/global_account_onboarding/widget/custom_progress_bar.dart';
import 'package:piapiri_v2/app/global_account_onboarding/widget/leave_page.dart';
import 'package:piapiri_v2/app/info/model/info_variant.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/tab/tab_bloc.dart';
import 'package:piapiri_v2/core/bloc/tab/tab_event.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class OnlineContractsPage extends StatefulWidget {
  final String title;
  const OnlineContractsPage({
    super.key,
    required this.title,
  });

  @override
  State<OnlineContractsPage> createState() => _OnlineContractsPageState();
}

class _OnlineContractsPageState extends State<OnlineContractsPage> {
  late GlobalAccountOnboardingBloc _accountOnboardingBloc;
  bool _agreementAcknowledgement = false;
  bool _digitalSignatureAcknowledgement = false;
  bool buttonLoading = false;
  int reTryCount = 0;
  final ValueNotifier<bool> _resendingNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    _accountOnboardingBloc = getIt<GlobalAccountOnboardingBloc>();
    _accountOnboardingBloc.add(
      AccountInfoEvent(listType: 2),
    );
    super.initState();
  }

  @override
  void dispose() {
    _resendingNotifier.dispose();
    super.dispose();
  }

  void _startAccountUploadProcess(ValueNotifier<bool>? infoPageCloseableNotifier) async {
    if (reTryCount == 0) {
      setState(() {
        buttonLoading = true;
      });
    }

    _accountOnboardingBloc.add(
      UploadAccountInfoEvent(
        agreementAcknowledgement: _agreementAcknowledgement,
        digitalSignatureAcknowledgement: _digitalSignatureAcknowledgement,
        agreementSignedAt: DateTime.now().toIso8601String(),
        agreementIpAddress: await IpAddress().getIpAddress(),
        createAccount: true,
        callback: (response) {
          if (buttonLoading) {
            setState(() {
              buttonLoading = false;
            });
          }
          if (_resendingNotifier.value) {
            _resendingNotifier.value = false;
          }

          _navigateInfoPage(
            response,
            infoPageCloseableNotifier,
          );
        },
      ),
    );
  }

  void _navigateInfoPage(ApiResponse response, ValueNotifier<bool>? infoPageCloseableNotifier) {
    if (reTryCount == 0) {
      router.push(_getInfoRoute(response));
    } else {
      infoPageCloseableNotifier?.value = true;
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          //Info routu kapatır, Info routu açar.
          router.popAndPush(_getInfoRoute(response));
          infoPageCloseableNotifier?.dispose();
        },
      );
    }
  }

  InfoRoute _getInfoRoute(ApiResponse response) {
    final infoPageCloseableNotifier = ValueNotifier<bool>(false);
    return InfoRoute(
      variant: response.success ? InfoVariant.success : InfoVariant.failed,
      message: response.success ? L10n.tr('account_opening_request_success') : L10n.tr('account_opening_request_error'),
      subMessage: response.success
          ? L10n.tr('account_opening_notification')
          : L10n.tr('global_onboarding.${response.dioResponse?.data['errorCode'] ?? ''}'),
      subMessageStyle: context.pAppStyle.labelReg18textPrimary,
      buttonText: response.success ? L10n.tr('go_to_contracts_to_follow_process') : L10n.tr('retry'),
      buttonLoadingNotifier: _resendingNotifier,
      fromGlobalOnboarding: true,
      infoPageCloseableNotifier: infoPageCloseableNotifier,
      onPressedCloseIcon: () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (router.routeNames.contains(TransactionHistoryGeneralRoute.name)) {
            router.popUntilRouteWithName(TransactionHistoryGeneralRoute.name);
          } else if (router.routeNames.contains(PortfolioRoute.name)) {
            router.popUntilRoot();
            getIt<TabBloc>().add(
              const TabChangedEvent(
                tabIndex: 3,
              ),
            );
          } else if (router.routeNames.contains(SymbolUsDetailRoute.name)) {
            router.popUntilRouteWithName(SymbolUsDetailRoute.name);
          } else {
            router.popUntilRouteWithName(DashboardRoute.name);
            router.push(
              ContractsListRoute(
                title: L10n.tr('agreements'),
              ),
            );
          }
        });
      },
      onTapButton: response.success
          ? () async {
              infoPageCloseableNotifier.value = true;
              // Not: bu sayfanın süreci her zaman GlobalAccountOnboardingRoute ' den başlar
              // GlobalAccountOnboardingRoute sayfasının yeniden çizilmesi için bu yöntem kullanılmıştır.
              // GlobalAccountOnboardingRoute tan yönlendirildiği sürece hiçbir zaman else methoduna düşmeyecektir.
              if (router.routeNames.contains(GlobalAccountOnboardingRoute.name)) {
                router.popUntilRouteWithName(GlobalAccountOnboardingRoute.name);
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  router.popAndPush(const GlobalAccountOnboardingRoute());
                });
              } else {
                router.popUntilRoot();
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  router.push(const GlobalAccountOnboardingRoute());
                });
              }
            }
          : () {
              if (!_resendingNotifier.value) {
                reTryCount++;
                _resendingNotifier.value = true;
                _startAccountUploadProcess(infoPageCloseableNotifier);
              }
            },
    );
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
        bloc: _accountOnboardingBloc,
        builder: (context, state) {
          return Scaffold(
            appBar: PInnerAppBar(
              title: L10n.tr(widget.title),
              //Device'ın back tuşuna engel olması durumu için eklendi
              //Not sayfa router.maybePop() ile kapanmaz.
              //Şuan kapatılan her yerde router üzerindeki popUntilRouteWithName ile kapatılıyor
              backButtonPressedDisposeClosedPage: true,
              backButtonPressedDisposeClosedFunction: () => toGlobalOnboardingPage(context),
              onPressed: () => toGlobalOnboardingPage(context),
            ),
            persistentFooterButtons: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Grid.s,
                ),
                child: PButton(
                  text: L10n.tr(
                    'complate',
                  ),
                  loading: state.isLoading || buttonLoading,
                  fillParentWidth: true,
                  onPressed: _agreementAcknowledgement &&
                          _digitalSignatureAcknowledgement &&
                          (!state.isLoading && !buttonLoading)
                      ? () => _startAccountUploadProcess(null)
                      : null,
                ),
              ),
            ],
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Grid.m,
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: Grid.m + Grid.xs,
                    ),
                    CustomProgressBar(
                      value: 3 / 3,
                      progressText: '3/3',
                      title: L10n.tr('onlineContracts'),
                    ),
                    const SizedBox(
                      height: Grid.m + Grid.xs,
                    ),
                    InkWell(
                      splashColor: context.pColorScheme.transparent,
                      highlightColor: context.pColorScheme.transparent,
                      onTap: () {
                        if (state.accountInfo != null) {
                          router.push(
                            OnlineContractsPdfRoute(
                              pdfUrl: state.accountInfo!.alpacaCustomerAgreement,
                            ),
                          );
                        }
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Text(
                              L10n.tr('read_alcapa_customer_contract'),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: context.pAppStyle.labelMed14primary,
                            ),
                          ),
                          const SizedBox(
                            width: Grid.s,
                          ),
                          SvgPicture.asset(
                            ImagesPath.fileInfo,
                            width: Grid.m,
                            colorFilter: ColorFilter.mode(
                              context.pColorScheme.primary,
                              BlendMode.srcIn,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: Grid.m + Grid.xs,
                    ),
                    PCheckboxRow(
                      value: _agreementAcknowledgement,
                      removeCheckboxPadding: true,
                      onChanged: (value) {
                        setState(() {
                          _agreementAcknowledgement = value ?? false;
                        });
                      },
                      label: L10n.tr('agreementAcknowledgement'),
                    ),
                    const SizedBox(height: Grid.s + Grid.xs),
                    PCheckboxRow(
                      value: _digitalSignatureAcknowledgement,
                      removeCheckboxPadding: true,
                      onChanged: (value) {
                        setState(() {
                          _digitalSignatureAcknowledgement = value ?? false;
                        });
                      },
                      label: L10n.tr('digitalSignatureAcknowledgement'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
