import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:piapiri_v2/common/widgets/textfields/keyboard_done_action.dart';

/// Harflerin olduğu klavye kullanımı.
class PValueLetterTextfieldWidget extends StatefulWidget {
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
  final FocusNode? focusNode;
  final bool isError;
  final Color? valueTextColor;
  final Widget? subTitleWidget;
  final TextStyle? valueTextStyle;
  final List<TextInputFormatter>? inputFormatters;
  final bool isEnable;
  final TextStyle? suffixStyle;
  final double? cursorWidth;
  final double? cursorHeight;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final TextAlign? textAlign;
  final TextAlignVertical? textAlignVertical;
  final InputDecoration? inputDecoration;
  final TextStyle? prefixStyle;
  final bool showSeperator;
  final String? hintText;
  final double? titleWidth;
  final double? valueWidth;

  const PValueLetterTextfieldWidget({
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
    this.focusNode,
    this.isError = false,
    this.valueTextColor,
    this.subTitleWidget,
    this.valueTextStyle,
    this.inputFormatters,
    this.isEnable = true,
    this.suffixStyle,
    this.cursorWidth,
    this.cursorHeight,
    this.textInputAction,
    this.keyboardType,
    this.textAlign,
    this.textAlignVertical,
    this.inputDecoration,
    this.prefixStyle,
    this.showSeperator = true,
    this.hintText,
    this.titleWidth,
    this.valueWidth,
  });

  @override
  State<PValueLetterTextfieldWidget> createState() => _PValueLetterTextfieldWidgetState();
}

class _PValueLetterTextfieldWidgetState extends State<PValueLetterTextfieldWidget> {
  late FocusNode _focusNode;
  late ValueNotifier<String> _notifier;
  late int selectionStart;
  late int selectionEnd;
  bool isSelectionActive = false;

  @override
  void initState() {
    _focusNode = widget.focusNode ?? FocusNode();

    _notifier = ValueNotifier<String>('');
    _notifier.value = widget.controller.text;
    selectionStart = widget.controller.selection.start;
    selectionEnd = widget.controller.selection.end;
    widget.controller.addListener(() {
      ///Text Selection yapildi ise secilen texti siler ve yeni texti ekler
      if (isSelectionActive) {
        if (widget.controller.text.substring(selectionStart, selectionEnd) == widget.controller.text) return;
        String newValue =
            widget.controller.text.replaceRange(selectionStart, selectionEnd, widget.controller.text.characters.last);
        newValue = newValue.substring(0, newValue.length - 1);
        selectionStart = newValue.length;
        selectionEnd = newValue.length;
        isSelectionActive = false;
        _notifier.value = newValue;
      }
      if (selectionStart != selectionEnd &&
          widget.controller.selection.start == -1 &&
          widget.controller.selection.end == -1) {
        isSelectionActive = !isSelectionActive;
        return;
      }

      selectionStart = widget.controller.selection.start;
      selectionEnd = widget.controller.selection.end;

      _notifier.value = widget.controller.text;
    });
    _notifier.addListener(() {
      widget.controller.text = _notifier.value;
      widget.onChanged?.call(_notifier.value);
    });

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _notifier.value = widget.controller.text;
      }
      widget.onFocusChange?.call(_focusNode.hasFocus);
    });
    super.initState();
  }

  @override
  void dispose() {
    _notifier.removeListener(() {});
    widget.controller.removeListener(() {});
    _focusNode.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusColor: context.pColorScheme.transparent,
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
            children: [
              SizedBox(
                width: widget.titleWidth ?? MediaQuery.sizeOf(context).width * .4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.title != null) ...[
                      Text(
                        widget.title!,
                        textAlign: TextAlign.start,
                        style: context.pAppStyle.labelReg14textPrimary,
                      )
                    ],
                    if (widget.subTitle != null) ...[
                      const SizedBox(
                        height: Grid.xs,
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
                            child: KeyboardDoneAction(
                              focusNode: _focusNode,
                              child: TextField(
                                focusNode: _focusNode,
                                enabled: widget.isEnable,
                                showCursor: true,
                                cursorColor: context.pColorScheme.primary,
                                cursorHeight: 19,
                                textAlign: TextAlign.end,
                                style: widget.valueTextStyle ??
                                    context.pAppStyle.interRegularBase.copyWith(
                                      fontSize: Grid.m + Grid.xxs,
                                      color: !widget.isEnable
                                          ? context.pColorScheme.textPrimary
                                          : widget.isError
                                              ? context.pColorScheme.critical
                                              : context.pColorScheme.primary,
                                    ),
                                maxLines: 1,
                                onChanged: widget.onChanged,
                                onSubmitted: widget.onSubmitted,
                                keyboardType: widget.keyboardType ?? TextInputType.text,
                                onTap: null,
                                inputFormatters: widget.inputFormatters,
                                onTapOutside: widget.onTapOutside,
                                controller: widget.controller,
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
                                        color: widget.isError
                                            ? context.pColorScheme.critical
                                            : context.pColorScheme.primary,
                                        fontSize: Grid.m + Grid.xxs,
                                      ),
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
                        style: context.pAppStyle.interMediumBase.copyWith(
                          fontSize: Grid.s + Grid.xs,
                          color: context.pColorScheme.critical,
                        ),
                      )
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    // return GestureDetector(
    //   onTap: () {
    //     _focusNode.requestFocus();
    //   },
    //   child: Container(
    //     height: 60,
    //     decoration: BoxDecoration(
    //       color: widget.backgroundColor ?? PColor.card500,
    //       borderRadius: BorderRadius.circular(
    //         Grid.m,
    //       ),
    //     ),
    //     child: Padding(
    //       padding: const EdgeInsets.symmetric(
    //         vertical: Grid.s,
    //         horizontal: Grid.m,
    //       ),
    //       child: Row(
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: [
    //           SizedBox(
    //             width: MediaQuery.sizeOf(context).width * .4,
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: [
    //                 if (widget.title != null) ...[
    //                   Text(
    //                     widget.title!,
    //                     textAlign: TextAlign.start,
    //                     style: const PTypography.title(
    //                       color: PColor.textPrimary500,
    //                     ),
    //                   )
    //                 ],
    //                 if (widget.subTitle != null) ...[
    //                   const SizedBox(
    //                     height: Grid.xs,
    //                   ),
    //                   FittedBox(
    //                     fit: BoxFit.scaleDown,
    //                     child: widget.subTitle!,
    //                   ),
    //                 ]
    //               ],
    //             ),
    //           ),
    //           SizedBox(
    //             width: MediaQuery.of(context).size.width * .43,
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.end,
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: [
    //                 Row(
    //                   mainAxisAlignment: MainAxisAlignment.end,
    //                   children: [
    //                     if (widget.prefix != null) ...[
    //                       widget.prefix!,
    //                       const SizedBox(
    //                         width: Grid.xs,
    //                       ),
    //                     ],
    //                     Container(
    //                       constraints: BoxConstraints(
    //                         maxWidth: MediaQuery.of(context).size.width * .42,
    //                       ),
    //                       child: IntrinsicWidth(
    //                         child: TextField(
    //                           focusNode: _focusNode,
    //                           enabled: widget.isEnable,
    //                           showCursor: true,
    //                           readOnly: true,
    //                           cursorColor: PColor.primary500,
    //                           cursorHeight: 19,
    //                           textAlign: TextAlign.end,
    //                           style: widget.valueTextStyle ??
    //                               PTypography.title(
    //                                 fontSize: Grid.m,
    //                                 color: !widget.isEnable
    //                                     ? PColor.textPrimary500
    //                                     : widget.isError
    //                                         ? PColor.critical500
    //                                         : PColor.primary500,
    //                               ),
    //                           maxLines: 1,
    //                           onChanged: widget.onChanged,
    //                           onSubmitted: widget.onSubmitted,
    //                           keyboardType: const TextInputType.numberWithOptions(
    //                             decimal: true,
    //                             signed: true,
    //                           ),
    //                           onTap: null,
    //                           inputFormatters: widget.inputFormatters,
    //                           onTapOutside: widget.onTapOutside,
    //                           controller: widget.controller,
    //                           decoration: InputDecoration(
    //                             contentPadding: EdgeInsets.zero,
    //                             isCollapsed: true,
    //                             filled: false,
    //                             fillColor: Colors.transparent,
    //                             border: InputBorder.none,
    //                             hintText: widget.hintText ?? '',
    //                             hintStyle: const PTypography.title(
    //                               color: PColor.textTeritary500,
    //                             ),
    //                             prefixText: widget.prefixText,
    //                             prefixStyle: widget.prefixStyle ??
    //                                 PTypography.subTitle(
    //                                   color: widget.isError ? PColor.critical500 : PColor.primary500,
    //                                   fontSize: Grid.m,
    //                                 ),
    //                             suffixText: widget.suffixText,
    //                             suffixStyle: widget.suffixStyle ??
    //                                 PTypography.subTitle(
    //                                   color: widget.isError ? PColor.critical500 : PColor.primary500,
    //                                   fontSize: Grid.m,
    //                                 ),
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                     if (widget.suffix != null) ...[
    //                       const SizedBox(
    //                         width: Grid.xs,
    //                       ),
    //                       widget.suffix!,
    //                     ],
    //                   ],
    //                 ),
    //                 if (widget.errorText != null && widget.errorText!.isNotEmpty) ...[
    //                   Text(
    //                     textAlign: TextAlign.end,
    //                     widget.errorText!,
    //                     style: const PTypography.subTitle(
    //                       color: PColor.critical500,
    //                     ),
    //                   )
    //                 ]
    //               ],
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
