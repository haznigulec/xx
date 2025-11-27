import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/advices/bloc/advices_bloc.dart';
import 'package:piapiri_v2/app/advices/bloc/advices_state.dart';
import 'package:piapiri_v2/app/advices/enum/market_type_enum.dart';
import 'package:piapiri_v2/app/advices/widgets/advice_card.dart';
import 'package:piapiri_v2/app/advices/widgets/advice_empty_widget.dart';
import 'package:piapiri_v2/app/advices/widgets/advice_first_widget.dart';
import 'package:piapiri_v2/app/markets/widgets/hide_widget.dart';
import 'package:piapiri_v2/app/robo_signal/widgets/robo_signals_card.dart';
import 'package:piapiri_v2/common/widgets/progress_indicators/shimmerize.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/config/analytics/analytics.dart';
import 'package:piapiri_v2/core/config/analytics/analytics_events.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/insider_event_enum.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/order_action_type_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class BistAnalysisAdvicesWidget extends StatefulWidget {
  final String mainGroup;
  final bool showEmptyWidget;
  const BistAnalysisAdvicesWidget({
    super.key,
    required this.mainGroup,
    this.showEmptyWidget = false,
  });

  @override
  State<BistAnalysisAdvicesWidget> createState() => _BistAnalysisAdvicesWidgetState();
}

class _BistAnalysisAdvicesWidgetState extends State<BistAnalysisAdvicesWidget> {
  late AdvicesBloc _advicesBloc;
  bool _isExpanded = false;

  @override
  void initState() {
    _advicesBloc = getIt<AdvicesBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<AdvicesBloc, AdvicesState>(
      bloc: _advicesBloc,
      builder: (context, state) {
        if (state.adviceList.isEmpty) {
          if (widget.showEmptyWidget) {
            return Padding(
              padding: const EdgeInsets.only(
                top: Grid.m,
              ),
              child: AdviceEmptyWidget(
                mainGroup: widget.mainGroup,
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        }

        return widget.showEmptyWidget
            ? const SizedBox.shrink()
            : Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: Grid.m,
                ),
                child: Shimmerize(
                  enabled: state.advicesState == PageState.loading,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            L10n.tr('oneriler'),
                            style: context.pAppStyle.labelMed18textPrimary,
                          ),
                          InkWell(
                            onTap: () {
                              getIt<Analytics>().track(
                                AnalyticsEvents.roboSignalsTabClick,
                                taxonomy: widget.mainGroup == MarketTypeEnum.marketBist.value
                                    ? [
                                        InsiderEventEnum.controlPanel.value,
                                        InsiderEventEnum.marketsPage.value,
                                        InsiderEventEnum.istanbulStockExchangeTab.value,
                                        InsiderEventEnum.analysisTab.value,
                                      ]
                                    : [
                                        InsiderEventEnum.controlPanel.value,
                                        InsiderEventEnum.marketsPage.value,
                                        InsiderEventEnum.americanStockExchanges.value,
                                        InsiderEventEnum.analysisTab.value,
                                      ],
                              );

                              router.push(
                                BistAnalysisAllAdvicesRoute(
                                  adviceList: state.adviceList,
                                  mainGroup: widget.mainGroup,
                                ),
                              );
                            },
                            child: Text(
                              L10n.tr('see_all'),
                              style: context.pAppStyle.labelReg16primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: Grid.s,
                      ),
                      _isExpanded
                          ? ListView.builder(
                              itemCount: state.adviceList.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                bool isLast = index == state.adviceList.length - 1;
                                bool isRoboSignal = state.adviceList[index].isRoboSignal != null &&
                                    state.adviceList[index].isRoboSignal!;

                                if (isRoboSignal) {
                                  return isLast
                                      ? Stack(
                                          children: [
                                            RoboSignalCard(
                                              roboSignal: state.adviceList[index],
                                            ),
                                            HideWidget(
                                              onTap: () {
                                                setState(() {
                                                  _isExpanded = !_isExpanded;
                                                });
                                              },
                                            ),
                                          ],
                                        )
                                      : RoboSignalCard(
                                          roboSignal: state.adviceList[index],
                                        );
                                }

                                return isLast
                                    ? Stack(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              if (widget.mainGroup == MarketTypeEnum.marketUs.value) {
                                                router.push(
                                                  CreateUsOrderRoute(
                                                    symbol: state.adviceList[index].symbolName,
                                                    action: state.adviceList[index].adviceSideId == 1
                                                        ? OrderActionTypeEnum.buy
                                                        : OrderActionTypeEnum.sell,
                                                  ),
                                                );
                                              } else {
                                                router.push(
                                                  CreateOrderRoute(
                                                    symbol: MarketListModel(
                                                      symbolCode: state.adviceList[index].symbolName,
                                                      updateDate: '',
                                                    ),
                                                    action: state.adviceList[index].adviceSideId == 1
                                                        ? OrderActionTypeEnum.buy
                                                        : OrderActionTypeEnum.sell,
                                                  ),
                                                );
                                              }
                                            },
                                            child: AdviceCard(
                                              advice: state.adviceList[index],
                                              isForeign: widget.mainGroup == MarketTypeEnum.marketUs.value,
                                            ),
                                          ),
                                          HideWidget(
                                            onTap: () {
                                              setState(() {
                                                _isExpanded = !_isExpanded;
                                              });
                                            },
                                          ),
                                        ],
                                      )
                                    : InkWell(
                                        onTap: () {
                                          if (widget.mainGroup == MarketTypeEnum.marketUs.value) {
                                            router.push(
                                              CreateUsOrderRoute(
                                                symbol: state.adviceList[index].symbolName,
                                                action: state.adviceList[index].adviceSideId == 1
                                                    ? OrderActionTypeEnum.buy
                                                    : OrderActionTypeEnum.sell,
                                              ),
                                            );
                                          } else {
                                            router.push(
                                              CreateOrderRoute(
                                                symbol: MarketListModel(
                                                  symbolCode: state.adviceList[index].symbolName,
                                                  updateDate: '',
                                                ),
                                                action: state.adviceList[index].adviceSideId == 1
                                                    ? OrderActionTypeEnum.buy
                                                    : OrderActionTypeEnum.sell,
                                              ),
                                            );
                                          }
                                        },
                                        child: AdviceCard(
                                          advice: state.adviceList[index],
                                          isForeign: widget.mainGroup == MarketTypeEnum.marketUs.value,
                                        ),
                                      );
                              },
                            )
                          : AdviceFirstWidget(
                              adviceList: state.adviceList,
                              mainGroup: widget.mainGroup,
                              onTap: () {
                                setState(() {
                                  _isExpanded = !_isExpanded;
                                });
                              },
                            ),
                    ],
                  ),
                ),
              );
      },
    );
  }
}
