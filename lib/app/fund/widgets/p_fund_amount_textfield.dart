import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/pvalue_textfield_widget.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/utils/text_input_formatters.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/fund_order_action.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class PFundAmountTextfield extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FundOrderActionEnum action;
  final String? errorText;
  final Function(double newAmount) onAmountChanged;
  const PFundAmountTextfield({
    super.key,
    this.controller,
    this.focusNode,
    required this.action,
    required this.errorText,
    required this.onAmountChanged,
  });

  @override
  State<PFundAmountTextfield> createState() => _PFundAmountTextfieldState();
}

class _PFundAmountTextfieldState extends State<PFundAmountTextfield> {
  late TextEditingController _amountController;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _amountController = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    if (widget.controller == null) {
      _amountController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PValueTextfieldWidget(
      controller: _amountController,
      title: L10n.tr('tutar'),
      suffixText: CurrencyEnum.turkishLira.symbol,
      focusNode: _focusNode,
      isError: widget.errorText != null,
      errorText: widget.errorText,
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
        signed: false,
      ),
      inputFormatters: [
        AppInputFormatters.decimalFormatter(
          maxDigitAfterSeparator: 2,
        ),
      ],
      onFocusChange: _onFocusChange,
    );
  }

  void _onFocusChange(bool hasFocus) {
    if (!hasFocus) {
      if (_amountController.text == ',' || _amountController.text == '.' || _amountController.text == '') {
        _amountController.text = '0';
      }
      double amount = MoneyUtils().fromReadableMoney(_amountController.text);
      _amountController.text = MoneyUtils().readableMoney(amount);
      widget.onAmountChanged(amount);
    } else {
      _amountController.text =
          MoneyUtils().fromReadableMoney(_amountController.text.isEmpty ? '0' : _amountController.text).toInt() == 0
              ? ''
              : _amountController.text;
    }
    setState(() {});
  }
}
