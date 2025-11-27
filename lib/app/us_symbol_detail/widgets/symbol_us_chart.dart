import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:piapiri_v2/app/symbol_chart/utils/symbol_chart_utils.dart';
import 'package:piapiri_v2/app/symbol_chart/widget/symbol_chart_options.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_bloc.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_event.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_state.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/charts/chart_loading_widget.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/core/model/chart_model.dart';
import 'package:piapiri_v2/core/model/current_daily_bar.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SymbolUsChart extends StatefulWidget {
  final ChartType chartType;
  final bool isLoading;
  final String symbol;

  const SymbolUsChart({
    super.key,
    this.chartType = ChartType.area,
    this.isLoading = false,
    required this.symbol,
  });

  @override
  State<SymbolUsChart> createState() => _SymbolUsChartState();
}

class _SymbolUsChartState extends State<SymbolUsChart> {
  late UsEquityBloc _usEquityBloc;
  late List<ChartFilter> _chartFilterList;

  @override
  void initState() {
    _usEquityBloc = getIt<UsEquityBloc>();
    _chartFilterList = ChartFilter.values
        .where(
          (e) =>
              e != ChartFilter.sixMonth &&
              e != ChartFilter.threeMonth &&
              e != ChartFilter.threeYear &&
              e != ChartFilter.fiveYear,
        )
        .toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<UsEquityBloc, UsEquityState>(
      bloc: _usEquityBloc,
      buildWhen: (previous, current) =>
          previous.chartFilter != current.chartFilter ||
          previous.chartType != current.chartType ||
          previous.isLoading != current.isLoading ||
          previous.graphData != current.graphData ||
          previous.currencyType != current.currencyType,
      builder: (context, state) {
        DateFormat dateFormatXAxis = SymbolChartUtils().handleXAxisTypeForSFCartesianChart(state.chartFilter);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (state.isLoading || (state.isNotLoading && state.graphData.isEmpty)) ...[
              ChartLoadingWidget(
                isFailed: state.isNotLoading && state.graphData.isEmpty,
              )
            ] else ...[
              SizedBox(
                height: 230.0,
                child: SfCartesianChart(
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
                      CurrentDailyBar data = state.graphData[trackballDetails.pointIndex!];
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
                              data.timeUtc != null
                                  ? state.chartFilter == ChartFilter.oneMinute ||
                                          state.chartFilter == ChartFilter.oneHour
                                      ? dateFormatXAxis.format(DateTime.parse(data.timeUtc!))
                                      : DateTimeUtils.dateFormat(DateTime.parse(data.timeUtc!))
                                  : '-',
                              style: context.pAppStyle.labelMed12textPrimary,
                            ),
                            if (state.chartType != ChartType.area)
                              Text(
                                '${L10n.tr('chartOpen')}: ${data.close == null ? '-' : '${state.currencyType.symbol}${MoneyUtils().readableMoney(data.open ?? 0)}'}',
                                style: context.pAppStyle.labelMed12textPrimary,
                              ),
                            Text(
                              state.chartType != ChartType.area
                                  ? '${L10n.tr('chartClose')}: ${data.close == null ? '-' : '${state.currencyType.symbol}${MoneyUtils().readableMoney(data.close ?? 0)}'}'
                                  : data.close == null
                                      ? '-'
                                      : '${state.currencyType.symbol}${MoneyUtils().readableMoney(data.close ?? 0)}',
                              style: context.pAppStyle.labelMed12textPrimary,
                            ),
                            if (state.chartType != ChartType.area)
                              Text(
                                '${L10n.tr('chartHigh')}: ${data.close == null ? '-' : '${state.currencyType.symbol}${MoneyUtils().readableMoney(data.high ?? 0)}'}',
                                style: context.pAppStyle.labelMed12textPrimary,
                              ),
                            if (state.chartType != ChartType.area)
                              Text(
                                '${L10n.tr('chartLow')}: ${data.close == null ? '-' : '${state.currencyType.symbol}${MoneyUtils().readableMoney(data.low ?? 0)}'}',
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
                    if (state.chartType == ChartType.area)
                      AreaSeries<CurrentDailyBar, DateTime>(
                        dataSource: state.graphData,
                        animationDuration: 0,
                        xValueMapper: (CurrentDailyBar sales, _) => DateTime.parse(sales.timeUtc!),
                        yValueMapper: (CurrentDailyBar sales, _) => sales.close,
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
                    if (state.chartType == ChartType.ohlc)
                      HiloOpenCloseSeries<CurrentDailyBar, DateTime>(
                        dataSource: state.graphData,
                        animationDuration: 0,
                        bearColor: context.pColorScheme.critical,
                        bullColor: context.pColorScheme.success,
                        xValueMapper: (CurrentDailyBar sales, _) => DateTime.parse(sales.timeUtc!),
                        lowValueMapper: (CurrentDailyBar sales, _) => sales.low,
                        highValueMapper: (CurrentDailyBar sales, _) => sales.high,
                        openValueMapper: (CurrentDailyBar sales, _) => sales.open,
                        closeValueMapper: (CurrentDailyBar sales, _) => sales.close,
                      ),
                    if (state.chartType == ChartType.candle)
                      CandleSeries<CurrentDailyBar, DateTime>(
                        dataSource: state.graphData,
                        animationDuration: 0,
                        bearColor: context.pColorScheme.critical,
                        bullColor: context.pColorScheme.success,
                        enableSolidCandles: true,
                        xValueMapper: (CurrentDailyBar sales, _) => DateTime.parse(sales.timeUtc!),
                        openValueMapper: (CurrentDailyBar data, _) => data.open,
                        highValueMapper: (CurrentDailyBar data, _) => data.high,
                        lowValueMapper: (CurrentDailyBar data, _) => data.low,
                        closeValueMapper: (CurrentDailyBar data, _) => data.close,
                        onRendererCreated: (ChartSeriesController controller) {},
                      ),
                  ],
                ),
              ),
            ],
            const SizedBox(
              height: Grid.s,
            ),
            SymbolChartOptions(
              hasCurrencySwitch: false,
              showChartCurrency: true,
              selectedCurrencyEnum: state.currencyType,
              chartFilter: state.chartFilter,
              selectedType: state.chartType,
              chartFilterList: _chartFilterList,
              onFilterChanged: (index) {
                _usEquityBloc.add(
                  GetCustomBarsEvent(
                    chartFilter: _chartFilterList[index],
                    symbols: widget.symbol,
                  ),
                );
              },
              onCurrencyChanged: (currencyEnum) {
                Navigator.pop(context);
                if (currencyEnum != state.currencyType) {
                  _usEquityBloc.add(
                    SetUsChartCurrentType(),
                  );
                  _usEquityBloc.add(
                    GetCustomBarsEvent(
                      symbols: widget.symbol,
                    ),
                  );
                }
              },
              onTypeChanged: (chartType) {
                if (chartType != state.chartType) {
                  Navigator.pop(context);
                  _usEquityBloc.add(
                    SetUsChartType(
                      usChartType: chartType,
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
