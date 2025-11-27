import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';

class TextButtonSelector extends StatelessWidget {
  final String selectedItem;
  final Color? selectedColor;
  final TextStyle? selectedTextStyle;
  final Function() onSelect;
  final bool enable;
  const TextButtonSelector({
    super.key,
    required this.selectedItem,
    required this.onSelect,
    this.selectedTextStyle,
    this.selectedColor,
    this.enable = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: context.pColorScheme.transparent,
      highlightColor: context.pColorScheme.transparent,
      onTap: enable ? () => onSelect() : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            selectedItem,
            style: selectedTextStyle ??
                context.pAppStyle.labelReg14primary.copyWith(
                  color: selectedColor ?? (enable ? context.pColorScheme.primary : context.pColorScheme.textPrimary),
            ),
          ),
          const SizedBox(
            width: Grid.xs,
          ),
          if (enable)
          SvgPicture.asset(
            ImagesPath.chevron_down,
            height: 15,
            width: 15,
            colorFilter: ColorFilter.mode(
              selectedColor ?? context.pColorScheme.primary,
              BlendMode.srcIn,
            ),
          )
        ],
      ),
    );
  }
}
