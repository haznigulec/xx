import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/search_symbol/widgets/order_approvement_buttons.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class BottomSheetApprovementWidget extends StatelessWidget {
  final Widget textWidget;
  final VoidCallback onTapSeeDetailButton;
  final VoidCallback onTapApprove;
  const BottomSheetApprovementWidget({
    super.key,
    required this.textWidget,
    required this.onTapSeeDetailButton,
    required this.onTapApprove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: Grid.l,
        ),
        textWidget,
        const SizedBox(
          height: Grid.m,
        ),
        InkWell(
          onTap: onTapSeeDetailButton,
          child: Text(
            L10n.tr('see_request_detail'),
            style: context.pAppStyle.labelReg16primary,
          ),
        ),
        const SizedBox(
          height: Grid.l,
        ),
        OrderApprovementButtons(
          onPressedApprove: onTapApprove,
        ),
      ],
    );
  }
}
