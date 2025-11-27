import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:piapiri_v2/common/widgets/textfields/keyboard_done_action.dart';

class QuickCashTextfieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final Color? backgroundColor;
  final TextStyle? fieldStyle;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final Function(PointerDownEvent)? onTapOutside;
  final Function(bool)? onFocusChange;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final bool isEnable;
  final double? cursorWidth;
  final double? cursorHeight;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final TextAlign? textAlign;
  final TextAlignVertical? textAlignVertical;
  final InputDecoration? inputDecoration;
  final bool showSeperator;
  final int maxDigitAfterSeperator;
  final Function()? onTapPrice;

  const QuickCashTextfieldWidget({
    super.key,
    required this.controller,
    this.backgroundColor,
    required this.fieldStyle,
    this.onChanged,
    this.onSubmitted,
    this.onTapOutside,
    this.onFocusChange,
    this.focusNode,
    this.inputFormatters,
    this.isEnable = true,
    this.cursorWidth,
    this.cursorHeight,
    this.textInputAction,
    this.keyboardType,
    this.textAlign,
    this.textAlignVertical,
    this.inputDecoration,
    this.showSeperator = true,
    this.maxDigitAfterSeperator = 2,
    this.onTapPrice,
  });

  @override
  State<QuickCashTextfieldWidget> createState() => _QuickCashTextfieldWidgetState();
}

class _QuickCashTextfieldWidgetState extends State<QuickCashTextfieldWidget> {
  late FocusNode _focusNode;

  @override
  void initState() {
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        widget.onTapPrice?.call();
      } else {
        widget.onSubmitted?.call(widget.controller.text);
      }

      widget.onFocusChange?.call(_focusNode.hasFocus);
    });
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(() {});
    _focusNode.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusNode.requestFocus();
      },
      child: Container(
        alignment: Alignment.centerRight,
        child: IntrinsicWidth(
          child: KeyboardDoneAction(
            focusNode: _focusNode,
            child: TextField(
              focusNode: _focusNode,
              enabled: widget.isEnable,
              showCursor: true,
              cursorColor: context.pColorScheme.primary,
              cursorHeight: 19,
              textAlign: TextAlign.end,
              style: widget.fieldStyle,
              maxLines: 1,
              onChanged: widget.onChanged,
              onSubmitted: widget.onSubmitted,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
                signed: true,
              ),
              onTap: null,
              inputFormatters: widget.inputFormatters,
              onTapOutside: widget.onTapOutside,
              controller: widget.controller,
              decoration: widget.inputDecoration,
            ),
          ),
        ),
      ),
    );
  }
}
