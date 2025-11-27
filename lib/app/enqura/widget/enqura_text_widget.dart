import 'package:piapiri_v2/common/widgets/textfields/text_field.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/enqura/model/enqura_picker_model.dart';
import 'package:piapiri_v2/common/widgets/textfields/keyboard_done_action.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class EnquraTextWidget extends StatefulWidget {
  const EnquraTextWidget({
    required this.pickerModel,
    required this.onTextChanged,
    super.key,
  });

  final EnquraPickerModel pickerModel;
  final Function(String?) onTextChanged;

  @override
  State<EnquraTextWidget> createState() => _EnquraTextWidgetState();
}

class _EnquraTextWidgetState extends State<EnquraTextWidget> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  late bool _hasText;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.pickerModel.textValue ?? '',
    );
    _focusNode = FocusNode();
    _hasText = _controller.text.isNotEmpty;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: Grid.m + Grid.xs,
      ),
      child: KeyboardDoneAction(
        focusNode: _focusNode,
        disableScroll: true,
        child: widget.pickerModel.keyboaryIsNumber ?? false
            ? PTextField.number(
                focusNode: _focusNode,
                label: L10n.tr(widget.pickerModel.label),
                labelColor: context.pColorScheme.textSecondary,
                floatingLabelSize: Grid.m,
                textStyle: context.pAppStyle.labelMed16textPrimary,
                controller: _controller,
                maxLength: widget.pickerModel.maxLength,
                hasText: _hasText,
                enabled: true,
                onChanged: (value) {
                  if (value.isNotEmpty == true &&
                      widget.pickerModel.minValue != null &&
                      widget.pickerModel.maxValue != null) {
                    final numValue = double.tryParse(value) ?? 0;

                    if (numValue < widget.pickerModel.minValue!) {
                      _controller.value = TextEditingValue(
                        text: widget.pickerModel.minValue!.toInt().toString(),
                        selection: TextSelection.collapsed(
                          offset: widget.pickerModel.minValue!.toInt().toString().length,
                        ),
                      );
                      setState(() {
                        _hasText = true;
                      });
                      widget.onTextChanged.call(_controller.text);
                      return;
                    }

                    if (numValue > widget.pickerModel.maxValue!) {
                      _controller.value = TextEditingValue(
                        text: widget.pickerModel.maxValue!.toInt().toString(),
                        selection: TextSelection.collapsed(
                          offset: widget.pickerModel.maxValue!.toInt().toString().length,
                        ),
                      );
                      setState(() {
                        _hasText = true;
                      });
                      widget.onTextChanged.call(_controller.text);
                      return;
                    }
                  }

                  if (_hasText && value.isEmpty) {
                    setState(() {
                      _hasText = false;
                    });
                  } else if (!_hasText && value.isNotEmpty) {
                    setState(() {
                      _hasText = true;
                    });
                  }
                  widget.onTextChanged.call(value);
                },
                validator: !(widget.pickerModel.minLength != null || widget.pickerModel.maxLength != null)
                    ? null
                    : PValidator(
                        focusNode: _focusNode,
                        validate: (value) {
                          if (value != null && value.isNotEmpty) {
                            if (widget.pickerModel.minLength != null && value.length < widget.pickerModel.minLength!) {
                              return L10n.tr('textfield_min_length_alert', args: ['${widget.pickerModel.minLength!}']);
                            } else if (widget.pickerModel.maxLength != null &&
                                value.length > widget.pickerModel.maxLength!) {
                              return L10n.tr('textfield_max_length_alert', args: ['${widget.pickerModel.maxLength!}']);
                            } else {
                              return null;
                            }
                          }
                          return null;
                        },
                      ),
              )
            : PTextField(
                focusNode: _focusNode,
                label: L10n.tr(widget.pickerModel.label),
                labelColor: context.pColorScheme.textSecondary,
                floatingLabelSize: Grid.m,
                textStyle: context.pAppStyle.labelMed16textPrimary,
                controller: _controller,
                hasText: _hasText,
                enabled: true,
                onChanged: (value) {
                  if (_hasText && value.isEmpty) {
                    setState(() {
                      _hasText = false;
                    });
                  } else if (!_hasText && value.isNotEmpty) {
                    setState(() {
                      _hasText = true;
                    });
                  }
                  widget.onTextChanged.call(value);
                },
                validator: !(widget.pickerModel.minLength != null || widget.pickerModel.maxLength != null)
                    ? null
                    : PValidator(
                        focusNode: _focusNode,
                        validate: (value) {
                          if (value != null && value.isNotEmpty) {
                            if (widget.pickerModel.minLength != null && value.length < widget.pickerModel.minLength!) {
                              return L10n.tr('textfield_min_length_alert', args: ['${widget.pickerModel.minLength!}']);
                            } else if (widget.pickerModel.maxLength != null &&
                                value.length > widget.pickerModel.maxLength!) {
                              return L10n.tr('textfield_max_length_alert', args: ['${widget.pickerModel.maxLength!}']);
                            } else {
                              return null;
                            }
                          }
                          return null;
                        },
                      ),
              ),
      ),
    );
  }
}
