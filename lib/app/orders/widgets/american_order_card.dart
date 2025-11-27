import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/orders/model/american_order_type_enum.dart';
import 'package:piapiri_v2/app/orders/widgets/american_order_card_bottom_right_widget.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/model/order_status_enum.dart';
import 'package:piapiri_v2/core/model/transaction_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class AmericanOrderCard extends StatelessWidget {
  final TransactionModel order;
  final OrderStatusEnum orderStatus;
  const AmericanOrderCard({
    super.key,
    required this.order,
    required this.orderStatus,
  });
  @override
  Widget build(BuildContext context) {
    AmericanOrderTypeEnum orderType = _handleOrderType(
      order.orderType ?? '',
    );
    return InkWell(
      splashColor: context.pColorScheme.transparent,
      highlightColor: context.pColorScheme.transparent,
      onTap: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            order.symbol ?? '',
                            style: context.pAppStyle.labelReg14textPrimary,
                          ),
                          const SizedBox(
                            width: Grid.xs,
                          ),
                          Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              color: context.pColorScheme.textPrimary,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(
                                  Grid.m,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: Grid.xs,
                          ),
                          Expanded(
                            child: Text(
                              order.transactionType == 'buy'
                                  ? L10n.tr('alis').toUpperCase()
                                  : L10n.tr('satis').toUpperCase(),
                              style: context.pAppStyle.interRegularBase.copyWith(
                                fontSize: Grid.m - Grid.xxs,
                                color: order.transactionType == 'buy'
                                    ? context.pColorScheme.success
                                    : context.pColorScheme.critical,
                              ),
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Expanded(
                      child: Text(
                        L10n.tr(
                          orderType == AmericanOrderTypeEnum.trailStop
                              ? order.transactionType == 'buy'
                                  ? L10n.tr('trailStopOrderBuy')
                                  : L10n.tr('trailStopOrderSell')
                              : orderType.name,
                        ),
                        textAlign: TextAlign.right,
                        style: context.pAppStyle.labelMed12textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: Grid.xxs / 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      L10n.tr(order.symbolType?.name ?? ''),
                      style: context.pAppStyle.labelReg12textSecondary,
                    ),
                    const SizedBox(
                      width: Grid.s,
                    ),
                    AmericanOrderCardBottomRightWidget(
                      order: order,
                      orderType: orderType,
                      orderStatus: orderStatus,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            width: Grid.s,
          ),
          SvgPicture.asset(
            ImagesPath.chevron_right,
            width: 15,
            height: 15,
            colorFilter: ColorFilter.mode(
              context.pColorScheme.textPrimary,
              BlendMode.srcIn,
            ),
          ),
        ],
      ),
    );
  }

  AmericanOrderTypeEnum _handleOrderType(String orderType) {
    switch (orderType) {
      case 'market':
        return AmericanOrderTypeEnum.market;
      case 'limit':
        return AmericanOrderTypeEnum.limit;
      case 'stop':
        return AmericanOrderTypeEnum.stop;
      case 'stop_limit':
        return AmericanOrderTypeEnum.stopLimit;
      case 'trail_stop':
        return AmericanOrderTypeEnum.trailStop;
      default:
        return AmericanOrderTypeEnum.market;
    }
  }
}
