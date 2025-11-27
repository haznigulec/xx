import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/advices/widgets/advice_price.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/core/model/advice_history_model.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class AdviceHistoryCard extends StatelessWidget {
  final MarketListModel symbol;
  final ClosedAdvices closedAdvices;
  final bool isForeign;
  const AdviceHistoryCard({
    super.key,
    required this.closedAdvices,
    required this.symbol,
    this.isForeign = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Grid.s),
      child: Column(
        children: [
          SizedBox(
            height: 33,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SymbolIcon(
                  symbolName: symbol.symbolCode,
                  symbolType: stringToSymbolType(
                    isForeign ? 'foreign' : symbol.type,
                  ),
                  size: 28,
                ),
                const SizedBox(
                  width: Grid.s,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 15,
                      child: Text(
                        symbol.symbolCode,
                        style: context.pAppStyle.labelReg14textPrimary,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '${DateTimeUtils.dateFormat(DateTime.parse(closedAdvices.createdDate))} - ${DateTimeUtils.dateFormat(DateTime.parse(closedAdvices.closingDate))}',
                          style: context.pAppStyle.labelMed12textSecondary,
                        ),
                        const SizedBox(
                          width: Grid.xs,
                        ),
                        Text(
                          '(${DateTimeUtils.calculateDifferenceInDays(DateTime.parse(closedAdvices.createdDate), DateTime.parse(closedAdvices.closingDate))} ${L10n.tr('day')})',
                          style: context.pAppStyle.labelMed12textPrimary,
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  '${closedAdvices.profit > 0 ? '+' : '-'}${MoneyUtils().ratioFormat(closedAdvices.profit)}'
                      .replaceAll('%-', '%'),
                  style: context.pAppStyle.interMediumBase.copyWith(
                    color: closedAdvices.profit > 0 ? context.pColorScheme.success : context.pColorScheme.critical,
                    fontSize: Grid.m - Grid.xxs,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: Grid.m,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AdvicePrice(
                      title: L10n.tr('opening_price'),
                      price: closedAdvices.openingPrice.toDouble(),
                      isForeign: isForeign,
                    ),
                    const SizedBox(
                      height: Grid.s,
                    ),
                    AdvicePrice(
                      title: L10n.tr('target_price'),
                      price: closedAdvices.targetPrice,
                      isForeign: isForeign,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    AdvicePrice(
                      title: L10n.tr('stop_loss'),
                      price: closedAdvices.stopLoss,
                      isForeign: isForeign,
                    ),
                    const SizedBox(
                      height: Grid.s,
                    ),
                    AdvicePrice(
                      title: L10n.tr('closing_price'),
                      price: closedAdvices.closingPrice,
                      isForeign: isForeign,
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
