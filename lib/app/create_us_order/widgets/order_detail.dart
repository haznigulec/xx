import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/create_order/model/condition.dart';
import 'package:piapiri_v2/app/create_order/model/stoploss_takeprofit.dart';
import 'package:piapiri_v2/app/search_symbol/widgets/order_approvement_buttons.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/list/symbol_about_tile.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/model/order_action_type_enum.dart';
import 'package:piapiri_v2/core/model/order_type_enum.dart';
import 'package:piapiri_v2/core/model/order_validity_enum.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class OrderDetail extends StatelessWidget {
  final String symbolCode;
  final SymbolTypes symbolType;
  final OrderActionTypeEnum action;
  final OrderTypeEnum orderType;
  final double price;
  final int unit;
  final double amount;
  final OrderValidityEnum validity;
  final String accountExtId;
  final DateTime orderDate;
  final Condition? condition;
  final StopLossTakeProfit? stopLossTakeProfit;
  final Function() onPressedApprove;
  const OrderDetail({
    super.key,
    required this.symbolCode,
    required this.symbolType,
    required this.action,
    required this.orderType,
    required this.price,
    required this.unit,
    required this.amount,
    required this.validity,
    required this.accountExtId,
    required this.orderDate,
    this.condition,
    this.stopLossTakeProfit,
    required this.onPressedApprove,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle trailingTextStyle = context.pAppStyle.labelMed16textPrimary;
    return Column(
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
          trailing: L10n.tr(orderType.localizationKey),
          trailingStyle: trailingTextStyle,
        ),
        const PDivider(),
        SymbolAboutTile(
          leading: L10n.tr('fiyat'),
          trailing: orderType == OrderTypeEnum.market || orderType == OrderTypeEnum.marketToLimit
              ? L10n.tr('Serbest')
              : '${MoneyUtils().getCurrency(symbolType)}${MoneyUtils().readableMoney(price)}',
          trailingStyle: trailingTextStyle,
        ),
        const PDivider(),
        SymbolAboutTile(
          leading: L10n.tr('adet'),
          trailing: unit.toString(),
          trailingStyle: trailingTextStyle,
        ),
        const PDivider(),
        SymbolAboutTile(
          leading: L10n.tr('estimated_amount'),
          trailing: '${MoneyUtils().getCurrency(symbolType)}${MoneyUtils().readableMoney(amount)}',
          trailingStyle: trailingTextStyle,
        ),
        const PDivider(),
        SymbolAboutTile(
          leading: L10n.tr('validity_period'),
          trailing: L10n.tr(validity.localizationKey),
          trailingStyle: trailingTextStyle,
        ),
        const PDivider(),
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
        SymbolAboutTile(
          leading: L10n.tr('hesap'),
          trailing: accountExtId,
          trailingStyle: trailingTextStyle,
        ),
        const PDivider(),
        SymbolAboutTile(
          leading: L10n.tr('order_date'),
          trailing: DateTimeUtils.dateAndTimeFromDate(orderDate, splitter: ','),
          trailingStyle: trailingTextStyle,
        ),
        const SizedBox(
          height: Grid.m,
        ),
        OrderApprovementButtons(
          onPressedApprove: () => onPressedApprove(),
        ),
      ],
    );
  }
}
