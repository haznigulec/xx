import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/orders/model/american_order_type_enum.dart';
import 'package:piapiri_v2/app/orders/widgets/black_dot_widget.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/order_status_enum.dart';
import 'package:piapiri_v2/core/model/transaction_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class AmericanOrderCardBottomRightWidget extends StatelessWidget {
  final TransactionModel order;
  final AmericanOrderTypeEnum orderType;
  final OrderStatusEnum orderStatus;
  const AmericanOrderCardBottomRightWidget({
    super.key,
    required this.order,
    required this.orderType,
    required this.orderStatus,
  });

  @override
  Widget build(BuildContext context) {
    String leftText = '';
    String rightText = '';

    if (orderType == AmericanOrderTypeEnum.market) {
      leftText = L10n.tr('serbest');

      if (order.orderUnit != null) {
        rightText =
            '${MoneyUtils().readableMoney(order.orderUnit!, pattern: MoneyUtils().getPatternByUnitDecimal(order.orderUnit!))} ${L10n.tr('adet')}';
      } else if (order.orderAmount != null) {
        rightText = '\$${MoneyUtils().readableMoney(order.orderAmount!)}';
      }
    } else if (orderType == AmericanOrderTypeEnum.limit) {
      if (order.orderPrice != null) {
        leftText = '${L10n.tr('fiyat')} \$${MoneyUtils().readableMoney(
          order.orderPrice ?? 0,
          pattern: MoneyUtils().countDecimalPlaces(order.orderPrice ?? 0) > 2
              ? MoneyUtils().getPatternByUnitDecimal(order.orderPrice ?? 0)
              : '#,##0.00',
        )}';
      }

      if (orderStatus == OrderStatusEnum.filled) {
        if (order.realizedUnit != null) {
          rightText =
              '${MoneyUtils().readableMoney(order.realizedUnit!, pattern: MoneyUtils().getPatternByUnitDecimal(order.realizedUnit!))} ${L10n.tr('adet')}';
        } else if (order.orderAmount != null) {
          rightText = '\$${MoneyUtils().readableMoney(order.orderAmount!)} ${L10n.tr('tutar')}';
        }
      } else {
        if (order.orderUnit != null) {
          rightText =
              '${MoneyUtils().readableMoney(order.orderUnit!, pattern: MoneyUtils().getPatternByUnitDecimal(order.orderUnit!))} ${L10n.tr('adet')}';
        } else if (order.orderAmount != null) {
          rightText = '\$${MoneyUtils().readableMoney(order.orderAmount!)} ${L10n.tr('tutar')}';
        }
      }
    } else if (orderType == AmericanOrderTypeEnum.stop) {
      leftText = L10n.tr('serbest');

      rightText =
          '${MoneyUtils().readableMoney((order.orderUnit ?? 0), pattern: MoneyUtils().getPatternByUnitDecimal(order.orderUnit ?? 0))} ${L10n.tr('adet')}';
    } else if (orderType == AmericanOrderTypeEnum.stopLimit) {
      leftText =
          '${L10n.tr('fiyat')} \$${order.orderPrice != null ? MoneyUtils().readableMoney(order.orderPrice!) : L10n.tr('serbest')}';

      rightText =
          '${MoneyUtils().readableMoney((order.orderUnit ?? 0), pattern: MoneyUtils().getPatternByUnitDecimal(order.orderUnit ?? 0))} ${L10n.tr('adet')}';
    } else if (orderType == AmericanOrderTypeEnum.trailStop) {
      leftText = L10n.tr('serbest');
      rightText =
          '${MoneyUtils().readableMoney((order.orderUnit ?? 0), pattern: MoneyUtils().getPatternByUnitDecimal(order.orderUnit ?? 0))} ${L10n.tr('adet')}';
    }

    return Row(
      children: [
        Text(
          orderStatus == OrderStatusEnum.filled
              ? '${L10n.tr('fiyat')} ${CurrencyEnum.dollar.symbol}${MoneyUtils().readableMoney(
                  double.parse(order.filledAvgPrice ?? '0'),
                )}'
              : leftText,
          style: context.pAppStyle.labelMed12textPrimary,
        ),
        const BlackDotWidget(),
        Text(
          rightText,
          style: context.pAppStyle.labelMed12textPrimary,
        ),
      ],
    );
  }
}
