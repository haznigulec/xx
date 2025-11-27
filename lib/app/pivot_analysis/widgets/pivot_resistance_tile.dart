import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class PivotResistanceTile extends StatelessWidget {
  final int index;
  final double pivotResistance;
  final double pivotSupport;
  final SymbolTypes type;
  const PivotResistanceTile({
    super.key,
    required this.index,
    required this.pivotResistance,
    required this.pivotSupport,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      child: Row(
        children: [
          Container(
            height: 20,
            constraints: const BoxConstraints(
              minWidth: 49,
            ),
            padding: const EdgeInsets.symmetric(horizontal: Grid.s),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: context.pColorScheme.success.withValues(alpha: .15),
            ),
            child: Text(
              '${MoneyUtils().getCurrency(type)}${MoneyUtils().readableMoney(pivotSupport)}',
              style: context.pAppStyle.interMediumBase.copyWith(
                fontSize: Grid.m - Grid.xxs,
                color: context.pColorScheme.success,
              ),
            ),
          ),
          const SizedBox(width: Grid.m),
          Text(
            '${L10n.tr('destek')} $index',
            style: context.pAppStyle.labelReg14textSecondary,
          ),
          const Spacer(),
          Text(
            '${L10n.tr('direnc')} $index',
            style: context.pAppStyle.labelReg14textSecondary,
          ),
          const SizedBox(width: Grid.m),
          Container(
            height: 20,
            constraints: const BoxConstraints(
              minWidth: 49,
            ),
            padding: const EdgeInsets.symmetric(horizontal: Grid.s),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: context.pColorScheme.critical.withValues(alpha: .15),
            ),
            child: Text(
              '${MoneyUtils().getCurrency(type)}${MoneyUtils().readableMoney(pivotResistance)}',
              style: context.pAppStyle.interMediumBase.copyWith(
                fontSize: Grid.m - Grid.xxs,
                color: context.pColorScheme.critical,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
