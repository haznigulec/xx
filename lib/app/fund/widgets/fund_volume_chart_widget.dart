import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/fund/model/fund_volume_history_model.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class FundVolumeHistoryChartWidget extends StatelessWidget {
  final List<FundVolumeHistoryModel> data;
  final bool isLoading;
  final bool isFailed;
  final String category;

  const FundVolumeHistoryChartWidget({
    super.key,
    required this.data,
    this.isLoading = false,
    this.isFailed = false,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    if (isFailed) {
      return _placeholder(context, isFailed: true);
    }

    return Column(
      children: [
        Skeletonizer.zone(
          enabled: isLoading,
          containersColor: context.pColorScheme.transparent,
          child: Skeleton.replace(
            replace: true,
            replacement: Skeletonizer(
              enabled: true,
              child: _placeholder(context),
            ),
            child: SizedBox(
              height: 230.0,
              child: SfCartesianChart(
                margin: const EdgeInsets.all(0),
                plotAreaBorderWidth: 0,
                primaryXAxis: DateTimeCategoryAxis(
                  dateFormat: DateFormat('MMM'),
                  intervalType: DateTimeIntervalType.months,
                  majorGridLines: const MajorGridLines(width: 0), // Y eksenindeki grid çizgilerini kaldırır
                  axisLine: const AxisLine(width: 0), // Y ekseninin ana çizgisini kaldırır
                  labelStyle: context.pAppStyle.labelLig12textTeritary,
                  majorTickLines: MajorTickLines(
                    color: context.pColorScheme.transparent,
                  ),
                ),
                primaryYAxis: NumericAxis(
                  numberFormat: NumberFormat.compact(locale: 'tr'),
                  axisLine: const AxisLine(width: 0), // Y ekseninin ana çizgisini kaldırır
                  majorGridLines: MajorGridLines(
                    width: 1,
                    color: context.pColorScheme.textQuaternary,
                    dashArray: const [1, 16],
                  ),
                  labelStyle: context.pAppStyle.labelLig12textTeritary,
                  minimum: 0,
                ),
                tooltipBehavior: TooltipBehavior(
                  header: '',
                  enable: true,
                  color: context.pColorScheme.transparent,
                  builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
                    final DateTime date = data.date;
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
                      child: Text(
                        textAlign: TextAlign.center,
                        '$category: ${MoneyUtils().compactMoney(point.y)}\n${DateFormat('MMMM', 'tr').format(date)}',
                        style: context.pAppStyle.interRegularBase.copyWith(
                          fontSize: Grid.m - Grid.xxs,
                        ),
                      ),
                    );
                  },
                ),
                series: <CartesianSeries>[
                  ColumnSeries<FundVolumeHistoryModel, DateTime>(
                    dataSource: data,
                    xValueMapper: (FundVolumeHistoryModel data, _) => data.date,
                    yValueMapper: (FundVolumeHistoryModel data, _) => _getVolumeHistoryListByCategory(data, category),
                    pointColorMapper: (FundVolumeHistoryModel data, _) =>
                        context.pColorScheme.primary.withValues(alpha: .4),
                    width: .8,
                    dataLabelSettings: const DataLabelSettings(
                      isVisible: false,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  double _getVolumeHistoryListByCategory(FundVolumeHistoryModel model, String category) {
    if (category == L10n.tr('portfolioSize')) {
      return model.portfolioSize;
    } else if (category == L10n.tr('numberOfPeople')) {
      return model.numberOfPeople;
    } else if (category == L10n.tr('numberOfShares')) {
      return model.numberOfShares;
    } else {
      return model.portfolioSize;
    }
  }

  Widget _placeholder(BuildContext context, {bool isFailed = false}) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(Grid.s),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          if (isFailed)
            Center(
              child: Text(
                L10n.tr('data_yok'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
        ],
      ),
    );
  }
}
