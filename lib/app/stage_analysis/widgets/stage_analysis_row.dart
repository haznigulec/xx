import 'package:auto_size_text/auto_size_text.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/model/stage_analysis_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';

class StageAnalysisRow extends StatelessWidget {
  final StageAnalysisModel stageAnalysisModel;
  final SymbolTypes symbolType;
  final int maxBidQuantity;
  final int maxAskQuantity;
  final int totalUnit;
  const StageAnalysisRow({
    super.key,
    required this.stageAnalysisModel,
    required this.symbolType,
    required this.maxBidQuantity,
    required this.maxAskQuantity,
    required this.totalUnit,
  });

  @override
  Widget build(BuildContext context) {
    int bidQuantity = stageAnalysisModel.bidQuantity ?? 0;
    double bidFactor = bidQuantity / maxBidQuantity;
    int askQuantity = stageAnalysisModel.askQuantity ?? 0;
    double askFactor = askQuantity / maxAskQuantity;
    int unit = bidQuantity + askQuantity;
    double? percentage;
    if (totalUnit > 0) {
      double bidPercentage = bidQuantity * 100 / totalUnit;
      double askPercentage = askQuantity * 100 / totalUnit;
      percentage = askPercentage + bidPercentage;
    }

    return Column(
      children: [
        const SizedBox(
          height: Grid.s,
        ),
        SizedBox(
          height: 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      MoneyUtils().generalNumberFormat(unit),
                      style: context.pAppStyle.labelReg14textSecondary,
                      textAlign: TextAlign.start,
                    ),
                    Expanded(
                      child: Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              if (bidFactor > 0)
                                FractionallySizedBox(
                                  widthFactor: bidFactor, // Barın genişliği
                                  child: Container(
                                    height: 20,
                                    color: context.pColorScheme.success.withValues(alpha: 0.15),
                                  ),
                                ),
                              Text(
                                MoneyUtils().generalNumberFormat(bidQuantity),
                                style: context.pAppStyle.interMediumBase.copyWith(
                                  color: context.pColorScheme.success,
                                  fontSize: Grid.m - Grid.xxs,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: AutoSizeText(
                  '${MoneyUtils().getCurrency(symbolType)}${MoneyUtils().readableMoney(
                    stageAnalysisModel.price as num,
                  )}',
                  style: context.pAppStyle.labelReg14textSecondary,
                  textAlign: TextAlign.center,
                  minFontSize: Grid.s,
                  maxFontSize: Grid.m - Grid.xxs,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: SizedBox(
                        child: Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            if (askFactor > 0)
                              FractionallySizedBox(
                                widthFactor: askQuantity / maxAskQuantity, // Barın genişliği
                                child: Container(
                                  height: 20,
                                  color: context.pColorScheme.critical.withValues(alpha: 0.15),
                                ),
                              ),
                            Text(
                              MoneyUtils().generalNumberFormat(askQuantity),
                              style: context.pAppStyle.interMediumBase.copyWith(
                                color: context.pColorScheme.critical,
                                fontSize: Grid.m - Grid.xxs,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Text(
                      percentage != null ? "%${percentage.toStringAsFixed(2)}" : '-',
                      style: context.pAppStyle.labelReg14textSecondary,
                      textAlign: TextAlign.end,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
