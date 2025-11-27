import 'package:piapiri_v2/common/widgets/textfields/text_field.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/utils/localization_utils.dart';

class EnquraTextFieldWidget extends StatefulWidget {
  final String? value;
  final bool editable;
  final String keys;
  final bool? isEnabled;
  final bool? isShowSuffixIcon;
  final TextEditingController? controller;
  final PValidator? validator;

  const EnquraTextFieldWidget({
    super.key,
    this.value,
    required this.editable,
    required this.keys,
    this.isEnabled,
    this.isShowSuffixIcon,
    this.controller,
    this.validator,
  });

  @override
  State<EnquraTextFieldWidget> createState() => _EnquraTextFieldWidgetState();
}

class _EnquraTextFieldWidgetState extends State<EnquraTextFieldWidget> {
  late bool hasText;
  late TextEditingController _textEditingController;

  @override
  void initState() {
    _textEditingController = widget.controller ?? TextEditingController(text: widget.value);
    hasText = _textEditingController.text.isNotEmpty && _textEditingController.text != L10n.tr('choose');
    _textEditingController.addListener(_addTextListener);
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.removeListener(_addTextListener);
    if (widget.controller == null) {
      _textEditingController.dispose();
    }
    super.dispose();
  }

  void _addTextListener() {
    if (_textEditingController.text.isNotEmpty && !hasText) {
      setState(() {
        hasText = true;
      });
    } else if (_textEditingController.text.isEmpty && hasText) {
      setState(() {
        hasText = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      minLines: 1,
      maxLines: 3,
      controller: widget.controller ?? TextEditingController(text: widget.value),
      enabled: widget.isEnabled ?? false,
      cursorColor: context.pColorScheme.primary,
      textInputAction: TextInputAction.done,
      style: context.pAppStyle.interMediumBase.copyWith(
        color: widget.value == L10n.tr('choose')
            ? context.pColorScheme.primary
            : widget.editable
                ? context.pColorScheme.textPrimary
                : context.pColorScheme.textSecondary,
        fontSize: Grid.m - Grid.xxs,
      ),
      decoration: InputDecoration(
        disabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: widget.editable && !hasText ? context.pColorScheme.primary : context.pColorScheme.textQuaternary,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: widget.editable && !hasText ? context.pColorScheme.primary : context.pColorScheme.textQuaternary,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: widget.editable ? context.pColorScheme.primary : context.pColorScheme.textQuaternary,
          ),
        ),
        hintStyle: context.pAppStyle.interRegularBase.copyWith(
          color: context.pColorScheme.textSecondary,
          fontSize: Grid.m - Grid.xxs,
        ),
        suffixIcon: widget.isShowSuffixIcon ?? true && widget.editable
            ? Transform.scale(
                scale: 0.4,
                child: SvgPicture.asset(
                  ImagesPath.chevron_down,
                  height: 14,
                  colorFilter: ColorFilter.mode(
                    widget.value == L10n.tr('choose') ? context.pColorScheme.primary : context.pColorScheme.textPrimary,
                    BlendMode.srcIn,
                  ),
                ),
              )
            : null,
        labelText: L10n.tr(
          widget.keys,
        ),
        labelStyle: context.pAppStyle.labelMed14textSecondary,
      ),
    );
  }
}
