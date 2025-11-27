import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/advices/enum/market_type_enum.dart';
import 'package:piapiri_v2/app/advices/widgets/advice_card.dart';
import 'package:piapiri_v2/app/robo_signal/widgets/robo_signals_card.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/model/advice_model.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/order_action_type_enum.dart';

class AdviceActiveList extends StatelessWidget {
  final List<AdviceModel> adviceList;
  final String mainGroup;
  const AdviceActiveList({
    super.key,
    required this.adviceList,
    required this.mainGroup,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: adviceList.length,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(
        top: Grid.m - Grid.xs,
        bottom: Grid.m,
      ),
      itemBuilder: (context, index) {
        if (adviceList[index].isRoboSignal != null && adviceList[index].isRoboSignal == true) {
          return RoboSignalCard(
            roboSignal: adviceList[index],
          );
        }

        return InkWell(
          onTap: () {
            if (mainGroup == MarketTypeEnum.marketBist.value) {
              router.push(
                CreateOrderRoute(
                  symbol: MarketListModel(
                    symbolCode: adviceList[index].symbolName,
                    updateDate: '',
                  ),
                  action: adviceList[index].adviceSideId == 1 ? OrderActionTypeEnum.buy : OrderActionTypeEnum.sell,
                ),
              );
            } else {
              router.push(
                CreateUsOrderRoute(
                  symbol: adviceList[index].symbolName,
                  action: adviceList[index].adviceSideId == 1 ? OrderActionTypeEnum.buy : OrderActionTypeEnum.sell,
                ),
              );
            }
          },
          child: AdviceCard(
            advice: adviceList[index],
            isForeign: mainGroup == MarketTypeEnum.marketUs.value,
          ),
        );
      },
    );
  }
}
