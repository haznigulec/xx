import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/symbol_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/model/warrant_calculation_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class WarrantCalculatedHeader extends StatelessWidget {
  final WarrantCalculateDetailsModel calculateDetails;
  final SymbolModel symbol;
  const WarrantCalculatedHeader({
    super.key,
    required this.symbol,
    required this.calculateDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SymbolIcon(
          symbolName: symbol.underlyingName,
          symbolType: SymbolTypes.warrant,
          size: 28,
        ),
        const SizedBox(
          width: Grid.s,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 15,
              child: Text(
                symbol.name,
                style: context.pAppStyle.labelReg14textPrimary,
              ),
            ),
            const SizedBox(
              height: 1,
            ),
            SizedBox(
              height: 14,
              child: Text(
                L10n.tr('call_warrant', args: [symbol.underlyingName]),
                style: context.pAppStyle.labelMed12textSecondary,
              ),
            ),
          ],
        ),
        const Spacer(),
        Text(
          '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(calculateDetails.price ?? 0)}',
          style: context.pAppStyle.interMediumBase.copyWith(
            color: context.pColorScheme.textPrimary,
            fontSize: Grid.l + Grid.xxs,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
