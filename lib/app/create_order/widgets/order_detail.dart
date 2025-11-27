import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/create_order/model/condition.dart';
import 'package:piapiri_v2/app/create_order/model/stoploss_takeprofit.dart';
import 'package:piapiri_v2/app/search_symbol/widgets/order_approvement_buttons.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/list/symbol_about_tile.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/model/order_action_type_enum.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class OrderDetail extends StatelessWidget {
  final String symbolCode;
  final SymbolTypes symbolType;
  final OrderActionTypeEnum action;
  final String orderType;
  final double? price;
  final double? stopPrice;
  final num? unit;
  final int? shownQty;
  final String? amountText;
  final double? amount;
  final String? transactionFee;
  final String validityLocalizationKey;
  final DateTime? validityDate;
  final String? accountExtId;
  final DateTime orderDate;
  final Condition? condition;
  final StopLossTakeProfit? stopLossTakeProfit;
  final bool showExcludingTransactionFee;
  final Function() onPressedApprove;
  const OrderDetail({
    super.key,
    required this.symbolCode,
    required this.symbolType,
    required this.action,
    required this.orderType,
    this.price,
    this.stopPrice,
    this.unit,
    this.shownQty,
    this.amountText,
    this.amount,
    this.transactionFee,
    required this.validityLocalizationKey,
    this.validityDate,
    this.accountExtId,
    required this.orderDate,
    this.condition,
    this.stopLossTakeProfit,
    this.showExcludingTransactionFee = false,
    required this.onPressedApprove,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle trailingTextStyle = context.pAppStyle.labelMed16textPrimary;
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.75,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SymbolAboutTile(
                  leading: L10n.tr('sembol'),
                  trailing: symbolCode,
                  trailingStyle: trailingTextStyle,
                ),
                const PDivider(),
                SymbolAboutTile(
                  leading: L10n.tr('islem_turu'),
                  trailing: L10n.tr(action.localizationKey1).toUpperCase(),
                  trailingStyle: context.pAppStyle.interMediumBase.copyWith(
                    fontSize: Grid.m,
                    color: action.color,
                  ),
                ),
                const PDivider(),
                SymbolAboutTile(
                  leading: L10n.tr('emir_tipi'),
                  trailing: L10n.tr(orderType),
                  trailingStyle: trailingTextStyle,
                ),
                const PDivider(),
                SymbolAboutTile(
                  leading: L10n.tr('fiyat'),
                  trailing: price == null
                      ? L10n.tr('Serbest')
                      : '${MoneyUtils().getCurrency(symbolType)}${MoneyUtils().readableMoney(price!, pattern: price! >= 1 ? '#,##0.00' : '#,##0.0000#####')}',
                  trailingStyle: trailingTextStyle,
                ),
                const PDivider(),
                if (stopPrice != null) ...[
                  SymbolAboutTile(
                    leading: L10n.tr('stop_price'),
                    trailing: '${MoneyUtils().getCurrency(symbolType)}${MoneyUtils().readableMoney(stopPrice!)}',
                    trailingStyle: trailingTextStyle,
                  ),
                  const PDivider(),
                ],
                if (unit != null) ...[
                  SymbolAboutTile(
                    leading: L10n.tr('adet'),
                    trailing: MoneyUtils().readableMoney(unit!, pattern: MoneyUtils().getPatternByUnitDecimal(unit!)),
                    trailingStyle: trailingTextStyle,
                  ),
                  const PDivider(),
                ],
                if (shownQty != null) ...[
                  SymbolAboutTile(
                    leading: L10n.tr('gorunenadet'),
                    trailing:
                        MoneyUtils().readableMoney(shownQty!, pattern: MoneyUtils().getPatternByUnitDecimal(unit!)),
                    trailingStyle: trailingTextStyle,
                  ),
                  const PDivider(),
                ],
                if (amount != null) ...[
                  SymbolAboutTile(
                    leading: amountText ?? L10n.tr('estimated_amount'),
                    afterLeading: showExcludingTransactionFee
                        ? Text(
                            '(${L10n.tr('excluding_transaction_fee')})',
                            style: context.pAppStyle.labelReg12textTeritary,
                          )
                        : null,
                    trailing: '${MoneyUtils().getCurrency(symbolType)}${MoneyUtils().readableMoney(amount!)}',
                    trailingStyle: trailingTextStyle,
                  ),
                  const PDivider(),
                ],
                if (transactionFee != null) ...[
                  SymbolAboutTile(
                    leading: L10n.tr('transaction_fee'),
                    trailing: transactionFee!,
                    trailingStyle: trailingTextStyle,
                  ),
                  const PDivider(),
                ],
                SymbolAboutTile(
                  leading: L10n.tr('validity_period'),
                  trailing: L10n.tr(validityLocalizationKey),
                  trailingStyle: trailingTextStyle,
                ),
                const PDivider(),
                if (validityDate != null) ...[
                  SymbolAboutTile(
                    leading: L10n.tr('validity_date'),
                    trailing: DateTimeUtils.dateFormat(validityDate!),
                    trailingStyle: trailingTextStyle,
                  ),
                  const PDivider(),
                ],
                if (stopLossTakeProfit != null) ...[
                  SymbolAboutTile(
                    leading: L10n.tr('kar_al'),
                    trailing:
                        '${MoneyUtils().getCurrency(symbolType)}${MoneyUtils().readableMoney(stopLossTakeProfit!.takeProfitPrice!)}',
                    trailingStyle: trailingTextStyle,
                  ),
                  const PDivider(),
                  SymbolAboutTile(
                    leading: L10n.tr('zarar_durdur'),
                    trailing:
                        '${MoneyUtils().getCurrency(symbolType)}${MoneyUtils().readableMoney(stopLossTakeProfit!.stopLossPrice!)}',
                    trailingStyle: trailingTextStyle,
                  ),
                  const PDivider(),
                  SymbolAboutTile(
                    leading: L10n.tr('validity_date'),
                    trailing: DateTimeUtils.dateFormat(stopLossTakeProfit!.validityDate),
                    trailingStyle: trailingTextStyle,
                  ),
                  const PDivider(),
                ],
                if (condition != null) ...[
                  SymbolAboutTile(
                    leading: L10n.tr('sart_sembol'),
                    trailing: condition!.symbol.symbolCode,
                    trailingStyle: trailingTextStyle,
                  ),
                  const PDivider(),
                  SymbolAboutTile(
                    leading: L10n.tr('sart_tipi_fiyat'),
                    trailing: L10n.tr(condition!.condition.localizationKey),
                    trailingStyle: trailingTextStyle,
                  ),
                  const PDivider(),
                  SymbolAboutTile(
                    leading: L10n.tr('Condition_Price'),
                    trailing:
                        '${MoneyUtils().getCurrency(stringToSymbolType(condition!.symbol.type))}${MoneyUtils().readableMoney(condition!.price)}',
                    trailingStyle: trailingTextStyle,
                  ),
                  const PDivider(),
                ],
                if (accountExtId != null) ...[
                  SymbolAboutTile(
                    leading: L10n.tr('hesap'),
                    trailing: accountExtId!,
                    trailingStyle: trailingTextStyle,
                  ),
                  const PDivider(),
                ],
                SymbolAboutTile(
                  leading: L10n.tr('order_date'),
                  trailing: DateTimeUtils.dateAndTimeFromDate(orderDate, splitter: ','),
                  trailingStyle: trailingTextStyle,
                ),
                const SizedBox(
                  height: Grid.xxl + Grid.m,
                ),
              ],
            ),
          ),
        ),
        Container(
          color: context.pColorScheme.backgroundColor,
          padding: const EdgeInsets.only(top: Grid.s),
          child: OrderApprovementButtons(
            onPressedApprove: () async {
              await router.maybePop();
              onPressedApprove();
            },
          ),
        ),
      ],
    );
  }
}
