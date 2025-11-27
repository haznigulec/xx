import 'package:piapiri_v2/app/us_equity/us_market_utils.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/diff_percentage.dart';
import 'package:piapiri_v2/common/widgets/progress_indicators/shimmerize.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/model/us_symbol_snapshot.dart';

class LoserGainerTile extends StatelessWidget {
  final UsSymbolSnapshot snapshot;
  final bool isDividend;
  final bool shimmerize;

  const LoserGainerTile({
    super.key,
    required this.snapshot,
    this.shimmerize = false,
    this.isDividend = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        router.push(
          SymbolUsDetailRoute(
            symbolName: snapshot.ticker,
            ignoreUnsubscribeSymbols: true,
          ),
        );
      },
      child: SizedBox(
        height: 64,
        child: Row(
          children: [
            SymbolIcon(
          size: 30,
          symbolName: snapshot.ticker.toString(),
          symbolType: SymbolTypes.foreign,
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
                    snapshot.ticker.toString(),
                    overflow: TextOverflow.ellipsis,
                    style: context.pAppStyle.labelReg14textPrimary,
                  ),
                  Shimmerize(
                    enabled: shimmerize,
                    child: Text(
                      shimmerize ? snapshot.ticker * 3 : snapshot.name?.toUpperCase() ?? '',
                      overflow: TextOverflow.ellipsis,
                      style: context.pAppStyle.labelMed12textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Shimmerize(
              enabled: shimmerize,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${CurrencyEnum.dollar.symbol}${isDividend ? MoneyUtils().getUsPrice(snapshot) : MoneyUtils().readableMoney(snapshot.fmv ?? 0)}',
                    style: context.pAppStyle.labelMed14textPrimary,
                  ),
                  DiffPercentage(
                    percentage: UsMarketUtils().getDiffPercent(snapshot, isDividend: isDividend),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
    

  }
}
