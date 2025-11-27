import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class OrderApprovementButtons extends StatelessWidget {
  final String? approveButtonText;
  final Function()? onPressedApprove;
  final bool showApproveButton;
  final String? cancelButtonText;
  final Function()? onPressedCancel;
  final bool showCancelButton;

  const OrderApprovementButtons({
    super.key,
    this.approveButtonText,
    required this.onPressedApprove,
    this.showApproveButton = true,
    this.cancelButtonText,
    this.onPressedCancel,
    this.showCancelButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showCancelButton)
          Expanded(
            child:
                // şimdilik yorum satırında kalsın, ekipçe konuşup test edelim
                //  POutlinedButton(
                //   text: cancelButtonText ?? L10n.tr('vazgeç'),
                //   variant: PButtonVariant.error,
                //   onPressed: onPressedCancel ??
                //       () {
                //         router.maybePop();
                //       },
                // ),
                OutlinedButton(
              onPressed: onPressedCancel ??
                  () {
                    router.maybePop();
                  },
              style: context.pAppStyle.elevatedMediumPrimaryStyle,
              child: FittedBox(
                child: Text(
                  maxLines: 1,
                  cancelButtonText ?? L10n.tr('vazgeç'),
                ),
              ),
            ),
          ),
        if (showCancelButton && showApproveButton)
          const SizedBox(
            width: Grid.s,
          ),
        if (showApproveButton)
          Expanded(
            child: PButton(
              text: approveButtonText ?? L10n.tr('onayla'),
              variant: PButtonVariant.brand,
              onPressed: onPressedApprove,
            ),
          ),
      ],
    );
  }
}
