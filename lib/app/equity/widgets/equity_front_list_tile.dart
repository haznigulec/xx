import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/diff_percentage.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';

class EquityFrontListTile extends StatelessWidget {
  final MarketListModel symbol;
  final Function()? onTap;
  const EquityFrontListTile({
    super.key,
    required this.symbol,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 64,
        child: Row(
          children: [
            SymbolIcon(
              symbolName: symbol.symbolCode,
              symbolType: SymbolTypes.equity,
              size: 28,
            ),
            const SizedBox(
              width: Grid.s,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    symbol.symbolCode,
                    overflow: TextOverflow.ellipsis,
                    style: context.pAppStyle.labelReg14textPrimary,
                  ),
                  Text(
                    symbol.description,
                    overflow: TextOverflow.ellipsis,
                    style: context.pAppStyle.labelMed12textSecondary,
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(symbol.last)}',
                  style: context.pAppStyle.labelMed14textPrimary,
                ),
                DiffPercentage(
                  percentage: symbol.differencePercent,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
