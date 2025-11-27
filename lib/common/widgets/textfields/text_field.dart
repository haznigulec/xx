import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart' as intl;
import 'package:p_core/keys/keys.dart';
import 'package:p_core/utils/validator_utils.dart';
import 'package:pattern_formatter/numeric_formatter.dart';

class PTextField extends StatefulWidget {
  final TextStyle? textStyle;
  final String? label;
  final Color? labelColor;
  final double? floatingLabelSize;
  final String? helperText;
  final String? errorText;
  final String? hint;
  final Color? hintColor;
  final String? initialValue;
  final bool optional;
  final bool enabled;
  final bool showCharCount;
  final bool autoCorrect;
  final int? maxLength;
  final int? minLines;
  final int? maxLines;
  final int? hintMaxLines;
  final int? errorMaxLines;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final PValidator? validator;
  final Function()? onTap;
  final FocusNode? focusNode;
  final bool autoFocus;
  final Widget? suffixWidget;
  final IconData? suffixIcon;
  final IconData? prefixIcon;
  final String? prefixText;
  final TextStyle? prefixStyle;
  final TextInputAction? textInputAction;
  final TextDirection? textDirection;
  final TextAlign textAlign;
  final List<TextInputFormatter>? inputFormatters;
  final InputType inputType;
  final Iterable<String>? autofillHints;
  final EdgeInsetsGeometry? contentPadding;
  final AutovalidateMode autovalidateMode;
  final Widget? labelWidget;
  final TextCapitalization? textCapitalization;
  final bool obscure;
  final String? imagePath;
  final Function(bool)? onObscure;
  final bool? readOnly;
  final bool? hasText;

  const PTextField({
    super.key,
    this.textStyle,
    this.label,
    this.labelColor,
    this.floatingLabelSize,
    this.helperText,
    this.errorText,
    this.hint,
    this.hintColor,
    this.initialValue,
    this.optional = false,
    this.showCharCount = false,
    this.autoCorrect = false,
    this.enabled = true,
    this.maxLength,
    this.maxLines,
    this.hintMaxLines,
    this.errorMaxLines,
    this.onChanged,
    this.controller,
    this.validator,
    this.onTap,
    this.focusNode,
    this.autoFocus = false,
    this.suffixWidget,
    this.suffixIcon,
    this.prefixIcon,
    this.prefixText,
    this.prefixStyle,
    this.textInputAction,
    this.textDirection,
    this.textAlign = TextAlign.start,
    this.inputFormatters,
    this.autofillHints,
    this.contentPadding,
    this.autovalidateMode = AutovalidateMode.always,
    this.labelWidget,
    this.textCapitalization,
    this.obscure = false,
    this.imagePath,
    this.onObscure,
    this.readOnly = false,
    this.hasText = false,
  })  : minLines = null,
        inputType = InputType.text;

  /// Text Field that allows entering multiline input.
  /// [autoCorrect] is true by default, but can be disabled
  const PTextField.multiline({
    super.key,
    this.textStyle,
    this.label,
    this.floatingLabelSize,
    this.helperText,
    this.errorText,
    this.hint,
    this.hintColor,
    this.initialValue,
    this.optional = false,
    this.enabled = true,
    this.showCharCount = false,
    this.autoCorrect = true,
    this.maxLength,
    this.minLines,
    this.maxLines,
    this.hintMaxLines,
    this.errorMaxLines,
    this.onChanged,
    this.controller,
    this.validator,
    this.onTap,
    this.focusNode,
    this.autoFocus = false,
    this.suffixIcon,
    this.prefixIcon,
    this.prefixText,
    this.prefixStyle,
    this.textInputAction,
    this.textDirection,
    this.textAlign = TextAlign.start,
    this.inputFormatters,
    this.autofillHints,
    this.contentPadding,
    this.autovalidateMode = AutovalidateMode.always,
    this.labelWidget,
    this.textCapitalization,
    this.obscure = false,
    this.readOnly = false,
    this.hasText = false,
  })  : inputType = InputType.multiline,
        suffixWidget = null,
        labelColor = null,
        imagePath = null,
        onObscure = null;

  /// Email field
  const PTextField.email({
    super.key,
    this.textStyle,
    this.label = 'Email',
    this.labelColor,
    this.floatingLabelSize,
    this.helperText,
    this.errorText,
    this.hint,
    this.hintColor,
    this.initialValue,
    this.optional = false,
    this.enabled = true,
    this.maxLength,
    this.onChanged,
    this.controller,
    this.validator,
    this.onTap,
    this.focusNode,
    this.autoFocus = false,
    this.suffixIcon,
    this.prefixIcon,
    this.prefixText,
    this.prefixStyle,
    this.textInputAction,
    this.textDirection,
    this.textAlign = TextAlign.start,
    this.inputFormatters,
    this.autofillHints,
    this.contentPadding,
    this.autovalidateMode = AutovalidateMode.always,
    this.labelWidget,
    this.textCapitalization,
    this.obscure = false,
    this.readOnly = false,
    this.hasText = false,
  })  : inputType = InputType.email,
        autoCorrect = false,
        minLines = null,
        suffixWidget = null,
        showCharCount = false,
        maxLines = null,
        hintMaxLines = null,
        errorMaxLines = null,
        imagePath = null,
        onObscure = null;

  /// Number field
  const PTextField.number({
    super.key,
    bool allowDecimal = false,
    this.textStyle,
    this.label,
    this.labelColor,
    this.floatingLabelSize,
    this.helperText,
    this.errorText,
    this.hint,
    this.hintColor,
    this.initialValue,
    this.optional = false,
    this.enabled = true,
    this.maxLength,
    this.errorMaxLines,
    this.onChanged,
    this.controller,
    this.validator,
    this.onTap,
    this.focusNode,
    this.autoFocus = false,
    this.suffixWidget,
    this.suffixIcon,
    this.prefixIcon,
    this.prefixText,
    this.prefixStyle,
    this.textInputAction = TextInputAction.done,
    this.textDirection,
    this.textAlign = TextAlign.start,
    this.inputFormatters,
    this.autofillHints,
    this.contentPadding,
    this.autovalidateMode = AutovalidateMode.always,
    this.labelWidget,
    this.textCapitalization,
    this.obscure = false,
    this.readOnly = false,
    this.hasText = false,
  })  : inputType = allowDecimal ? InputType.decimalNumber : InputType.number,
        autoCorrect = false,
        minLines = null,
        showCharCount = false,
        maxLines = null,
        hintMaxLines = null,
        imagePath = null,
        onObscure = null;

  /// Number field
  const PTextField.phone({
    super.key,
    this.textStyle,
    this.label,
    this.labelColor,
    this.floatingLabelSize,
    this.helperText,
    this.errorText,
    this.hint,
    this.hintColor,
    this.initialValue,
    this.optional = false,
    this.enabled = true,
    this.maxLength,
    this.onChanged,
    this.controller,
    this.validator,
    this.onTap,
    this.focusNode,
    this.autoFocus = false,
    this.suffixWidget,
    this.suffixIcon,
    this.prefixIcon,
    this.prefixText,
    this.prefixStyle,
    this.textInputAction,
    this.textDirection,
    this.textAlign = TextAlign.start,
    this.inputFormatters,
    this.autofillHints,
    this.contentPadding,
    this.autovalidateMode = AutovalidateMode.always,
    this.labelWidget,
    this.textCapitalization,
    this.obscure = false,
    this.readOnly = false,
    this.hasText = false,
  })  : inputType = InputType.phone,
        autoCorrect = false,
        minLines = null,
        maxLines = null,
        hintMaxLines = null,
        errorMaxLines = null,
        showCharCount = false,
        imagePath = null,
        onObscure = null;

  /// Number field
  const PTextField.creditCard({
    super.key,
    this.textStyle,
    this.label,
    this.floatingLabelSize,
    this.helperText,
    this.errorText,
    this.hint,
    this.hintColor,
    this.initialValue,
    this.optional = false,
    this.enabled = true,
    this.onChanged,
    this.controller,
    this.validator,
    this.onTap,
    this.focusNode,
    this.autoFocus = false,
    this.suffixWidget,
    this.suffixIcon,
    this.prefixIcon,
    this.prefixText,
    this.prefixStyle,
    this.textInputAction,
    this.textDirection,
    this.textAlign = TextAlign.start,
    this.autofillHints,
    this.contentPadding,
    this.autovalidateMode = AutovalidateMode.always,
    this.labelWidget,
    this.textCapitalization,
    this.obscure = false,
    this.readOnly = false,
    this.hasText = false,
  })  : inputType = InputType.creditCard,
        autoCorrect = false,
        minLines = null,
        maxLines = null,
        inputFormatters = null,
        maxLength = null,
        hintMaxLines = null,
        errorMaxLines = null,
        showCharCount = false,
        labelColor = null,
        imagePath = null,
        onObscure = null;

  /// URL field
  const PTextField.url({
    super.key,
    this.textStyle,
    this.label,
    this.floatingLabelSize,
    this.helperText,
    this.errorText,
    this.hint,
    this.hintColor,
    this.initialValue,
    this.optional = false,
    this.enabled = true,
    this.maxLength,
    this.onChanged,
    this.controller,
    this.validator,
    this.onTap,
    this.focusNode,
    this.autoFocus = false,
    this.suffixWidget,
    this.suffixIcon,
    this.prefixIcon,
    this.prefixText,
    this.prefixStyle,
    this.textInputAction,
    this.textDirection,
    this.textAlign = TextAlign.start,
    this.inputFormatters,
    this.autofillHints,
    this.contentPadding,
    this.autovalidateMode = AutovalidateMode.always,
    this.labelWidget,
    this.textCapitalization,
    this.obscure = false,
    this.readOnly = false,
    this.hasText = false,
  })  : inputType = InputType.url,
        autoCorrect = false,
        minLines = null,
        maxLines = null,
        hintMaxLines = null,
        errorMaxLines = null,
        showCharCount = false,
        labelColor = null,
        imagePath = null,
        onObscure = null;

  /// Password field
  const PTextField.password({
    super.key,
    this.textStyle,
    this.label = 'Password',
    this.floatingLabelSize,
    this.helperText,
    this.errorText,
    this.hint,
    this.hintColor,
    this.initialValue,
    this.optional = false,
    this.showCharCount = false,
    this.enabled = true,
    this.maxLength,
    this.onChanged,
    this.controller,
    this.validator,
    this.onTap,
    this.focusNode,
    this.autoFocus = false,
    this.prefixIcon,
    this.prefixStyle,
    this.textInputAction,
    this.textDirection,
    this.textAlign = TextAlign.start,
    this.autofillHints,
    this.contentPadding,
    this.autovalidateMode = AutovalidateMode.always,
    this.labelWidget,
    this.labelColor,
    this.textCapitalization,
    this.obscure = true,
    this.imagePath,
    this.onObscure,
    this.readOnly = false,
    this.hasText = false,
  })  : inputType = InputType.password,
        autoCorrect = false,
        minLines = null,
        maxLines = null,
        hintMaxLines = null,
        errorMaxLines = null,
        inputFormatters = null,
        prefixText = null,
        suffixWidget = null,
        suffixIcon = null;

  @override
  State<StatefulWidget> createState() => _PTextFieldState();
}

class _PTextFieldState extends State<PTextField> {
  late FocusNode focusNode;
  late bool disposeFocusNode;
  late bool obscure;

  @override
  void initState() {
    obscure = widget.obscure;
    if (widget.focusNode == null) {
      focusNode = FocusNode();
      disposeFocusNode = true;
    } else {
      focusNode = widget.focusNode!;
      disposeFocusNode = false;
    }
    super.initState();
  }

  @override
  void dispose() {
    if (disposeFocusNode) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          autofocus: widget.autoFocus,
          enableInteractiveSelection: false,
          keyboardType: _getKeyboard(),
          initialValue: widget.initialValue,
          enabled: widget.enabled,
          readOnly: widget.readOnly ?? false,
          validator: widget.validator?._validator,
          onTap: widget.onTap,
          autovalidateMode: widget.autovalidateMode,
          obscureText: obscure,
          textInputAction: widget.textInputAction,
          textDirection: widget.textDirection,
          textAlign: widget.textAlign,
          autocorrect: widget.autoCorrect,
          onChanged: widget.onChanged,
          maxLines: widget.maxLines ?? (widget.inputType == InputType.multiline ? null : 1),
          minLines: widget.minLines,
          cursorColor: context.pColorScheme.primary,
          textCapitalization: widget.textCapitalization ?? TextCapitalization.none,
          maxLength: widget.showCharCount ? widget.maxLength : null,
          buildCounter: widget.showCharCount && widget.maxLength != null
              ? (
                  BuildContext context, {
                  required int currentLength,
                  required int? maxLength,
                  required bool isFocused,
                }) {
                  return Text(
                    '$currentLength/$maxLength',
                    // style: const PTypography.helperText(color: PColor.darkMedium),
                    style: context.pAppStyle.interMediumBase.copyWith(
                      fontSize: Grid.m,
                      color: context.pColorScheme.textPrimary,
                    ),
                  );
                }
              : null,
          inputFormatters: <TextInputFormatter>[
            if (!widget.showCharCount && widget.maxLength != null)
              LengthLimitingTextInputFormatter(
                widget.maxLength,
              ),
            if (widget.inputType == InputType.phone)
              TextInputFormatter.withFunction(
                (TextEditingValue oldValue, TextEditingValue newValue) =>
                    RegExp(r'^[+]*[-\s\./0-9]*$').hasMatch(newValue.text) ? newValue : oldValue,
              ),
            if (widget.inputType == InputType.number)
              ThousandsFormatter(formatter: intl.NumberFormat.decimalPattern()..turnOffGrouping()),
            if (widget.inputType == InputType.decimalNumber)
              TextInputFormatter.withFunction(
                (TextEditingValue oldValue, TextEditingValue newValue) {
                  final TextEditingValue value =
                      newValue.text.isEmpty || RegExp(r'^[0-9]+((\.|\,)[0-9]*)?$').hasMatch(newValue.text)
                          ? newValue
                          : oldValue;
                  return value.copyWith(text: value.text.replaceAll(',', '.'));
                },
              ),
            if (widget.inputType == InputType.creditCard) CreditCardFormatter(),
            if (widget.inputFormatters != null) ...widget.inputFormatters!,
          ],
          // style: const PTypography.body1(color: PColor.darkHigh),
          style: widget.textStyle ??
              context.pAppStyle.interRegularBase.copyWith(
                fontSize: Grid.m + Grid.xxs,
                color: context.pColorScheme.textPrimary,
              ),
          decoration: InputDecoration(
            label: widget.labelWidget,
            contentPadding: widget.contentPadding ??
                const EdgeInsets.symmetric(
                  vertical: Grid.s,
                ),
            // prefixStyle: PTypography.body1(
            //   color: widget.inputType == InputType.phone ? PColor.textPrimary500 : PColor.darkMedium,
            // ),
            prefixStyle: widget.prefixStyle ??
                context.pAppStyle.interRegularBase.copyWith(
                  fontSize: Grid.m + Grid.xxs,
                  color: context.pColorScheme.textPrimary,
                ),
            prefixText: widget.prefixText,
            prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon, size: Grid.l) : null,
            // suffixStyle: const PTypography.title(
            //   color: PColor.primary500,
            // ),
            suffixStyle: context.pAppStyle.interRegularBase.copyWith(
              fontSize: Grid.m - Grid.xxs,
              color: context.pColorScheme.primary,
            ),
            suffixIcon: widget.inputType == InputType.password
                ? InkWell(
                    focusColor: context.pColorScheme.transparent,
                    splashColor: context.pColorScheme.transparent,
                    highlightColor: context.pColorScheme.transparent,
                    child: Transform.scale(
                      scale: 0.4,
                      child: SvgPicture.asset(
                        widget.imagePath ?? '',
                        width: 17,
                        colorFilter: ColorFilter.mode(
                          context.pColorScheme.primary,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        obscure = !obscure;
                        widget.onObscure!(obscure);
                      });
                    },
                  )
                : widget.suffixWidget ?? (widget.suffixIcon != null ? Icon(widget.suffixIcon, size: Grid.m) : null),
            labelText: widget.label != null ? '${widget.label}' : null,
            labelStyle: context.pAppStyle.interRegularBase.copyWith(
              color: widget.labelColor ?? context.pColorScheme.primary,
              fontSize: Grid.m,
            ),
            floatingLabelStyle: context.pAppStyle.interMediumBase.copyWith(
              color: widget.labelColor ?? context.pColorScheme.primary,
              fontSize: widget.floatingLabelSize ?? Grid.s + Grid.xs,
            ),
            hintText: widget.hint,
            // hintStyle: PTypography.label(color: widget.hintColor).copyWith(fontWeight: FontWeight.w400),
            hintStyle: context.pAppStyle.interRegularBase.copyWith(
              fontSize: Grid.m - Grid.xxs,
              color: widget.hintColor ?? context.pColorScheme.textPrimary,
            ),
            hintMaxLines: widget.hintMaxLines,
            errorText: widget.errorText,
            // errorStyle: const PTypography.subTitle(color: PColor.critical500),
            errorStyle: context.pAppStyle.interMediumBase.copyWith(
              fontSize: Grid.s + Grid.xs,
              color: context.pColorScheme.critical,
            ),
            errorMaxLines: widget.errorMaxLines,
            helperText: widget.helperText,
            helperMaxLines: 2,
            // helperStyle: const PTypography.helperText(color: PColor.darkMedium),
            helperStyle: context.pAppStyle.interMediumBase.copyWith(
              fontSize: Grid.m - Grid.xs,
              color: context.pColorScheme.textPrimary,
            ),
            isDense: true,
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            filled: true,
            fillColor: context.pColorScheme.backgroundColor,
            border: const UnderlineInputBorder(),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: widget.hasText! ? context.pColorScheme.textQuaternary : context.pColorScheme.primary,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: context.pColorScheme.primary,
              ),
            ),
            disabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: widget.hasText! ? context.pColorScheme.textQuaternary : context.pColorScheme.primary,
              ),
            ),
            errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: context.pColorScheme.primary,
              ),
            ),
            focusedErrorBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: context.pColorScheme.primary,
              ),
            ),
            focusColor: context.pColorScheme.primary,
          ),
          autofillHints: widget.autofillHints,
          key: const Key(GeneralKeys.pTextField),
        ),
      ],
    );
  }

  String? emailValidator(String email) {
    return focusNode.hasFocus
        ? null
        : ValidatorUtils.isEmail(email)
            ? null
            : 'email validator';
  }

  TextInputType _getKeyboard() {
    switch (widget.inputType) {
      case InputType.text:
        return TextInputType.text;
      case InputType.multiline:
        return TextInputType.multiline;

      case InputType.email:
        return TextInputType.emailAddress;

      case InputType.url:
        return TextInputType.url;

      case InputType.number:
        return TextInputType.number;

      case InputType.decimalNumber:
        return const TextInputType.numberWithOptions(decimal: true);

      case InputType.phone:
        return TextInputType.phone;

      case InputType.password:
        return TextInputType.number;
      case InputType.creditCard:
        return TextInputType.number;
    }
  }
}

class PValidator {
  final FocusNode focusNode;
  final FormFieldValidator<String> validate;
  final bool validateEmptyInput;

  String? _validator(String? input) {
    if (input?.isNotEmpty == true || validateEmptyInput) {
      return validate(input);
    }

    return null;
  }

  PValidator({
    required this.focusNode,
    required this.validate,
    this.validateEmptyInput = false,
  });
}

class CustomMinutesRangeTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text == '') {
      return TextEditingValue.empty.copyWith(text: '');
    } else if (int.parse(newValue.text) < 0) {
      return TextEditingValue.empty.copyWith(text: '0');
    } else {
      return int.parse(newValue.text) > 59 ? TextEditingValue.empty.copyWith(text: '59') : newValue;
    }
  }
}

enum InputType {
  text,
  multiline,
  creditCard,
  email,
  url,
  number,
  decimalNumber,
  phone,
  password,
}
