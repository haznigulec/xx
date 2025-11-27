import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class ChartLoadingWidget extends StatelessWidget {
  final bool isFailed;

  const ChartLoadingWidget({
    super.key,
    required this.isFailed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        Grid.s,
      ),
      height: 230,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(color: context.pColorScheme.secondary, width: 20, height: 50),
              Container(color: context.pColorScheme.secondary, width: 20, height: 100),
              Container(color: context.pColorScheme.secondary, width: 20, height: 70),
              Container(color: context.pColorScheme.secondary, width: 20, height: 110),
              Container(color: context.pColorScheme.secondary, width: 20, height: 80),
              Container(color: context.pColorScheme.secondary, width: 20, height: 120),
              Container(color: context.pColorScheme.secondary, width: 20, height: 90),
              Container(color: context.pColorScheme.secondary, width: 20, height: 130),
            ],
          ),
          if (isFailed)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  L10n.tr('no_chart_data'),
                  style: context.pAppStyle.labelMed18primary,
                ),
                const SizedBox(
                  height: Grid.xxl + Grid.xxl + Grid.xl,
                )
              ],
            ),
        ],
      ),
    );
  }
}
