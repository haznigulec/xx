import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/advices/enum/market_type_enum.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/model/specific_list_bist_type_enum.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/model/specific_list_model.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/symbol_chips_widget.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';

class SpecificListCard extends StatelessWidget {
  final SpecificListModel specificListItem;
  final double? leftPadding;
  final double? rightPadding;

  const SpecificListCard({
    super.key,
    required this.specificListItem,
    this.leftPadding,
    this.rightPadding,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusColor: context.pColorScheme.transparent,
      onTap: () {
        (specificListItem.tab == BistType.equityBist.type ||
                    specificListItem.tab == BistType.warrantBist.type ||
                    specificListItem.tab == BistType.viopBist.type ||
                    specificListItem.symbolType == SpecialListSymbolTypeEnum.equity.type ||
                    specificListItem.symbolType == SpecialListSymbolTypeEnum.warrant.type ||
                    specificListItem.symbolType == SpecialListSymbolTypeEnum.viop.type) &&
                specificListItem.mainGroup != MarketTypeEnum.marketUs.value &&
                specificListItem.mainGroup != MarketTypeEnum.marketFund.value
            ? router.push(
                SpecificListDetailRoute(
                  specificListItem: specificListItem,
                ),
              )
            : specificListItem.mainGroup == BistType.fundBist.type ||
                    specificListItem.symbolType == SpecialListSymbolTypeEnum.fund.type ||
                    (specificListItem.symbolType != null &&
                        specificListItem.symbolType!.isEmpty &&
                        specificListItem.mainGroup != MarketTypeEnum.marketUs.value)
                ? router.push(
                    FundSpecificListDetailRoute(
                      specificListItem: specificListItem,
                    ),
                  )
                : router.push(
                    UsSpecificListDetailRoute(
                      specificListItem: specificListItem,
                    ),
                  );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: Grid.m,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            if (leftPadding != null)
              SizedBox(
                width: leftPadding,
              ),
            Padding(
              padding: const EdgeInsets.all(
                Grid.s + Grid.xxs,
              ),
              child: CardImage(
                imageUrl: specificListItem.image,
                size: 40,
              ),
            ),
            const SizedBox(
              width: Grid.s,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      right: rightPadding ?? 0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          specificListItem.listName,
                          style: context.pAppStyle.labelReg14textPrimary,
                        ),
                        const SizedBox(
                          height: Grid.xs,
                        ),
                        Text(
                          specificListItem.description,
                          style: context.pAppStyle.labelMed12textSecondary,
                        ),
                        const SizedBox(
                          height: Grid.xs,
                        ),
                      ],
                    ),
                  ),
                  SymbolChipsWidget(
                    key: ValueKey('SYMBOLCHIPS_${specificListItem.symbolNames.join(',')}'),
                    symbolList: specificListItem.symbolNames,
                    symbolListType: specificListItem.symbolType,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
