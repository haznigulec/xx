import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class DividendColumnWidget extends StatelessWidget {
  final String title;
  final String value;
  const DividendColumnWidget({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: Grid.s,
      ),
      child: SizedBox(
        height: 38,
        child: Column(
          spacing: Grid.xs,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                L10n.tr(title),
                textAlign: TextAlign.start,
                style: context.pAppStyle.labelReg14textSecondary,
              ),
            ),
            Text(
              value,
              textAlign: TextAlign.start,
              style: context.pAppStyle.labelMed14textPrimary,
            ),
          ],
        ),
      ),
    );
  }
}
