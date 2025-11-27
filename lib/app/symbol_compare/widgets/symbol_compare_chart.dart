import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:piapiri_v2/app/symbol_compare/widgets/track_ball_container.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/core/model/chart_model.dart';
import 'package:piapiri_v2/core/model/chart_performance_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SymbolCompareChart extends StatelessWidget {
  final List<ChartPerformanceModel> performanceData;
  final ChartFilter selectedPerformanceFilter;
  const SymbolCompareChart({
    super.key,
    required this.performanceData,
    required this.selectedPerformanceFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230.0,
      color: context.pColorScheme.transparent,
      child: SfCartesianChart(
        margin: const EdgeInsets.all(0),
        plotAreaBorderWidth: 0, // Grafiğin etrafındaki çerçeve çizgisini kaldırır
        zoomPanBehavior: ZoomPanBehavior(
          enablePinching: true,
          zoomMode: ZoomMode.x,
          enablePanning: true,
        ),
        crosshairBehavior: CrosshairBehavior(
          enable: true,
          activationMode: ActivationMode.singleTap,
          lineDashArray: const [5, 5],
          lineType: CrosshairLineType.vertical,
          lineColor: context.pColorScheme.primary,
        ),
        tooltipBehavior: TooltipBehavior(
          enable: true,
          shared: true, // Tüm serilerin aynı tooltip içinde görünmesini sağlar
        ),
        trackballBehavior: TrackballBehavior(
          lineColor: Colors.transparent,
          enable: true,
          activationMode: ActivationMode.singleTap,
          shouldAlwaysShow: false,
          tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
          // chartta bir yere tiklandiginda gosterilen info Popup
          builder: (context, trackballDetails) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TrackBallContainer(
                  backgroundColor: context.pColorScheme.backgroundColor,
                  borderColor: context.pColorScheme.primary,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        ImagesPath.pinned,
                        width: 13,
                        colorFilter: ColorFilter.mode(
                          context.pColorScheme.primary,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(
                        width: Grid.xxs,
                      ),
                      Text(
                        DateTimeUtils.dateFormat(trackballDetails.groupingModeInfo?.points.first.x ?? DateTime.now()),
                        style: context.pAppStyle.labelMed12textPrimary,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: Grid.xxs,
                ),
                for (int i = 0; i < performanceData.length; i++)
                  trackBallWidget(context, performanceData[i], i, trackballDetails),
              ],
            );
          },
        ),
        primaryXAxis: DateTimeAxis(
          intervalType: DateTimeIntervalType.days,
          dateFormat: DateFormat('dd.MM'),
          labelAlignment: LabelAlignment.center,
          interactiveTooltip: const InteractiveTooltip(enable: false),
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          majorGridLines: const MajorGridLines(width: 0), // Y eksenindeki grid çizgilerini kaldırır
          axisLine: const AxisLine(width: 0), // Y ekseninin ana çizgisini kaldırır
          labelStyle: context.pAppStyle.labelReg12textTeritary,
        ),
        primaryYAxis: NumericAxis(
          anchorRangeToVisiblePoints: true,
          enableAutoIntervalOnZooming: true,
          numberFormat: NumberFormat.percentPattern(),
          interactiveTooltip: const InteractiveTooltip(enable: false),
          rangePadding: ChartRangePadding.round,
          majorGridLines: MajorGridLines(
            color: context.pColorScheme.textQuaternary,
            dashArray: const [1, 16],
            width: 1,
          ),
          axisLine: AxisLine(
            color: context.pColorScheme.transparent,
          ),
          majorTickLines: MajorTickLines(
            color: context.pColorScheme.transparent,
          ),
          labelStyle: context.pAppStyle.labelReg12textTeritary,
        ),
        series: performanceData
            .map(
              (e) => LineSeries<ChartPerformanceData, DateTime>(
                dataSource: e.data,
                animationDuration: 0,
                width: 1.75,
                color: context.pColorScheme.performanceChartColors[performanceData.indexOf(e)],
                xValueMapper: (ChartPerformanceData sales, _) => sales.date,
                yValueMapper: (ChartPerformanceData sales, _) => (sales.performance ?? 0) / 100,
                enableTooltip: false,
              ),
            )
            .toList(),
      ),
    );
  }

  Widget trackBallWidget(
    BuildContext context,
    ChartPerformanceModel chartPerformanceModel,
    int index,
    TrackballDetails trackballDetails,
  ) {
    ChartPerformanceData? chartPerformanceData = chartPerformanceModel.data?.firstWhereOrNull(
      (element) => element.date == trackballDetails.groupingModeInfo?.points.first.x,
    );

    return TrackBallContainer(
      backgroundColor: context.pColorScheme.backgroundColor,
      borderColor: context.pColorScheme.performanceChartColors[performanceData.indexOf(chartPerformanceModel)],
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SymbolIcon(
            symbolName: [
              SymbolTypes.warrant,
              SymbolTypes.future,
              SymbolTypes.option,
              SymbolTypes.fund,
            ].contains(chartPerformanceModel.symbolType)
                ? chartPerformanceModel.underlyingName
                : chartPerformanceModel.symbolName,
            symbolType: chartPerformanceModel.symbolType,
            size: 18,
          ),
          const SizedBox(
            width: Grid.xs,
          ),
          SizedBox(
            width: 70,
            child: AutoSizeText(
              chartPerformanceModel.symbolName,
              maxLines: 2,
              minFontSize: Grid.s,
              style: context.pAppStyle.labelReg14textPrimary,
            ),
          ),
          //Güne ait kayıtların gelmediği noktada karşılaştırma görüntüsünün bozulmaması için symbolun değerine - koyuyoruz
          SizedBox(
            width: 65,
            child: AutoSizeText(
              chartPerformanceData?.performance == null
                  ? '-'
                  : MoneyUtils().ratioFormat(
                      chartPerformanceData!.performance!,
                    ),
              style: context.pAppStyle.labelMed14textPrimary,
              minFontSize: Grid.s,
              maxFontSize: Grid.m - Grid.xxs,
              textAlign: TextAlign.end,
            ),
          )
        ],
      ),
    );
  }
}
