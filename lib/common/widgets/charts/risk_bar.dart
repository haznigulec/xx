import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';

class RiskBar extends StatelessWidget {
  final int riskLevel;
  const RiskBar({
    super.key,
    required this.riskLevel,
  });

  @override
  Widget build(BuildContext context) {
    if (riskLevel < 1 || riskLevel > 7) {
      throw Exception('Risk level must be between 1 and 7');
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.centerLeft,
          children: [
            Container(
              height: 8,
              width: 49,
              decoration: BoxDecoration(
                color: context.pColorScheme.line,
                borderRadius: BorderRadius.circular(Grid.s),
              ),
            ),
            Container(
              height: 8,
              width: calculateRiskWidth(),
              decoration: BoxDecoration(
                color: getRiskColor(context),
                borderRadius: BorderRadius.circular(Grid.s),
              ),
            ),
          ],
        ),
        const SizedBox(width: Grid.s),
        SizedBox(
          width: 10,
          child: Text(
            '$riskLevel',
            style: context.pAppStyle.labelMed14textPrimary.copyWith(
              color: getRiskColor(context),
            ),
          ),
        ),
      ],
    );
  }

  Color getRiskColor(BuildContext context) {
    switch (riskLevel) {
      case 1:
      case 2:
      case 3:
        return context.pColorScheme.success;
      case 4:
      case 5:
        return context.pColorScheme.warning;
      case 6:
      case 7:
        return context.pColorScheme.critical;
      default:
        return context.pColorScheme.success;
    }
  }

  double calculateRiskWidth() {
    switch (riskLevel) {
      case 1:
        return 8;
      case 2:
        return 14;
      case 3:
        return 21;
      case 4:
        return 28;
      case 5:
        return 35;
      case 6:
        return 42;
      case 7:
        return 49;
      default:
        return 49;
    }
  }
}
