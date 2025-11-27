import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/data_grid/utils/column_utils.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/diff_percentage.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';

class FavoriteGridBox extends StatelessWidget {
  final String symbolName;
  final String symbolIconName;
  final SymbolTypes symbolTypes;
  final String price;
  final double diffPercentage;
  final String updateDate;
  final Function onTapGrid;
  const FavoriteGridBox({
    super.key,
    required this.symbolName,
    required this.symbolIconName,
    required this.symbolTypes,
    required this.price,
    required this.diffPercentage,
    this.updateDate = '',
    required this.onTapGrid,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: context.pColorScheme.transparent,
      highlightColor: context.pColorScheme.transparent,
      onTap: () => onTapGrid(),
      child: Container(
        color: ColumnUtils().getGridBoxColor(context, diffPercentage),
        padding: const EdgeInsets.all(Grid.s),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SymbolIcon(
                      symbolName: symbolIconName,
                      size: 28,
                      symbolType: symbolTypes,
                      borderWidth: 3,
                    ),
                    const SizedBox(width: Grid.xs),
                    Text(
                      symbolName,
                      style: context.pAppStyle.labelMed16lightHigh,
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      FittedBox(
                        child: Text(
                          price,
                          textAlign: TextAlign.right,
                          style: context.pAppStyle.labelMed12lightHigh,
                        ),
                      ),
                      FittedBox(
                        child: DiffPercentage(
                          percentage: diffPercentage,
                          color: context.pColorScheme.lightHigh,
                        ),
                      ),
                      FittedBox(
                        child: Text(
                          updateDate.isEmpty ? '-' : updateDate,
                          textAlign: TextAlign.right,
                          style: context.pAppStyle.labelMed12lightHigh,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
