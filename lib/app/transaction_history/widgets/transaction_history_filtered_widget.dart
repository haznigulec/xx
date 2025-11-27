import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';

class TransactionHistoryFilteredWidget extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const TransactionHistoryFilteredWidget({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: Grid.s,
      ),
      child: SizedBox(
        height: 23,
        child: PCustomOutlinedButtonWithIcon(
          text: text,
          iconSource: ImagesPath.x,
          foregroundColorApllyBorder: false,
          foregroundColor: context.pColorScheme.primary,
          backgroundColor: context.pColorScheme.secondary,
          onPressed: onTap,
        ),
      ),
    );
  }
}
