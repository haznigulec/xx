import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/textfields/keyboard_done_action.dart';

class PValueTextfieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String? title;
  final Widget? subTitle;
  final Color? backgroundColor;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final Function(PointerDownEvent)? onTapOutside;
  final Function(bool)? onFocusChange;
  final Widget? prefix;
  final Widget? suffix;
  final String? prefixText;
  final String? suffixText;
  final String? errorText;
  final Color? errorTextColor;
  final FocusNode? focusNode;
  final bool isError;
  final TextStyle? valueTextStyle;
  final List<TextInputFormatter>? inputFormatters;
  final bool isEnable;
  final TextStyle? suffixStyle;
  final double? cursorWidth;
  final double? cursorHeight;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final TextStyle? prefixStyle;
  final bool showSeperator;
  final String? hintText;
  final Function()? onTapPrice;
  final double? titleWidth;
  final double? valueWidth;
  final double? subTitleTopPadding;
  final bool autoFocus;

  const PValueTextfieldWidget({
    super.key,
    required this.controller,
    this.title,
    this.subTitle,
    this.backgroundColor,
    this.onChanged,
    this.onSubmitted,
    this.onTapOutside,
    this.onFocusChange,
    this.prefix,
    this.suffix,
    this.prefixText,
    this.suffixText,
    this.errorText,
    this.errorTextColor,
    this.focusNode,
    this.isError = false,
    this.valueTextStyle,
    this.inputFormatters,
    this.isEnable = true,
    this.suffixStyle,
    this.cursorWidth,
    this.cursorHeight,
    this.textInputAction,
    this.keyboardType,
    this.prefixStyle,
    this.showSeperator = true,
    this.hintText,
    this.onTapPrice,
    this.titleWidth,
    this.valueWidth,
    this.subTitleTopPadding,
    this.autoFocus = false,
  });

  @override
  State<PValueTextfieldWidget> createState() => _PValueTextfieldWidgetState();
}

class _PValueTextfieldWidgetState extends State<PValueTextfieldWidget> {
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
    return KeyboardDoneAction(
      focusNode: _focusNode,
      child: GestureDetector(
        onTap: () {
          _focusNode.requestFocus();
        },
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? context.pColorScheme.card,
            borderRadius: BorderRadius.circular(
              Grid.m,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: Grid.s,
              horizontal: Grid.m,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: widget.titleWidth ?? MediaQuery.sizeOf(context).width * .4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.title != null) ...[
                        Text(widget.title!, textAlign: TextAlign.start, style: context.pAppStyle.labelReg14textPrimary)
                      ],
                      if (widget.subTitle != null) ...[
                        SizedBox(
                          height: widget.subTitleTopPadding ?? Grid.xs,
                        ),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: widget.subTitle!,
                        ),
                      ]
                    ],
                  ),
                ),
                SizedBox(
                  width: widget.valueWidth ?? MediaQuery.of(context).size.width * .43,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (widget.prefix != null) ...[
                            widget.prefix!,
                            const SizedBox(
                              width: Grid.xs,
                            ),
                          ],
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: widget.valueWidth ?? MediaQuery.of(context).size.width * .42,
                            ),
                            child: IntrinsicWidth(
                              child: TextField(
                                focusNode: _focusNode,
                                enabled: widget.isEnable,
                                showCursor: true,
                                autofocus: widget.autoFocus,
                                cursorColor: context.pColorScheme.primary,
                                cursorHeight: 19,
                                textAlign: TextAlign.end,
                                style: widget.valueTextStyle ??
                                    context.pAppStyle.interMediumBase.copyWith(
                                      fontSize: Grid.m + Grid.xxs,
                                      color: !widget.isEnable
                                          ? context.pColorScheme.textPrimary
                                          : widget.isError
                                              ? context.pColorScheme.critical
                                              : context.pColorScheme.primary,
                                    ),
                                maxLines: 1,
                                onChanged: (value) {
                                  String newValue = value;
                                  String pattern = '#,##0';
                                  String separator = MoneyUtils().getDecimalSeparator();
                                  double parsedValue = MoneyUtils().fromReadableMoney(newValue);
                                  if (newValue.contains(separator)) {
                                    int decimalCount = newValue.split(separator).last.length;
                                    pattern = '#,##0.${'0' * decimalCount}';
                                  }
                                  final oldSelection = widget.controller.selection;
                                  if (value.isNotEmpty && newValue != '.' && newValue != ',') {
                                    final formatted = MoneyUtils().readableMoney(parsedValue, pattern: pattern);
                                                        
                                    final offset = formatted.length - (value.length - oldSelection.baseOffset);
                                                        
                                    widget.controller.value = TextEditingValue(
                                      text: formatted,
                                      selection: TextSelection.collapsed(
                                        offset: offset.clamp(0, formatted.length),
                                      ),
                                    );
                                    MoneyUtils().readableMoney(parsedValue, pattern: pattern);
                                  }
                                  widget.onChanged?.call(newValue);
                                },
                                onSubmitted: widget.onSubmitted,
                                keyboardType: widget.keyboardType ??
                                    TextInputType.numberWithOptions(decimal: widget.showSeperator),
                                onTap: null,
                                inputFormatters: widget.inputFormatters,
                                onTapOutside: (pointerDownEvent) {
                                  widget.onTapOutside?.call(pointerDownEvent);
                                },
                                controller: widget.controller,
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  isCollapsed: true,
                                  filled: false,
                                  fillColor: Colors.transparent,
                                  border: InputBorder.none,
                                  hintText: widget.hintText ?? '',
                                  hintStyle: context.pAppStyle.labelReg14textTeritary,
                                  prefixText: widget.prefixText,
                                  prefixStyle: widget.prefixStyle ??
                                      context.pAppStyle.interMediumBase.copyWith(
                                        color: widget.isError
                                            ? context.pColorScheme.critical
                                            : context.pColorScheme.primary,
                                        fontSize: Grid.m + Grid.xxs,
                                      ),
                                  suffixText: widget.suffixText,
                                  suffixStyle: widget.suffixStyle ??
                                      context.pAppStyle.interMediumBase.copyWith(
                                        color: !widget.isEnable
                                            ? context.pColorScheme.textPrimary
                                            : widget.isError
                                                ? context.pColorScheme.critical
                                                : context.pColorScheme.primary,
                                        fontSize: Grid.m + Grid.xxs,
                                      ),
                                ),
                              ),
                            ),
                          ),
                          if (widget.suffix != null) ...[
                            const SizedBox(
                              width: Grid.xs,
                            ),
                            widget.suffix!,
                          ],
                        ],
                      ),
                      if (widget.errorText != null && widget.errorText!.isNotEmpty) ...[
                        Text(
                          textAlign: TextAlign.end,
                          widget.errorText!,
                          style: context.pAppStyle.labelMed12primary.copyWith(
                            color: widget.errorTextColor ?? context.pColorScheme.critical,
                          ),
                        )
                      ]
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
