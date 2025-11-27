import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/create_order/model/stoploss_takeprofit.dart';
import 'package:piapiri_v2/app/search_symbol/widgets/order_approvement_buttons.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/date_select_row.dart';
import 'package:piapiri_v2/common/widgets/textfields/order_text_fields/p_sltp_textfield.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/order_action_type_enum.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class StoplossTakeprofitOrder extends StatefulWidget {
  final bool isForUpdate;
  final StopLossTakeProfit stopLossTakeProfit;
  final double currentPrice;
  final MarketListModel symbol;
  final OrderActionTypeEnum action;
  final Function(StopLossTakeProfit? stopLossTakeProfit) onSLTPChanged;
  const StoplossTakeprofitOrder({
    super.key,
    this.isForUpdate = false,
    required this.currentPrice,
    required this.stopLossTakeProfit,
    required this.symbol,
    required this.action,
    required this.onSLTPChanged,
  });

  @override
  State<StoplossTakeprofitOrder> createState() => _StoplossTakeprofitOrderState();
}

class _StoplossTakeprofitOrderState extends State<StoplossTakeprofitOrder> {
  final TextEditingController _takeProfitController = TextEditingController();
  final TextEditingController _stopLossController = TextEditingController();
  late StopLossTakeProfit _stopLossTakeProfit;

  late DateTime _startDate;
  late SymbolTypes _symbolType;
  @override
  initState() {
    _stopLossTakeProfit = widget.stopLossTakeProfit;
    _symbolType = stringToSymbolType(widget.symbol.type);
    if (widget.action == OrderActionTypeEnum.buy) {
      _stopLossTakeProfit.takeProfitPrice = widget.isForUpdate
          ? widget.stopLossTakeProfit.takeProfitPrice
          : widget.currentPrice + widget.symbol.priceStep;
      _stopLossTakeProfit.stopLossPrice =
          widget.isForUpdate ? widget.stopLossTakeProfit.stopLossPrice : widget.currentPrice - widget.symbol.priceStep;
      if ((_stopLossTakeProfit.takeProfitPrice ?? 0) > widget.symbol.limitUp && _symbolType != SymbolTypes.warrant) {
        _stopLossTakeProfit.takeProfitPrice = widget.symbol.limitUp;
      }
      if ((_stopLossTakeProfit.stopLossPrice ?? 0) < widget.symbol.limitDown) {
        _stopLossTakeProfit.takeProfitPrice = widget.symbol.limitDown;
      }
      _takeProfitController.text = MoneyUtils().readableMoney(_stopLossTakeProfit.takeProfitPrice!);
      _stopLossController.text = MoneyUtils().readableMoney(_stopLossTakeProfit.stopLossPrice!);
    } else {
      _stopLossTakeProfit.takeProfitPrice = widget.isForUpdate
          ? widget.stopLossTakeProfit.takeProfitPrice
          : widget.currentPrice - widget.symbol.priceStep;
      _stopLossTakeProfit.stopLossPrice =
          widget.isForUpdate ? widget.stopLossTakeProfit.stopLossPrice : widget.currentPrice + widget.symbol.priceStep;
      if ((_stopLossTakeProfit.takeProfitPrice ?? 0) < widget.symbol.limitDown && _symbolType != SymbolTypes.warrant) {
        _stopLossTakeProfit.takeProfitPrice = widget.symbol.limitDown;
      }
      if ((_stopLossTakeProfit.stopLossPrice ?? 0) > widget.symbol.limitUp) {
        _stopLossTakeProfit.takeProfitPrice = widget.symbol.limitUp;
      }

      _takeProfitController.text = MoneyUtils().readableMoney(_stopLossTakeProfit.takeProfitPrice!);
      _stopLossController.text = MoneyUtils().readableMoney(_stopLossTakeProfit.stopLossPrice!);
    }
    _startDate = widget.isForUpdate ? widget.stopLossTakeProfit.validityDate : _stopLossTakeProfit.validityDate;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: Grid.m,
        ),
        PSLTPTextField(
          controller: _takeProfitController,
          title: L10n.tr('take_profit'),
          marketListModel: widget.symbol.copyWith(
            limitUp: widget.action == OrderActionTypeEnum.sell
                ? widget.currentPrice - widget.symbol.priceStep < widget.symbol.limitDown
                    ? widget.symbol.limitDown
                    : widget.currentPrice - widget.symbol.priceStep
                : widget.symbol.limitUp,
            limitDown: widget.action == OrderActionTypeEnum.buy
                ? widget.currentPrice + widget.symbol.priceStep > widget.symbol.limitUp
                    ? widget.symbol.limitUp
                    : widget.currentPrice + widget.symbol.priceStep
                : widget.symbol.limitDown,
          ),
          action: widget.action,
          backgroundColor: context.pColorScheme.card.shade50,
          currentPrice: widget.currentPrice,
          isStopLoss: false,
          onPriceChanged: (newPrice) {
            setState(() {
              _stopLossTakeProfit.takeProfitPrice = newPrice;
            });
          },
        ),
        const SizedBox(
          height: Grid.s,
        ),
        PSLTPTextField(
          controller: _stopLossController,
          title: L10n.tr('zarar_durdur'),
          marketListModel: widget.symbol.copyWith(
            limitUp: widget.action == OrderActionTypeEnum.buy
                ? widget.currentPrice - widget.symbol.priceStep
                : widget.symbol.limitUp,
            limitDown: widget.action == OrderActionTypeEnum.sell
                ? widget.currentPrice + widget.symbol.priceStep
                : widget.symbol.limitDown,
          ),
          currentPrice: widget.currentPrice,
          action: widget.action,
          isStopLoss: true,
          backgroundColor: context.pColorScheme.card.shade50,
          onPriceChanged: (newPrice) {
            setState(() {
              _stopLossTakeProfit.stopLossPrice = newPrice;
            });
          },
        ),
        const SizedBox(
          height: Grid.s,
        ),
        DateSelectRow(
          leading: L10n.tr('gecerlilik_tarihi'),
          trailing: DateTimeUtils.dateFormat(_stopLossTakeProfit.validityDate),
          selectedDate: _stopLossTakeProfit.validityDate,
          minimumDate: _startDate,
          style: context.pAppStyle.labelReg14textPrimary,
          onDateSelected: (DateTime value) {
            DateTime date = DateTimeUtils().moveToSessionDate(value);
            _stopLossTakeProfit.validityDate = date;
            setState(() {});
          },
        ),
        const SizedBox(
          height: Grid.m,
        ),
        SizedBox(
          height: 52,
          width: MediaQuery.of(context).size.width - Grid.m * 2,
          child: !widget.isForUpdate
              ? PButton(
                  text: L10n.tr('add'),
                  variant: PButtonVariant.brand,
                  onPressed: () {
                    widget.onSLTPChanged(_stopLossTakeProfit);
                    router.maybePop();
                  },
                )
              : OrderApprovementButtons(
                  cancelButtonText: L10n.tr('sil'),
                  approveButtonText: L10n.tr('guncelle'),
                  onPressedCancel: () async {
                    bool isConfirmed = false;
                    await PBottomSheet.showError(
                      context,
                      content: L10n.tr('delete_order', args: [L10n.tr('tp_sl')]),
                      showFilledButton: true,
                      filledButtonText: L10n.tr('onayla'),
                      onFilledButtonPressed: () {
                        isConfirmed = true;
                        widget.onSLTPChanged(null);
                        router.maybePop();
                      },
                      showOutlinedButton: true,
                      outlinedButtonText: L10n.tr('vazgec'),
                      onOutlinedButtonPressed: () {
                        widget.onSLTPChanged(_stopLossTakeProfit);
                        router.maybePop();
                      },
                    );
                    if (isConfirmed) {
                      router.maybePop();
                    }
                  },
                  onPressedApprove: () {
                    widget.onSLTPChanged(_stopLossTakeProfit);
                    router.maybePop();
                  },
                ),
        ),
        const SizedBox(
          height: Grid.m,
        ),
      ],
    );
  }
}
