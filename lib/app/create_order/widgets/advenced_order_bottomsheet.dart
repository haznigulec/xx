import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/create_order/bloc/create_orders_bloc.dart';
import 'package:piapiri_v2/app/create_order/bloc/create_orders_event.dart';
import 'package:piapiri_v2/app/create_order/model/condition.dart';
import 'package:piapiri_v2/app/create_order/model/stoploss_takeprofit.dart';
import 'package:piapiri_v2/app/create_order/widgets/add_chain_widget.dart';
import 'package:piapiri_v2/app/create_order/widgets/advenced_order_tile.dart';
import 'package:piapiri_v2/app/create_order/widgets/condition_order.dart';
import 'package:piapiri_v2/app/create_order/widgets/stoploss_takeprofit_order.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/core/bloc/time/time_bloc.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/condition_enum.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/order_action_type_enum.dart';
import 'package:piapiri_v2/core/model/order_type_enum.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class AdvencedOrderBottomsheet extends StatelessWidget {
  final MarketListModel symbol;
  final String accountId;
  final Condition? conditionalOrder;
  final StopLossTakeProfit? stopLossTakeProfit;
  final double currentPrice;
  final OrderActionTypeEnum action;
  final Function(Condition? condition) onConditionChanged;
  final Function(StopLossTakeProfit? stopLossTakeProfit) onSLTPChanged;
  final double transactionLimit;
  final OrderTypeEnum orderType;

  const AdvencedOrderBottomsheet({
    super.key,
    required this.symbol,
    required this.conditionalOrder,
    required this.stopLossTakeProfit,
    required this.currentPrice,
    required this.action,
    required this.onConditionChanged,
    required this.onSLTPChanged,
    required this.accountId,
    required this.transactionLimit,
    required this.orderType,
  });

  @override
  Widget build(BuildContext context) {
    bool hasChain = getIt<CreateOrdersBloc>().state.chainOrderList.isNotEmpty;

    return Column(
      children: [
        AdvencedOrderTile(
          title: L10n.tr('add_condition'),
          subTitle: L10n.tr('add_condition_description'),
          isSelected: conditionalOrder != null,
          onTap: (_) async {
            bool isConfirmed = false;
            if (stopLossTakeProfit != null) {
              _showResetAlert(
                context: context,
                choosenTitle: L10n.tr('add_condition'),
                oldChoosenTitle: L10n.tr('tp_sl'),
                onFilledButtonPressed: () async {
                  isConfirmed = true;
                  onSLTPChanged(null);

                  await PBottomSheet.show(
                    context,
                    title: conditionalOrder == null ? L10n.tr('add_condition') : L10n.tr('edit_condition'),
                    child: _showConditionOrder(),
                  );

                  await router.maybePop();
                  await router.maybePop();
                },
              );
            } else if (hasChain) {
              /// Zincir Emir seçiliyse uyarı çıkarıyoruz

              _showResetAlert(
                context: context,
                choosenTitle: L10n.tr('add_condition'),
                oldChoosenTitle: L10n.tr('zincir_ekle'),
                onFilledButtonPressed: () async {
                  isConfirmed = true;
                  getIt<CreateOrdersBloc>().add(
                    ClearChainOrderListEvent(),
                  );

                  await PBottomSheet.show(
                    context,
                    title: L10n.tr('add_condition'),
                    child: _showConditionOrder(),
                  );

                  await router.maybePop();
                  await router.maybePop();
                },
              );
            } else {
              await PBottomSheet.show(
                context,
                title: conditionalOrder == null ? L10n.tr('add_condition') : L10n.tr('edit_condition'),
                child: _showConditionOrder(),
              );
              router.maybePop();
            }
            if (isConfirmed) {
              router.maybePop();
            }
          },
        ),
        if (action != OrderActionTypeEnum.shortSell) ...[
          const PDivider(),
          AdvencedOrderTile(
            title: L10n.tr('tp_sl'),
            subTitle:
                '${L10n.tr('tp_sl_description')} ${orderType != OrderTypeEnum.limit ? L10n.tr('sltp_orderType_error') : ''}',
            isSelected: stopLossTakeProfit != null,
            isEnabled: orderType == OrderTypeEnum.limit,
            onTap: (_) async {
              bool isConfirmed = false;
              if (conditionalOrder != null) {
                /// Şart Ekle seçiliyse uyarı çıkarıyoruz
                _showResetAlert(
                  context: context,
                  choosenTitle: L10n.tr('tp_sl'),
                  oldChoosenTitle: L10n.tr('add_condition'),
                  onFilledButtonPressed: () async {
                    isConfirmed = true;
                    onConditionChanged(null);

                    await PBottomSheet.show(
                      context,
                      title: L10n.tr('tp_sl'),
                      child: _showStopLossTakeProfit(),
                    );

                    await router.maybePop();
                    await router.maybePop();
                  },
                );
              } else if (hasChain) {
                /// Zincir Emir seçiliyse uyarı çıkarıyoruz

                _showResetAlert(
                  context: context,
                  choosenTitle: L10n.tr('tp_sl'),
                  oldChoosenTitle: L10n.tr('zincir_ekle'),
                  onFilledButtonPressed: () async {
                    isConfirmed = true;
                    getIt<CreateOrdersBloc>().add(
                      ClearChainOrderListEvent(),
                    );

                    await PBottomSheet.show(
                      context,
                      title: L10n.tr('tp_sl'),
                      child: _showStopLossTakeProfit(),
                    );

                    await router.maybePop();
                    await router.maybePop();
                  },
                );
              } else {
                await PBottomSheet.show(
                  context,
                  title: L10n.tr('tp_sl'),
                  child: _showStopLossTakeProfit(),
                );
                router.maybePop();
              }
              if (isConfirmed) {
                router.maybePop();
              }
            },
          ),
        ],
        if (symbol.type == SymbolTypes.equity.dbKey || symbol.type == SymbolTypes.warrant.dbKey) ...[
          const PDivider(),
          AdvencedOrderTile(
            title: L10n.tr('zincir_ekle'),
            subTitle: L10n.tr('add_chain_desc'),
            isSelected: hasChain,
            onTap: (_) async {
              bool isConfirmed = false;

              if (stopLossTakeProfit != null) {
                /// Kar Al Zarar Durdur seçiliyse uyarı çıkarıyoruz.
                _showResetAlert(
                  context: context,
                  choosenTitle: L10n.tr('zincir_ekle'),
                  oldChoosenTitle: L10n.tr('tp_sl'),
                  onFilledButtonPressed: () async {
                    isConfirmed = true;
                    onSLTPChanged(null);

                    await PBottomSheet.show(
                      context,
                      title: L10n.tr('zincir_ekle'),
                      child: AddChainWidget(
                        transactionLimit: transactionLimit,
                        accountId: accountId,
                        type: stringToSymbolType(symbol.type),
                      ),
                    );

                    await router.maybePop();
                    await router.maybePop();
                  },
                );
              } else if (conditionalOrder != null) {
                /// Şart Ekle seçiliyse uyarı çıkarıyoruz.
                _showResetAlert(
                  context: context,
                  choosenTitle: L10n.tr('zincir_ekle'),
                  oldChoosenTitle: L10n.tr('add_condition'),
                  onFilledButtonPressed: () async {
                    isConfirmed = true;
                    onConditionChanged(null);

                    await PBottomSheet.show(
                      context,
                      title: L10n.tr('zincir_ekle'),
                      child: AddChainWidget(
                        transactionLimit: transactionLimit,
                        accountId: accountId,
                        type: stringToSymbolType(symbol.type),
                      ),
                    );

                    await router.maybePop();
                    await router.maybePop();
                  },
                );
              } else {
                await PBottomSheet.show(
                  context,
                  title: L10n.tr('zincir_ekle'),
                  child: AddChainWidget(
                    transactionLimit: transactionLimit,
                    accountId: accountId,
                    type: stringToSymbolType(symbol.type),
                  ),
                );

                router.maybePop();
              }

              if (isConfirmed) {
                router.maybePop();
              }
            },
          ),
        ],
      ],
    );
  }

  Widget _showStopLossTakeProfit() {
    return StoplossTakeprofitOrder(
      isForUpdate: !(stopLossTakeProfit == null),
      currentPrice: currentPrice,
      symbol: symbol,
      stopLossTakeProfit: stopLossTakeProfit ??
          StopLossTakeProfit(
            stopLossPrice: null,
            takeProfitPrice: null,
            validityDate: DateTimeUtils().checkStopLossDate(
              getIt<TimeBloc>().state.mxTime?.timestamp != null
                  ? DateTime.fromMicrosecondsSinceEpoch(
                      getIt<TimeBloc>().state.mxTime!.timestamp.toInt(),
                    )
                  : DateTime.now(),
            ),
          ),
      action: action,
      onSLTPChanged: (StopLossTakeProfit? stopLossTakeProfit) => onSLTPChanged(stopLossTakeProfit),
    );
  }

  Widget _showConditionOrder() {
    return ConditionOrder(
      accountId: accountId,
      isForUpdate: !(conditionalOrder == null),
      condition: conditionalOrder ??
          Condition(
            symbol: symbol,
            price: currentPrice,
            condition: ConditionEnum.greatherThen,
          ),
      onConditionChanged: (newCondition) => onConditionChanged(newCondition),
    );
  }

  void _showResetAlert({
    required BuildContext context,
    required String choosenTitle,
    required String oldChoosenTitle,
    required Function() onFilledButtonPressed,
  }) async {
    await PBottomSheet.showError(
      context,
      content: L10n.tr(
        'reset_condition_alert',
        args: [
          choosenTitle,
          oldChoosenTitle,
        ],
      ),
      showFilledButton: true,
      filledButtonText: L10n.tr('reset'),
      onFilledButtonPressed: onFilledButtonPressed,
      showOutlinedButton: true,
      outlinedButtonText: L10n.tr('vazgec'),
      onOutlinedButtonPressed: () {
        router.maybePop();
      },
    );
  }
}
