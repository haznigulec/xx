import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/utils/localization_utils.dart';

class StageAnalysisTitle extends StatelessWidget {
  const StageAnalysisTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 22,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 3,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      L10n.tr('adet'),
                      textAlign: TextAlign.start,
                      style: context.pAppStyle.labelMed12textSecondary,
                    ),
                    Expanded(
                      child: Text(
                        L10n.tr('bids_lot'),
                        textAlign: TextAlign.end,
                        style: context.pAppStyle.labelMed12textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  L10n.tr('fiyat'),
                  textAlign: TextAlign.center,
                  style: context.pAppStyle.labelMed12textSecondary,
                ),
              ),
              Expanded(
                flex: 3,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        L10n.tr('asks_lot'),
                        textAlign: TextAlign.start,
                        style: context.pAppStyle.labelMed12textSecondary,
                      ),
                    ),
                    Text(
                      L10n.tr('yuzde'),
                      textAlign: TextAlign.end,
                      style: context.pAppStyle.labelMed12textSecondary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: Grid.s,
        ),
        PDivider(
          color: context.pColorScheme.line,
          tickness: 1,
        ),
      ],
    );
  }
}
