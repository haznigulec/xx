import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';

class BankInfoRowWidget extends StatelessWidget {
  final String title;
  final String value;
  final Function()? onTapCopy;
  final bool showCopyIcon;
  const BankInfoRowWidget({
    super.key,
    required this.title,
    required this.value,
    this.onTapCopy,
    this.showCopyIcon = true,
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
            style: context.pAppStyle.labelReg14textSecondary,
          ),
          const SizedBox(
            width: Grid.xs,
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    textAlign: TextAlign.right,
                    style: context.pAppStyle.labelReg14textPrimary,
                  ),
                ),
                if (showCopyIcon) ...[
                  const SizedBox(
                    width: Grid.xs,
                  ),
                  GestureDetector(
                    onTap: onTapCopy,
                    child: SvgPicture.asset(
                      ImagesPath.copy,
                      width: 17,
                      height: 17,
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
