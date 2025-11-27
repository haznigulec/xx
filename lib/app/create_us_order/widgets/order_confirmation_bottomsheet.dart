import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/create_order/widgets/order_detail.dart';
import 'package:piapiri_v2/app/orders/model/american_order_type_enum.dart';
import 'package:piapiri_v2/app/search_symbol/widgets/order_approvement_buttons.dart';
import 'package:piapiri_v2/app/us_symbol_detail/widgets/extended_trading_hours_info_widget.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/order_action_type_enum.dart';
import 'package:piapiri_v2/core/model/order_validity_enum.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/model/us_market_status_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class OrderConfirmationBottomsheet extends StatelessWidget {
  final String symbolName;
  final String unit;
  final String price;
  final String amount;
  final String stopPrice;
  final OrderActionTypeEnum action;
  final AmericanOrderTypeEnum orderType;
  final UsMarketStatus? usMarketStatus;
  final bool showQuantity;
  final Function() onPressedApprove;
  final double commission;

  const OrderConfirmationBottomsheet({
    super.key,
    required this.symbolName,
    required this.unit,
    required this.price,
    required this.amount,
    required this.stopPrice,
    required this.action,
    required this.orderType,
    this.usMarketStatus,
    required this.showQuantity,
    required this.onPressedApprove,
    required this.commission,
  });

  @override
  Widget build(BuildContext context) {
    bool isMarketOrStopOrder = orderType == AmericanOrderTypeEnum.market || orderType == AmericanOrderTypeEnum.stop;
    bool isStopOrder = orderType == AmericanOrderTypeEnum.stop || orderType == AmericanOrderTypeEnum.stopLimit;
    return Column(
      children: [
        const SizedBox(
          height: Grid.m,
        ),
        RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: isMarketOrStopOrder
                      ? L10n.tr(
                          'order_send_span_market',
                          args: [unit, symbolName],
                        )
                      : L10n.tr(
                          'order_send_span_3',
                          args: [
                            '${MoneyUtils().getCurrency(SymbolTypes.foreign)}$price',
                            unit,
                            symbolName,
                          ],
                        ),
                  style: context.pAppStyle.labelReg16textPrimary,
                ),
                TextSpan(
                  text: ' ${L10n.tr(action.localizationKey2).toUpperCase()} ',
                  style: context.pAppStyle.interMediumBase.copyWith(
                    color: action.color,
                    fontSize: Grid.m,
                  ),
                ),
                TextSpan(
                  text: L10n.tr('order_send_span_2'),
                  style: context.pAppStyle.labelReg16textPrimary,
                ),
              ],
            )),
        const SizedBox(
          height: Grid.s,
        ),
        TextButton(
          child: Text(
            L10n.tr('show_order_detail'),
            style: context.pAppStyle.labelReg16primary,
          ),
          onPressed: () {
            PBottomSheet.show(
              context,
              titlePadding: const EdgeInsets.only(
                top: Grid.m,
              ),
              title: L10n.tr('emir_detay'),
              child: OrderDetail(
                symbolCode: symbolName,
                symbolType: SymbolTypes.foreign,
                action: action,
                orderType: orderType.localizationKey,
                price: isMarketOrStopOrder ? null : MoneyUtils().fromReadableMoney(price),
                stopPrice: isStopOrder ? MoneyUtils().fromReadableMoney(stopPrice) : null,
                unit: showQuantity ? MoneyUtils().fromReadableMoney(unit) : null,
                transactionFee:
                    '${CurrencyEnum.dollar.symbol}${MoneyUtils().readableMoney(commission, pattern: '#,##0.00#')}',
                amountText: showQuantity ? L10n.tr('estimated_amount') : L10n.tr('tutar'),
                amount: MoneyUtils().fromReadableMoney(amount),
                validityLocalizationKey: OrderValidityEnum.daily.localizationKey,
                //stopLossTakeProfit: _stopLossTakeProfit,
                showExcludingTransactionFee: true,
                orderDate: DateTime.now(),
                onPressedApprove: () async {
                  await router.maybePop();
                  onPressedApprove();
                },
              ),
            );
          },
        ),
        if (usMarketStatus != UsMarketStatus.open) ...[
          Text(
            _getClosedMarketDesc(),
            style: context.pAppStyle.labelReg14textPrimary,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: Grid.s,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                ImagesPath.info,
                height: 15,
                width: 15,
                colorFilter: ColorFilter.mode(
                  context.pColorScheme.primary,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(
                width: Grid.xs,
              ),
              TextButton(
                style: ButtonStyle(
                  padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                    const EdgeInsets.all(0),
                  ),
                ),
                child: Text(
                  L10n.tr('view_transaction_hours'),
                  style: context.pAppStyle.labelReg14primary,
                ),
                onPressed: () {
                  PBottomSheet.show(
                    context,
                    title: L10n.tr('transaction_hours'),
                    child: const ExtendedTradingHoursInfoWidget(),
                  );
                },
              ),
            ],
          ),
        ],
        const SizedBox(
          height: Grid.m,
        ),
        OrderApprovementButtons(
          onPressedApprove: () async {
            await router.maybePop();
            onPressedApprove();
          },
        ),
        const SizedBox(
          height: Grid.m,
        ),
      ],
    );
  }

  String _getClosedMarketDesc() {
    if (orderType != AmericanOrderTypeEnum.limit) {
      if (usMarketStatus == UsMarketStatus.closed) {
        return L10n.tr('closed_market_desc');
      }
      return L10n.tr('closed_market_desc2');
    } else {
      if (usMarketStatus == UsMarketStatus.closed) {
        return L10n.tr('closed_market_desc');
      }
      return L10n.tr('closed_market_desc3');
    }
  }
}
