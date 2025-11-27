import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/advices/enum/market_type_enum.dart';
import 'package:piapiri_v2/app/advices/widgets/advice_card.dart';
import 'package:piapiri_v2/app/robo_signal/widgets/robo_signals_card.dart';
import 'package:piapiri_v2/core/model/advice_model.dart';

class AdviceFirstWidget extends StatelessWidget {
  final List<AdviceModel> adviceList;
  final String mainGroup;
  final Function() onTap;
  const AdviceFirstWidget({
    super.key,
    required this.adviceList,
    required this.mainGroup,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    int adviceCount = adviceList.length > 2 ? 2 : adviceList.length - 1;

    return Stack(
      children: [
        Column(
          children: [
            const SizedBox(
              height: Grid.s,
            ),
            if (adviceList[0].isRoboSignal != null && adviceList[0].isRoboSignal!) ...[
              RoboSignalCard(
                roboSignal: adviceList[0],
                bottomPadding: 0,
                onTap: onTap,
                borderColor: context.pColorScheme.iconPrimary.shade400,
              ),
            ] else ...[
              InkWell(
                onTap: onTap,
                child: AdviceCard(
                  advice: adviceList[0],
                  elevation: 1,
                  borderColor: context.pColorScheme.iconPrimary.shade400,
                  bottomPadding: 0,
                  isForeign: mainGroup == MarketTypeEnum.marketUs.value,
                ),
              )
            ],
            for (int i = 0; i < adviceCount; i++)
              Container(
                width: double.infinity,
                height: 10,
                margin: EdgeInsets.symmetric(
                  horizontal: Grid.s + (i * Grid.s + Grid.xs),
                ),
                decoration: BoxDecoration(
                  color: context.pColorScheme.card,
                  border: Border(
                    bottom: BorderSide(
                      color: context.pColorScheme.iconPrimary.shade400,
                      width: 1,
                    ),
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(
                      Grid.m,
                    ),
                    bottomRight: Radius.circular(
                      Grid.m,
                    ),
                  ),
                ),
              ),
          ],
        ),
        Positioned(
            top: 0,
            right: 18,
            child: Container(
              width: 25,
              height: 25,
              padding: const EdgeInsets.symmetric(
                horizontal: Grid.s - Grid.xxs,
                vertical: Grid.xs + Grid.xxs,
              ),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: FittedBox(
                  child: Text(
                    '${adviceList.length}',
                    style: context.pAppStyle.interMediumBase.copyWith(
                      fontSize: Grid.m,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )),
      ],
    );
  }
}
