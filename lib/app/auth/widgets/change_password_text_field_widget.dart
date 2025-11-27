import 'package:piapiri_v2/common/widgets/textfields/text_field.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/textfields/keyboard_done_action.dart';


class ChangePasswordTextFieldWidget extends StatefulWidget {
  final TextEditingController textEditingController;
  final String labelText;
  final FormFieldValidator<String> validation;
  const ChangePasswordTextFieldWidget({
    super.key,
    required this.textEditingController,
    required this.labelText,
    required this.validation,
  });

  @override
  State<ChangePasswordTextFieldWidget> createState() => _ChangePasswordTextFieldWidgetState();
}

class _ChangePasswordTextFieldWidgetState extends State<ChangePasswordTextFieldWidget> {
  late FocusNode _focusNode;
  bool _obscure = true;
  @override
  initState() {
    _focusNode = FocusNode(debugLabel: widget.labelText);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDoneAction(
      focusNode: _focusNode,
      child: PTextField.password(
        focusNode: _focusNode,
        controller: widget.textEditingController,
        label: widget.labelText,
        labelColor: context.pColorScheme.textSecondary,
        imagePath: _obscure ? ImagesPath.eye_off : ImagesPath.eye_on,
        onObscure: (obscure) {
          setState(() {
            _obscure = obscure;
          });
        },
        validator: PValidator(
          focusNode: _focusNode,
          validate: widget.validation,
        ),
      ),
    );
  }
}
