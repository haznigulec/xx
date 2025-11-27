import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/advices/bloc/advices_bloc.dart';
import 'package:piapiri_v2/app/advices/bloc/advices_event.dart';
import 'package:piapiri_v2/app/advices/enum/market_type_enum.dart';
import 'package:piapiri_v2/app/advices/widgets/advice_card.dart';
import 'package:piapiri_v2/app/advices/widgets/advice_history_card.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/app/global_account_onboarding/bloc/global_account_onboarding_bloc.dart';
import 'package:piapiri_v2/app/global_account_onboarding/bloc/global_account_onboarding_event.dart';
import 'package:piapiri_v2/common/utils/utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/create_account_widget.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/common/widgets/tab_controller/model/tab_bar_item.dart';
import 'package:piapiri_v2/common/widgets/tab_controller/tab_controllers/p_main_tab_controller.dart';
import 'package:piapiri_v2/core/config/analytics/analytics.dart';
import 'package:piapiri_v2/core/config/analytics/analytics_events.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/advice_history_model.dart';
import 'package:piapiri_v2/core/model/advice_model.dart';
import 'package:piapiri_v2/core/model/alpaca_account_status_enum.dart';
import 'package:piapiri_v2/core/model/insider_event_enum.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/order_action_type_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class AdvicesPage extends StatefulWidget {
  final MarketListModel symbol;
  final List<AdviceModel> advices;
  final List<ClosedAdvices> closedAdvices;
  final bool isUsOrder;
  const AdvicesPage({
    super.key,
    required this.symbol,
    required this.advices,
    required this.closedAdvices,
    this.isUsOrder = false,
  });

  @override
  State<AdvicesPage> createState() => _AdvicesPageState();
}

class _AdvicesPageState extends State<AdvicesPage> {
  late AdvicesBloc _bloc;
  late AuthBloc _authBloc;
  late GlobalAccountOnboardingBloc _globalOnboardingBloc;

  @override
  void initState() {
    getIt<Analytics>().track(
      AnalyticsEvents.onerilerTabClick,
      taxonomy: widget.isUsOrder
          ? [
              InsiderEventEnum.controlPanel.value,
              InsiderEventEnum.marketsPage.value,
              InsiderEventEnum.americanStockExchanges.value,
              InsiderEventEnum.analysisTab.value,
            ]
          : [
              InsiderEventEnum.controlPanel.value,
              InsiderEventEnum.marketsPage.value,
              InsiderEventEnum.istanbulStockExchangeTab.value,
              InsiderEventEnum.analysisTab.value,
            ],
    );
    _bloc = getIt<AdvicesBloc>();
    _authBloc = getIt<AuthBloc>();
    _globalOnboardingBloc = getIt<GlobalAccountOnboardingBloc>();

    if (_authBloc.state.isLoggedIn) {
      _bloc.add(
        GetAdvicesEvent(
          symbolName: widget.symbol.symbolCode,
          mainGroup: MarketTypeEnum.marketBist.value,
        ),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PInnerAppBar(
        title: widget.advices.isEmpty ? L10n.tr('past_suggestions') : L10n.tr('advices'),
      ),
      body: !_authBloc.state.isLoggedIn
          ? CreateAccountWidget(
              memberMessage: L10n.tr('create_account_app_advice_alert'),
              loginMessage: L10n.tr('login_app_advice_alert'),
              onLogin: () => router.push(
                AuthRoute(
                  afterLoginAction: () async {
                    router.push(
                      AdvicesRoute(
                        symbol: widget.symbol,
                        advices: widget.advices,
                        closedAdvices: widget.closedAdvices,
                      ),
                    );
                  },
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Grid.m,
              ),
              child: widget.advices.isEmpty
                  ? ListView.separated(
                      itemCount: widget.closedAdvices.length,
                      padding: const EdgeInsets.only(
                        top: Grid.s + Grid.xs,
                      ),
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      separatorBuilder: (context, index) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: Grid.s,
                          ),
                          child: PDivider(),
                        );
                      },
                      itemBuilder: (context, index) {
                        return AdviceHistoryCard(
                          closedAdvices: widget.closedAdvices[index],
                          symbol: widget.symbol,
                          isForeign: widget.isUsOrder,
                        );
                      },
                    )
                  : PMainTabController(
                      scrollable: false,
                      tabs: [
                        PTabItem(
                          title: L10n.tr('active'),
                          page: Padding(
                            padding: const EdgeInsets.only(
                              top: Grid.m + Grid.xs,
                            ),
                            child: ListView.builder(
                                itemCount: widget.advices.length,
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  if (widget.advices[index].isRoboSignal != null &&
                                      widget.advices[index].isRoboSignal == true) {
                                    return const SizedBox.shrink();
                                  }

                                  return InkWell(
                                    onTap: () {
                                      if (widget.isUsOrder) {
                                        if (Utils().canTradeAmericanMarket()) {
                                          _checkCapraAccount(
                                            // Amerikan borsasında hesabı var mı yok mu kontrolü.
                                            widget.advices[index].adviceSideId == 1
                                                ? OrderActionTypeEnum.buy
                                                : OrderActionTypeEnum.sell,
                                            widget.advices[index].symbolName,
                                          );
                                        }
                                      } else {
                                        router.push(
                                          CreateOrderRoute(
                                            symbol: MarketListModel(
                                              symbolCode: widget.advices[index].symbolName,
                                              updateDate: '',
                                            ),
                                            action: widget.advices[index].adviceSideId == 1
                                                ? OrderActionTypeEnum.buy
                                                : OrderActionTypeEnum.sell,
                                          ),
                                        );
                                      }
                                    },
                                    child: AdviceCard(
                                      advice: widget.advices[index],
                                      isForeign: widget.isUsOrder,
                                    ),
                                  );
                                }),
                          ),
                        ),
                        PTabItem(
                          title: L10n.tr('past'),
                          page: ListView.separated(
                            itemCount: widget.closedAdvices.length,
                            padding: const EdgeInsets.only(
                              top: Grid.s + Grid.xs,
                            ),
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            separatorBuilder: (context, index) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: Grid.s,
                                ),
                                child: PDivider(),
                              );
                            },
                            itemBuilder: (context, index) {
                              return AdviceHistoryCard(
                                closedAdvices: widget.closedAdvices[index],
                                symbol: widget.symbol,
                                isForeign: widget.isUsOrder,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
            ),
    );
  }

  _checkCapraAccount(
    OrderActionTypeEnum action,
    String symbol,
  ) {
    AlpacaAccountStatusEnum? alpacaAccountStatus;
    _globalOnboardingBloc.add(
      AccountSettingStatusEvent(
        succesCallback: (accountSettingStatus) {
          setState(() {
            alpacaAccountStatus = AlpacaAccountStatusEnum.values.firstWhereOrNull(
              (e) => e.value == accountSettingStatus.accountStatus,
            );
          });
          if (alpacaAccountStatus != AlpacaAccountStatusEnum.active) {
            PBottomSheet.showError(
              context,
              content: alpacaAccountStatus == null
                  ? L10n.tr('alpaca_account_not_active')
                  : L10n.tr('portfolio.${alpacaAccountStatus!.descriptionKey}'),
              showFilledButton: true,
              showOutlinedButton: true,
              filledButtonText: alpacaAccountStatus == null ? L10n.tr('get_started') : L10n.tr('go_agreements'),
              outlinedButtonText: L10n.tr('afterwards'),
              onOutlinedButtonPressed: () => router.maybePop(),
              onFilledButtonPressed: () async {
                Navigator.of(context).pop();
                router.push(
                  const GlobalAccountOnboardingRoute(),
                );
              },
            );
            return;
          }

          router.push(
            CreateUsOrderRoute(
              symbol: symbol,
              action: action,
            ),
          );
        },
      ),
    );

    router.push(
      CreateUsOrderRoute(
        symbol: symbol,
        action: action,
      ),
    );
  }
}
