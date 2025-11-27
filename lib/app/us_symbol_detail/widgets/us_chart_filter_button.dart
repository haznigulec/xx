import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/core/model/chart_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class UsChartFilterButton extends StatelessWidget {
  const UsChartFilterButton({
    required this.isSelected,
    required this.filter,
    required this.onSelected,
    super.key,
  });
  final bool isSelected;
  final ChartFilter filter;
  final Function() onSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelected,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: Grid.s, vertical: Grid.xs),
        decoration: BoxDecoration(
          color: isSelected ? context.pColorScheme.backgroundColor : Colors.transparent,
          borderRadius: BorderRadius.circular(Grid.m + Grid.xs),
        ),
        child: Text(
          L10n.tr(
            filter.localizationKey,
          ),
          style: context.pAppStyle.interRegularBase.copyWith(
            fontSize: Grid.m - Grid.xxs,
            color: isSelected ? context.pColorScheme.textPrimary : context.pColorScheme.textTeritary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
