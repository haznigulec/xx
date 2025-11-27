import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/common/utils/button_padding.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class BuySellButtons extends StatelessWidget {
  final Function() onTapBuy;
  final Function() onTapSell;

  const BuySellButtons({
    super.key,
    required this.onTapBuy,
    required this.onTapSell,
  });

  @override
  Widget build(BuildContext context) {
    return generalButtonPadding(
      context: context,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: PButton(
              text: L10n.tr('sat'),
              sizeType: PButtonSize.medium,
              variant: PButtonVariant.error,
              onPressed: onTapSell,
            ),
          ),
          const SizedBox(
            width: Grid.s,
          ),
          Expanded(
            child: PButton(
              text: L10n.tr('al'),
              variant: PButtonVariant.success,
              sizeType: PButtonSize.medium,
              onPressed: onTapBuy,
            ),
          ),
        ],
      ),
    );
  }
}
