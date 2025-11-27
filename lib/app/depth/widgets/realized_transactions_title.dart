import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/utils/localization_utils.dart';

class RealizedTransactionsTitle extends StatelessWidget {
  const RealizedTransactionsTitle({super.key});

  @override
  Widget build(BuildContext context) {
    double maxWidth = (MediaQuery.of(context).size.width - Grid.m * 3) / 4;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: maxWidth,
          child: Text(
            L10n.tr('adet'),
            textAlign: TextAlign.left,
            style: context.pAppStyle.labelMed12textSecondary,
          ),
        ),
        SizedBox(
          width: maxWidth,
          child: Text(
            L10n.tr('fiyat'),
            textAlign: TextAlign.center,
            style: context.pAppStyle.labelMed12textSecondary,
          ),
        ),
        SizedBox(
          width: maxWidth,
          child: Text(
            L10n.tr('alan'),
            textAlign: TextAlign.center,
            style: context.pAppStyle.labelMed12textSecondary,
          ),
        ),
        SizedBox(
          width: maxWidth,
          child: Text(
            L10n.tr('satan'),
            textAlign: TextAlign.right,
            style: context.pAppStyle.labelMed12textSecondary,
          ),
        ),
      ],
    );
  }
}
