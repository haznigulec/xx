import 'package:piapiri_v2/common/widgets/sliding_segment/model/sliding_segment_model.dart';
import 'package:piapiri_v2/common/widgets/sliding_segment/sliding_segment.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:p_core/utils/keyboard_utils.dart';
import 'package:piapiri_v2/app/orders/model/american_order_type_enum.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/textfields/order_text_fields/p_amount_textfield.dart';
import 'package:piapiri_v2/common/widgets/textfields/order_text_fields/p_quantity_textfield.dart';
import 'package:piapiri_v2/common/widgets/textfields/order_text_fields/p_us_price_textfield.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/order_action_type_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class UsInputs extends StatefulWidget {
  final OrderActionTypeEnum action;
  final AmericanOrderTypeEnum orderType;
  final ScrollController? scrollController;
  final double tradeLimit;
  final num? sellableUnit;
  final num buyableUnit;
  final bool isQuantitative;
  final bool fractionable;
  final TextEditingController stopPriceController;
  final TextEditingController priceController;
  final TextEditingController unitController;
  final TextEditingController amountController;
  final Function(bool isQuantitative)? onSegmentChanged;
  final Function(double stopPrice)? onPriceChanged;
  final Function(double price)? onStopPriceChanged;
  final Function(double amount)? onAmountChanged;
  final Function(num unit)? onUnitChanged;
  final String pattern;

  const UsInputs({
    super.key,
    required this.action,
    required this.orderType,
    this.scrollController,
    required this.tradeLimit,
    this.sellableUnit,
    required this.buyableUnit,
    required this.isQuantitative,
    required this.fractionable,
    required this.stopPriceController,
    required this.priceController,
    required this.unitController,
    required this.amountController,
    this.onSegmentChanged,
    this.onPriceChanged,
    this.onStopPriceChanged,
    this.onAmountChanged,
    this.onUnitChanged,
    this.pattern = '#,##0.00',
  });

  @override
  State<UsInputs> createState() => _UsInputsState();
}

class _UsInputsState extends State<UsInputs> {
  late GlobalKey priceKey;
  late GlobalKey qtyKey;
  late GlobalKey amountKey;
  late GlobalKey stopKey;

  @override
  initState() {
    super.initState();
    priceKey = GlobalKey(debugLabel: 'usPrice');
    qtyKey = GlobalKey(debugLabel: 'usQTY');
    amountKey = GlobalKey(debugLabel: 'usAmount');
    stopKey = GlobalKey(debugLabel: 'usStop');
  }

  @override
  Widget build(BuildContext context) {
    bool isMarket = widget.orderType == AmericanOrderTypeEnum.market || widget.orderType == AmericanOrderTypeEnum.stop;
    bool isStop = widget.orderType == AmericanOrderTypeEnum.stop || widget.orderType == AmericanOrderTypeEnum.stopLimit;
    return Column(
      children: [
        if (!isMarket || widget.action != OrderActionTypeEnum.buy) ...[
          SizedBox(
            height: 35,
            child: SlidingSegment(
              backgroundColor: context.pColorScheme.card,
              initialSelectedSegment: widget.isQuantitative ? 0 : 1,
              segmentList: [
                PSlidingSegmentModel(
                  segmentTitle: L10n.tr('adet'),
                  segmentColor: context.pColorScheme.secondary,
                ),
                PSlidingSegmentModel(
                  segmentTitle: L10n.tr('tutar'),
                  segmentColor: context.pColorScheme.secondary,
                ),
              ],
              onValueChanged: (p0) => widget.onSegmentChanged?.call(p0 == 0),
            ),
          ),
          const SizedBox(
            height: Grid.s,
          ),
        ],
        if (isStop) ...[
          PUsPriceTextfield(
            key: stopKey,
            controller: widget.stopPriceController,
            title: L10n.tr('stop_price'),
            onTapPrice: widget.scrollController == null
                ? null
                : () => KeyboardUtils().scrollOnFocus(
                      context,
                      stopKey,
                      widget.scrollController!,
                    ),
            onPriceChanged: (price) => widget.onStopPriceChanged?.call(price),
          ),
          const SizedBox(
            height: Grid.s,
          ),
        ],
        if (!isMarket) ...[
          PUsPriceTextfield(
            key: priceKey,
            controller: widget.priceController,
            onTapPrice: widget.scrollController == null
                ? null
                : () => KeyboardUtils().scrollOnFocus(
                      context,
                      priceKey,
                      widget.scrollController!,
                    ),
            onPriceChanged: (price) => widget.onPriceChanged?.call(price),
          ),
          const SizedBox(
            height: Grid.s,
          ),
        ],
        if (widget.isQuantitative) ...[
          PQuantityTextfield(
            key: qtyKey,
            controller: widget.unitController,
            action: widget.action,
            autoFocus: false,
            subtitle:
                '${widget.action == OrderActionTypeEnum.buy ? '${L10n.tr('alinabilir_adet')}:' : '${L10n.tr('satilabilir_adet')}:'} ${widget.action == OrderActionTypeEnum.buy ? MoneyUtils().fromReadableMoney(widget.priceController.text) == 0 ? '-' : '~${widget.buyableUnit}' : MoneyUtils().readableMoney(widget.sellableUnit ?? 0, pattern: MoneyUtils().getPatternByUnitDecimal(widget.sellableUnit ?? 0))}',
            isError: widget.action == OrderActionTypeEnum.sell &&
                widget.sellableUnit != null &&
                MoneyUtils().fromReadableMoney(widget.unitController.text) > widget.sellableUnit!,
            errorText: widget.action == OrderActionTypeEnum.sell &&
                    widget.sellableUnit != null &&
                    MoneyUtils().fromReadableMoney(widget.unitController.text) > widget.sellableUnit!
                ? L10n.tr('insufficient_transaction_unit')
                : null,
            onTapSubtitle: () {
              num unit = widget.action == OrderActionTypeEnum.buy ? widget.buyableUnit : (widget.sellableUnit ?? 0);
              widget.unitController.text = MoneyUtils().readableMoney(
                unit,
                pattern: MoneyUtils().getPatternByUnitDecimal(unit),
              );
              widget.onUnitChanged?.call(unit);
            },
            onTapQuantity: widget.scrollController == null
                ? null
                : () => KeyboardUtils().scrollOnFocus(
                      context,
                      qtyKey,
                      widget.scrollController!,
                    ),
            isDouble: widget.fractionable,
            onUnitChanged: (unit) => widget.onUnitChanged?.call(unit),
          ),
          const SizedBox(
            height: Grid.s,
          ),
        ] else ...[
          PAmountTextfield(
            key: amountKey,
            controller: widget.amountController,
            action: widget.action,
            pattern: '#,##0.00',
            currency: CurrencyEnum.dollar,
            isError: widget.action == OrderActionTypeEnum.buy &&
                widget.sellableUnit != null &&
                MoneyUtils().fromReadableMoney(widget.amountController.text) > widget.tradeLimit,
            errorText: '',
            onTapAmount: widget.scrollController == null
                ? null
                : () => KeyboardUtils().scrollOnFocus(
                      context,
                      amountKey,
                      widget.scrollController!,
                    ),
            onAmountChanged: (amount) => widget.onAmountChanged?.call(amount),
          ),
        ],
      ],
    );
  }
}
