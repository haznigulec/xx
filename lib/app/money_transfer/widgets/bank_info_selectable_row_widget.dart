import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';

class BankInfoSelectableRowWidget extends StatelessWidget {
  final String title;
  final String value;
  final bool isSelectable;
  final Function()? onClick;

  const BankInfoSelectableRowWidget({
    super.key,
    required this.title,
    required this.value,
    this.isSelectable = false,
    this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: Grid.s + Grid.xs,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            textAlign: TextAlign.left,
            style: context.pAppStyle.labelMed14primary,
          ),
          const SizedBox(
            width: Grid.xs,
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: isSelectable ? () => onClick?.call() : null,
                    child: Text(
                      value,
                      textAlign: TextAlign.right,
                      style: isSelectable
                          ? context.pAppStyle.labelReg14primary
                          : context.pAppStyle.labelReg14textSecondary,
                    ),
                  ),
                ),
                if (isSelectable) ...[
                  const SizedBox(
                    width: Grid.xs,
                  ),
                  GestureDetector(
                    onTap: isSelectable ? () => onClick?.call() : null,
                    child: SvgPicture.asset(
                      ImagesPath.chevron_down,
                      width: 17,
                      height: 17,
                      colorFilter: ColorFilter.mode(
                        context.pColorScheme.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
