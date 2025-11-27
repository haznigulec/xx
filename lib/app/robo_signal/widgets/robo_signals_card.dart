import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:p_core/extensions/date_time_extensions.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/core/config/analytics/analytics.dart';
import 'package:piapiri_v2/core/config/analytics/analytics_events.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/advice_model.dart';
import 'package:piapiri_v2/core/model/insider_event_enum.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/order_action_type_enum.dart';
import 'package:piapiri_v2/core/model/robo_signal_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class RoboSignalCard extends StatelessWidget {
  final AdviceModel roboSignal;
  final double? bottomPadding;
  final Function()? onTap;
  final Color? borderColor;
  const RoboSignalCard({
    super.key,
    required this.roboSignal,
    this.bottomPadding,
    this.onTap,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    int status = checkStatus(roboSignal);
    double symbolHeight = 30;

    return InkWell(
      onTap: onTap ??
          () {
            getIt<Analytics>().track(
              AnalyticsEvents.roboSignalsBuySellClick,
              taxonomy: [
                InsiderEventEnum.controlPanel.value,
                InsiderEventEnum.marketsPage.value,
                InsiderEventEnum.analysisTab.value,
                InsiderEventEnum.advices.value,
                InsiderEventEnum.seeAll.value,
              ],
            );

            router.push(
              CreateOrderRoute(
                symbol: MarketListModel(
                  symbolCode: roboSignal.code ?? '',
                  updateDate: '',
                ),
                action: status.isNegative ? OrderActionTypeEnum.sell : OrderActionTypeEnum.buy,
              ),
            );
          },
      child: Container(
        margin: EdgeInsets.only(
          bottom: bottomPadding ?? Grid.s,
        ),
        decoration: BoxDecoration(
          color: context.pColorScheme.card,
          borderRadius: const BorderRadius.all(Radius.circular(
            Grid.m,
          )),
          border: Border(
            bottom: BorderSide(
              color: borderColor ?? context.pColorScheme.transparent,
              width: 1,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(
            Grid.m,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 33,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SymbolIcon(
                      symbolName: roboSignal.code ?? '',
                      symbolType: SymbolTypes.equity,
                      size: symbolHeight,
                    ),
                    const SizedBox(
                      width: Grid.s,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            roboSignal.code ?? '',
                            textAlign: TextAlign.start,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.pAppStyle.labelReg14textPrimary,
                          ),
                          const Spacer(),
                          Text(
                            roboSignal.date == null ? '' : DateTime.parse(roboSignal.date!).formatDayMonthYearTime(),
                            style: context.pAppStyle.labelMed12textSecondary,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: Grid.xs,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              status.isNegative ? L10n.tr('sat') : L10n.tr('al'),
                              style: context.pAppStyle.interMediumBase.copyWith(
                                fontSize: Grid.m - Grid.xxs,
                                color: status.isNegative ? context.pColorScheme.critical : context.pColorScheme.success,
                              ),
                            ),
                            Text(
                              L10n.tr('robot'),
                              style: context.pAppStyle.labelReg12textSecondary,
                            ),
                          ],
                        ),
                        SvgPicture.asset(
                          status.isNegative ? ImagesPath.roboSat : ImagesPath.roboAl,
                          width: 28,
                          height: 28,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: Grid.xs,
                  left: symbolHeight + Grid.s,
                ),
                child: InkWell(
                  onTap: () {
                    PBottomSheet.show(
                      context,
                      title: '${roboSignal.code} ${L10n.tr('indicators')}',
                      child: _indicatorListWidget(roboSignal.indicators!),
                    );

                    return;
                  },
                  child: Text(
                    '${status.abs()} ${L10n.tr('indicator')}',
                    style: context.pAppStyle.labelReg12textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int checkStatus(AdviceModel roboSignal) {
    return roboSignal.indicators!.fold<int>(0, (previousValue, element) {
      if (element.type == 1) {
        return previousValue += 1;
      } else if (element.type == 2) {
        return previousValue -= 1;
      }
      return previousValue;
    });
  }

  Widget _indicatorListWidget(List<IndicatorModel> indicators) {
    List<IndicatorModel> filteredIndicators = indicators.where((element) => element.status != '').toList();

    return SizedBox(
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        separatorBuilder: (_, __) => const Padding(
          padding: EdgeInsets.symmetric(
            vertical: Grid.s + Grid.xs,
          ),
          child: PDivider(),
        ),
        shrinkWrap: true,
        itemCount: filteredIndicators.length,
        itemBuilder: (context, index) {
          return filteredIndicators[index].status == ''
              ? const SizedBox.shrink()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        filteredIndicators[index].code,
                        style: context.pAppStyle.labelReg14textSecondary,
                      ),
                    ),
                    Text(
                      MoneyUtils().readableMoney(filteredIndicators[index].value ?? 0),
                      textAlign: TextAlign.end,
                      style: context.pAppStyle.labelMed12textPrimary,
                    ),
                  ],
                );
        },
      ),
    );
  }
}
