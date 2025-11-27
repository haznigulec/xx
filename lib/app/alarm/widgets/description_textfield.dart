import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class DescriptionTextfield extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final int minLines;
  final int maxLines;
  final int maxLength;
  final String hintText;
  final bool showCounter;
  final Function()? onTap;

  const DescriptionTextfield({
    super.key,
    required this.controller,
    this.focusNode,
    this.minLines = 1,
    this.maxLines = 5,
    this.maxLength = 100,
    this.hintText = 'aciklama_giriniz',
    this.showCounter = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: Grid.s, horizontal: Grid.m),
        decoration: BoxDecoration(
          color: context.pColorScheme.card,
          borderRadius: BorderRadius.circular(Grid.m),
        ),
        child: TextFormField(
          focusNode: focusNode ?? FocusNode(),
          controller: controller,
          minLines: minLines,
          maxLines: maxLines,
          maxLength: maxLength,
          showCursor: true,
          cursorColor: context.pColorScheme.primary,
          onTapOutside: (event) {
            FocusScope.of(context).unfocus();
          },
          onTap: () => onTap?.call(),
          style: context.pAppStyle.labelReg16textPrimary,
          decoration: InputDecoration(
            hintText: L10n.tr(hintText),
            hintStyle: context.pAppStyle.labelReg16textSecondary,
            border: InputBorder.none,
          ),
          buildCounter: (
            BuildContext context, {
            required int currentLength,
            required int? maxLength,
            required bool isFocused,
          }) {
            if (maxLength == null || !showCounter) return const SizedBox.shrink();
            return Text(
              '$currentLength/$maxLength',
              style: context.pAppStyle.labelReg14textPrimary.copyWith(
                color: currentLength >= maxLength ? context.pColorScheme.critical : context.pColorScheme.textPrimary,
              ),
            );
          },
        ),
      ),
    );
  }
}
