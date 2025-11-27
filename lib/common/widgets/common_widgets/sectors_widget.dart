import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class SectorsWidget extends StatelessWidget {
  final List<Map> sectors;
  final String? title;
  final Function(String, String) onPressed;
  final double? leftPadding;
  final double? rightPadding;

  const SectorsWidget({
    super.key,
    required this.sectors,
    this.title,
    required this.onPressed,
    this.leftPadding,
    this.rightPadding,
  });

  @override
  Widget build(BuildContext context) {
    final int itemsPerRow = sectors.length < 3 ? sectors.length : (sectors.length / 3).ceil();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: Grid.s + Grid.xs,
        ),
        Padding(
          padding: EdgeInsets.only(
            left: leftPadding ?? 0,
            right: rightPadding ?? 0,
          ),
          child: Text(
            title ?? L10n.tr('sectors'),
            style: context.pAppStyle.labelMed18textPrimary,
          ),
        ),
        const SizedBox(
          height: Grid.s + Grid.xs,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.only(
            left: leftPadding ?? 0,
            right: rightPadding ?? 0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (sectors.length < 3)
                buildScrollableRow(sectors, context)
              else ...[
                buildScrollableRow(sectors.sublist(0, itemsPerRow), context),
                buildScrollableRow(sectors.sublist(itemsPerRow, 2 * itemsPerRow), context),
                buildScrollableRow(sectors.sublist(2 * itemsPerRow), context),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget buildScrollableRow(List<Map> items, BuildContext context) {
    return Row(
      children: items.map(
        (item) {
          return Padding(
            padding: const EdgeInsets.only(
              right: Grid.s,
              bottom: Grid.s,
            ),
            child: SizedBox(
              height: 32,
              child: OutlinedButton(
                style: context.pAppStyle.oulinedMediumPrimaryStyle,
                onPressed: () => onPressed(
                  item['name'],
                  item['code'].toString(),
                ),
                child: Text(
                  L10n.tr(
                    item['name'],
                  ),
                ),
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}
