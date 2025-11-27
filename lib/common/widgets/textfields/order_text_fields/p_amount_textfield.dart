import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/pvalue_textfield_widget.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/utils/text_input_formatters.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/order_action_type_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class PAmountTextfield extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final OrderActionTypeEnum action;
  final String? subTitle;
  final String? subTitleValue;
  final bool isError;
  final String? errorText;
  final bool ignoreLimit;
  final bool enabled;
  final Function()? onTapAmount;
  final Function(double newAmount) onAmountChanged;
  final String pattern;
  final CurrencyEnum currency;
  final int maxDigitAfterSeparator;
  final VoidCallback? onTapSubTitle;

  const PAmountTextfield({
    super.key,
    this.controller,
    this.focusNode,
    required this.action,
    this.subTitle,
    this.isError = false,
    this.errorText,
    this.enabled = true,
    this.subTitleValue,
    this.ignoreLimit = false,
    this.onTapAmount,
    required this.onAmountChanged,
    this.pattern = '#,##0.00',
    this.currency = CurrencyEnum.turkishLira,
    this.maxDigitAfterSeparator = 2,
    this.onTapSubTitle,
  });

  @override
  State<PAmountTextfield> createState() => _PAmountTextfieldState();
}

class _PAmountTextfieldState extends State<PAmountTextfield> {
  late TextEditingController _amountController;
  late FocusNode _focusNode;
  @override
  void initState() {
    super.initState();
    _amountController = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PValueTextfieldWidget(
          controller: _amountController,
          title: L10n.tr('tutar'),
          focusNode: _focusNode,
          isEnable: widget.enabled,
          isError: widget.ignoreLimit ? false : widget.isError,
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
            signed: false,
          ),
          inputFormatters: [
            AppInputFormatters.decimalFormatter(
              maxDigitAfterSeparator: widget.maxDigitAfterSeparator,
            ),
          ],
          errorText: widget.ignoreLimit
              ? null
              : widget.isError
                  ? widget.errorText ?? L10n.tr('TradeLimitInsufficient')
                  : null,
          suffixText: widget.currency.symbol,
          subTitle: widget.subTitle != null && widget.subTitleValue != null
              ? InkWell(
                  onTap: () => widget.onTapSubTitle?.call(),
                  child: Row(
                    children: [
                      Text(
                        '${widget.subTitle}: ',
                        style: context.pAppStyle.labelReg12textSecondary,
                      ),
                      Text(
                        '${widget.currency.symbol}${widget.subTitleValue}',
                        style: context.pAppStyle.labelMed12textSecondary,
                      ),
                    ],
                  ),
                )
              : null,
          onFocusChange: (hasFocus) {
            if (!hasFocus) {
              double amount =
                  _amountController.text.isEmpty ? 0 : MoneyUtils().fromReadableMoney(_amountController.text);
              _amountController.text = MoneyUtils().readableMoney(amount, pattern: widget.pattern);
              widget.onAmountChanged(amount);
            } else {
              double amount =
                  _amountController.text.isEmpty ? 0 : MoneyUtils().fromReadableMoney(_amountController.text);
              if (amount == 0) {
                _amountController.text = '';
              }
              widget.onTapAmount?.call();
            }
          },
        ),
      ],
    );
  }
}
