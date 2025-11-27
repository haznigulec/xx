import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/pvalue_textfield_widget.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/utils/text_input_formatters.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class PReserveTextfield extends StatefulWidget {
  final TextEditingController? controller;
  final Function(num newUnit) onUnitChanged;
  final Function()? onTapReserve;
  const PReserveTextfield({
    super.key,
    this.controller,
    required this.onUnitChanged,
    this.onTapReserve,
  });

  @override
  State<PReserveTextfield> createState() => _PReserveTextfieldState();
}

class _PReserveTextfieldState extends State<PReserveTextfield> {
  late TextEditingController _unitController;
  late FocusNode _focusNode;
  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _unitController = widget.controller ?? TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return PValueTextfieldWidget(
      controller: _unitController,
      title: L10n.tr('gorunenadet'),
      focusNode: _focusNode,
      showSeperator: false,
      keyboardType: const TextInputType.numberWithOptions(
        decimal: false,
        signed: false,
      ),
      inputFormatters: [
        AppInputFormatters.decimalFormatter(
          maxDigitAfterSeparator: 0,
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
          widget.onTapReserve?.call();
        }
      },
    );
  }
}
