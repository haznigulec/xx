import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:piapiri_v2/app/warrant/warrant_constants.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/bottomsheet_button.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/bottomsheet_select_tile.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/model/warrant_calculation_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class WarrantCalculatedChart extends StatefulWidget {
  final List<Graph> dataSource;
  const WarrantCalculatedChart({
    super.key,
    required this.dataSource,
  });

  @override
  State<WarrantCalculatedChart> createState() => _WarrantCalculatedChartState();
}

class _WarrantCalculatedChartState extends State<WarrantCalculatedChart> {
  String _selectedChartType = WarrantConstants().warrantChartTypes.first;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              L10n.tr('graphic'),
              style: context.pAppStyle.labelReg12textSecondary,
            ),
            const Spacer(),
            BottomsheetButton(
              title: L10n.tr(_selectedChartType),
              onPressed: () {
                PBottomSheet.show(
                  context,
                  title: L10n.tr('chart_type'),
                  child: ListView.separated(
                    itemCount: WarrantConstants().warrantChartTypes.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      String type = WarrantConstants().warrantChartTypes[index];
                      return BottomsheetSelectTile(
                        title: L10n.tr(type),
                        isSelected: _selectedChartType == type,
                        value: type,
                        onTap: (_, value) {
                          setState(() {
                            _selectedChartType = value;
                          });
                          router.maybePop();
                        },
                      );
                    },
                    separatorBuilder: (context, index) => const PDivider(),
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(
          height: Grid.m + Grid.xs,
        ),
        SfCartesianChart(
          primaryXAxis: CategoryAxis(
            desiredIntervals: 6,
            labelStyle: context.pAppStyle.labelLig12textTeritary,
            majorGridLines: const MajorGridLines(
              width: 0.5,
              dashArray: [4, 4],
            ),
            axisLine: AxisLine(
              width: 0.5,
              dashArray: [4, 4],
              color: context.pColorScheme.textTeritary,
            ),
            majorTickLines: const MajorTickLines(size: 0),
          ),
          primaryYAxis: NumericAxis(
            desiredIntervals: 4,
            numberFormat: NumberFormat.currency(),
            labelStyle: context.pAppStyle.labelLig12textTeritary,
            majorTickLines: const MajorTickLines(size: 0),
            majorGridLines: const MajorGridLines(
              width: 0.5,
              dashArray: [4, 4],
            ),
            axisLine: AxisLine(
              width: 0.5,
              dashArray: [4, 4],
              color: context.pColorScheme.textTeritary,
            ),
          ),
          margin: EdgeInsets.zero,
          series: <CartesianSeries>[
            SplineSeries<Graph, int>(
              color: context.pColorScheme.primary,
              dataSource: widget.dataSource,
              xValueMapper: (Graph graph, _) => widget.dataSource.indexOf(graph),
              yValueMapper: (Graph graph, _) {
                switch (_selectedChartType) {
                  case 'warrant_price':
                    return graph.warrantPrice;
                  case 'delta':
                    return graph.delta;
                  case 'vega':
                    return graph.vega;
                  case 'gamma':
                    return graph.gamma;
                  case 'theta':
                    return graph.theta;
                  default:
                    return graph.warrantPrice; // Default value
                }
              },
            ),
          ],
        )
      ],
    );
  }
}
