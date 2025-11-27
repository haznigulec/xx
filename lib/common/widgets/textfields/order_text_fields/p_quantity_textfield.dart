import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/pvalue_textfield_widget.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/utils/text_input_formatters.dart';
import 'package:piapiri_v2/core/model/order_action_type_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class PQuantityTextfield extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final OrderActionTypeEnum action;
  final String? subtitle;
  final Function()? onTapSubtitle;
  final bool isError;
  final String? errorText;
  final bool ignoreLimit;
  final Function(num newUnit) onUnitChanged;
  final Function()? onTapQuantity;
  final bool isDouble;
  final bool autoFocus;
  final bool isEnable;
  const PQuantityTextfield({
    super.key,
    this.controller,
    this.focusNode,
    required this.action,
    this.subtitle,
    this.onTapSubtitle,
    this.isError = false,
    this.errorText,
    this.ignoreLimit = false,
    required this.onUnitChanged,
    this.onTapQuantity,
    this.isDouble = false,
    this.autoFocus = true,
    this.isEnable = true,
  });

  @override
  State<PQuantityTextfield> createState() => _PQuantityTextfieldState();
}

class _PQuantityTextfieldState extends State<PQuantityTextfield> {
  late TextEditingController _unitController;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _unitController = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    if (widget.autoFocus) _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return PValueTextfieldWidget(
      controller: _unitController,
      isEnable: widget.isEnable,
      title: L10n.tr('adet'),
      subTitle: widget.subtitle != null
          ? InkWell(
              onTap: () async {
                await widget.onTapSubtitle?.call();
                setState(() {});
              },
              child: Text(
                widget.subtitle!,
                style: context.pAppStyle.labelMed12textSecondary,
              ),
            )
          : null,
      focusNode: _focusNode,
      isError: widget.isError,
      showSeperator: widget.isDouble,
      errorText: widget.ignoreLimit
          ? null
          : widget.isError
              ? widget.errorText ?? L10n.tr('insufficient_number_of_shares')
              : null,
      keyboardType: TextInputType.numberWithOptions(
        decimal: widget.isDouble,
        signed: false,
      ),
      inputFormatters: [
        AppInputFormatters.decimalFormatter(
          maxDigitAfterSeparator: widget.isDouble ? 9 : 0,
        ),
      ],
      onFocusChange: (hasFocus) {
        if (!hasFocus) {
          if (_unitController.text == ',' || _unitController.text == '.') {
            _unitController.text = '0';
          }
          num unit = _unitController.text.isEmpty ? 0 : MoneyUtils().fromReadableMoney(_unitController.text);
          _unitController.text = MoneyUtils().readableMoney(unit, pattern: MoneyUtils().getPatternByUnitDecimal(unit));
          widget.onUnitChanged(unit);
          setState(() {});
        } else {
          _unitController.text =
              MoneyUtils().fromReadableMoney(_unitController.text.isEmpty ? '0' : _unitController.text) == 0
                  ? ''
                  : _unitController.text;
          widget.onTapQuantity?.call();
        }
      },
    );
  }
}
