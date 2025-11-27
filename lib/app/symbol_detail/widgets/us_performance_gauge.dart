import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/diff_percentage.dart';
import 'package:piapiri_v2/common/widgets/progress_indicators/shimmerize.dart';
import 'package:piapiri_v2/core/extension/double_extension.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class UsPerformanceGauge extends StatelessWidget {
  final String title;
  final double low;
  final double high;
  final double mean;
  final double performance;
  final CurrencyEnum currency;
  final bool shimmerize;

  const UsPerformanceGauge({
    super.key,
    required this.title,
    required this.low,
    required this.high,
    required this.mean,
    required this.performance,
    required this.currency,
    required this.shimmerize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: Grid.s),
      margin: const EdgeInsets.only(bottom: Grid.s),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            L10n.tr(title),
            style: context.pAppStyle.labelMed14textPrimary,
          ),
          const SizedBox(height: Grid.s),
          Shimmerize(
            enabled: shimmerize,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${currency.symbol}${MoneyUtils().readableMoney(low, pattern: low < 1 ? '#,##0.0000' : '#,##0.00')}',
                  style: context.pAppStyle.labelMed12textSecondary,
                ),
                DiffPercentage(
                  percentage: performance,
                  fontSize: Grid.l / 2,
                ),
                Text(
                  '${currency.symbol}${MoneyUtils().readableMoney(high, pattern: high < 1 ? '#,##0.0000' : '#,##0.00')}',
                  style: context.pAppStyle.labelMed12textSecondary,
                ),
              ],
            ),
          ),
          Shimmerize(
            enabled: shimmerize,
            child: SfLinearGauge(
              minimum: low >= high ? high - .001 : low,
              maximum: high.isNaN || high.isInfinite ? 1 : high,
              showLabels: false,
              animateAxis: false,
              showTicks: false,
              axisTrackStyle: LinearAxisTrackStyle(
                color: context.pColorScheme.line,
              ),
              markerPointers: shimmerize
                  ? null
                  : [
                      LinearShapePointer(
                        value: mean.isNullOrZero ? low : mean,
                        color: performance > 0
                            ? context.pColorScheme.success.shade100
                            : performance < 0
                                ? context.pColorScheme.critical.shade100
                                : context.pColorScheme.iconPrimary.shade100,
                        width: 18,
                        position: LinearElementPosition.cross,
                        shapeType: LinearShapePointerType.circle,
                        height: 18,
                        borderColor: performance > 0
                            ? context.pColorScheme.success
                            : performance < 0
                                ? context.pColorScheme.critical
                                : context.pColorScheme.iconPrimary,
                        borderWidth: 5,
                      ),
                    ],
            ),
          ),
        ],
      ),
    );
  }
}
