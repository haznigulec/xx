import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';

import 'package:piapiri_v2/core/utils/localization_utils.dart';

class TradeLimitRow extends StatelessWidget {
  final String dataKey;
  final Map<String, dynamic> limitInfos;
  final bool isVisible;

  const TradeLimitRow({
    super.key,
    required this.dataKey,
    required this.limitInfos,
    required this.isVisible,
  });
  @override
  Widget build(BuildContext context) {
    if (limitInfos['tradeLimitCalculationDetails'][dataKey] == 0.0) {
      return const SizedBox.shrink();
    }
    return Container(
      margin: const EdgeInsets.only(bottom: Grid.m + Grid.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              L10n.tr(dataKey),
              style: context.pAppStyle.labelMed14textSecondary,
              maxLines: 2,
            ),
          ),
          const SizedBox(width: Grid.s),
          Text(
            isVisible
                ? '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(
                    limitInfos['tradeLimitCalculationDetails'][dataKey],
                  )}'
                : '${CurrencyEnum.turkishLira.symbol}***',
            style: context.pAppStyle.labelMed14textPrimary,
          ),
        ],
      ),
    );
  }
}
