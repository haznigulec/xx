import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String label;
  final TextStyle labelStyle;
  final TextStyle textStyle;
  final TextEditingController controller;
  final Function(String)? onTextChanged;
  final Color backgroundColor;
  final String errorText;

  const CustomTextFormField({
    super.key,
    required this.label,
    required this.labelStyle,
    required this.textStyle,
    required this.controller,
    this.onTextChanged,
    required this.backgroundColor,
    required this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      constraints: const BoxConstraints(minHeight: 60),
      padding: const EdgeInsets.symmetric(
        horizontal: Grid.m,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                label,
                style: labelStyle,
              ),
              const SizedBox(
                width: Grid.s,
              ),
              Expanded(
                child: TextFormField(
                  controller: controller,
                  onChanged: onTextChanged,
                  maxLines: 1,
                  style: textStyle,
                  textAlign: TextAlign.right,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: Grid.s,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (errorText.isNotEmpty) ...[
            Text(
              errorText,
              textAlign: TextAlign.right,
              style: context.pAppStyle.labelReg14primary.copyWith(
                color: context.pColorScheme.critical,
              ),
            )
          ]
        ],
      ),
    );
  }
}
