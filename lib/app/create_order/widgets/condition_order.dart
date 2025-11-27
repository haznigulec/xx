import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/create_order/model/condition.dart';
import 'package:piapiri_v2/app/search_symbol/enum/symbol_search_filter_enum.dart';
import 'package:piapiri_v2/app/search_symbol/widgets/order_approvement_buttons.dart';
import 'package:piapiri_v2/app/search_symbol/widgets/symbol_search_selected.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/utils/utils.dart';
import 'package:piapiri_v2/common/widgets/textfields/order_text_fields/p_condition_textfield.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/model/order_action_type_enum.dart';
import 'package:piapiri_v2/core/model/symbol_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class ConditionOrder extends StatefulWidget {
  final Condition condition;
  final String accountId;
  final bool isForUpdate;
  final Function(Condition? condition) onConditionChanged;
  const ConditionOrder({
    super.key,
    required this.condition,
    required this.isForUpdate,
    required this.onConditionChanged,
    required this.accountId,
  });

  @override
  State<ConditionOrder> createState() => _ConditionOrderState();
}

class _ConditionOrderState extends State<ConditionOrder> {
  final TextEditingController _priceController = TextEditingController();
  late Condition _condition;
  double priceStep = 0.01;
  @override
  initState() {
    _condition = widget.condition;
    priceStep = Utils().getPriceStep(
      _condition.price,
      _condition.symbol.type,
      _condition.symbol.marketCode,
      _condition.symbol.subMarketCode,
      _condition.symbol.priceStep,
    );
    if (stringToSymbolType(_condition.symbol.type) == SymbolTypes.warrant ||
        stringToSymbolType(_condition.symbol.type) == SymbolTypes.certificate) { 
      _priceController.text = MoneyUtils().readableMoney(
        _condition.price + priceStep,
      );
    } else {
      _priceController.text = MoneyUtils().readableMoney(
        _condition.price + priceStep > _condition.symbol.limitUp
            ? _condition.symbol.limitUp
            : _condition.price + priceStep,
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SymbolSearchSelected(
          key: ValueKey(_condition.symbol),
          accountId: widget.accountId,
          symbolModel: SymbolModel.fromMarketListModel(_condition.symbol),
          showPriceInfo: false,
          filterList: SymbolSearchFilterEnum.values
              .where(
                (e) =>
                    e != SymbolSearchFilterEnum.foreign &&
                    e != SymbolSearchFilterEnum.fund &&
                    e != SymbolSearchFilterEnum.crypto &&
                    e != SymbolSearchFilterEnum.parity &&
                    e != SymbolSearchFilterEnum.preciousMetals &&
                    e != SymbolSearchFilterEnum.etf,
              )
              .toList(),
          onTapSymbol: (marketListModel) {
            setState(() {
              _condition.symbol = marketListModel;
              _condition.price = MoneyUtils().getPrice(marketListModel, OrderActionTypeEnum.buy);
              _priceController.text = MoneyUtils().readableMoney(_condition.price);
            });
          },
        ),
        const SizedBox(
          height: Grid.m,
        ),
        PConditionTextfield(
          controller: _priceController,
          action: OrderActionTypeEnum.buy,
          marketListModel: _condition.symbol,
          condition: _condition,
          onConditionChanged: (newCondition) {
            setState(() {
              _condition.condition = newCondition;
            });
            router.maybePop();
          },
          onPriceChanged: (newPrice) {
            setState(() {
              _condition.price = newPrice;
            });
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
                    widget.onConditionChanged(_condition);
                    router.maybePop();
                  },
                )
              : OrderApprovementButtons(
                  approveButtonText: L10n.tr('guncelle'),
                  cancelButtonText: L10n.tr('sil'),
                  onPressedCancel: () async {
                    bool isConfirmed = false;
                    await PBottomSheet.showError(
                      context,
                      content: L10n.tr('delete_order', args: [L10n.tr('add_condition')]),
                      showFilledButton: true,
                      filledButtonText: L10n.tr('onayla'),
                      onFilledButtonPressed: () {
                        isConfirmed = true;
                        widget.onConditionChanged(null);
                        router.maybePop();
                      },
                      showOutlinedButton: true,
                      outlinedButtonText: L10n.tr('vazgec'),
                      onOutlinedButtonPressed: () {
                        router.maybePop();
                      },
                    );
                    if (isConfirmed) {
                      router.maybePop();
                    }
                  },
                  onPressedApprove: () {
                    widget.onConditionChanged(_condition);
                    router.maybePop();
                  },
                ),
        ),
      ],
    );
  }
}
