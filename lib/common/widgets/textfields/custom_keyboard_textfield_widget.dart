import 'package:piapiri_v2/common/widgets/textfields/text_field.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/textfields/keyboard_done_action.dart';

class CustomKeyboardTextfieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final Color? backgroundColor;
  final TextStyle? textStyle;

  final String label;
  final TextStyle labelStyle;
  final TextStyle? focusedLabelStyle;

  final bool hasTextControl;
  final bool isObscure;
  final bool isEnable;

  final Function(String)? onChanged;
  final Function(PointerDownEvent)? onTapOutside;
  final Function(bool)? onFocusChange;
  final Function(String)? onFieldSubmitted;

  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final PValidator? validator;

  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final InputDecoration? inputDecoration;
  final bool showSeperator;
  final int maxDigitAfterSeperator;

  final Color? enabledColor;
  final Color? focusedColor;

  const CustomKeyboardTextfieldWidget({
    super.key,
    required this.controller,
    this.backgroundColor,
    required this.textStyle,
    required this.label,
    required this.labelStyle,
    this.focusedLabelStyle,
    this.hasTextControl = true,
    this.isObscure = false,
    this.isEnable = true,
    this.onChanged,
    this.onTapOutside,
    this.onFocusChange,
    this.focusNode,
    this.textInputAction,
    this.keyboardType,
    this.inputDecoration,
    this.showSeperator = true,
    this.maxDigitAfterSeperator = 2,
    this.inputFormatters,
    this.validator,
    this.enabledColor,
    this.focusedColor,
    this.onFieldSubmitted,
  });

  @override
  State<CustomKeyboardTextfieldWidget> createState() => _CustomKeyboardTextfieldWidgetState();
}

class _CustomKeyboardTextfieldWidgetState extends State<CustomKeyboardTextfieldWidget> {
  late FocusNode _focusNode;

  late int selectionStart;
  late int selectionEnd;

  final bool _hasText = false;
  late bool _isObscure;
  String? _errorText;

  @override
  void initState() {
    _focusNode = widget.focusNode ?? FocusNode();

    _isObscure = widget.isObscure;

    selectionStart = widget.controller.selection.start;
    selectionEnd = widget.controller.selection.end;
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(() {});
    _focusNode.removeListener(() {});
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusNode.requestFocus();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          KeyboardDoneAction(
            focusNode: _focusNode,
            onDone: () {
              if (widget.onFieldSubmitted != null) {
                widget.onFieldSubmitted!('');
              } else {
                _focusNode.unfocus();
              }
            },
            child: TextFormField(
              showCursor: true,
              enabled: widget.isEnable,
              focusNode: _focusNode,
              controller: widget.controller,
              style: widget.textStyle,
              obscureText: _isObscure,
              maxLines: 1,
              onChanged: widget.onChanged,
              keyboardType: TextInputType.number,
              inputFormatters: widget.inputFormatters,
              onTapOutside: widget.onTapOutside,
              onFieldSubmitted: widget.onFieldSubmitted,
              decoration: InputDecoration(
                labelText: widget.label,
                labelStyle: widget.labelStyle,
                floatingLabelStyle: widget.focusedLabelStyle,
                border: InputBorder.none,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: _errorText?.isNotEmpty == true
                        ? context.pColorScheme.critical
                        : !widget.hasTextControl
                            ? (widget.enabledColor ?? context.pColorScheme.textQuaternary)
                            : _hasText
                                ? (widget.enabledColor ?? context.pColorScheme.textQuaternary)
                                : (widget.focusedColor ?? context.pColorScheme.primary),
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: _errorText?.isNotEmpty == true
                        ? context.pColorScheme.critical
                        : widget.focusedColor ?? context.pColorScheme.primary,
                    width: 1.0,
                  ),
                ),
                suffixIcon: widget.isObscure
                    ? InkWell(
                        child: Transform.scale(
                          scale: 0.4,
                          child: SvgPicture.asset(
                            _isObscure ? ImagesPath.eye_off : ImagesPath.eye_on,
                            width: 18,
                            colorFilter: ColorFilter.mode(
                              context.pColorScheme.primary,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        onTap: () {
                          setState(
                            () {
                              _isObscure = !_isObscure;
                            },
                          );
                        },
                      )
                    : null,
              ),
            ),
          ),
          if (_errorText?.isNotEmpty == true) ...{
            const SizedBox(height: Grid.xs),
            Text(
              _errorText!,
              style: context.pAppStyle.labelMed12primary.copyWith(
                color: context.pColorScheme.critical,
              ),
            ),
          }
        ],
      ),
    );
  }
}
