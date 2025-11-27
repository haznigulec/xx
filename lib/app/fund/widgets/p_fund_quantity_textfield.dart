import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/pvalue_textfield_widget.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/utils/text_input_formatters.dart';

import 'package:piapiri_v2/core/model/fund_order_action.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class PFundQuantityTextfield extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FundOrderActionEnum action;
  final String? subTitle;
  final String? errorText;
  final Function()? onTapSubtitle;
  final Function(int newUnit) onUnitChanged;
  const PFundQuantityTextfield({
    super.key,
    this.controller,
    this.focusNode,
    required this.action,
    required this.subTitle,
    required this.errorText,
    required this.onUnitChanged,
    this.onTapSubtitle,
  });

  @override
  State<PFundQuantityTextfield> createState() => _PFundQuantityTextfieldState();
}

class _PFundQuantityTextfieldState extends State<PFundQuantityTextfield> {
  late TextEditingController _unitController;
  late FocusNode _focusNode;
  @override
  void initState() {
    super.initState();
    _unitController = widget.controller ?? TextEditingController(text: '0');
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    // Sadece bizim oluşturduğumuz focusNode'u dispose et (dışarıdan verilmediyse)
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    // Sadece bizim oluşturduğumuz controller'ı dispose et
    if (widget.controller == null) {
      _unitController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PValueTextfieldWidget(
      controller: _unitController,
      showSeperator: false,
      focusNode: _focusNode,
      title: L10n.tr('adet'),
      keyboardType: const TextInputType.numberWithOptions(
        decimal: false,
        signed: false,
      ),
      inputFormatters: [
        AppInputFormatters.decimalFormatter(
          maxDigitAfterSeparator: 0,
        ),
      ],
      subTitle: widget.subTitle != null
          ? InkWell(
              onTap: () {
                onFocusChange(_focusNode.hasFocus);
                widget.onTapSubtitle?.call();
                
              },
              child: Text(
                widget.subTitle!,
                style: context.pAppStyle.labelReg12textSecondary,
              ),
            )
          : null,
      errorText: widget.errorText,
      onFocusChange: onFocusChange,
    );
  }

  void onFocusChange(bool hasFocus) {
    if (!hasFocus) {
      if (_unitController.text == ',' || _unitController.text == '.' || _unitController.text == '') {
        _unitController.text = '0';
      }
      int unit = MoneyUtils().fromReadableMoney(_unitController.text).toInt();
      _unitController.text = MoneyUtils().readableMoney(unit, pattern: MoneyUtils().getPatternByUnitDecimal(unit));
      widget.onUnitChanged(unit);
      setState(() {});
    } else {
      _unitController.text =
          MoneyUtils().fromReadableMoney(_unitController.text.isEmpty ? '0' : _unitController.text) == 0
              ? ''
              : _unitController.text;
    }
  }
}
