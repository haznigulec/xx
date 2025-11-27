import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/money_transfer/widgets/quick_cash_textfield_widget.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class QuickCashLimitWidget extends StatefulWidget {
  const QuickCashLimitWidget({
    super.key,
    required this.currencyType,
    required this.amountController,
    required this.totalAmount,
    required this.buttonEnabled,
  });

  final CurrencyEnum currencyType;
  final TextEditingController amountController;

  final double totalAmount;
  final ValueNotifier<bool> buttonEnabled;

  @override
  State<QuickCashLimitWidget> createState() => _QuickCashLimitWidgetState();
}

class _QuickCashLimitWidgetState extends State<QuickCashLimitWidget> {
  bool _isError = false;
  late FocusNode _ammountFocusNode;
  @override
  void initState() {
    _ammountFocusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!_ammountFocusNode.hasFocus) {
          _ammountFocusNode.requestFocus();
        }
      },
      child: Container(
        alignment: Alignment.center,
        constraints: const BoxConstraints(minHeight: 60),
        padding: const EdgeInsets.symmetric(
          horizontal: Grid.m,
        ),
        decoration: BoxDecoration(
          color: context.pColorScheme.card,
          borderRadius: BorderRadius.circular(
            Grid.m,
          ),
        ),
        child: Row(
          spacing: Grid.xs,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              L10n.tr('amount_to_be_converted_to_cash'),
              style: context.pAppStyle.labelReg14textPrimary,
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) => Container(
                  alignment: Alignment.centerRight,
                  width: constraints.maxWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      QuickCashTextfieldWidget(
                        controller: widget.amountController,
                        focusNode: _ammountFocusNode,
                        fieldStyle: context.pAppStyle.interRegularBase.copyWith(
                          color: _isError ? context.pColorScheme.critical : context.pColorScheme.primary,
                          fontSize: Grid.m + Grid.xxs,
                        ),
                        inputDecoration: context.pAppStyle.quickCashTextfieldDecoration.copyWith(
                          prefixText: widget.currencyType.symbol,
                          prefixStyle: context.pAppStyle.interMediumBase.copyWith(
                            color: _isError ? context.pColorScheme.critical : context.pColorScheme.primary,
                            fontSize: Grid.m + Grid.xxs,
                          ),
                        ),
                        onFocusChange: (hasFocus) {
                          if (!hasFocus) {
                            double amount = widget.amountController.text.isEmpty
                                ? 0
                                : MoneyUtils().fromReadableMoney(widget.amountController.text);
                            widget.amountController.text = MoneyUtils().readableMoney(amount);
                          } else {
                            double amount = MoneyUtils().fromReadableMoney(widget.amountController.text);
                            setState(() {
                              widget.amountController.text = amount == 0 ? '' : MoneyUtils().readableMoney(amount);
                            });
                          }
                        },
                        onChanged: (value) {
                          if (!mounted) return;

                          setState(
                            () {
                              widget.amountController.text = value.toString();
                              double amount = MoneyUtils().fromReadableMoney(widget.amountController.text);
                              if (amount > widget.totalAmount || amount <= 0) {
                                _isError = true;
                                widget.buttonEnabled.value = false;
                              } else {
                                _isError = false;
                                widget.buttonEnabled.value = true;
                              }
                            },
                          );
                        },
                        onSubmitted: (value) {
                          setState(
                            () {
                              if (value.isEmpty) {
                                value = '0';
                              }
                              widget.amountController.text = value;
                              double amount = MoneyUtils().fromReadableMoney(widget.amountController.text);
                              if (amount > widget.totalAmount || amount <= 0) {
                                _isError = true;
                                widget.buttonEnabled.value = false;
                              } else {
                                _isError = false;
                                widget.buttonEnabled.value = true;
                              }
                              FocusScope.of(context).unfocus();
                            },
                          );
                        },
                      ),
                      if (_isError &&
                          MoneyUtils().fromReadableMoney(widget.amountController.text) > widget.totalAmount) ...[
                        Text(
                          L10n.tr(
                            'insufficient_balance',
                            args: [
                              '${widget.currencyType.symbol}${MoneyUtils().readableMoney(widget.totalAmount)}',
                            ],
                          ),
                          style: context.pAppStyle.labelReg12textPrimary.copyWith(
                            color: context.pColorScheme.critical,
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
