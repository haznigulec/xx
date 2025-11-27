import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/create_order/model/stoploss_takeprofit.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/pvalue_textfield_widget.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/utils/text_input_formatters.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class PUsPriceTextfield extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? title;
  final Function()? onTapPrice;
  final Function(double newPrice) onPriceChanged;
  final Function(StopLossTakeProfit sltp)? onSLTPChanged;
  final Color? backgroundColor;
  final StopLossTakeProfit? stopLossTakeProfit;
  const PUsPriceTextfield({
    super.key,
    this.controller,
    this.focusNode,
    this.title,
    required this.onPriceChanged,
    this.onTapPrice,
    this.onSLTPChanged,
    this.backgroundColor,
    this.stopLossTakeProfit,
  });

  @override
  State<PUsPriceTextfield> createState() => _PUsPriceTextfieldState();
}

class _PUsPriceTextfieldState extends State<PUsPriceTextfield> {
  late TextEditingController _priceController;
  late FocusNode _focusNode;
  String priceText = '';
  String pattern = '#,##0.00';
  @override
  void initState() {
    super.initState();
    _priceController = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.unfocus();
    pattern = _priceController.text.startsWith('0.') ||
            _priceController.text.startsWith('0,') ||
            priceText.startsWith('0.') ||
            priceText.startsWith('0,')
        ? '#,##0.0000'
        : '#,##0.00';
  }

  @override
  Widget build(BuildContext context) {
    return PValueTextfieldWidget(
      controller: _priceController,
      title: widget.title ?? L10n.tr('limit_price'),
      focusNode: _focusNode,
      suffixText: CurrencyEnum.dollar.symbol,
      backgroundColor: widget.backgroundColor,
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
        signed: false,
      ),
      inputFormatters: [
        AppInputFormatters.decimalFormatter(
          maxDigitAfterSeparator: pattern.split('.').last.length,
        ),
      ],
      onChanged: (p0) {
        pattern = _priceController.text.startsWith('0.') ||
                _priceController.text.startsWith('0,') ||
                p0.startsWith('0.') ||
                p0.startsWith('0,')
            ? '#,##0.0000'
            : '#,##0.00';
        priceText = p0;
        setState(() {});
      },
      onFocusChange: (hasFocus) {
        if (!hasFocus) {
          if (_priceController.text == ',' || _priceController.text == '.') {
            _priceController.text = '0';
          }
          double price = _priceController.text.isEmpty ? 0 : MoneyUtils().fromReadableMoney(_priceController.text);
          _priceController.text = MoneyUtils().readableMoney(price, pattern: pattern);
          widget.onPriceChanged(price);
        } else {
          double price = _priceController.text.isEmpty ? 0 : MoneyUtils().fromReadableMoney(_priceController.text);
          if (price == 0) {
            _priceController.text = '';
          }
          widget.onTapPrice?.call();
        } 
      },
    );
  }
}
