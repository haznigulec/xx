import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/textfields/keyboard_done_action.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class SymbolSearchField extends StatefulWidget {
  final TextEditingController controller;
  final void Function(String)? onChanged;
  final void Function()? onTapSuffix;
  final String? hintText;
  final bool showCancelButton;

  const SymbolSearchField({
    super.key,
    this.onChanged,
    required this.controller,
    this.onTapSuffix,
    this.hintText,
    this.showCancelButton = true,
  });

  @override
  State<SymbolSearchField> createState() => _SymbolSearchFieldState();
}

class _SymbolSearchFieldState extends State<SymbolSearchField> {
  final FocusNode _focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width - Grid.m * 2,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              height: 43,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: context.pColorScheme.stroke,
                borderRadius: BorderRadius.circular(24),
              ),
              child: KeyboardDoneAction(
                focusNode: _focusNode,
                child: TextField(
                  focusNode: _focusNode,
                  textAlignVertical: TextAlignVertical.center,
                  controller: widget.controller,
                  maxLines: 1,
                  cursorColor: context.pColorScheme.primary,
                  enableInteractiveSelection: false,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: widget.hintText ?? L10n.tr('search_in_piapiri'),
                    hintStyle: context.pAppStyle.labelReg16textSecondary.copyWith(height: 1.5),
                    border: InputBorder.none,
                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 44,
                      minHeight: 17,
                      maxWidth: 44,
                      maxHeight: 17,
                    ),
                    prefixIcon: Row(
                      children: [
                        const SizedBox(
                          width: Grid.s + Grid.xs,
                        ),
                        SvgPicture.asset(
                          ImagesPath.search,
                          colorFilter: ColorFilter.mode(
                            context.pColorScheme.textSecondary,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(
                          width: Grid.s,
                        ),
                      ],
                    ),
                    suffixIcon: widget.controller.text.isNotEmpty
                        ? GestureDetector(
                            onTap: widget.onTapSuffix,
                            child: Padding(
                              padding: const EdgeInsets.all(
                                Grid.s + Grid.xs,
                              ),
                              child: SvgPicture.asset(
                                ImagesPath.x,
                                colorFilter: ColorFilter.mode(context.pColorScheme.primary, BlendMode.srcIn),
                              ),
                            ),
                          )
                        : null,
                    contentPadding: const EdgeInsets.symmetric(vertical: 11),
                  ),
                  onChanged: widget.onChanged,
                ),
              ),
            ),
          ),
          if (widget.showCancelButton) ...[
            const SizedBox(
              width: Grid.m,
            ),
            InkWell(
              onTap: () {
                router.maybePop();
              },
              child: Text(
                L10n.tr('vazgec'),
                style: context.pAppStyle.labelReg16primary,
              ),
            ),
          ]
        ],
      ),
    );
  }
}
