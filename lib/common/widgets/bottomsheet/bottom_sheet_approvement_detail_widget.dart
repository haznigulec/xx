import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';

class BottomSheetApprovementDetailWidget extends StatelessWidget {
  final Map<String, String> data;
  const BottomSheetApprovementDetailWidget({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final entries = data.entries.toList();

    return Column(
      children: entries.map((e) {
        final isLast = entries.last == e;

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: Grid.s,
              children: [
                Expanded(
                  child: Text(
                    e.key,
                    textAlign: TextAlign.start,
                    style: context.pAppStyle.labelReg14textSecondary,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    e.value,
                    textAlign: TextAlign.end,
                    style: context.pAppStyle.labelMed14textPrimary,
                  ),
                ),
              ],
            ),
            if (isLast) ...[
              const SizedBox(
                height: Grid.l + Grid.s,
              ),
            ] else
              const PDivider(
                padding: EdgeInsets.symmetric(
                  vertical: Grid.s + Grid.xs,
                ),
              ),
          ],
        );
      }).toList(),
    );
  }
}
