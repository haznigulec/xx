import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/utils/localization_utils.dart';

class DepthTitle extends StatelessWidget {
  const DepthTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                L10n.tr('emir'),
                style: context.pAppStyle.labelMed12textSecondary,
              ),
              Text(
                L10n.tr('adet'),
                style: context.pAppStyle.labelMed12textSecondary,
              ),
              Text(
                L10n.tr('alis'),
                style: context.pAppStyle.labelMed12textSecondary,
              ),
            ],
          ),
        ),
        const SizedBox(
          width: Grid.m,
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                L10n.tr('satis'),
                style: context.pAppStyle.labelMed12textSecondary,
              ),
              Text(
                L10n.tr('adet'),
                style: context.pAppStyle.labelMed12textSecondary,
              ),
              Text(
                L10n.tr('emir'),
                style: context.pAppStyle.labelMed12textSecondary,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
