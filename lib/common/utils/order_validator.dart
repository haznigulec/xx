import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/create_order/model/stoploss_takeprofit.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/utils/utils.dart';
import 'package:piapiri_v2/core/model/order_action_type_enum.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class OrderValidator {
  static double priceValidator(
    BuildContext context, {
    required String symbolName,
    required double price,
    required double limitUp,
    required double limitDown,
    required SymbolTypes type,    
    bool showPopup = true,
  }) {
    if (type == SymbolTypes.warrant || type == SymbolTypes.certificate) {
      return _warrantPrice(context, price, symbolName, showPopup: showPopup);
    }
    
    if (price == 0) {
      return limitDown;
    }
    if (price > limitUp) {
      if (showPopup) {
        PBottomSheet.showError(
        context,
        content: '${L10n.tr('margin_error', args: [
              symbolName
            ])}\n(${MoneyUtils().getCurrency(type)}${MoneyUtils().readableMoney(limitDown)}) - (${MoneyUtils().getCurrency(type)}${MoneyUtils().readableMoney(limitUp)})',
      );
      }
      return limitUp;
    }
    if (price < limitDown) {
      if (showPopup) {
        PBottomSheet.showError(
        context,
        content:
            '${L10n.tr('margin_error', args: [
                symbolName
              ])}\n(${MoneyUtils().getCurrency(type)}${MoneyUtils().readableMoney(limitDown)}) - (${MoneyUtils().getCurrency(type)}${MoneyUtils().readableMoney(limitUp)})',
        );
      }
      return limitDown;
    }
    return price;
  }

  static double _warrantPrice(
    BuildContext context,
    double price,
    String symbolCode, {
    bool showPopup = true,
  }) {
    if (price <= 0) {
      if (showPopup) {
        PBottomSheet.showError(
          context,
          content: L10n.tr(
            'min_price_warning_chain',
            args: [
              symbolCode,
              MoneyUtils().readableMoney(.01),
            ],
          ),
        );
      }
      return 0.01;
    }
    double priceStep = Utils().getPriceStep(price, SymbolTypes.warrant.name, '', '', 0.01);
    double result = double.parse((price % priceStep).toStringAsFixed(3));
    if (result != 0 && result != priceStep) {
      if (showPopup) {
        PBottomSheet.showError(
          context,
          content: L10n.tr(
            'price_step_warning',
            args: [priceStep.toString()],
          ),
        );
      }

      return (price / priceStep).round() * priceStep;
    }
    return price;
  }

  static StopLossTakeProfit priceToStopLossValidator(
    BuildContext context, {
    required double price,
    required double limitUp,
    required double limitDown,
    required OrderActionTypeEnum action,
    required StopLossTakeProfit stopLossTakeProfit,
    required double priceStep,
  }) {
    if (action == OrderActionTypeEnum.buy) {
      if (price <= stopLossTakeProfit.stopLossPrice!) {
        PBottomSheet.showError(
          context,
          content: L10n.tr('stop_loss_error'),
        );
        stopLossTakeProfit.stopLossPrice = price - priceStep < limitDown ? limitDown : price - priceStep;
        return stopLossTakeProfit;
      }
      if (price >= stopLossTakeProfit.takeProfitPrice!) {
        PBottomSheet.showError(
          context,
          content: L10n.tr('take_profit_error'),
        );
        stopLossTakeProfit.takeProfitPrice = price + priceStep > limitUp ? limitUp : price + priceStep;
        return stopLossTakeProfit;
      }
    } else {
      if (price >= stopLossTakeProfit.stopLossPrice!) {
        PBottomSheet.showError(
          context,
          content: L10n.tr('stop_loss_error'),
        );
        stopLossTakeProfit.stopLossPrice = price + priceStep > limitUp ? limitUp : price + priceStep;
        return stopLossTakeProfit;
      }
      if (price <= stopLossTakeProfit.takeProfitPrice!) {
        PBottomSheet.showError(
          context,
          content: L10n.tr('take_profit_error'),
        );
        stopLossTakeProfit.takeProfitPrice = price - priceStep < limitDown ? limitDown : price - priceStep;
        return stopLossTakeProfit;
      }
    }
    return stopLossTakeProfit;
  }
}
