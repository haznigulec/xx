import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/create_order/bloc/create_orders_bloc.dart';
import 'package:piapiri_v2/app/create_order/bloc/create_orders_state.dart';
import 'package:piapiri_v2/app/create_order/model/condition.dart';
import 'package:piapiri_v2/app/create_order/model/stoploss_takeprofit.dart';
import 'package:piapiri_v2/app/create_order/widgets/advenced_order_bottomsheet.dart';
import 'package:piapiri_v2/app/create_order/widgets/chain_card.dart';
import 'package:piapiri_v2/app/create_order/widgets/condition_order.dart';
import 'package:piapiri_v2/app/create_order/widgets/stoploss_takeprofit_order.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/list/symbol_about_tile.dart';
import 'package:piapiri_v2/common/widgets/buttons/text_button_selector.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/account_model.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/order_action_type_enum.dart';
import 'package:piapiri_v2/core/model/order_type_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class AdvencedOrders extends StatefulWidget {
  final MarketListModel symbol;
  final AccountModel selectedAccount;
  final Condition? conditionalOrder;
  final StopLossTakeProfit? stopLossTakeProfit;
  final double price;
  final OrderActionTypeEnum action;
  final double tradeLimit;
  final Function(Condition?) onConditionChanged;
  final Function(StopLossTakeProfit?) onSLTPChanged;
  final OrderTypeEnum orderType;
  const AdvencedOrders({
    super.key,
    required this.symbol,
    required this.selectedAccount,
    this.conditionalOrder,
    this.stopLossTakeProfit,
    required this.price,
    required this.action,
    required this.tradeLimit,
    required this.onConditionChanged,
    required this.onSLTPChanged,
    required this.orderType,
  });

  @override
  State<AdvencedOrders> createState() => _AdvencedOrdersState();
}

class _AdvencedOrdersState extends State<AdvencedOrders> {
  final CreateOrdersBloc _createOrdersBloc = getIt<CreateOrdersBloc>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Zincir Emir, sartli emir ve stoploss emir girilmek istenidginde acilan bottomsheet
        TextButtonSelector(
          selectedItem: L10n.tr('advanced_order_features'),
          selectedColor: context.pColorScheme.textPrimary,
          onSelect: () {
            PBottomSheet.show(
              context,
              title: L10n.tr('advanced_order_features'),
              subtitle: L10n.tr('advanced_order_features_desc'),
              titlePadding: const EdgeInsets.only(
                top: Grid.m,
              ),
              child: AdvencedOrderBottomsheet(
                accountId: widget.selectedAccount.accountId.split('-').last,
                symbol: widget.symbol.copyWith(description: widget.symbol.description),
                conditionalOrder: widget.conditionalOrder,
                stopLossTakeProfit: widget.stopLossTakeProfit,
                action: widget.action,
                currentPrice: widget.price,
                transactionLimit: widget.tradeLimit,
                onConditionChanged: widget.onConditionChanged,
                onSLTPChanged: widget.onSLTPChanged,
                orderType: widget.orderType,
              ),
            );
          },
        ),
        if (widget.conditionalOrder != null)
          InkWell(
            child: Column(
              children: [
                const SizedBox(
                  height: Grid.s,
                ),
                SymbolAboutTile(
                  leading: L10n.tr('sart_sembol'),
                  trailing: widget.conditionalOrder!.symbol.symbolCode,
                  leadingStyle: context.pAppStyle.labelReg14textSecondary,
                  trailingStyle: context.pAppStyle.labelMed14textPrimary,
                ),
                const PDivider(),
                SymbolAboutTile(
                  leading: L10n.tr('sart_tipi_fiyat'),
                  trailing: L10n.tr(widget.conditionalOrder!.condition.localizationKey),
                  leadingStyle: context.pAppStyle.labelReg14textSecondary,
                  trailingStyle: context.pAppStyle.labelMed14textPrimary,
                ),
                const PDivider(),
                SymbolAboutTile(
                  leading: L10n.tr('Condition_Price'),
                  trailing:
                      '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(widget.conditionalOrder!.price)}',
                  leadingStyle: context.pAppStyle.labelReg14textSecondary,
                  trailingStyle: context.pAppStyle.labelMed14textPrimary,
                ),
              ],
            ),
            onTap: () async {
              await PBottomSheet.show(
                context,
                title: L10n.tr('edit_condition'),
                child: ConditionOrder(
                  accountId: widget.selectedAccount.accountId.split('-').last,
                  isForUpdate: true,
                  condition: widget.conditionalOrder!,
                  onConditionChanged: widget.onConditionChanged,
                ),
              );
            },
          ),
        if (widget.stopLossTakeProfit != null)
          InkWell(
            child: Column(
              children: [
                const SizedBox(
                  height: Grid.s,
                ),
                if (widget.stopLossTakeProfit!.takeProfitPrice != null) ...[
                  SymbolAboutTile(
                    leading: L10n.tr('kar_al'),
                    trailing:
                        '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(widget.stopLossTakeProfit!.takeProfitPrice!)}',
                    leadingStyle: context.pAppStyle.labelReg14textSecondary,
                    trailingStyle: context.pAppStyle.labelMed14textPrimary,
                  ),
                  const PDivider(),
                ],
                if (widget.stopLossTakeProfit!.stopLossPrice != null) ...[
                  SymbolAboutTile(
                    leading: L10n.tr('zarar_durdur'),
                    trailing:
                        '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(widget.stopLossTakeProfit!.stopLossPrice!)}',
                    leadingStyle: context.pAppStyle.labelReg14textSecondary,
                    trailingStyle: context.pAppStyle.labelMed14textPrimary,
                  ),
                  const PDivider(),
                ],
                SymbolAboutTile(
                  leading: L10n.tr('gecerlilik_tarihi'),
                  trailing: DateTimeUtils.dateFormat(widget.stopLossTakeProfit!.validityDate),
                  leadingStyle: context.pAppStyle.labelReg14textSecondary,
                  trailingStyle: context.pAppStyle.labelMed14textPrimary,
                ),
              ],
            ),
            onTap: () async {
              await PBottomSheet.show(
                context,
                title: L10n.tr('tp_sl'),
                titlePadding: const EdgeInsets.only(
                  top: Grid.m,
                ),
                child: StoplossTakeprofitOrder(
                  isForUpdate: true,
                  stopLossTakeProfit: widget.stopLossTakeProfit!,
                  currentPrice: widget.price,
                  symbol: widget.symbol,
                  action: widget.action,
                  onSLTPChanged: widget.onSLTPChanged,
                ),
              );
            },
          ),
        PBlocBuilder<CreateOrdersBloc, CreateOrdersState>(
          bloc: _createOrdersBloc,
          builder: (context, state) {
            if (state.chainOrderList.isEmpty) {
              return const SizedBox.shrink();
            }
            return ListView.separated(
                itemCount: state.chainOrderList.length,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(
                  top: Grid.m,
                ),
                separatorBuilder: (context, index) => const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: Grid.s + Grid.xs,
                      ),
                      child: Divider(),
                    ),
                itemBuilder: (context, index) {
                  return ChainCard(
                    chainOrder: state.chainOrderList[index],
                    index: index,
                    transactionLimit: widget.tradeLimit,
                    accountId: widget.selectedAccount.accountId.split('-').last,
                  );
                });
          },
        ),
      ],
    );
  }
}
