import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/orders/model/american_order_type_enum.dart';
import 'package:piapiri_v2/app/orders/widgets/american_order_card_bottom_right_widget.dart';
import 'package:piapiri_v2/app/orders/widgets/black_dot_widget.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/model/order_status_enum.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/model/transaction_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class OrderUsCard extends StatelessWidget {
  final int index;
  final TransactionModel order;
  final OrderStatusEnum orderStatus;
  const OrderUsCard({
    super.key,
    required this.index,
    required this.order,
    required this.orderStatus,
  });

  @override
  Widget build(BuildContext context) {
    AmericanOrderTypeEnum orderType = AmericanOrderTypeEnum.values.firstWhere(
      (element) => element.value == order.orderType,
    );

    String valueKey = 'US_SYMBOL_ICON_${orderStatus.value}_${index}_${order.symbol ?? ''}';
    return InkWell(
      splashColor: context.pColorScheme.transparent,
      highlightColor: context.pColorScheme.transparent,
      onTap: () {
        router.push(
          OrderUsDetailRoute(
            selectedOrder: order,
            orderStatus: orderStatus,
            orderType: orderType,
          ),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SymbolIcon(
            key: ValueKey(valueKey),
            symbolName: order.symbol ?? '',
            symbolType: SymbolTypes.foreign,
            size: 28,
          ),
          const SizedBox(
            width: Grid.s + Grid.xs,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          order.symbol ?? '',
                          style: context.pAppStyle.labelReg14textPrimary,
                        ),
                        const BlackDotWidget(),
                        Text(
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
                      ],
                    ),
                    Text(
                      L10n.tr(order.symbolType?.name ?? ''),
                      style: context.pAppStyle.labelReg12textSecondary,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (orderStatus == OrderStatusEnum.canceled)
                          Text(
                            L10n.tr(orderType.localizationKey),
                            textAlign: TextAlign.right,
                            style: context.pAppStyle.labelMed12textSecondary,
                          ),
                        Text(
                          orderStatus == OrderStatusEnum.canceled
                              ? L10n.tr('canceled')
                              : orderStatus == OrderStatusEnum.filled
                                  ? '${L10n.tr(orderType.localizationKey)} \n ${L10n.tr('tutar')} \$${MoneyUtils().readableMoney(
                                      double.parse(order.filledAvgPrice ?? '0') * (order.realizedUnit ?? 0),
                                    )}'
                                  : L10n.tr(
                                      orderType == AmericanOrderTypeEnum.trailStop
                                          ? order.transactionType == 'buy'
                                              ? L10n.tr('trailStopOrderBuy')
                                              : L10n.tr('trailStopOrderSell')
                                          : order.orderStatus == 'partially_filled'
                                              ? '${L10n.tr(orderType.localizationKey)}\n${L10n.tr('gerceklesen_adet')}: ${order.realizedUnit?.toInt() ?? 0}'
                                              : orderType.localizationKey,
                                    ),
                          textAlign: TextAlign.right,
                          style: orderStatus == OrderStatusEnum.canceled
                              ? context.pAppStyle.labelMed12textSecondary.copyWith(color: context.pColorScheme.critical)
                              : context.pAppStyle.labelMed12textSecondary,
                        ),
                      ],
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
}
