import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/sliding_segment/model/sliding_segment_model.dart';
import 'package:piapiri_v2/common/widgets/sliding_segment/sliding_segment.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:piapiri_v2/app/fund/bloc/fund_bloc.dart';
import 'package:piapiri_v2/app/fund/bloc/fund_event.dart';
import 'package:piapiri_v2/app/fund/bloc/fund_state.dart';
import 'package:piapiri_v2/app/fund/model/fund_price_graph_model.dart';
import 'package:piapiri_v2/app/symbol_chart/utils/symbol_chart_utils.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/bottomsheet_select_tile.dart';
import 'package:piapiri_v2/common/widgets/charts/chart_loading_widget.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/core/model/chart_model.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class FundChartWidget extends StatefulWidget {
  final String fundCode;
  const FundChartWidget({
    super.key,
    required this.fundCode,
  });

  @override
  State<FundChartWidget> createState() => _FundChartWidgetState();
}

class _FundChartWidgetState extends State<FundChartWidget> {
  late FundBloc _fundBloc;
  late List<ChartFilter> _chartFilterList;
  @override
  void initState() {
    _fundBloc = getIt<FundBloc>();
    _chartFilterList = ChartFilter.values
        .where(
          (e) =>
              e != ChartFilter.oneMinute &&
              e != ChartFilter.oneHour &&
              e != ChartFilter.threeMonth &&
              e != ChartFilter.sixMonth &&
              e != ChartFilter.threeYear &&
              e != ChartFilter.fiveYear,
        )
        .toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<FundBloc, FundState>(
      bloc: _fundBloc,
      builder: (context, state) {
        DateFormat dateFormatXAxis = SymbolChartUtils().handleXAxisTypeForSFCartesianChart(state.chartFilter);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (state.isLoading || (!state.isLoading && !(state.fundGraphPriceList?.isNotEmpty == true))) ...[
              ChartLoadingWidget(
                isFailed: !state.isLoading && !(state.fundGraphPriceList?.isNotEmpty == true),
              )
            ] else ...[
              SizedBox(
                height: 230,
                child: PBlocBuilder<FundBloc, FundState>(
                  bloc: getIt<FundBloc>(),
                  builder: (context, state) {
                    return SfCartesianChart(
                      margin: EdgeInsets.zero,
                      plotAreaBorderWidth: 0,
                      zoomPanBehavior: ZoomPanBehavior(
                        enablePinching: true,
                        zoomMode: ZoomMode.x,
                        enablePanning: true,
                      ),
                      crosshairBehavior: CrosshairBehavior(
                        enable: true,
                        activationMode: ActivationMode.singleTap,
                        shouldAlwaysShow: false,
                        lineDashArray: const [5, 5],
                        lineType: CrosshairLineType.both,
                        lineColor: context.pColorScheme.primary,
                        lineWidth: 0.5,
                      ),
                      trackballBehavior: TrackballBehavior(
                        lineColor: Colors.transparent,
                        enable: true,
                        activationMode: ActivationMode.singleTap,
                        shouldAlwaysShow: false,
                        markerSettings: TrackballMarkerSettings(
                          height: 14,
                          width: 14,
                          markerVisibility: TrackballVisibilityMode.visible,
                          borderColor: context.pColorScheme.backgroundColor,
                          borderWidth: 6,
                          color: context.pColorScheme.primary,
                        ),
                        tooltipSettings: InteractiveTooltip(
                          color: context.pColorScheme.backgroundColor,
                          borderColor: context.pColorScheme.primary,
                        ),
                        builder: (context, trackballDetails) {
                          if (trackballDetails.pointIndex == null) return const SizedBox();
                          FundPriceGraphModel data = state.fundGraphPriceList![trackballDetails.pointIndex!];
                          return Container(
                            decoration: BoxDecoration(
                              color: context.pColorScheme.backgroundColor,
                              borderRadius: BorderRadius.circular(Grid.s),
                              border: Border.all(
                                color: context.pColorScheme.primary,
                                width: 0.5,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: Grid.s,
                              vertical: Grid.s,
                            ),
                            child: Column(
                              spacing: Grid.xs,
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  DateTimeUtils.dateFormat(data.date),
                                  style: context.pAppStyle.labelMed12textPrimary,
                                ),
                                Text(
                                  '${state.currencyType.symbol}${MoneyUtils().readableMoney(data.price, pattern: '#,##0.000000')}',
                                  style: context.pAppStyle.labelMed12textPrimary,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      primaryXAxis: DateTimeCategoryAxis(
                        dateFormat: dateFormatXAxis,
                        labelAlignment: LabelAlignment.start,
                        edgeLabelPlacement: EdgeLabelPlacement.shift,
                        majorGridLines: const MajorGridLines(width: 0), // Y eksenindeki grid çizgilerini kaldırır
                        axisLine: const AxisLine(width: 0), // Y ekseninin ana çizgisini kaldırır
                        labelStyle: context.pAppStyle.labelLig12textTeritary,
                        interactiveTooltip: InteractiveTooltip(
                          color: context.pColorScheme.backgroundColor,
                          borderColor: context.pColorScheme.primary,
                          textStyle: context.pAppStyle.labelMed12textPrimary,
                        ),
                        majorTickLines: MajorTickLines(
                          color: context.pColorScheme.transparent,
                        ),
                      ),
                      primaryYAxis: NumericAxis(
                        anchorRangeToVisiblePoints: true,
                        enableAutoIntervalOnZooming: true,
                        rangePadding: ChartRangePadding.round,
                        axisLine: const AxisLine(width: 0), // Y ekseninin ana çizgisini kaldırır
                        majorGridLines: MajorGridLines(
                          color: context.pColorScheme.textQuaternary,
                          dashArray: const [1, 16],
                          width: 1,
                        ),
                        interactiveTooltip: InteractiveTooltip(
                          color: context.pColorScheme.backgroundColor,
                          borderColor: context.pColorScheme.primary,
                          textStyle: context.pAppStyle.labelMed12textPrimary,
                        ),
                        labelStyle: context.pAppStyle.labelLig12textTeritary,
                      ),
                      series: <CartesianSeries>[
                        AreaSeries<FundPriceGraphModel, DateTime>(
                          dataSource: state.fundGraphPriceList,
                          animationDuration: 0,
                          xValueMapper: (FundPriceGraphModel sales, _) => sales.date,
                          yValueMapper: (FundPriceGraphModel sales, _) => sales.price,
                          borderWidth: 2,
                          borderColor: context.pColorScheme.primary,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              context.pColorScheme.primary.withValues(alpha: .2),
                              context.pColorScheme.primary.withValues(alpha: .05),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
            const SizedBox(
              height: Grid.s,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) => SizedBox(
                      height: 30,
                      child: SlidingSegment(
                        initialSelectedSegment: _chartFilterList.indexOf(state.chartFilter),
                        slidingSegmentWidth: constraints.maxWidth - Grid.s,
                        backgroundColor: context.pColorScheme.card,
                        slidingSegmentRadius: Grid.m,
                        dividerColor: context.pColorScheme.transparent,
                        selectedTextStyle: context.pAppStyle.labelMed14textPrimary,
                        unSelectedTextStyle: context.pAppStyle.labelMed14textTeritary,
                        segmentList: List.generate(
                          _chartFilterList.length,
                          (index) => PSlidingSegmentModel(
                            segmentTitle: L10n.tr(
                              _chartFilterList[index].localizationKey,
                            ),
                            segmentColor: context.pColorScheme.backgroundColor,
                          ),
                        ),
                        onValueChanged: (int index) {
                          _fundBloc.add(
                            GetFundPriceGraphEvent(
                              chartFilter: _chartFilterList[index],
                              fundCode: widget.fundCode,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: Grid.s,
                ),
                InkWell(
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: context.pColorScheme.card,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      state.currencyType.symbol,
                      style: context.pAppStyle.labelReg16textPrimary,
                    ),
                  ),
                  onTap: () {
                    PBottomSheet.show(
                      context,
                      title: L10n.tr('chartCurrency'),
                      titlePadding: const EdgeInsets.only(
                        top: Grid.m,
                      ),
                      child: ListView.separated(
                        itemCount: 2,
                        shrinkWrap: true,
                        separatorBuilder: (context, index) => const PDivider(),
                        itemBuilder: (context, index) {
                          CurrencyEnum currency = index == 0 ? CurrencyEnum.turkishLira : CurrencyEnum.dollar;
                          return BottomsheetSelectTile(
                            value: currency,
                            title: L10n.tr(currency.shortName),
                            isSelected: state.currencyType == currency,
                            onTap: (String title, value) {
                              var type = value as CurrencyEnum;
                              if (type != state.currencyType) {
                                Navigator.pop(context);
                                _fundBloc.add(
                                  SetFunCurrencyType(),
                                );
                                _fundBloc.add(
                                  GetFundPriceGraphEvent(
                                    fundCode: widget.fundCode,
                                  ),
                                );
                              }
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
